package x509

import (
	"crypto/tls"
	"crypto/x509"
	"encoding/pem"
	"fmt"
	"net"
	"sync"
	"time"

	"github.com/vincoll/vigie/pkg/probe"
)

func (p *Probe) process(timeout time.Duration) (probeAnswers []*ProbeAnswer) {

	// Resolve only some IPv
	ips, err := probe.GetIPsFromHostname(p.Host, 0)
	if err != nil {
		pi := probe.ProbeInfo{Status: probe.Error, Error: err.Error()}
		probeAnswers = make([]*ProbeAnswer, 0, 0)
		probeAnswers = append(probeAnswers, &ProbeAnswer{ProbeInfo: pi})
		return probeAnswers
	}

	if len(ips) == 0 {
		errNoIP := fmt.Errorf("No IP for %s with ipv%d found.", p.Host, 0)

		pi := probe.ProbeInfo{Status: probe.Error, Error: errNoIP.Error()}
		probeAnswers = make([]*ProbeAnswer, 0, 0)
		probeAnswers = append(probeAnswers, &ProbeAnswer{ProbeInfo: pi})
		return probeAnswers
	}

	// Loop for each ip behind a DNS record
	// probeAnswers store the results for each IP
	probeAnswers = make([]*ProbeAnswer, len(ips))
	var wg sync.WaitGroup
	wg.Add(len(ips))

	for i, ip := range ips {

		go func(i int, ip string) {
			pa := checkX509(p.Host, ip, nil, timeout)
			/*	if errReq != nil {
					// print(errReq)
				}
			*/

			probeAnswers[i] = &pa
			wg.Done()
		}(i, ip)

	}
	wg.Wait()
	return probeAnswers
}

func checkX509(host string, ip string, rootCert *x509.CertPool, timeout time.Duration) ProbeAnswer {

	var tlsConf tls.Config
	if rootCert != nil {
		tlsConf = tls.Config{RootCAs: rootCert, InsecureSkipVerify: false}
	}

	// TODO: Gérer l'err UnknowAuthError en tant que normal, > générer les verified cert
	dialTimeout := net.Dialer{Timeout: timeout}
	start := time.Now()
	conn, err := tls.DialWithDialer(&dialTimeout, "tcp", host, &tlsConf)
	elapsed := time.Since(start)

	// Error
	if err != nil {

		var pi probe.ProbeInfo
		var pa ProbeAnswer

		certErr, typeCertInvalid := err.(x509.CertificateInvalidError)

		if !typeCertInvalid {
			// Error no directly related to TLS
			pi = probe.ProbeInfo{
				SubTest:      host,
				Status:       probe.Error,
				ResponseTime: elapsed,
				Error:        err.Error(),
			}
		} else {

			pa.EndCertificate = goCertToProbeCert(certErr.Cert)
			//	pa.Trusted = isCertTrusted(certErr.Cert)
			pi = probe.ProbeInfo{
				SubTest:      host,
				Status:       probe.Success,
				ResponseTime: elapsed,
			}

			switch certErr.Reason {
			case x509.Expired:
				pa.Expired = true

			case x509.NotAuthorizedToSign:
				// pa.Trusted = false
			}
		}

		pa.Valid = false
		pa.ProbeInfo = pi

		return pa
	}

	_ = conn.Close()

	// Success
	pi := probe.ProbeInfo{
		SubTest:      host,
		Status:       probe.Success,
		ResponseTime: elapsed,
	}

	pa := ProbeAnswer{
		Valid:               true,
		Expired:             false,
		Daybeforeexpiration: dayBeforeExp(conn),
		EndCertificate:      goCertToProbeCert(conn.ConnectionState().VerifiedChains[0][0]),
		IntCertificate:      goCertToProbeCert(conn.ConnectionState().VerifiedChains[0][1]),
		RootCertificate:     goCertToProbeCert(conn.ConnectionState().VerifiedChains[0][2]),
		ProbeInfo:           pi,
	}

	return pa
}

// dayBeforeExp returns number of days before the certificate expires.
// The server certificate can not exceed the expiration date of its own intermediate CA.
// Therefore pcs[0] (srv cert) is used without others check.
func dayBeforeExp(c *tls.Conn) int {

	timeNow := time.Now()
	pcs := c.ConnectionState().PeerCertificates
	dBefExp := pcs[0].NotAfter.Sub(timeNow).Hours() / 24

	return int(dBefExp)
}

