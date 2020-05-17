# Vigie

Vigie is a high level monitoring software built to monitor and audit various application services. Check endpoints with built-in probes and confront the expected result with your own assertions.

> :construction: Vigie is in alpha stage, still under heavy development.
>
> Therefore it should only be use for experimental use.
>
> Feedback and ideas are really appreciated (FR/EN) to : vigiefeedback@vincoll.io

## Use Cases :dart:

**Monitor your infrastructure from its corners**

A segmented infrastructure from a network stand point can be difficult to monitor by a central system. Vigie is so tiny that it can be fit into each of your restrictive network zones. That's enable you to monitor in real condition internal or external services with the perspective and constraints of a network zone.

**Ping OK nor HTTP 200 is enough**

Vigie thanks to its probes can analyse the complete response of a service. And thus verify with certainty if the service being tested is rendered as it should.

**Save time during outages**

When you encounter an outage, Vigie accelerates your diagnosis by presenting the current state of your infrastructure. The more your Vigie knows about the nominal state of your infrastructure through multiple kind of tests, the easier it will be to identify or rule out the cause of the incident.

**Detect subtle changes**

Detect and Audit any changes even if the service is OK. Eg:

* Your HTTPS connections are made successfully, but why a outdated cipher like 3DES and SSLv3 are now available in your TLS negociation? (Poodle)
* Why the hash of a third party JS ressource changed without any noticed? (TicketMaster attack by Magecart)
* Be the first to know about *Half-Life 3* by watching any changes taking place on the Valve's DNS.

**Create SLI & Mesure SLO**

If Vigie is coupled with a Timeseries Database, you can mesure your SLO compliance based on advanced assertions (SLI) over time.

## Get started :rocket:

* **Documentation** :notebook_with_decorative_cover:
  * [Vigie Documentation](https://docs.vigie.dev)

* **Create Tests**
  * [Examples](https://github.com/Vincoll/vigie-demo-test)

* **Configure**
  * [Documentation](https://docs.vigie.dev/configuration/overview/)

* **Deploy Vigie**
  * [Documentation WIP]()
  * [Examples](https://github.com/Vincoll/vigie-deploy)

## Features :tada:

**Probes**

Vigie has serveral built-in probes.
* Stable (HTTP, ICMP, DNS, TCP/UDP, X509, Hash, ...).
* WIP (TLS, SSH, Traceroute, SMTP, IMAP)

**High level service checks**

Vigie let you create assertions based on full protocol responses from probes.

**Assertions**

You can assert probe results with multiples operators.
* Equal, Greater Than, Contain, ...

**Alerting**

Vigie can alert you if a test fails. You can received notification by : Email, Discord; ...

**Tests Structure**

Vigie implement a test structure, readable and ready for automation.

**Exposes a Rest API**

Rest API for read and interaction.

**Low footprint**

Vigie uses little RAM and CPU.

**Modularity**

Vigie can be deployed in different ways depending on your usage.

**Data persistance**

If Vigie is bind with InfluxDB, save every probe response and assertion result.

## Examples :memo:

`A TestSuite containing a TestCase containing TestSteps`

```yaml
name: TestSuite Read Me Example

config:
  frequency:
    x509: 1h // x509 probes will run every 1h (can be overload in TestCase or TestStep)
    http: 6s // http probes will run every 6s if not spec a timeout for a req is set at 6s too
testcases:
  - name: Testcase Read Me Example
    steps:
      - name: abc.xyz x509
        probe:
          type: x509    // Probe type
          host: abc.xyz // X509 Probe param
          port: 443     // X509 Probe param
        assertions:
          - valid == true
          - daybeforeexpiration > 15
          - expired == false
          - endcertificate.dnsnames $$ "*.golang.com"
          - rootcertificate.publickeyalgorithm != "3DES"
          - endcertificate.signaturealgorithm == "SHA256-RSA"

      - name: Get a JSON value
        probe:
          type: http                    // Probe type
          follow_redirects: true        // Follow 300 redirects
          method: GET                   // HTTP Method
          url: https://httpbin.org/json // URL
        assertions:
          - probeinfo.responsetime < 600ms
          - httpcode == 200
          - headers.Content-Type == "application/json"
          - bodyjson.slideshow.author == "Yours Truly"
  ```
