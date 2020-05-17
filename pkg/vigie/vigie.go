package vigie

import (
	"fmt"
	"github.com/vincoll/vigie/pkg/load"
	"github.com/vincoll/vigie/pkg/utils"
	"net"
	"net/url"
	"os"
	"os/user"
	"runtime"
	"strings"

	"sync"
	"time"

	"github.com/vincoll/vigie/pkg/teststruct"
	"github.com/vincoll/vigie/pkg/ticker"
)

type Vigie struct {
	mu            sync.RWMutex
	TestSuites    map[uint64]*teststruct.TestSuite
	tickerpools   map[time.Duration]*ticker.TickerPool
	Status        byte // Ready, Healthy
	HostInfo      HostInfo
	ImportManager load.ImportManager
}

// NewVigie Constructor: Vigie
func NewVigie() (*Vigie, error) {
	v := &Vigie{
		tickerpools: map[time.Duration]*ticker.TickerPool{},
		Status:      0,
	}
	// Init
	v.TestSuites = map[uint64]*teststruct.TestSuite{}
	v.tickerpools = map[time.Duration]*ticker.TickerPool{}

	// Create folder structure
	err := v.createTempFolder()
	if err != nil {
		return nil, err
	}
	return v, nil
}

// Add a new TickerPool
func (v *Vigie) createTickerPool(freq time.Duration) error {

	tp, err := ticker.NewTickerPool(freq)
	if err != nil {
		return fmt.Errorf("can not create a Tickerpool: %s", err.Error())
	}

	v.tickerpools[freq] = tp
	return nil
}

// Is TickerPool Exist
func (v *Vigie) getTickerPool(frequency time.Duration) bool {
	_, present := v.tickerpools[frequency]
	return present
}

// Create a temp folder required for some probes
func (v *Vigie) createTempFolder() error {

	var path string

	if runtime.GOOS == "windows" {

		// prepare Vigie Folder
		// Get User Info
		usr, err := user.Current()
		if err != nil {
			return fmt.Errorf("cannot create a temp folder for Vigie : %s", err.Error())
		}

		tokuser := strings.Split(usr.Username, "\\")
		username := tokuser[len(tokuser)-1]

		path = fmt.Sprintf("C:\\Users\\%s\\AppData\\Local\\Temp\\vigie\\", username)

	} else if runtime.GOOS == "linux" {
		path = "/tmp/vigie_dl/"
	}

	// Create Vigie Folder
	if _, err := os.Stat(path); os.IsNotExist(err) {
		err = os.MkdirAll(path, 0744)
		if err != nil {
			return fmt.Errorf("cannot create a temp folder for Vigie : %s", err.Error())
		}
	}
	// Set this path as global State Var
	utils.TEMPPATH = path

	return nil
}

type HostInfo struct {
	Name        string            // Familiar Name
	URL         string            // Web URL to Vigie Instance
	Tags        map[string]string // Descriptives Tags
	IPv6Capable bool              // IPv6Capable
}

// AddHostSytemInfo adds info about the specification
// or capabilities of a host.
func (hi *HostInfo) AddHostSytemInfo() {

	if hi.Name == "" {
		hostname, err := os.Hostname()
		if err == nil {
			hi.Name = "cannotbedetermined"
		}
		hi.Name = hostname
	}

	if hi.URL == "" {

		_, err := url.Parse(hi.URL)
		if err != nil {
			hi.URL = "http://badurlformat"
		}

		hostname, err := os.Hostname()
		if err == nil {
		}
		hi.URL = fmt.Sprintf("http://%s", hostname)
	}
	// ipv6 Detection : Quick & Dirty
	interfaces, err := net.Interfaces()
	if err != nil {

	}
	for _, i := range interfaces {

		byNameInterface, err := net.InterfaceByName(i.Name)
		if err != nil {
			fmt.Println(err)
		}
		addresses, err := byNameInterface.Addrs()
		for _, v := range addresses {
			ip := v.String()
			switch {

			case strings.Contains(ip, "2000:"):
				hi.IPv6Capable = true

			case strings.Contains(ip, "fc00:"):
				hi.IPv6Capable = true

			case strings.Contains(ip, "fe80:"):
				hi.IPv6Capable = true

			case strings.Contains(ip, "2000:"):
				hi.IPv6Capable = true

			}
		}
	}

}
