package tsdb

//
// Highly experimental
/*

type vInfluxDB2 struct {
	conf   ConfInfluxDBv2
	client influxdb.Client
}

var InfluxInst2 vInfluxDB2

func LoadInfluxDB2(c ConfInfluxDBv2) error {

	if c.Enable == true {

		InfluxInst2 = vInfluxDB2{
			conf: c,
		}
		// Test if vInfluxDB is accessible
		err := InfluxInst.validateConnection()
		if err != nil {
			return fmt.Errorf("failed to validate a connection with %q: %s", c.Addr, err)
		}
	}
	utils.Log.WithFields(logrus.Fields{
		"component": "tsdb",
		"host":      c.Addr,
		"org":       c.Organization,
		"bucket":    c.Bucket,
	}).Infof(fmt.Sprintln("Vigie TsdbEndpoint connection succeed"))
	return nil
}

func (idb *vInfluxDB2) createClient() (*influxdb.Client, error) {

	x := http.Client{
		timeout: time.Duration(3 * time.Second),
	}

	influxClient, err := influxdb.New(idb.conf.Addr, idb.conf.Token, influxdb.WithHTTPClient(&x))
	if err != nil {
		return nil, fmt.Errorf("error creating vInfluxDB Client: %s", err.Error())
	}

	return influxClient, nil
}

// writePointToInfluxDB convenience function to insert data into the database
func (idb *vInfluxDB2) writePointToInfluxDB(np influxdb.Metric) (err error) {

	_, _ = idb.client.Write(context.TODO(), idb.conf.Bucket, idb.conf.Organization)

	return nil
}

// https://v2.docs.influxdata.com/v2.0/write-data/


*/
