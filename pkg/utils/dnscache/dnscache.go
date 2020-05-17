package dnscache

import (
	"context"
	"fmt"
	"github.com/miekg/dns"
	"net"
	"sync"
	"time"
)

type Resolver struct {
	// timeout defines the maximum allowed time allowed for a lookup.
	timeout time.Duration

	cache map[string]*cacheEntry

	garbageCollector *time.Ticker

	mutex sync.RWMutex

	chanLock        sync.Mutex
	resolveChannels map[string]chan error
}

// getIPFromCache returns only cached IPs with a specific IP version
// if absent from cache returns nil, false.
func (r *Resolver) getIPFromCache(fqdn string, ipv int) ([]net.IP, bool) {

	// Concat IPs if need
	// 0 : Both ipv4 and ipv6
	// 4 : Only ipv4
	// 6 : Only ipv6
	r.mutex.Lock()
	defer r.mutex.Unlock()

	_, ok := r.cache[fqdn]
	if ok == false {
		// Absent from the cache
		return nil, false
	}

	if r.cache[fqdn].expirationTime.Before(time.Now()) {
		return nil, false
	}

	// Update LastHit to prevent cleaning by the Cache Own GC
	r.cache[fqdn].lastHit = time.Now()

	switch ipv {

	case 4:
		return r.cache[fqdn].ipsv4, true
	case 6:
		return r.cache[fqdn].ipsv6, true

	default:
		ips := make([]net.IP, 0, len(r.cache[fqdn].ipsv4)+len(r.cache[fqdn].ipsv6))
		ips = append(ips, r.cache[fqdn].ipsv4...)
		ips = append(ips, r.cache[fqdn].ipsv6...)
		return ips, true

	}

}

// cacheEntry
// Not perfect, a expirationTime is shared for every records
// Good enough for now (v0.7)
type cacheEntry struct {
	ipsv6 []net.IP
	ipsv4 []net.IP

	expirationTime time.Time
	lastHit        time.Time
}

// emptyRecords returns a bool value which indicates whether the cache has IPs
func (i *cacheEntry) emptyRecords(ipv int) bool {

	switch ipv {

	case 4:
		if len(i.ipsv4) == 0 {
			return true
		}
	case 6:
		if len(i.ipsv6) == 0 {
			return true
		}
	default:
		if len(i.ipsv6) == 0 && len(i.ipsv4) == 0 {
			return true
		}
	}

	return false
}

// NewCachedResolver runs a DNS Cache to avoid frequent DNS queries to
// the host OS. This save CPU and time.
// This DNS Cache is fairly simple (v0.7)
func NewCachedResolver() (*Resolver, error) {

	r := Resolver{
		timeout:          6 * time.Second,
		garbageCollector: time.NewTicker(12 * time.Minute),
	}
	r.cache = make(map[string]*cacheEntry, 1)
	r.resolveChannels = make(map[string]chan error)

	go r.runGC()

	return &r, nil
}

// resolveWithoutCache will query A and/or AAAA record from a DNS resolver
func (r *Resolver) resolveWithoutCache(fqdn string, ipv int) (*cacheEntry, error) {

	// Simply add . if missing from a fqdn (mandatory for miekg/dns)
	if fqdn[len(fqdn)-1:] != "." {
		fqdn = fmt.Sprint(fqdn + ".")
	}

	now := time.Now().Local()

	ce := cacheEntry{
		lastHit: now,
	}

	config, err := dns.ClientConfigFromFile("/etc/resolv.conf")
	if err != nil {
		return nil, fmt.Errorf("DNSCache : unable to detect a DNS resolver : %s", err)
	}
	c := new(dns.Client)
	m := new(dns.Msg)
	m.RecursionDesired = true

	// minExpiration will set the expiration for all the fqdn records
	// This is not the proper way to cache DNS record but for now it's OK (v0.7)
	// rfc2181 Set maximum expiration, if other exp are < , kinda ugly too
	// but getting the first record TTL required multiples lines.
	minExpiration := time.Now().Local().Add(time.Second * 2147483647)

	if ipv == 0 || ipv == 4 {

		m.SetQuestion(fqdn, dns.TypeA)
		rA, _, errEx := c.Exchange(m, config.Servers[0]+":"+config.Port)
		if errEx != nil {
			return nil, fmt.Errorf("DNSCache : unable to query : %s", errEx)
		}

		ips4 := make([]net.IP, 0, len(rA.Answer))

		for _, a := range rA.Answer {
			if rec, ok := a.(*dns.A); ok {
				ips4 = append(ips4, rec.A)

				x := time.Second * time.Duration(rec.Hdr.Ttl)
				exp := now.Add(x)
				if exp.Before(minExpiration) {
					minExpiration = exp
				}

			}
		}
		ce.ipsv4 = ips4
	}

	if ipv == 0 || ipv == 6 {

		m.SetQuestion(fqdn, dns.TypeAAAA)
		rAAAA, _, errEx := c.Exchange(m, config.Servers[0]+":"+config.Port)
		if errEx != nil {
			return nil, fmt.Errorf("DNSCache : unable to query : %s", errEx)
		}

		ips6 := make([]net.IP, 0, len(rAAAA.Answer))

		for _, a := range rAAAA.Answer {
			if rec, ok := a.(*dns.AAAA); ok {
				ips6 = append(ips6, rec.AAAA)

				x := time.Second * time.Duration(rec.Hdr.Ttl)
				exp := now.Add(x)
				if exp.Before(minExpiration) {
					minExpiration = exp
				}

			}
		}
		ce.ipsv6 = ips6
	}

	if minExpiration == now {
		// Localhost is as no TTL
		minExpiration = time.Now().Add(time.Hour)
	}
	ce.expirationTime = minExpiration

	return &ce, nil

}

