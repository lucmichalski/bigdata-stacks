package icmp

import (
	"fmt"
	"github.com/sparrc/go-ping"
	"github.com/vincoll/vigie/pkg/probe"
	"time"
)

// Ping
func (p *Probe) process(timeout time.Duration) (probeAnswers []ProbeAnswer) {

	// Resolve only some IPv
	ips, err := probe.GetIPsFromHostname(p.Host, p.IPversion)
	if err != nil {
		pi := probe.ProbeInfo{Status: probe.Error, Error: err.Error()}
		probeAnswers = make([]ProbeAnswer, 0)
		probeAnswers = append(probeAnswers, ProbeAnswer{ProbeInfo: pi})
		return probeAnswers
	}

	if len(ips) == 0 {
		errNoIP := fmt.Errorf("No IP for %s with ipv%d found.", p.Host, p.IPversion)
		pi := probe.ProbeInfo{Status: probe.Error, Error: errNoIP.Error()}
		probeAnswers = make([]ProbeAnswer, 0)
		probeAnswers = append(probeAnswers, ProbeAnswer{ProbeInfo: pi})
		return probeAnswers
	}

	// Loop for each ip behind a DNS record
	// probeAnswers store the results for each IP
	probeAnswers = make([]ProbeAnswer, 0, len(ips))
	/*
		var wg sync.WaitGroup
		wg.Add(len(ips))

		// Check for each IP
		for _, ip := range ips {

			go func() {

				pa, errReq := p.sendICMP(ip, timeout)
				if errReq != nil {
					//print(errReq)
				}
				probeAnswers = append(probeAnswers, pa)
				wg.Done()

			}()
		}
		wg.Wait()
	*/
	pa, errReq := p.sendICMP(ips[0], timeout)
	if errReq != nil {
		// print(errReq)
	}
	probeAnswers = append(probeAnswers, pa)

	return probeAnswers
}

func (p Probe) sendICMP(ip string, timeout time.Duration) (ProbeAnswer, error) {

	// Create a Custom Pinger
	pinger, err := ping.NewPinger(ip)
	if err != nil {
		paErr := toProbeAnswer(nil, err)
		return paErr, fmt.Errorf("Cannot create pinger %s", err.Error())
	} else {
		// Need setcap cap_net_raw=+ep on vigie binary
		pinger.SetPrivileged(true)
		pinger.Timeout = timeout
		pinger.Interval = p.Interval
		pinger.Size = p.PayloadSize
		pinger.Count = p.Count

		// Launch Ping
		pinger.Run()

		// Retrieve Info about the Ping
		pingerStats := pinger.Statistics()
		pa := toProbeAnswer(pingerStats, nil)
		return pa, nil
	}

}

func toProbeAnswer(ps *ping.Statistics, err error) (pa ProbeAnswer) {

	var pi probe.ProbeInfo

	if err != nil {
		pi = probe.ProbeInfo{
			SubTest: ps.Addr,
			Status:  probe.Error,
			Error:   err.Error(),
		}
		pa.ProbeInfo = pi
		return pa
	}

	if ps.PacketsSent == 0 {
		pi = probe.ProbeInfo{
			SubTest: ps.Addr,
			Status:  probe.Failure,
			Error:   fmt.Sprintf("No icmp packet have been sent. Linux required some system tweak to send icmp (cf: https://github.com/sparrc/go-ping#note-on-linux-support)."),
		}
		pa.ProbeInfo = pi
		return pa
	}

	pi.Status = 1
	pi.ResponseTime = ps.AvgRtt

	// Generate Probe ResultStatus
	if ps.PacketsRecv != 0 {
		pa.Reacheable = "true"
	} else {
		pa.Reacheable = "false"
	}

	pa.ProbeInfo = pi
	pa.MinRtt = ps.MinRtt
	pa.AvgRtt = ps.AvgRtt
	pa.Rtt = ps.AvgRtt
	pa.MaxRtt = ps.MaxRtt
	pa.PacketLoss = ps.PacketLoss
	pa.PacketsRecv = ps.PacketsRecv
	pa.IPAddr = ps.Addr

	return pa
}
