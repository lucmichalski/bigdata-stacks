package alertmanager

import (
	"bytes"
	"fmt"
	"github.com/vincoll/vigie/pkg/teststruct"
	"gopkg.in/gomail.v2"
	"html/template"
	"strings"
)

type email struct {
	To       string `toml:"to"`
	From     string `toml:"from"`
	Username string `toml:"username"`
	Password string `toml:"password"`
	SMTP     string `toml:"smtp"`
	Port     int    `toml:"port"`
}

func (ea *email) send(tamsg teststruct.TotalAlertMessage, at alertType) error {

	m := gomail.NewMessage()
	m.SetHeader("From", ea.Username)
	m.SetHeader("To", ea.To)

	if at == reminder {
		m.SetHeader("Subject", fmt.Sprintf("Vigie Alerting @ %s (Reminder)", AM.vigieInstanceName))
	} else {
		m.SetHeader("Subject", fmt.Sprintf("Vigie Alerting @ %s", AM.vigieInstanceName))
	}

	var body string

	r := strings.NewReplacer(
		"%vigieurl%", AM.vigieURL,
		"%vigiename%", AM.vigieInstanceName)

	if len(tamsg.TestSuites) == 0 {
		// Pick Success email
		body = r.Replace(emailTemplateOK)
	} else {
		// Generate a Error template
		var err error
		body, err = genErrorTemplateEmail(tamsg)
		if err != nil {
			return fmt.Errorf("error while templating email : %s", err)
		}

	}

	m.SetBody("text/html", body)

	d := gomail.NewDialer(ea.SMTP, ea.Port, ea.Username, ea.Password)

	// Send the email
	if err := d.DialAndSend(m); err != nil {
		return fmt.Errorf("fail to send a notification email: %s", err)
	}

	return nil
}

func (ea *email) name() string {
	return "email"
}

func genErrorTemplateEmail(tamsg teststruct.TotalAlertMessage) (string, error) {

	r := strings.NewReplacer(
		"%vigieurl%", AM.vigieURL,
		"%vigiename%", AM.vigieInstanceName)

	et2 := r.Replace(et)

	t, err := template.New("Vigie email").Parse(et2)
	if err != nil {
		return "", fmt.Errorf("cannot parse the template email: %s", err)
	}

	var tpl bytes.Buffer
	err = t.ExecuteTemplate(&tpl, "Vigie email", tamsg)
	if err != nil {
		return "", fmt.Errorf("cannot execute the template email: %s", err)

	}

	return tpl.String(), nil
}

const et = `
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Vigie Alerting</title>
</head>
<body>
<ul>
    {{ range $key , $ts := .TestSuites}}
        <li> {{$ts.Name}} : {{$ts.Status}}
            <ul>
                {{ range $key , $tc := $ts.TestCases}}
                    <li> {{$tc.Name}} : {{$tc.Status}}
                        <ul>
                            {{ range $key , $tstp := $tc.TestSteps}}
                                <li>{{$tstp.Name}} : {{$tstp.Status}}</li>
                                    <ul>
                                        {{ range $i , $val := $tstp.Details}}
                                        <li>{{$val}}</li>

                                        {{end}}
                                    </ul>
                            {{end}}
                        </ul>
                    </li>
                {{end}}
            </ul>
        </li>
    {{end}}
</ul>

<br>
<a href="%vigieurl%/api/testsuites/all">Vigie %vigiename% API</a> 

</body>
</html>

`

const emailTemplateOK = `
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<title>Vigie Alerting</title>
</head>
<body>

Every Testsuites are OK.<br>

<a href="%vigieurl%/api/testsuites/all">Vigie %vigiename% API</a> 

</body>
</html>`
