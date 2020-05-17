package version

import (
	"encoding/json"
	"fmt"
	"os"
	"runtime"

	"github.com/spf13/cobra"
)

// Cmd version
var Cmd = &cobra.Command{
	Use:     "version",
	Short:   "Print Vigie version information",
	Long:    "Print Vigie version information",
	Aliases: []string{"v"},
	Run: func(cmd *cobra.Command, args []string) {
		printVersion()
	},
}

func printVersion() {

	marshalled, err := json.MarshalIndent(initVersion(), "", "  ")
	if err != nil {
		fmt.Println("error:", err)
	}

	_, _ = os.Stdout.Write(marshalled)

	os.Exit(0)

}

func initVersion() vigieVersion {

	return vigieVersion{
		Version:   LdVersion,
		GitCommit: LdGitCommit,
		BuildDate: LdBuildDate,
		GoVersion: runtime.Version(),
		Compiler:  runtime.Compiler,
		Platform:  fmt.Sprintf("%s/%s", runtime.GOOS, runtime.GOARCH),
	}

}

type vigieVersion struct {
	Version   string
	GitCommit string
	BuildDate string
	Compiler  string
	GoVersion string
	Platform  string
}

// Variables set with ldflags during compilation.
var (
	LdVersion   = ""
	LdGitCommit = ""
	LdBuildDate = ""
)
