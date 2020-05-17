package probetable

import (
	"github.com/vincoll/vigie/pkg/probe"
	"github.com/vincoll/vigie/pkg/probe/debug"
	"github.com/vincoll/vigie/pkg/probe/dns"
	"github.com/vincoll/vigie/pkg/probe/hash"
	"github.com/vincoll/vigie/pkg/probe/http"
	"github.com/vincoll/vigie/pkg/probe/icmp"
	"github.com/vincoll/vigie/pkg/probe/port"
	"github.com/vincoll/vigie/pkg/probe/x509"
)

var AvailableProbes = map[string]probe.Probe{

	x509.Name:  x509.New(),
	hash.Name:  hash.New(),
	dns.Name:   dns.New(),
	port.Name:  port.New(),
	debug.Name: debug.New(),
	icmp.Name:  icmp.New(),
	http.Name:  http.New(),
}
