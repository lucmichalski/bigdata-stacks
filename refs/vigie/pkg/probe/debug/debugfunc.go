package debug

import (
	"github.com/vincoll/vigie/pkg/probe"
	"time"
)

func (p *Probe) genSuccess() ProbeAnswer {

	pi := probe.ProbeInfo{
		Error:        "",
		SubTest:      "",
		Status:       probe.Success,
		ProbeCode:    0,
		ResponseTime: time.Second,
	}

	pa := ProbeAnswer{
		Answer:    p.Answer,
		ProbeInfo: pi,
	}

	return pa
}

func (p *Probe) genSuccessMsg(msg string) ProbeAnswer {

	pi := probe.ProbeInfo{
		Error:        "",
		SubTest:      "",
		Status:       probe.Success,
		ProbeCode:    0,
		ResponseTime: time.Second,
	}

	pa := ProbeAnswer{
		Answer:    msg,
		ProbeInfo: pi,
	}

	return pa
}

func (p *Probe) genTimeout() ProbeAnswer {

	pi := probe.ProbeInfo{
		Error:        "Probe exec timeout",
		Status:       probe.Timeout,
		SubTest:      "",
		ProbeCode:    0,
		ResponseTime: 60 * time.Minute,
	}

	pa := ProbeAnswer{
		Answer:    "",
		ProbeInfo: pi,
	}

	return pa
}

func (p *Probe) genError() ProbeAnswer {

	pi := probe.ProbeInfo{
		Error:     "Probe exec error",
		SubTest:   "",
		Status:    probe.Error,
		ProbeCode: p.ErrorCode,
	}

	pa := ProbeAnswer{
		Answer:    "",
		ProbeInfo: pi,
	}

	return pa
}
