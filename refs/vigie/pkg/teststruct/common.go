package teststruct

import (
	"encoding/json"
	"fmt"
	"github.com/vincoll/vigie/pkg/assertion"
	"github.com/vincoll/vigie/pkg/probe"
	"time"
)

type VigieResult struct {
	ProbeAnswer       map[string]interface{}   `json:"probe_answer"`
	ProbeInfo         probe.ProbeInfo          `json:"probe_info"`
	AssertionResult   []assertion.AssertResult `json:"assertion_result"`
	Status            StepStatus               `json:"status"`
	StatusDescription string                   `json:"status_description"`
}

func (vr *VigieResult) GetValues() (vv VigieValue) {

	rt := vr.ProbeInfo.ResponseTime

	data, err := json.Marshal(vr)
	if err != nil {
		fmt.Printf("marshal failed: %s", err)
	}

	vv = VigieValue{
		// ResultStatus Teststep (string detail)
		Status: vr.Status.Int(),
		// Returned probe result (string: raw json result)
		Msg: string(data),
		// Subtest
		Subtest: vr.ProbeInfo.SubTest,
	}

	if vr.Status.IsTimeMesureable() {
		// ResponseTime (If relevant: float64 second based)
		vv.Responsetime = rt.Seconds()
	}

	return vv
}

type VigieValue struct {
	Status       int
	Responsetime float64
	Msg          string
	Subtest      string
}

type UIDTest struct {
	TestSuite TSHeader      `json:"testsuite"`
	TestCase  TCHeader      `json:"testcase"`
	TestStep  TStepDescribe `json:"teststep"`
}

type AlertMessage struct {
	TSname     string     `json:"tsname"`
	TSfile     string     `json:"tsfile"`
	TCname     string     `json:"tcname"`
	TCstatus   bool       `json:"tcres"`
	TStepfails []TestStep `json:"tstepfails"`
}

type TotalAlertMessage struct {
	Date       time.Time
	TestSuites map[uint64]TSAlertShort
}

type StepStatus int

const (
	Success       StepStatus = 1
	NotDefined    StepStatus = 0
	AssertFailure StepStatus = -1
	Failure       StepStatus = -2
	Timeout       StepStatus = -3
	Error         StepStatus = -4
)

func (ss StepStatus) String() string {

	m := map[StepStatus]string{
		NotDefined:    "not_defined",
		Success:       "success",
		AssertFailure: "assert_failure",
		Failure:       "failure",
		Timeout:       "timeout",
		Error:         "error",
	}

	return m[ss]
}

func (ss StepStatus) Int() int {
	return int(ss)
}

func (ss StepStatus) IsSucess() bool {
	return ss == Success
}

func (ss StepStatus) IsTimeMesureable() bool {
	if ss == Success || ss == AssertFailure {
		return true
	} else {
		return false
	}
}
