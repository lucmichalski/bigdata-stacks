package teststruct

import (
	"fmt"
	"time"
)

// unmarshallConfigTestStruct convert raw json data into more easily manipulated types
func unmarshallConfigTestStruct(ctjson configTestStructJson) (configTestStruct, error) {

	// Convert string duration format (1d, 127ms...) to time.duration
	cts := configTestStruct{
		Concurrency: ctjson.Concurrency,
		Retry:       ctjson.Retry,
		Frequency:   map[string]time.Duration{},
		Retrydelay:  map[string]time.Duration{},
		Timeout:     map[string]time.Duration{},
	}

	for k, v := range ctjson.Frequency {
		dur, err := time.ParseDuration(v)
		if err != nil {
			return cts, fmt.Errorf("%s: valid time units are [ns, us (or µs), ms, s, m, h", err)
		}
		cts.Frequency[k] = dur
	}

	for k, v := range ctjson.Timeout {
		dur, err := time.ParseDuration(v)
		if err != nil {
			return cts, fmt.Errorf("%s: valid time units are [ns, us (or µs), ms, s, m, h", err)
		}
		cts.Timeout[k] = dur
	}

	for k, v := range ctjson.Retrydelay {
		dur, err := time.ParseDuration(v)
		if err != nil {
			return cts, fmt.Errorf("%s: valid time units are [ns, us (or µs), ms, s, m, h", err)
		}
		cts.Retrydelay[k] = dur
	}

	return cts, nil
}
