package tsdb

import (
	"bytes"
	"encoding/base64"
	"fmt"
	"github.com/sirupsen/logrus"
	"github.com/vincoll/vigie/pkg/teststruct"
	"github.com/vincoll/vigie/pkg/utils"
	"net/http"
	"strconv"
	"strings"
	"time"
)

// https://github.com/miton18/go-warp10/tree/master/base
// https://github.com/PierreZ/Warp10Exporter

type warp10 struct {
	conf   ConfWarp10
	client *http.Client
}

func NewWarp10(conf ConfWarp10) (*warp10, error) {

	if conf.Timeout == 0 {
		conf.Timeout = 5 * time.Second
	}

	// Create HTTP CLient
	client := &http.Client{
		Transport: &http.Transport{
			Proxy: http.ProxyFromEnvironment,
		},
		Timeout: conf.Timeout,
	}

	w10 := warp10{
		conf:   conf,
		client: client}

	err := w10.validateConnection()
	if err != nil {
		return nil, err
	}

	return &w10, nil

}

func (w *warp10) Name() string {
	return "warp10"
}

func (w *warp10) validateConnection() error {
	return nil
}

func (w *warp10) WritePoint(task teststruct.Task) error {

	task.RLockAll()

	// Push the Step Results to InfluxDB
	utils.Log.WithFields(logrus.Fields{
		"package":   "process",
		"testcase":  task.TestCase.Name,
		"teststep":  task.TestStep.Name,
		"testsuite": task.TestSuite.Name,
	}).Debug("Push task result into ", w.Name())

	gtsPayload, err := w.genPayload(task)
	if err != nil {
		utils.Log.WithFields(logrus.Fields{
			"teststep":  task.TestStep.Name,
			"testcase":  task.TestCase.Name,
			"testsuite": task.TestSuite.Name,
			"package":   "tsdb_warp10",
		}).Error("Fail to generate Warp10 payload: ", err)
		return err
	}

	w.insertTestToDB(gtsPayload)

	task.RUnlockAll()
	return nil

}

func (w *warp10) insertTestToDB(gtsPayload string) {

	start := time.Now()

	// Write to InfluxDB
	errwdb := w.writePayload(gtsPayload)
	if errwdb != nil {

		utils.Log.WithFields(logrus.Fields{"package": "tsdb_warp10"}).Error("Cannot write Warp10 point into DB: ", errwdb)
	}

	// Push the Step Results to InfluxDB
	utils.Log.WithFields(logrus.Fields{
		"package": "tsdb_warp10",
	}).Tracef("Time to complete insert Into Warp10: %s", time.Since(start))

}

func (w *warp10) UpdateTestState(task teststruct.Task) error {
	return nil
}

//
//---
//

// GTS Warp 10
// https://www.warp10.io/content/03_Documentation/03_Interacting_with_Warp_10/03_Ingesting_data/02_GTS_input_format
type geoTimeSeries struct {
	Metric     string
	Tags       string
	Timestamp  int64
	MultiValue string
}

func (gts *geoTimeSeries) String() string {
	return fmt.Sprintf("%d// %s{%s} %s\n", gts.Timestamp, gts.Metric, gts.Tags, gts.MultiValue)
}

// Write metrics to Warp10
func (w *warp10) writePayload(payload string) error {

	req, err := http.NewRequest("POST", w.conf.Addr+"/api/v0/update", bytes.NewBufferString(payload))
	if err != nil {
		return err
	}
	req.Header.Set("X-Warp10-Token", w.conf.Token)
	req.Header.Set("Content-Type", "text/plain")

	resp, err := w.client.Do(req)
	if err != nil {
		return err
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return fmt.Errorf(resp.Status)
	}

	return nil
}

// genPayload compute Warp 10 metrics payload
func (w *warp10) genPayload(task teststruct.Task) (string, error) {

	multilineGTS := make([]string, 0)

	// Create a Time series data aka points for InfluxDB
	// TAGS are used to identify a task in the DB for later queries
	taskTags := buildTags(task)

	for _, vr := range task.TestStep.VigieResults {

		metricValue, err := buildValue(vr)
		if err != nil {
			return "", fmt.Errorf("could not encode value: %s", err)
		}

		gtsPoint := geoTimeSeries{
			Timestamp:  task.TestStep.LastAttempt.UnixNano() / 1000, // Microsec
			Metric:     fmt.Sprint(w.conf.Prefix, "teststep"),
			Tags:       strings.Join(taskTags, ","),
			MultiValue: metricValue,
		}
		multilineGTS = append(multilineGTS, gtsPoint.String())
	}

	return fmt.Sprint(strings.Join(multilineGTS, "")), nil
}

func buildTags(task teststruct.Task) []string {

	tags := []string{
		fmt.Sprintf("%s=%s", "teststep", task.TestStep.Name),
		fmt.Sprintf("%s=%s", "testcase", task.TestCase.Name),
		fmt.Sprintf("%s=%s", "testsuite", task.TestSuite.Name),
	}

	return tags
}

func buildValue(vr teststruct.VigieResult) (string, error) {

	vrValues := vr.GetValues()

	values := fmt.Sprintf("[%q %s %q %q]",
		// ResultStatus Teststep (string detail)
		vr.Status,
		// ResponseTime (If relevant: float64 second based)
		floatToString(vrValues.Responsetime),
		// Returned probe result (string: raw json result)
		// base64.RawURLEncoding is used to avoid any '/' char in the base64 string
		// char / can be misinterpreted and lead to parsing error.
		base64.RawURLEncoding.EncodeToString([]byte(vrValues.Msg)),
		// Subtest
		vrValues.Subtest,
	)

	return values, nil
}

func intToString(inputNum int64) string {
	return strconv.FormatInt(inputNum, 10)
}

func boolToString(inputBool bool) string {
	return strconv.FormatBool(inputBool)
}

func uIntToString(inputNum uint64) string {
	return strconv.FormatUint(inputNum, 10)
}

func floatToString(inputNum float64) string {
	return strconv.FormatFloat(inputNum, 'f', 6, 64)
}

// Close close
func (w *warp10) close() error {
	return nil
}

// Init Warp10 struct
func (w *warp10) Init() error {
	/*
		if w.MaxStringErrorSize <= 0 {
			w.MaxStringErrorSize = 511
		}
	*/
	return nil

}

// HandleError read http error body and return a corresponding error
func (w *warp10) HandleError(body string, maxStringSize int) string {
	if body == "" {
		return "Empty return"
	}

	if strings.Contains(body, "Invalid token") {
		return "Invalid token"
	}

	if strings.Contains(body, "Write token missing") {
		return "Write token missing"
	}

	if strings.Contains(body, "Token Expired") {
		return "Token Expired"
	}

	if strings.Contains(body, "Token revoked") {
		return "Token revoked"
	}

	if strings.Contains(body, "exceed your Monthly Active Data Streams limit") || strings.Contains(body, "exceed the Monthly Active Data Streams limit") {
		return "Exceeded Monthly Active Data Streams limit"
	}

	if strings.Contains(body, "Daily Data Points limit being already exceeded") {
		return "Exceeded Daily Data Points limit"
	}

	if strings.Contains(body, "Application suspended or closed") {
		return "Application suspended or closed"
	}

	if strings.Contains(body, "broken pipe") {
		return "broken pipe"
	}

	if len(body) < maxStringSize {
		return body
	}
	return body[0:maxStringSize]
}
