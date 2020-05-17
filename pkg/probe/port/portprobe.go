package port

import (
	"fmt"
	"time"

	valid "github.com/asaskevich/govalidator"
	"github.com/mitchellh/mapstructure"

	"github.com/vincoll/vigie/pkg/probe"
)

// Name of the probe
const Name = "port"

// New returns a new Probe
func New() probe.Probe {
	return &Probe{}
}

// Return Probe Name
func (Probe) GetName() string {
	return Name
}

func (Probe) GetDefaultTimeout() time.Duration {
	return time.Second * 10
}

func (Probe) GetDefaultFrequency() time.Duration {
	return time.Second * 30
}

// Probe struct : Informations necessaires à l'execution de la probe
// All attributes must be Public
type Probe struct {
	Host       string `json:"host"`
	Protocol   string `json:"protocol"`
	Port       int    `json:"port"`
	IPprotocol int    `json:"ipprotocol"`
}

// ProbeAnswer is the returned result after query
// All attributes must be Public
// ProbeInfo is Mandatory => Détail l'execution de la probe
type ProbeAnswer struct {
	Reachable bool            `json:"reachable"`
	ProbeInfo probe.ProbeInfo `json:"probeinfo"`
}

// GenerateTStepName return a tstep name if non existent
func (p *Probe) GenerateTStepName() string {
	generatedName := fmt.Sprintf("%s_%s@%s:%d", p.GetName(), p.Protocol, p.Host, p.Port)
	return generatedName
}

// Initialize Probe struct data
func (p *Probe) Initialize(step probe.StepProbe) error {

	// Decode Probe Struct from TestStep
	if err := mapstructure.Decode(step, p); err != nil {
		return err
	}

	// Check if TestStep is Valid with asaskevich/govalidator
	ok, err := valid.ValidateStruct(p)
	if err != nil {
		return err
	}
	if !ok {
		return fmt.Errorf("a step is not valid: %s", step)
	}

	// Support only IPv4 for now
	if p.IPprotocol == 0 {
		p.IPprotocol = 4
	}

	return nil
}

// Start the probe request
func (p *Probe) Run(timeout time.Duration) (probeReturns []probe.ProbeReturn) {

	// Start the Request
	probeAnswers := p.process(timeout)
	probeReturns = make([]probe.ProbeReturn, 0, len(probeAnswers))

	for _, pa := range probeAnswers {

		resDump, err := probe.ToMap(pa)
		if err != nil {
			println("Error Dump Probe Res")
		}
		pr := probe.ProbeReturn{Answer: resDump, ProbeInfo: pa.ProbeInfo}
		probeReturns = append(probeReturns, pr)

	}

	return probeReturns

}
