package tsdb

import (
	"github.com/vincoll/vigie/pkg/teststruct"
	"sync"
)

var TsdbManager Tsdbs

type Tsdbs struct {
	sync.RWMutex
	Enable        bool
	TsdbEndpoints []TsdbEndpoint
}

func (ts *Tsdbs) AddTsdb(endpoint TsdbEndpoint) {

	ts.Lock()
	defer ts.Unlock()

	ts.TsdbEndpoints = append(ts.TsdbEndpoints, endpoint)
	ts.Enable = true

	return
}

func (ts *Tsdbs) WriteOnTsdbs(task teststruct.Task) {

	var wg sync.WaitGroup
	wg.Add(len(ts.TsdbEndpoints))
	for _, tsdbEndpoint := range ts.TsdbEndpoints {

		go func(te TsdbEndpoint) {
			_ = te.WritePoint(task)
			wg.Done()
		}(tsdbEndpoint)

	}
	wg.Wait()

	return
}

func (ts *Tsdbs) UpdateTestStateToDB(task teststruct.Task) {

	var wg sync.WaitGroup
	wg.Add(len(ts.TsdbEndpoints))
	for _, te := range ts.TsdbEndpoints {

		go func() {
			_ = te.UpdateTestState(task)
			wg.Done()
		}()

	}
	wg.Wait()

}
