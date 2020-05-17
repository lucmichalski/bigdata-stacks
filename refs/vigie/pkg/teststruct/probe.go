package teststruct

import (
	"fmt"
	"time"

	"github.com/vincoll/vigie/pkg/probe"
)

// Property represents a key/value pair used to define properties.
type configTestStructJson struct {
	Frequency   ProbeConfigJsonRaw `json:"frequency"` // time interval between two tests
	Concurrency map[string]int     `json:"concurrency"`
	Timeout     ProbeConfigJsonRaw `json:"timeout"`    // timeout on executor
	Retry       map[string]int     `json:"retry"`      // nb retry a test case if it is in failure.
	Retrydelay  ProbeConfigJsonRaw `json:"retrydelay"` // delay between two retries
}

// Property represents a key/value pair used to define properties.
type configTestStruct struct {
	Frequency   map[string]time.Duration `json:"frequency"` // time interval between two tests
	Concurrency map[string]int           `json:"concurrency"`
	Timeout     map[string]time.Duration `json:"timeout"`    // timeout on executor
	Retry       map[string]int           `json:"retry"`      // nb retry a test case if it is in failure.
	Retrydelay  map[string]time.Duration `json:"retrydelay"` // delay between two retries
}

type ProbeConfigJsonRaw map[string]string

type ProbeWrap struct {
	Probe      probe.Probe   `json:"probe"`
	Frequency  time.Duration `json:"frequency"`  // time interval between two tests
	Retry      int           `json:"retry"`      // nb retry a test case if it is in failure.
	Retrydelay time.Duration `json:"retrydelay"` // delay between two retries
	Timeout    time.Duration `json:"timeout"`    // timeout on executor
}

type ProbeWrapAPI struct {
	Probe      probe.Probe `json:"probe"`
	Frequency  string      `json:"frequency"`  // time interval between two tests
	Retry      int         `json:"retry"`      // nb retry a test case if it is in failure.
	Retrydelay string      `json:"retrydelay"` // delay between two retries
	Timeout    string      `json:"timeout"`    // timeout on executor
}

func (pw ProbeWrap) Export() ProbeWrapAPI {
	return ProbeWrapAPI{
		Probe:      pw.Probe,
		Frequency:  fmt.Sprintf("%v", pw.Frequency),
		Timeout:    fmt.Sprintf("%v", pw.Timeout),
		Retry:      pw.Retry,
		Retrydelay: fmt.Sprintf("%v", pw.Retrydelay),
	}
}

func (pw ProbeWrap) Run() []probe.ProbeReturn {
	return pw.Probe.Run(pw.Timeout)
}

// StepAssertions contains step assertions
type StepAssertions struct {
	Assertions []string `json:"assertions,omitempty"`
}

/*
func _stringifyExecutorResult(e ProbeReturn) map[string]string {
	out := make(map[string]string)
	for k, v := range e {
		out[k] = fmt.Sprintf("%v", v)
	}
	return out
}
*/
