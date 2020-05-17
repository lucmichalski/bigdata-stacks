package process

import (
	"fmt"
	"time"

	"github.com/vincoll/vigie/pkg/probe"
	"github.com/vincoll/vigie/pkg/teststruct"
)

// runTestStepProbe runs a probe test
// The probe can get an answer, or the probe can timeout.
// Warning, a probe may returns multiples answser
func runTestStepProbe(pWrap *teststruct.ProbeWrap) ([]probe.ProbeReturn, error) {

	// Create Channel for Probe ResultStatus
	chProbeReturn := make(chan []probe.ProbeReturn, 1)
	//
	// Goroutine to run the probe teststep
	//
	go func() {
		chProbeReturn <- pWrap.Run()
	}()

	// Select dépend de l'issue de l'exec de la probe
	select {
	case probeRtrn := <-chProbeReturn: // Retour d'info de la probe
		return probeRtrn, nil

	// If no answer (timeout)
	// Failsafe : timeout
	case <-time.After(pWrap.Timeout):

		probeReturns := make([]probe.ProbeReturn, 0)

		pi := probe.ProbeInfo{
			Error:  fmt.Sprintf("timeout after %s", pWrap.Frequency.String()),
			Status: probe.Timeout,
		}

		pr := probe.ProbeReturn{
			Answer:    nil,
			ProbeInfo: pi,
		}
		probeReturns = append(probeReturns, pr)

		return probeReturns, fmt.Errorf("FailSafe: %s", pWrap.Timeout.String())
	}
}
