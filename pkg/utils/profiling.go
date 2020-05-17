package utils

import (
	"github.com/sirupsen/logrus"
	"time"
)

func Duration(invocation time.Time, name, pkg, desc string) {
	elapsed := time.Since(invocation)

	Log.WithFields(logrus.Fields{
		"name":    name,
		"package": pkg,
		"desc":    desc,
	}).Tracef("Time to complete %s : %s", name, elapsed)

}