// LookupHost looks up the given host
// As a cache DNS, if the host is present and still valid (TTL)
// no queries will be made to a DNS resolver.
// If the host is absent in the cache, a query will be made
// then the result saved for later queries.
func (r *Resolver) LookupHost(ctx context.Context, host string, ipv int) (addrs []string, err error) {

	a, err := r.resolveHost(ctx, host, ipv)
	if err != nil {
		return nil, err
	}

	ips := make([]string, 0, len(a))

	for _, ip := range a {
		ips = append(ips, ip.String())
	}

	return ips, nil
}

// resolveHost try to get a DNS Answer in the cache
// if absent then try to ask a DNS resolver
// if success : store the answer (ipv4 & 6) in the cache with an expiration date.
func (r *Resolver) resolveHost(ctx context.Context, host string, ipv int) ([]net.IP, error) {
	ips, ok := r.getIPFromCache(host, ipv)
	if ok {
		return ips, nil
	}

	r.chanLock.Lock()
	// Concurrent calls : This host may have already been requested.
	ch := r.resolveChannels[host]
	if ch == nil {
		// Recheck the cache.
		ips, ok := r.getIPFromCache(host, ipv)
		if ok {
			return ips, nil
		}
		ch = make(chan error, 1)
		r.resolveChannels[host] = ch
		// No IPs from this fqdn are the cache.
		// There is no resolving process for the host.
		// Create a new goroutine to lookup dns without cache.
		go func() {
			var dnsError error
			var item *cacheEntry

			//  !! Defer !!
			defer func() {
				r.mutex.Lock()
				if item == nil {
					// Remove host from cache.
					delete(r.cache, host)
				} else {
					// Cache the item.
					r.cache[host] = item
				}
				r.mutex.Unlock()

				// Wake up a resolveHost function.
				r.chanLock.Lock()
				delete(r.resolveChannels, host)
				ch <- dnsError
				r.chanLock.Unlock()
			}()

			// Resolve host without caching
			ipsWOCache, err := r.resolveWithoutCache(host, ipv)
			if err != nil {
				dnsError = fmt.Errorf("can't resolve host %q because %s", host, err.Error())
				return
			}
			if ipsWOCache.emptyRecords(ipv) {
				dnsError = fmt.Errorf("no dns records for host %s", host)
				return
			}
			item = ipsWOCache
			return
		}()
	}
	r.chanLock.Unlock()

	select {
	case err := <-ch:
		// Put back the error. This operation can wake up other resolveHost functions.
		ch <- err
		if err != nil {
			return nil, err
		}
		// Now that the resolution has taken place, try to get IP from the cache
		// If there is no entry at this point, then error.

		// The DNS cache entry should be fresh
		ips, _ := r.getIPFromCache(host, ipv)
		if ips != nil {
			return ips, nil
		} else {
			return nil, fmt.Errorf("no dns records of host %q in cache", host)
		}
	case <-ctx.Done():
		return nil, fmt.Errorf("can't resolve host %q because context timeout : %s", host, ctx.Err())
	}
}

// runGC avoid any residual records to stay in the cache
func (r *Resolver) runGC() {

	for {
		select {
		case <-r.garbageCollector.C:
			r.gcOldRecords()
		}
	}

}

// gcOldRecords remove expired records and
// records that have not been used for some time.
func (r *Resolver) gcOldRecords() {

	r.mutex.Lock()

	for fqdn, ce := range r.cache {

		if ce.expirationTime.After(time.Now()) {
			delete(r.cache, fqdn)
		}

		maxRetention := ce.lastHit.Add(13 * time.Hour)

		if time.Now().After(maxRetention) {
			delete(r.cache, fqdn)
		}

	}

	r.mutex.Unlock()

}
