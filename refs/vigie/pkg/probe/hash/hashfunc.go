package hash

import (
	"encoding/hex"
	"fmt"
	"hash"
	"io"
	"net/http"
	"os"
	"os/user"
	"runtime"
	"strings"
	"time"

	"github.com/vincoll/vigie/pkg/probe"
)

func hashFile(hasher hash.Hash, url string) ProbeAnswer {

	var pi probe.ProbeInfo
	var pa ProbeAnswer

	start := time.Now()

	// Download from URL
	filetohash, err := downloadFromUrl(url)
	if err != nil {
		pi = probe.ProbeInfo{
			Status: -3,
			Error:  err.Error(),
		}

		pa := ProbeAnswer{
			ProbeInfo: pi,
		}
		return pa
	}

	elapsed := time.Since(start)

	// Get sourceFile Hash
	filedata, err := os.Open(filetohash)
	if err != nil {
		pi = probe.ProbeInfo{
			Status: -3,
			Error:  err.Error(),
		}

		pa := ProbeAnswer{
			ResponseTime: elapsed.Seconds(),
			ProbeInfo:    pi,
		}
		return pa
	}

	defer filedata.Close()

	if _, err := io.Copy(hasher, filedata); err != nil {
		pi = probe.ProbeInfo{
			Status: -3,
			Error:  err.Error(),
		}

		pa := ProbeAnswer{
			ResponseTime: elapsed.Seconds(),
			ProbeInfo:    pi,
		}
		return pa

	}

	filehash := hex.EncodeToString(hasher.Sum(nil))

	// Delete the sourceFile
	os.Remove(filetohash)

	// Success
	pi = probe.ProbeInfo{
		Status: 1,
	}

	pa = ProbeAnswer{
		Hash:         filehash,
		ResponseTime: elapsed.Seconds(),
		ProbeInfo:    pi,
	}

	return pa
}

// downloadFromUrl and return filepath
func downloadFromUrl(url string) (string, error) {

	path := ""
	if runtime.GOOS == "windows" {

		// prepare Vigie Folder
		// Get User Info
		usr, err := user.Current()
		if err != nil {
			return "", err
		}

		tokuser := strings.Split(usr.Username, "\\")
		username := tokuser[len(tokuser)-1]

		path = fmt.Sprintf("C:\\Users\\%s\\AppData\\Local\\Temp\\vigie\\", username)

	} else if runtime.GOOS == "linux" {
		path = "/tmp/vigie/"
	}

	// Create Vigie Folder
	if _, err := os.Stat(path); os.IsNotExist(err) {
		err = os.MkdirAll(path, 740)
		if err != nil {
			panic(err) // TODO PANIC un peu moins
		}
	}

	url2file := strings.NewReplacer(":", "", "/", "", "\\\\", "")
	fileName := url2file.Replace(url)

	// Add nanosec timestamp for random filename
	filepath := fmt.Sprintf("%s%d%s", path, time.Now().UnixNano(), fileName)

	file, err := os.Create(filepath)
	if err != nil {
		errCF := fmt.Errorf("Error while creating %s - %s", fileName, err)
		return "", errCF
	}
	defer file.Close()

	response, err := http.Get(url)
	if err != nil {
		errGET := fmt.Errorf("Error while downloading %s - %s", url, err)
		file.Close()
		os.Remove(filepath)
		return "", errGET
	}
	defer response.Body.Close()

	_, erro := io.Copy(file, response.Body)
	if err != nil {
		errCOPY := fmt.Errorf("Error while writing %s - %s", "i", erro)
		file.Close()
		os.Remove(filepath)
		return "", errCOPY
	}
	file.Close()
	return filepath, nil
}
