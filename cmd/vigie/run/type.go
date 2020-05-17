package run

import (
	"fmt"
	"github.com/vincoll/vigie/pkg/alertmanager"
	"github.com/vincoll/vigie/pkg/load"
	"github.com/vincoll/vigie/pkg/vigie"
	"os"
	"path/filepath"

	"github.com/vincoll/vigie/pkg/promexporter"
	"github.com/vincoll/vigie/pkg/tsdb"
	"github.com/vincoll/vigie/pkg/utils"
	"github.com/vincoll/vigie/pkg/webapi"
)

// https://xuri.me/toml-to-go/

const defaultConfFile = "config/vigie.toml"

type VigieConf struct {
	ApiVersion  float32
	Environment string // Production, Dev
	Host        vigie.HostInfo
	Import      load.ConfImport
	API         webapi.ConfWebAPI
	Prometheus  promexporter.ConfPrometheus
	InfluxDB    tsdb.ConfInfluxDB
	Warp10      tsdb.ConfWarp10
	Datadog     tsdb.ConfDatadog
	Alerting    alertmanager.ConfAlerting
	Log         utils.LogConf
}

func defaultConfFilePath() string {

	path, err := os.Getwd()
	if err != nil {
		//	log.Printf(err)
	}

	pathToConf := filepath.Clean(fmt.Sprintf("%s/%s", path, defaultConfFile))

	return pathToConf
}
