package hash

import (
	"crypto/md5"
	"crypto/sha1"
	"crypto/sha256"
	"crypto/sha512"
	"fmt"
	"strings"
	"time"

	valid "github.com/asaskevich/govalidator"
	"github.com/mitchellh/mapstructure"

	"github.com/vincoll/vigie/pkg/probe"
)

// Name of the probe
const Name = "hash"

// New returns a new Probe
func New() probe.Probe {
	return &Probe{}
}

// Return Probe Name
func (Probe) GetName() string {
	return Name
}

func (Probe) GetDefaultTimeout() time.Duration {
	return time.Second * 60
}

func (Probe) GetDefaultFrequency() time.Duration {
	return time.Minute * 5
}

// Probe struct : Informations necessaires à l'execution de la probe
// All attributes must be Public
type Probe struct {
	Name     string `json:"name" yaml:"name"`
	Algo     string `json:"algo" yaml:"algo" valid:"in(md5|sha1|sha2|sha256|sha512),required"`
	URL      string `json:"url" yaml:"url" valid:"url,required"`
	Interval int    `json:"interval" yaml:"interval"`
}

// ProbeAnswer is the returned result after query
// All attributes must be Public
// ProbeInfo is Mandatory => Détail l'execution de la probe
type ProbeAnswer struct {
	Hash         string          `json:"hash"`
	ProbeInfo    probe.ProbeInfo `json:"probeinfo"`
	ResponseTime float64
}

// GenerateTStepName return a tstep name if non existent
func (p *Probe) GenerateTStepName() string {
	generatedName := fmt.Sprintf("%s_%s_%s", p.GetName(), p.Algo, p.URL)
	return generatedName
}

// Initialize Probe struct data
func (p *Probe) Initialize(step probe.StepProbe) error {

	// Decode Probe Struct from TestStep
	if err := mapstructure.Decode(step, p); err != nil {
		return err
	}

	// Lower the case for vigie valid SHA1 => sha1
	p.Algo = strings.ToLower(p.Algo)

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

	resDump, _ := probe.ToMap(probeAnswer)

	pr := probe.ProbeReturn{
		ProbeInfo: probeAnswer.ProbeInfo,
		Answer:    resDump,
	}

	probeReturns = make([]probe.ProbeReturn, 0, 1)
	probeReturns = append(probeReturns, pr)
	return probeReturns

}

// work déclenche l'appel "metier" de la probe.
// Le switch sert à appeller une fonction particuliére en fonction des info de la probe.
func (p *Probe) work(timeout time.Duration) ProbeAnswer {

	chResult := make(chan ProbeAnswer, 1) // Chan for ResultStatus

	switch p.Algo {

	case "md5":
		go func() {
			chResult <- hashFile(md5.New(), p.URL)
		}()

	case "sha1":
		go func() {
			chResult <- hashFile(sha1.New(), p.URL)
		}()

	case "sha2":
		go func() {
			chResult <- hashFile(sha256.New(), p.URL)
		}()

	case "sha256":
		go func() {
			chResult <- hashFile(sha256.New(), p.URL)
		}()

	case "sha512":
		go func() {
			chResult <- hashFile(sha512.New(), p.URL)
		}()

		/*
			case "blake256":
				r <- hashFile(crypto.BLAKE2b_256.New())
			case "blake384":
				r <- hashFile(crypto.BLAKE2b_384.New())
			case "blake512":
				r <- hashFile(crypto.BLAKE2b_512.New())
		*/

	default:
		pi := probe.ProbeInfo{Error: fmt.Sprintf("%q is not a supported algorithm.", p.Algo), Status: probe.Error}
		return ProbeAnswer{ProbeInfo: pi}
	}

	select {

	case pa := <-chResult:
		return pa

	case <-time.After(timeout):
		pi := probe.ProbeInfo{Status: probe.Timeout, Error: fmt.Sprintf("timeout after %s", timeout)}
		pa := ProbeAnswer{ProbeInfo: pi}
		return pa
	}

}
