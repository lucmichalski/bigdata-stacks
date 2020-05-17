package teststruct

import (
	"github.com/vincoll/vigie/pkg/probe"
	"github.com/vincoll/vigie/pkg/utils/timeutils"
	"time"
)

type StepResultDescribe struct {
	StatusStr                string         `json:"status"`
	LastAttempt              time.Time      `json:"lastattempt"`            // UnixTimeNano si Freq <1sec
	LastPositiveTimeResult   time.Time      `json:"lastpositivetimeresult"` // UnixTimeNano si Freq <1sec
	LastPositiveVigieResults *[]VigieResult `json:"lastpositivevigieresults"`
	VigieResults             []VigieResult  `json:"vigieresults"`
	Details                  []string       `json:"details"`
	LastChange               time.Time      `json:"lastchange"`
}

type TStepDescribe struct {
	Name      string             `json:"name"`
	StepProbe probe.Probe        `json:"probe"`
	StepD     StepParam          `json:"parameters"`
	StepResD  StepResultDescribe `json:"result"`
	StepAss   []string           `json:"assertions"`
}

type StepAssertionDescribe struct {
	Assertions []string
}

type TStepAlertShort struct {
	Name    string   `json:"name"`
	ID      uint64   `json:"id"`
	Status  string   `json:"status"`  // Status de la teststep
	Details []string `json:"details"` // Liste des messages result Assertions
}

// ToTestStepDescribe return a JSON API response
func (tStep *TestStep) ToTestStepDescribe() TStepDescribe {

	tStep.Mutex.RLock()

	TDesc := StepParam{
		Frequency:  timeutils.FormatDuration(tStep.ProbeWrap.Frequency),
		Retry:      tStep.ProbeWrap.Retry,
		Retrydelay: timeutils.FormatDuration(tStep.ProbeWrap.Retrydelay),
		Timeout:    timeutils.FormatDuration(tStep.ProbeWrap.Timeout),
	}

	// Add Assertion full text
	assrts := make([]string, 0, len(tStep.Assertions))
	for _, ta := range tStep.Assertions {
		assrts = append(assrts, ta.AssertConditionsLong())
	}

	TResDesc := StepResultDescribe{
		StatusStr:                tStep.Status.String(),
		LastAttempt:              tStep.LastAttempt,
		LastPositiveTimeResult:   tStep.LastPositiveTimeResult,
		LastPositiveVigieResults: tStep.GetLastPositiveResult(),
		VigieResults:             tStep.VigieResults,
		Details:                  tStep.Failures,
		LastChange:               tStep.LastChange,
	}

	desc := TStepDescribe{
		Name:      tStep.Name,
		StepProbe: tStep.ProbeWrap.Probe,
		StepD:     TDesc,
		StepResD:  TResDesc,
		StepAss:   assrts,
	}

	tStep.Mutex.RUnlock()

	return desc

}

func (tStep *TestStep) ToStepAlertShort() TStepAlertShort {

	tStep.Mutex.RLock()

	stepRecap := TStepAlertShort{
		Name:   tStep.Name,
		ID:     tStep.ID,
		Status: tStep.Status.String(),
	}

	switch tStep.Status {

	case AssertFailure:
		d := make([]string, 0, len(tStep.Assertions))

		for _, vr := range tStep.VigieResults {
			if vr.Status == AssertFailure {
				for _, assertRes := range vr.AssertionResult {
					if assertRes.ResultStatus != 1 {
						d = append(d, assertRes.ResultAssert)
					}
				}
			}
		}
		stepRecap.Details = d

	case Success, NotDefined:
		stepRecap.Details = nil

	case Error, Timeout:
		stepRecap.Details = tStep.Failures

	}

	tStep.Mutex.RUnlock()
	return stepRecap
}