func goCertToProbeCert(goCert *x509.Certificate) ProbeCert {

	return ProbeCert{
		Signature:                   goCert.Signature,
		SignatureAlgorithm:          goCert.SignatureAlgorithm.String(),
		PublicKeyAlgorithm:          goCert.PublicKeyAlgorithm.String(),
		PublicKey:                   goCert.PublicKeyAlgorithm.String(),
		Version:                     goCert.Version,
		SerialNumber:                goCert.SerialNumber,
		Issuer:                      goCert.Issuer,
		Subject:                     goCert.Subject,
		NotBefore:                   goCert.NotBefore,
		KeyUsage:                    keyUsageToString(goCert.KeyUsage),
		Extensions:                  goCert.Extensions,
		ExtraExtensions:             goCert.ExtraExtensions,
		UnhandledCriticalExtensions: goCert.UnhandledCriticalExtensions,
		ExtKeyUsage:                 extKeyUsageToString(goCert.ExtKeyUsage),
		BasicConstraintsValid:       goCert.BasicConstraintsValid,
		IsCA:                        goCert.IsCA,
		MaxPathLen:                  goCert.MaxPathLen,
		SubjectKeyId:                goCert.SubjectKeyId,
		AuthorityKeyId:              goCert.AuthorityKeyId,
		OCSPServer:                  goCert.OCSPServer,
		IssuingCertificateURL:       goCert.IssuingCertificateURL,
		DNSNames:                    goCert.DNSNames,
		EmailAddresses:              goCert.EmailAddresses,
		IPAddresses:                 goCert.IPAddresses,
		URIs:                        goCert.URIs,

		//: goCert.,
		PermittedDNSDomainsCritical: goCert.PermittedDNSDomainsCritical,
		PermittedDNSDomains:         goCert.PermittedDNSDomains,
		ExcludedDNSDomains:          goCert.ExcludedDNSDomains,
		PermittedIPRanges:           goCert.PermittedIPRanges,
		ExcludedIPRanges:            goCert.ExcludedIPRanges,
		PermittedEmailAddresses:     goCert.PermittedEmailAddresses,
		ExcludedEmailAddresses:      goCert.ExcludedEmailAddresses,
		PermittedURIDomains:         goCert.PermittedURIDomains,
		ExcludedURIDomains:          goCert.ExcludedURIDomains,

		//: goCert.			//:,
		CRLDistributionPoints: goCert.CRLDistributionPoints,
	}

}

func keyUsageToString(ku x509.KeyUsage) string {
	return keyUsageName[ku]
}

func extKeyUsageToString(extku []x509.ExtKeyUsage) string {

	return "Vigie TODO" //extKeyUsage[extku]
}

// Correspondence table Go 1.12
// KeyUsage represents the set of actions that are valid for a given key. It's
// a bitmap of the KeyUsage* constants.
var keyUsageName = [...]string{
	x509.KeyUsageDigitalSignature:  "KeyUsageDigitalSignature",
	x509.KeyUsageContentCommitment: "KeyUsageContentCommitment",
	x509.KeyUsageKeyEncipherment:   "KeyUsageKeyEncipherment",
	x509.KeyUsageDataEncipherment:  "KeyUsageDataEncipherment",
	x509.KeyUsageKeyAgreement:      "KeyUsageKeyAgreement",
	x509.KeyUsageCertSign:          "KeyUsageCertSign",
	x509.KeyUsageCRLSign:           "KeyUsageCRLSign",
	x509.KeyUsageEncipherOnly:      "KeyUsageEncipherOnly",
	x509.KeyUsageDecipherOnly:      "KeyUsageDecipherOnly",
}

// Correspondence table Go 1.12
// ExtKeyUsage represents an extended set of actions that are valid for a given key.
// Each of the ExtKeyUsage* constants define a unique action.
var extKeyUsage = [...]string{
	x509.ExtKeyUsageAny:                            "ExtKeyUsageAny",
	x509.ExtKeyUsageServerAuth:                     "ExtKeyUsageServerAuth",
	x509.ExtKeyUsageClientAuth:                     "ExtKeyUsageClientAuth",
	x509.ExtKeyUsageCodeSigning:                    "ExtKeyUsageCodeSigning",
	x509.ExtKeyUsageEmailProtection:                "ExtKeyUsageEmailProtection",
	x509.ExtKeyUsageIPSECEndSystem:                 "ExtKeyUsageIPSECEndSystem",
	x509.ExtKeyUsageIPSECTunnel:                    "ExtKeyUsageIPSECTunnel",
	x509.ExtKeyUsageIPSECUser:                      "ExtKeyUsageIPSECUser",
	x509.ExtKeyUsageTimeStamping:                   "ExtKeyUsageTimeStamping",
	x509.ExtKeyUsageOCSPSigning:                    "ExtKeyUsageOCSPSigning",
	x509.ExtKeyUsageMicrosoftServerGatedCrypto:     "ExtKeyUsageMicrosoftServerGatedCrypto",
	x509.ExtKeyUsageNetscapeServerGatedCrypto:      "ExtKeyUsageNetscapeServerGatedCrypto",
	x509.ExtKeyUsageMicrosoftCommercialCodeSigning: "ExtKeyUsageMicrosoftCommercialCodeSigning",
	x509.ExtKeyUsageMicrosoftKernelCodeSigning:     "ExtKeyUsageMicrosoftKernelCodeSigning",
}

func isCertTrusted(c *x509.Certificate) bool {

	opts := x509.VerifyOptions{}

	_, err := c.Verify(opts)

	if err != nil {
		return false
	}
	return true

}

func tryVerifyCustomRoot(certPEM, rootPEM []byte) bool {

	// First, create the set of root certificates. For this example we only
	// have one. It's also possible to omit this in order to use the
	// default root set of the current operating system.
	roots := x509.NewCertPool()
	ok := roots.AppendCertsFromPEM([]byte(rootPEM))
	if !ok {
		panic("failed to parse root certificate")
	}

	block, _ := pem.Decode([]byte(certPEM))
	if block == nil {
		panic("failed to parse certificate PEM")
	}
	cert, err := x509.ParseCertificate(block.Bytes)
	if err != nil {
		panic("failed to parse certificate: " + err.Error())
	}

	opts := x509.VerifyOptions{
		DNSName: "mail.google.com",
		Roots:   roots,
	}

	if _, err := cert.Verify(opts); err != nil {
		panic("failed to verify certificate: " + err.Error())
	}

	return true
}

func rawToCertPool(rawCert string) x509.CertPool {

	rootCert, err := x509.ParseCertificate([]byte(rawCert))
	if err != nil {
	}
	// Make the CertPool.
	pool := x509.NewCertPool()
	pool.AddCert(rootCert)

	return *pool

}
