package webapi

import (
	"net/http"
	"path/filepath"
)

type ConfWebAPI struct {
	Enable      bool   `toml:"enable"`
	Hostname    string `toml:"hostname" valid:"hostname"`
	Port        int    `toml:"port" valid:"port"`
	Environment string `toml:"environment"`
}

// spaHandler implements the http.Handler interface, so we can use it
// to respond to HTTP requests. The path to the static directory and
// path to the index file within that static directory are used to
// serve the SPA in the given static directory.
type spaHandler struct {
	staticFS  http.FileSystem
	indexPath string
}

// ServeHTTP inspects the URL path to locate a file within the static dir
// on the SPA handler. If a file is found, it will be served. If not, the
// file located at the index path on the SPA handler will be served. This
// is suitable behavior for serving an SPA (single page application).
func (h spaHandler) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	// get the absolute path to prevent directory traversal
	path, err := filepath.Abs(r.URL.Path)
	if err != nil {
		// if we failed to get the absolute path respond with a 400 bad request
		// and stop
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}
	print(path)
	/*
		// prepend the path with the path to the static directory
		staticFile, errfs := h.staticFS.Open(path)

		// check whether a file exists at the given path
		if os.IsNotExist(errfs) {
			// file does not exist, serve index.html
			http.ServeFile(w, r, staticFile)
			return
		} else if err != nil {
			// if we got an error (that wasn't that the file doesn't exist) stating the
			// file, return a 500 internal server error and stop
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		// otherwise, use http.FileServer to serve the static dir
		//http.FileServer(http.Dir(h.staticFS)).ServeHTTP(w, r)
		http.FileServer().ServeHTTP(w, r)

		//http.FileServer().ServeHTTP(w, r)
	*/

}
