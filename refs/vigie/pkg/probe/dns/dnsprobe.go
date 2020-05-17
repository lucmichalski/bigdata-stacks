package dns

import (
	"fmt"
	"github.com/miekg/dns"
	"time"

	valid "github.com/asaskevich/govalidator"
	"github.com/mitchellh/mapstructure"

	"github.com/vincoll/vigie/pkg/probe"
)

// Name of the probe
const Name = "dns"

// New returns a new Probe
func New() probe.Probe {
	return &Probe{}
}

// Return Probe Name
func (Probe) GetName() string {
	return Name
}

func (Probe) GetDefaultTimeout() time.Duration {
	return time.Second * 2
}

func (Probe) GetDefaultFrequency() time.Duration {
	return time.Second * 600
}

// Probe struct. Json and yaml descriptor are used for json output
type Probe struct {
	FQDN         string   `json:"fqdn"`         // IP or Hostname
	RecordType   string   `json:"recordtype"`   // Record Type to Lookup
	StrictAnswer bool     `json:"strictanswer"` // Attend uniquement la valeur
	NameServers  []string `json:"nameservers"`  // Send Request to a specified Nameserver
}

// ProbeAnswer is the returned result after query
// Every DNS Probe should have a different ProbeAnswer
// For now All in One
type ProbeAnswer struct {
	Answer       []string        `json:"answer"`
	TTL          uint32          `json:"ttl"`
	ResponseTime float64         `json:"responsetime"` // Reference Time Unit = Second
	Class        string          `json:"class"`
	Priority     int             `json:"priority"`
	Weight       int             `json:"weight"`
	Port         int             `json:"port"`
	Target       string          `json:"target"`
	Proto        string          `json:"proto"`
	ProbeInfo    probe.ProbeInfo `json:"probeinfo"`
}

// GenerateTStepName return a tstep name if non existent
func (p *Probe) GenerateTStepName() string {
	generatedName := fmt.Sprintf("%s_%s-%s", p.GetName(), p.FQDN, p.RecordType)
	return generatedName
}

// Initialize Probe struct data
func (p *Probe) Initialize(step probe.StepProbe) error {

	// Decode Probe Struct from TestStep
	if err := mapstructure.Decode(step, p); err != nil {
		return err
	}

	// TODO: Test if valid fqdn string

	// Simply add . if missing from a fqdn (mandatory for miekg/dns)
	if p.FQDN[len(p.FQDN)-1:] != "." {
		p.FQDN = fmt.Sprint(p.FQDN + ".")
	}

	// Check if TestStep is Valid with asaskevich/govalidator
	ok, err := valid.ValidateStruct(p)
	if err != nil {
		return err
	}
	if !ok {
		return fmt.Errorf("a step is not valid: %s", step)
	}

	return nil
}

// Start the probe request
func (p *Probe) Run(timeout time.Duration) (probeReturns []probe.ProbeReturn) {

	// Start the Request
	probeAnswers := p.work(timeout)

	for _, pa := range probeAnswers {

		aswDump, err := probe.ToMap(pa)
		if err != nil {
			pr := probe.ProbeReturn{Answer: aswDump, ProbeInfo: pa.ProbeInfo}
			probeReturns = append(probeReturns, pr)
		}
		pr := probe.ProbeReturn{Answer: aswDump, ProbeInfo: pa.ProbeInfo}
		probeReturns = append(probeReturns, pr)
	}

	return probeReturns

}

func (p *Probe) work(timeout time.Duration) (pas []ProbeAnswer) {

	dnsConfig := dns.ClientConfig{
		Timeout: int(timeout.Nanoseconds()),
		Port:    "53",
	}

	if len(p.NameServers) == 0 {
		config, err := dns.ClientConfigFromFile("/etc/resolv.conf")
		if err != nil {
			pi := probe.ProbeInfo{Error: fmt.Sprintf("/etc/resolv.conf is not a valid resolv.conf file : %s", err)}
			pa := ProbeAnswer{ProbeInfo: pi}
			pas = append(pas, pa)
			return pas
		}
		dnsConfig.Servers = config.Servers
	} else {
		dnsConfig.Servers = p.NameServers
	}

	switch p.RecordType {

	case "A":
		pas = lookupA(p.FQDN, dnsConfig)
	case "AAAA":
		pas = lookupAAAA(p.FQDN, dnsConfig)
	case "CNAME":
		pas = lookupCNAME(p.FQDN, dnsConfig)
	case "TXT":
		pas = lookupTXT(p.FQDN, dnsConfig)
	default:
		pi := probe.ProbeInfo{Error: fmt.Sprintf("%q is not a supported DNS Record Type.", p.RecordType), Status: probe.Error}
		pa := ProbeAnswer{ProbeInfo: pi}
		pas = append(pas, pa)

	}

	return pas
}
