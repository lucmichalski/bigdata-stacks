package ticker

import (
	"fmt"
	"math/rand"
	"sync"
	"time"

	log "github.com/sirupsen/logrus"

	"github.com/vincoll/vigie/pkg/process"
	"github.com/vincoll/vigie/pkg/teststruct"
	"github.com/vincoll/vigie/pkg/utils"
)

//https://guzalexander.com/2017/05/31/gracefully-exit-server-in-go.html

type TickerPool struct {
	ticker    time.Ticker
	frequency time.Duration
	Tasks     map[uint64]*tPoolTasker
	close     chan struct{}
	d         time.Time
}

type tPoolTasker struct {
	sync.Mutex
	task            teststruct.Task
	schedulingDelay time.Duration
	// reSync is used when a newState is loaded. => Reset Tickerpools
	// It add a scheduling delay based on the last attempt to respect
	// the test interval of this task even if a tickerpool have been reset.
	reSync time.Duration
}

func (tpt *tPoolTasker) applyReSync() {
	tpt.Lock()
	if tpt.reSync != 0 {
		time.Sleep(tpt.reSync)
		tpt.resetReSync()
	}
	tpt.Unlock()
}

func (tpt *tPoolTasker) resetReSync() {
	tpt.reSync = 0
}

func NewTickerPool(freq time.Duration) (*TickerPool, error) {

	var tp TickerPool

	if freq <= time.Millisecond {
		return nil, fmt.Errorf("TickerPool cannot be created: frequency cannot be < 1ms")
	} else {

		tp = TickerPool{
			ticker:    *time.NewTicker(freq),
			frequency: freq,
			Tasks:     make(map[uint64]*tPoolTasker, 0),
			close:     make(chan struct{}),
			d:         time.Now(),
		}
		return &tp, nil
	}

}

func (tp *TickerPool) AddTask(tsuite *teststruct.TestSuite, tcase *teststruct.TestCase, tstep *teststruct.TestStep) {

	ntask := teststruct.Task{
		TestSuite: tsuite,
		TestCase:  tcase,
		TestStep:  tstep,
	}

	task3 := tPoolTasker{
		task:            ntask,
		schedulingDelay: 0,
		reSync:          ntask.TestStep.GetReSyncro(),
	}

	tp.Tasks[tstep.ID] = &task3

}

// Start the tickerpool as seperate goroutine
func (tp *TickerPool) Start() {

	// Some types of probes will be more likely to have long intervals
	// Avoid waiting the first tick in case of a long duration.

	if tp.frequency > time.Duration(59)*time.Second {

		// Delay the launch of the different tickerpools
		// to avoid a startup spike.

		rand.Seed(time.Now().UnixNano())
		n := rand.Intn(15) // n will be between 0 and val
		wait := time.Duration(n) * time.Second
		time.Sleep(wait)

		utils.Log.WithFields(log.Fields{
			"package": "ticker",
		}).Debugf("Ticker %s PRE-START (%s) at %s", tp.frequency.String(), wait, time.Now().Format(time.RFC3339))

		tp.processAllTasks()
	}
	go tp.run()
}

// run will run all the tasks on each ticking
func (tp *TickerPool) run() {
	// Loop, Start at each Ticker Tick

	for {
		select {
		case <-tp.ticker.C:
			tp.processAllTasks()
		case <-tp.close:
			tp.ticker.Stop()
			return
		}
	}

}

// run will run all the tasks on each ticking
func (tp *TickerPool) Stop() {
	// Stop the tick
	tp.close <- struct{}{}
	close(tp.close)

}

// processAllTasks launched at each Tick :
// Run all TickerPool tests in independent goroutines.
// Fine timeout management is managed as close as possible to the probe.
func (tp *TickerPool) processAllTasks() {

	utils.Log.WithFields(log.Fields{
		"package": "ticker",
	}).Debugf("Ticker %s START at %s with %d Tasks ", tp.frequency.String(), time.Now().Format(time.RFC3339), len(tp.Tasks))

	// Task scheduling is an important part, for now it's very simple and limited.
	// More refined way to avoid spikes will be engaged.

	// To avoid spikes at each tick a little pause is interleaved between the tests.
	// The pause scheduling_delay is calculated from 5% freq, otherwise for 24H freq the pause are too long

	// Dummy leapPause calc
	maxInterval := float64(tp.frequency.Nanoseconds()) * 0.05
	leapPause := time.Duration(int64(maxInterval) / int64(len(tp.Tasks)))

	for i, _ := range tp.Tasks {

		go func() {
			tp.Tasks[i].applyReSync()
			process.ProcessTask(tp.Tasks[i].task)
		}()

		// Sleep leapPause before another run
		time.Sleep(leapPause)
	}

}
