package probe

import (
	"encoding/json"
	"time"
)

type StepProbe map[string]interface{}
type ProbeAnswer map[string]interface{}

type Status int

const (
	Success Status = 1  // Success
	Timeout Status = -2 // The probe request encountered a timeout
	Error   Status = -3 // The probe request encountered a error (can be considered as a desired state)
	Failure Status = -4 // The probe cannot create the request nor send it
)

// ProbeInfo details
// DO NOT EDIT
type ProbeInfo struct {
	Error        string        `json:"error"`
	Status       Status        `json:"status"`
	ProbeCode    int           `json:"probecode"`
	ResponseTime time.Duration `json:"responsetime"`
	SubTest      string        `json:"subtest"`
}

func (pi ProbeInfo) MarshalJSON() ([]byte, error) {

	type Copy ProbeInfo
	return json.Marshal(&struct {
		ResponseTime string `json:"responsetime"`
		Copy
	}{
		ResponseTime: pi.ResponseTime.String(),
		Copy:         (Copy)(pi),
	})
}

type ProbeDuration struct {
	time.Duration
}

func (d ProbeDuration) MarshalJSON() ([]byte, error) {
	return json.Marshal(d.String())
}

// ProbeReturn represents an probe result on a test step
type ProbeReturn struct {
	ProbeInfo ProbeInfo
	Answer    ProbeAnswer
}

// Probe execute a testStep.
type Probe interface {
	// Start run a Step TStep
	Run(timeout time.Duration) []ProbeReturn
	GetName() string
	Initialize(StepProbe) error
	GenerateTStepName() string
	GetDefaultTimeout() time.Duration
	GetDefaultFrequency() time.Duration
}
