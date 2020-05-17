package http

//
// Parts of this Probe's code came from httpstat
// https://github.com/davecheney/httpstat
// Thanks to Dave Cheney & Reorx
//

import (
	"fmt"
	"net"
	"net/http"
	"time"

	valid "github.com/asaskevich/govalidator"
	"github.com/mitchellh/mapstructure"

	"github.com/vincoll/vigie/pkg/probe"
)

// Name of the probe
const Name = "http"
const timeout = time.Second * 30
const defaultHTTPSport = 80

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
	return time.Second * 45
}

// Headers represents header HTTP for Request
type headers map[string]string

// Probe struct : Informations necessaires à l'execution de la probe
// All attributes must be Public
type Probe struct {
	Method              string  `json:"method"`  // Optional (GET, POST...) RFC 7231 section 4.3. (PATCH RFC 5789) Default=GET
	Version             int     `json:"version"` // Optional (1.0, 1.1, 2.0) Default=1.1
	URL                 string  `json:"url"`     // Full url http://fqdn.tld/path
	Body                string  `json:"body"`
	BodyFile            string  `json:"bodyfile"`
	Headers             headers `json:"headers"`
	IgnoreVerifySSL     bool    `json:"ignore_verify_ssl"`   // Optional Default=false
	BasicAuthUser       string  `json:"basic_auth_user"`     // Optional BasicAuth User
	BasicAuthPassword   string  `json:"basic_auth_password"` // Optional BasicAuth Password
	DontFollowRedirects bool    `json:"follow_redirects"`
	IpVersion           int     `json:"ip_version"` // Optional Resolve IPv4, IPv6, or Both (default 0=both)
	Proxy               string  `json:"proxy"`
	UserAgent           string  `json:"user_agent"`

	host    string // host:port
	request *http.Request

	// https://medium.com/@masnun/making-http-requests-in-golang-dd123379efe7

}

// ProbeAnswer is the returned result after query
// All attributes must be Public
// ProbeInfo is Mandatory => Détail l'execution de la probe
type ProbeAnswer struct {
	ProbeInfo     probe.ProbeInfo `json:"probeinfo"`
	HTTPcode      int             `json:"httpcode" `
	Body          string          `json:"body"`
	BodyJSON      interface{}     `json:"bodyjson"`
	Headers       headers         `json:"headers"`
	ResponsesTime responsesTime   `json:"responses_time"`
}

func (pa *ProbeAnswer) emptyAnswer(pInfo probe.ProbeInfo) {

	pa = &ProbeAnswer{
		HTTPcode:      0,
		Body:          "",
		BodyJSON:      nil,
		Headers:       nil,
		ProbeInfo:     pInfo,
		ResponsesTime: responsesTime{},
	}
}

type responsesTime struct {
	DnsLookup        time.Duration
	TcpConnection    time.Duration
	TlsHandshake     time.Duration
	ServerProcessing time.Duration
	ContentTransfert time.Duration
	Namelookup       time.Duration
	Connect          time.Duration
	Pretransfert     time.Duration
	Starttransfert   time.Duration
	Total            time.Duration
}

// GenerateTStepName return a tstep name if non existent
func (p *Probe) GenerateTStepName() string {
	generatedName := fmt.Sprintf("%s_(%s)%s", p.GetName(), p.Method, p.URL)
	return generatedName
}

// Initialize Probe struct data
func (p *Probe) Initialize(step probe.StepProbe) error {

	// Decode Probe Struct from TestStep
	if err := mapstructure.Decode(step, p); err != nil {
		return err
	}

	if !(p.IpVersion == 0 || p.IpVersion == 4 || p.IpVersion == 6) {
		return fmt.Errorf("ipVersion can be 4, 6, or 0 (both)")
	}
	if p.IpVersion == 0 {
		p.IpVersion = 4
	}

	if p.Method == "POST" || p.Method == "PUT" {
		/*
			if p.Body != "" && p.BodyFile != "" { //&& p.MultipartForm != nil {
				return fmt.Errorf("both body and body_file are filled. please choose only one")
			}
		*/

	}
	// Check if TestStep is Valid with asaskevich/govalidator
	ok, err := valid.ValidateStruct(p)
	if err != nil {
		return fmt.Errorf("a step is not valid: %s", err)
	}
	if !ok {
		return fmt.Errorf("a step is not valid: %s", step)
	}

	u, err := parseURL(p.URL)
	if err != nil {
		return fmt.Errorf("cannot parse URL %q : %s", p.URL, err)
	}

	host, _, err := net.SplitHostPort(u.Host)
	if err != nil {
		host = u.Host
	}
	p.host = host

	p.request, err = p.generateHTTPRequest(u.String())
	if err != nil {
		return fmt.Errorf("cannot generate a valid HTTP Request %s", err)
	}

	return nil
}

// Start the probe request
func (p *Probe) Run(timeout time.Duration) (probeReturns []probe.ProbeReturn) {

	// Start the Request
	probeAnswers := p.work(timeout)
	probeReturns = make([]probe.ProbeReturn, 0, len(probeAnswers))

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

// work déclenche l'appel "metier" de la probe.
// Le switch sert à appeller une fonction particuliére en fonction des info de la probe.
func (p *Probe) work(timeout time.Duration) []*ProbeAnswer {

	res := p.process(timeout)

	return res

}
