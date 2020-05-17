package utils

import (
	"os"
	"strings"

	"github.com/sirupsen/logrus"
)

// https://stackoverflow.com/questions/47737242/share-object-from-in-local-package

// Define your custom logger type.

var Log *logrus.Logger

// init Initialise le module de Logging de vigie.
// L'instance crée sera accessible par tout les packages
func InitLogger(lconf LogConf) {

	var logger = logrus.New()

	// Set log Level
	switch strings.ToLower(lconf.Level) {
	case "warning", "warn":
		logger.SetLevel(logrus.WarnLevel)
	case "info":
		logger.SetLevel(logrus.InfoLevel)
	case "debug":
		logger.SetLevel(logrus.DebugLevel)
	case "trace":
		logger.SetLevel(logrus.TraceLevel)
	default:
		logger.SetLevel(logrus.WarnLevel)
	}

	if lconf.Stdout {
		// Write in stdout by default
		logger.Out = os.Stdout
	}

	if lconf.LogFile == true && lconf.FilePath != "" {
		// You could set this to any `io.Writer` such as a file
		file, err := os.OpenFile(lconf.FilePath, os.O_CREATE|os.O_WRONLY, 0666)
		if err == nil {
			logger.Out = file
		} else {
			logger.Out = os.Stdout
			logger.Warn("Failed to log to file, using default stderr")
		}
	}
	// TODO: Add multiple Log Writers
	//mw := io.MultiWriter(os.Stdout, logFile)
	//logrus.SetOutput(mw)

	if strings.ToLower(lconf.Format) == "json" {
		logger.Formatter = &logrus.JSONFormatter{}
	} else {
		logger.Formatter = &logrus.TextFormatter{
			FullTimestamp: true,
			ForceColors:   true,
		}
	}

	logger.WithFields(logrus.Fields{
		"package": "logger",
	}).Tracef("Logger is set to : %s", logger.Level.String())

	Log = logger
}
