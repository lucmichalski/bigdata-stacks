package dns

import (
	"github.com/miekg/dns"
	"github.com/vincoll/vigie/pkg/probe"
	"strings"
	"time"
)

// LookupNS returns the DNStask NS records for the given domain name.
func _LookupNS(probe Probe) (*ProbeAnswer, error) {
	// TODO NS
	return nil, nil
}

func lookupA(fqdn string, config dns.ClientConfig) []ProbeAnswer {

	c := new(dns.Client)
	c.Timeout = time.Duration(config.Timeout)

	m := new(dns.Msg)
	m.SetQuestion(fqdn, dns.TypeA)
	m.RecursionDesired = true

	r, rtt, err := c.Exchange(m, config.Servers[0]+":"+config.Port)
	if err != nil {
		return generateProbeErrCode(err, probe.Failure)
	}

	if r.Rcode != dns.RcodeSuccess {
		return generateProbeErrCode(err, probe.Error)
	}

	// Concat every answer into a array
	// easier to assert for now (v0.7)
	answers := make([]string, 0, len(r.Answer))
	for _, a := range r.Answer {
		if rec, ok := a.(*dns.A); ok {
			answers = append(answers, rec.A.String())
		}
	}

	pas := make([]ProbeAnswer, 0, len(r.Answer))
	// Every DNS record as a answer.
	for _, a := range r.Answer {

		if rec, ok := a.(*dns.A); ok {

			pa := ProbeAnswer{
				Answer:       answers,
				ResponseTime: rtt.Seconds(),
				ProbeInfo:    probe.ProbeInfo{Status: probe.Success},
				TTL:          rec.Hdr.Ttl,
			}
			pas = append(pas, pa)
		}
	}

	return pas
}

func lookupAAAA(fqdn string, config dns.ClientConfig) []ProbeAnswer {

	c := new(dns.Client)
	c.Timeout = time.Duration(config.Timeout)

	m := new(dns.Msg)
	m.SetQuestion(fqdn, dns.TypeAAAA)
	m.RecursionDesired = true

	r, rtt, err := c.Exchange(m, config.Servers[0]+":"+config.Port)
	if err != nil {
		return generateProbeErrCode(err, probe.Failure)
	}

	if r.Rcode != dns.RcodeSuccess {
		return generateProbeErrCode(err, probe.Error)
	}

	// Concat every answer into a array
	// easier to assert for now (v0.7)
	answers := make([]string, 0, len(r.Answer))
	for _, a := range r.Answer {
		if rec, ok := a.(*dns.AAAA); ok {
			answers = append(answers, rec.AAAA.String())
		}
	}

	pas := make([]ProbeAnswer, 0, len(r.Answer))
	// Every DNS record as a answer.
	for _, a := range r.Answer {

		if rec, ok := a.(*dns.AAAA); ok {

			pa := ProbeAnswer{
				Answer:       answers,
				ResponseTime: rtt.Seconds(),
				ProbeInfo:    probe.ProbeInfo{Status: probe.Success},
				TTL:          rec.Hdr.Ttl,
			}
			pas = append(pas, pa)
		}
	}

	return pas
}

func lookupTXT(fqdn string, config dns.ClientConfig) []ProbeAnswer {

	c := new(dns.Client)
	c.Timeout = time.Duration(config.Timeout)

	m := new(dns.Msg)
	m.SetQuestion(fqdn, dns.TypeTXT)
	m.RecursionDesired = true

	r, rtt, err := c.Exchange(m, config.Servers[0]+":"+config.Port)
	if err != nil {
		return generateProbeErrCode(err, probe.Failure)
	}

	if r.Rcode != dns.RcodeSuccess {
		return generateProbeErrCode(err, probe.Error)
	}

	// Concat every answer into a array
	// easier to assert for now (v0.7)
	answers := make([]string, 0, len(r.Answer))
	for _, a := range r.Answer {
		if rec, ok := a.(*dns.TXT); ok {
			answers = append(answers, rec.Txt[0])
		}
	}

	pas := make([]ProbeAnswer, 0, len(r.Answer))
	// Every DNS record as a answer.
	for _, a := range r.Answer {

		if rec, ok := a.(*dns.TXT); ok {

			pa := ProbeAnswer{
				Answer:       answers,
				ResponseTime: rtt.Seconds(),
				ProbeInfo:    probe.ProbeInfo{Status: probe.Success},
				TTL:          rec.Hdr.Ttl,
			}
			pas = append(pas, pa)
		}
	}

	return pas
}

