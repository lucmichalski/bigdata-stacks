package x509

import (
	"crypto/x509"
	"crypto/x509/pkix"
	"encoding/asn1"
	"fmt"
	"math/big"
	"net"
	"net/url"
	"time"

	valid "github.com/asaskevich/govalidator"
	"github.com/mitchellh/mapstructure"

	"github.com/vincoll/vigie/pkg/probe"
)

// Name of the probe
const Name = "x509"
const defaultHTTPSport = 443

// New returns a new Probe
func New() probe.Probe {
	return &Probe{}
}

// Return Probe Name
func (Probe) GetName() string {
	return Name
}

func (Probe) GetDefaultTimeout() time.Duration {
	return time.Second * 30
}

func (Probe) GetDefaultFrequency() time.Duration {
	return time.Minute * 5
}

// Probe struct : Informations necessaires à l'execution de la probe
// All attributes must be Public
type Probe struct {
	Host        string `json:"host"`
	Port        int    `json:"port"`
	RootCertRaw string `json:"rootCert"`
	rootCert    x509.CertPool
}

// ProbeAnswer is the returned result after query
// All attributes must be Public
// ProbeInfo is Mandatory => Détail l'execution de la probe
type ProbeAnswer struct {
	Valid   bool `json:"valid"`
	Expired bool `json:"expired"`
	// TODO Trusted             bool      `json:"trusted"`
	Daybeforeexpiration int       `json:"daybeforeexpiration"`
	EndCertificate      ProbeCert `json:"endcertificate"`
	IntCertificate      ProbeCert `json:"intcertificate"`
	RootCertificate     ProbeCert `json:"rootcertificate"`

	ProbeInfo probe.ProbeInfo `json:"probeinfo"`
}

type ProbeCert struct {
	Signature                   []byte                  `json:"signature"`
	SignatureAlgorithm          string                  `json:"signaturealgorithm"`
	PublicKeyAlgorithm          string                  `json:"publickeyalgorithm"`
	PublicKey                   string                  `json:"publickey"` //interface{}
	Version                     int                     `json:"version"`
	SerialNumber                *big.Int                `json:"serialnumber"`
	Issuer                      pkix.Name               `json:"issuer"`
	Subject                     pkix.Name               `json:"subject"`
	NotBefore                   time.Time               `json:"notbefore"` // Validity bounds.
	NotAfter                    time.Time               `json:"notafter"`
	KeyUsage                    string                  `json:"keyusage"`
	Extensions                  []pkix.Extension        `json:"extensions"`
	ExtraExtensions             []pkix.Extension        `json:"extraextensions"`
	UnhandledCriticalExtensions []asn1.ObjectIdentifier `json:"unhandledcriticalextensions"`
	ExtKeyUsage                 string                  `json:"extkeyusage"` // []string // Sequence of extended key usages.
	BasicConstraintsValid       bool                    `json:"basicconstraintsvalid"`
	IsCA                        bool                    `json:"isca"`
	MaxPathLen                  int                     `json:"maxpathlen"`
	SubjectKeyId                []byte                  `json:"subjectkeyid"`
	AuthorityKeyId              []byte                  `json:"authoritykeyid"`
	OCSPServer                  []string                `json:"ocspserver"`
	IssuingCertificateURL       []string                `json:"issuingcertificateurl"`
	DNSNames                    []string                `json:"dnsnames"`
	EmailAddresses              []string                `json:"emailaddresses"`
	IPAddresses                 []net.IP                `json:"ipaddresses"`
	URIs                        []*url.URL              `json:"uris"`

	// Name constraints
	PermittedDNSDomainsCritical bool         `json:"permitteddnsdomainscritical"` // if true then the name constraints are marked critical.
	PermittedDNSDomains         []string     `json:"permitteddnsdomains"`
	ExcludedDNSDomains          []string     `json:"excludeddnsdomains"`
	PermittedIPRanges           []*net.IPNet `json:"permittedipranges"`
	ExcludedIPRanges            []*net.IPNet `json:"excludedipranges"`
	PermittedEmailAddresses     []string     `json:"permittedemailaddresses"`
	ExcludedEmailAddresses      []string     `json:"excludedemailaddresses"`
	PermittedURIDomains         []string     `json:"permitteduridomains"`
	ExcludedURIDomains          []string     `json:"excludeduridomains"`

	// CRL Distribution Points
	CRLDistributionPoints []string
}

// GenerateTStepName return a tstep name if non existent
func (p *Probe) GenerateTStepName() string {
	generatedName := fmt.Sprintf("%s_%s:%d", p.GetName(), p.Host, p.Port)
	return generatedName
}

// Initialize Probe struct data
func (p *Probe) Initialize(step probe.StepProbe) error {

	// Decode Probe Struct from TestStep
	if err := mapstructure.Decode(step, p); err != nil {
		return err
	}

	if p.Port == 0 {
		p.Port = defaultHTTPSport
	}

	if p.RootCertRaw != "" {
		p.rootCert = rawToCertPool(p.RootCertRaw)
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
	probeAnswer := p.work(timeout)
	probeReturns = make([]probe.ProbeReturn, 0, 1)
	var pr probe.ProbeReturn

	resDump, err := probe.ToMap(probeAnswer)
	if err != nil {
		println("Error Dump Probe Res")
	}

	pr = probe.ProbeReturn{Answer: resDump, ProbeInfo: probeAnswer.ProbeInfo}
	probeReturns = append(probeReturns, pr)

	return probeReturns

}

// work déclenche l'appel "metier" de la probe.
// Le switch sert à appeller une fonction particuliére en fonction des info de la probe.
func (p *Probe) work(timeout time.Duration) ProbeAnswer {

	tcpHost := fmt.Sprintf("%s:%d", p.Host, p.Port)

	if p.RootCertRaw != "" {
		return checkX509(tcpHost, "", &p.rootCert, timeout)
	} else {
		return checkX509(tcpHost, "", nil, timeout)
	}

}
