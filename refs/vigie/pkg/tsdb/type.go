package tsdb

import (
	"github.com/vincoll/vigie/pkg/teststruct"
	"time"
)

type ConfInfluxDB struct {
	Enable   bool          `toml:"enable"`
	Addr     string        `toml:"addr"`
	User     string        `toml:"user"`
	Password string        `toml:"password"`
	Database string        `toml:"database"`
	Timeout  time.Duration `toml:"timeout"`
}

type ConfInfluxDBv2 struct {
	Enable       bool   `toml:"enable"`
	Addr         string `toml:"addr"`
	Organization string `toml:"organization"`
	Bucket       string `toml:"bucket"`
	Precision    string `toml:"precision"`
	Token        string `toml:"token"`
}

type ConfWarp10 struct {
	Enable  bool `toml:"enable"`
	Addr    string
	Token   string
	Prefix  string
	Timeout time.Duration `toml:"timeout"`
}

type ConfDatadog struct {
	Enable       bool          `toml:"enable"`
	Endpoint     string        `toml:"endpoint"`
	APIKey       string        `toml:"api_key"`
	APPKey       string        `toml:"app_key"`
	CustomPrefix string        `toml:"customprefix"`
	Timeout      time.Duration `toml:"timeout"`
}

type TsdbEndpoint interface {
	Name() string
	validateConnection() error
	WritePoint(task teststruct.Task) error
	UpdateTestState(task teststruct.Task) error
}
