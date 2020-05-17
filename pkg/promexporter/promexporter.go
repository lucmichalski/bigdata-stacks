package promexporter

import (
	"fmt"
	"github.com/prometheus/client_golang/prometheus/promhttp"
	"github.com/sirupsen/logrus"
	"net/http"

	"github.com/vincoll/vigie/pkg/utils"
)

func InitPromExporter(confProm ConfPrometheus) {

	if confProm.Enable == true || confProm.Environment == "dev" || confProm.Environment == "development" {

		utils.Log.WithFields(logrus.Fields{
			"component": "prometheusexporter",
			"port":      confProm.Port,
			"env":       confProm.Environment,
		}).Infof(fmt.Sprintln("Vigie Prom exporter is exposed"))

		run(confProm.Port)

	}
}

func run(port int) {

	// Add Go Runtime Metrics
	// This section will start the HTTP server and expose
	// any metrics on the /metrics endpoint.
	http.Handle("/metrics", promhttp.Handler())
	_ = http.ListenAndServe(fmt.Sprint(":", port), nil)
}