func lookupCNAME(fqdn string, config dns.ClientConfig) []ProbeAnswer {

	c := new(dns.Client)
	c.Timeout = time.Duration(config.Timeout)

	m := new(dns.Msg)
	m.SetQuestion(fqdn, dns.TypeCNAME)
	m.RecursionDesired = true

	r, rtt, err := c.Exchange(m, config.Servers[0]+":"+config.Port)
	if err != nil {
		return generateProbeErrCode(err, probe.Failure)
	}

	if r.Rcode != dns.RcodeSuccess {
		return generateProbeErrCode(err, probe.Error)
	}

	answers := make([]string, 0, len(r.Answer))
	for _, a := range r.Answer {
		if rec, ok := a.(*dns.CNAME); ok {
			answers = append(answers, rec.Target)
		}
	}

	pas := make([]ProbeAnswer, 0, len(r.Answer))
	for _, a := range r.Answer {

		if rec, ok := a.(*dns.CNAME); ok {

			pa := ProbeAnswer{
				Answer:       answers,
				ResponseTime: rtt.Seconds(),
				ProbeInfo:    probe.ProbeInfo{Status: probe.Success},
				TTL:          rec.Hdr.Ttl,
			}
			pas = append(pas, pa)
		}
	}

	return pas
}

func lookupMX(fqdn string, config dns.ClientConfig) []ProbeAnswer {

	c := new(dns.Client)
	c.Timeout = time.Duration(config.Timeout)

	m := new(dns.Msg)
	m.SetQuestion(fqdn, dns.TypeMX)
	m.RecursionDesired = true

	r, rtt, err := c.Exchange(m, config.Servers[0]+":"+config.Port)
	if err != nil {
		return generateProbeErrCode(err, probe.Failure)
	}

	if r.Rcode != dns.RcodeSuccess {
		return generateProbeErrCode(err, probe.Error)
	}

	// Concat every answer into a array
	// easier to assert for now (v0.7)
	answers := make([]string, 0, len(r.Answer))
	for _, a := range r.Answer {
		if rec, ok := a.(*dns.MX); ok {
			answers = append(answers, rec.Mx)
		}
	}

	pas := make([]ProbeAnswer, 0, len(r.Answer))
	// Every DNS record as a answer.
	for _, a := range r.Answer {

		if rec, ok := a.(*dns.MX); ok {

			pa := ProbeAnswer{
				Answer:       answers,
				ResponseTime: rtt.Seconds(),
				ProbeInfo:    probe.ProbeInfo{Status: probe.Success},
				TTL:          rec.Hdr.Ttl,
			}
			pas = append(pas, pa)
		}
	}

	return pas
}

func generateProbeErrCode(err error, status probe.Status) []ProbeAnswer {

	pi := probe.ProbeInfo{
		Status: status,
		Error:  err.Error(),
	}
	// Define Vigie ProbeCode Error
	switch {

	case strings.ContainsAny("no such host", err.Error()):
		pi.ProbeCode = 404
	default:
		pi.ProbeCode = 666

	}

	pa := ProbeAnswer{
		ProbeInfo: pi,
	}
	probeAnswers := make([]ProbeAnswer, 0, 0)
	probeAnswers = append(probeAnswers, pa)
	return probeAnswers
}
