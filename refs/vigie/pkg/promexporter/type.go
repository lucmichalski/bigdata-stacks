package promexporter

type ConfPrometheus struct {
	Enable      bool   `toml:"enable"`
	Port        int    `toml:"port" valid:"port"`
	Environment string `toml:"environment"`
}
