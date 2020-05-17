package probe

import (
	"context"
	"fmt"
	"github.com/vincoll/vigie/pkg/core"
	"net"
)

// GetIPsFromHostname returns a array of IPs resolved by a Hostname
// Ipv4 or Ipv6
// This func must be divided WIP
func GetIPsFromHostname(host string, ipv int) ([]string, error) {

	// If a Hostname is provided:
	// The probe will check every IPs behind this DNS record

	// Test if host is a network hostname or an IP
	// If IP : checks and return,
	// If NetworkName : Get all IP @ behind this name check and return.
	res := net.ParseIP(host)

	// If IP
	if res != nil {
		// Simply return the IP if matching ipv
		switch {

		case ipv == 0:

			simpleIP := []string{res.String()}
			return simpleIP, nil

		case isIPv4(res) && ipv <= 4:

			simpleIP := []string{res.String()}
			return simpleIP, nil

		case isIPv6(res) && ipv >= 6:

			simpleIP := []string{res.String()}
			return simpleIP, nil

		default:
			return nil, fmt.Errorf("the one IP %q is not the expected ip version (%d)", host, ipv)

		}

	}

	//
	// Network Hostname
	// Get all the IPs behind a DNS record
	//

	addrs, err := core.VigieServer.CacheDNS.LookupHost(context.Background(), host, ipv)
	if err != nil {
		return nil, fmt.Errorf("error while DNS resolution of %q : %s", host, err)
	}

	hosts := make([]string, 0, len(addrs))

	for _, addr := range addrs {

		switch {

		case isIPv6(net.ParseIP(addr)) && ipv == 6:
			hosts = append(hosts, addr)

		case isIPv4(net.ParseIP(addr)) && ipv == 4:
			hosts = append(hosts, addr)

		default:
			hosts = append(hosts, addr)

		}

	}
	return hosts, nil

}

func GetIPsWithPort(host string, port int, ipv int) ([]string, error) {

	ips, err := GetIPsFromHostname(host, ipv)
	if err != nil {
		return nil, err
	}
	ipsPort := make([]string, 0, len(ips))
	for _, ip := range ips {
		simpleIP := net.JoinHostPort(ip, fmt.Sprintf("%d", port))

		ipsPort = append(ipsPort, simpleIP)
	}

	return ipsPort, nil
}

func isIPv4(ip net.IP) bool {
	return len(ip.To4()) == net.IPv4len
}

func isIPv6(ip net.IP) bool {
	return len(ip) == net.IPv6len
}
