package debug

import (
	"fmt"
	"github.com/vincoll/vigie/pkg/utils"
	"time"

	"github.com/vincoll/vigie/pkg/probe"

	valid "github.com/asaskevich/govalidator"
	"github.com/mitchellh/mapstructure"
)

// Name of the probe
const Name = "debug"

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
	return time.Second * 30
}

// Probe struct. Json and yaml descriptor are used for json output
type Probe struct {
	Answer                 string        `json:"answer"`     // Answer to return for assertion
	Success                bool          `json:"success"`    // Return Probe Success
	Timeout                bool          `json:"timeout"`    // Return Probe timeout
	Error                  bool          `json:"error"`      // Return probe error
	ErrorCode              int           `json:"error_code"` // Return a specific probe code error
	Sleep                  string        `json:"sleep"`      // Pause the probe to simulate a timeout
	sleep                  time.Duration // dirty conversion
	FlipStatus             bool          `json:"flip_status"`           // The status will change over time
	FlipStatusFrequency    string        `json:"flip_status_frequency"` // ex: (10s, 1m, 10min)
	flipStatusFrequency    time.Duration // dirty conversion
	FlipStatusWhenTimePair string        `json:"flip_status_when_time_pair"` // Status when time related to freq is pair 20h10m20s , 20h10m40s
	FlipStatusWhenTimeOdd  string        `json:"flip_status_when_time_odd"`  // Status when time related to freq is odd 20h10m10s , 20h10m30s
}

// ProbeAnswer is the returned result after query
// All attributes must be Public
// ProbeInfo is Mandatory => Détail l'execution de la probe
type ProbeAnswer struct {
	Answer    string          `json:"answer"`
	ProbeInfo probe.ProbeInfo `json:"probeinfo"`
}

// ProbeFail details
type ProbeFail struct {
	Error        string  `json:"error"`
	VigieCode    int     `json:"fail"`
	ResponseTime float64 `json:"responsetime"` // Reference Time Unit = Second
}

// GenerateTStepName return a tstep name if non existent
func (p *Probe) GenerateTStepName() string {
	generatedName := fmt.Sprintf("%s_Flip%v", p.GetName(), p.FlipStatus)
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
		return fmt.Errorf("a value is not valid: %s", step)
	}

	p.sleep, _ = utils.ParseDuration(p.Sleep)
	p.flipStatusFrequency, _ = utils.ParseDuration(p.FlipStatusFrequency)
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
// Le switch sert à appeler une fonction particuliére en fonction des infos de la probe.
func (p *Probe) work(timeout time.Duration) ProbeAnswer {

	if p.FlipStatus {

		if isPairTime(p.flipStatusFrequency) {

			switch p.FlipStatusWhenTimePair {

			case "success":
				return p.genSuccessMsg(p.FlipStatusWhenTimePair)
			case "timeout":
				return p.genTimeout()
			case "error":
				return p.genError()
			default:
				return p.genSuccessMsg(p.FlipStatusWhenTimePair)

			}

		} else {

			switch p.FlipStatusWhenTimeOdd {

			case "success":
				return p.genSuccessMsg(p.FlipStatusWhenTimeOdd)
			case "timeout":
				return p.genTimeout()
			case "error":
				return p.genError()
			default:
				return p.genSuccessMsg(p.FlipStatusWhenTimeOdd)

			}

		}

	}

	switch {

	case p.Success:
		return p.genSuccess()
	case p.Timeout:
		return p.genTimeout()
	case p.Error:
		return p.genError()

	default:
		return p.genError()

	}

}

func isPairTime(freq time.Duration) bool {

	currentTime := time.Now().UnixNano()
	/*
		timeStampString := currentTime.Format("2006-01-02 15:04:05")
		layOut := "2006-01-02 15:04:05"
		timeStamp, err := time.Parse(layOut, timeStampString)
		if err != nil {
			fmt.Println(err)
		}
		hr, min, sec := timeStamp.Clock()

		fmt.Println("Year   :", currentTime.Year())
		fmt.Println("Month  :", currentTime.Month())
		fmt.Println("Day    :", currentTime.Day())
		fmt.Println("Hour   :", hr)
		fmt.Println("Min    :", min)
		fmt.Println("Sec    :", sec)

		currentTime.Minute()
	*/
	mod := currentTime % int64(freq)
	aa := currentTime - mod
	bbb := aa / int64(freq)

	if bbb%2 == 0 {
		return true
	} else {
		return false
	}

}
