package core

import (
	"github.com/vincoll/vigie/pkg/utils/dnscache"
)

//
// Global var
//
var VigieServer Server

// Centralization attempt
type Server struct {
	//Vigie *vigie.Vigie
	//AlertManager *alertmanager.AlertManager
	//TsdbManager *tsdb.Tsdbs
	CacheDNS *dnscache.Resolver
}
