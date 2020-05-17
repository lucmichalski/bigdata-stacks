package alertmanager

import (
	"bytes"
	"encoding/json"
	"fmt"
	"github.com/vincoll/vigie/pkg/teststruct"
	"html/template"
	"net/http"
	"strings"
	"time"
)

type slackAlert struct {
	webhookURL string
	channel    string
}

func (sa *slackAlert) send(tamsg teststruct.TotalAlertMessage, at alertType) error {

	var body string
	if len(tamsg.TestSuites) == 0 {

		valReminder := ""
		if at == reminder {
			valReminder = "(Reminder)"
		}

		r := strings.NewReplacer(
			"%vigieurl%", AM.vigieURL,
			"%vigiename%", AM.vigieInstanceName,
			"%vigiename%", AM.vigieInstanceName,
			"%time%", time.Now().UTC().String(),
			"%reminder%", valReminder,
			"!µµ", "<")

		body = r.Replace(slackTemplateOK)

	} else {
		// Generate a Error template
		var err error
		body, err = createSlackpayload(tamsg, at)
		if err != nil {
			return err
		}
	}

	err2 := SendSlackNotification(sa.webhookURL, sa.channel, body)
	if err2 != nil {
		println(err2)
	}

	return err2
}

type slackRequestBody struct {
	Channel  string `json:"channel"`
	Username string `json:"username"`
	Blocks   string `json:"blocks"`
}

// SendSlackNotification will post to an 'Incoming Webook' url setup in Slack Apps. It accepts
// some text and the slack channel is saved within Slack.
func SendSlackNotification(webhookUrl, channel, body string) error {

	slackBody, _ := json.Marshal(slackRequestBody{Channel: channel, Username: "Vigie", Blocks: body})
	req, err := http.NewRequest(http.MethodPost, webhookUrl, bytes.NewBuffer(slackBody))
	if err != nil {
		return err
	}

	req.Header.Add("Content-Type", "application/json")

	client := &http.Client{Timeout: 10 * time.Second}
	resp, err := client.Do(req)
	if err != nil {
		return err
	}

	buf := new(bytes.Buffer)
	buf.ReadFrom(resp.Body)
	if buf.String() != "ok" {
		return fmt.Errorf("non ok response returned from Slack : %s", buf.String())
	}
	return nil
}

func createSlackpayload(tamsg teststruct.TotalAlertMessage, at alertType) (string, error) {

	valReminder := ""
	if at == reminder {
		valReminder = "(Reminder)"
	}

	r := strings.NewReplacer(
		"%vigieurl%", AM.vigieURL,
		"%vigiename%", AM.vigieInstanceName,
		"%time%", time.Now().UTC().String(),
		"%reminder%", valReminder,
		"!µµ", "<",
		"µµ!", ">",
		"^^^", "```")

	// slackTemplate2 := r.Replace(slackTemplate)

	t, err := template.New("Vigie Slack").Parse(slackTemplate)
	if err != nil {
		return "", fmt.Errorf("cannot parse the template email: %s", err)
	}

	var tpl bytes.Buffer
	err = t.ExecuteTemplate(&tpl, "Vigie Slack", tamsg)
	if err != nil {
		return "", fmt.Errorf("cannot execute the template email: %s", err)

	}

	tpl2 := r.Replace(tpl.String())

	return tpl2, nil
}

func (sa *slackAlert) name() string {
	return "slack"
}

const slackTemplate = `
[
{
"type": "section",
"text": {
"type": "mrkdwn",
"text": "*%vigiename% %reminder%* :sos:"
}
},

{{ range $key , $ts := .TestSuites}}

{
"type": "section",
"text": {
"type": "mrkdwn",
"text": "    !µµ%vigieurl%/api/{{$ts.ID}}|*{{$ts.Name}}*µµ!: {{$ts.Status}}"
}
},
{{ range $key , $tc := $ts.TestCases}}

{
"type": "section",
"text": {
"type": "mrkdwn",
"text": "> !µµ%vigieurl%/api/{{$ts.ID}}/{{$tc.ID}}|*{{$tc.Name}}*µµ!: {{$tc.Status}}"
}
},

{
"type": "section",
"text": {
"type": "mrkdwn",
"text": "^^^{{ range $key , $tstp := $tc.TestSteps}}!µµ%vigieurl%/api/{{$ts.ID}}/{{$tc.ID}}/{{$tstp.ID}}|{{$tstp.Name}}µµ! : {{$tstp.Status}}{{ range $i , $val := $tstp.Details}}\n{{$val}}{{end}}{{end}}^^^"
}
},


{{end}}

{{end}}
{
"type": "context",
"elements": [
{
"type": "mrkdwn",
"text": "_!µµ%vigieurl%/api/testsuites/all|Vigie API> %time%_"
}
]
},
{
"type": "divider"
}
]

`

const slackTemplateOK = `
 [

 	{
		"type": "section",
		"text": {
			"type": "mrkdwn",
			"text": "*%vigiename% %reminder%*\n:ok: All Testsuites are healthy."
		}
	},
	{
		"type": "context",
		"elements": [
			{
				"type": "mrkdwn",
				"text": "_!µµ%vigieurl%/api/testsuites/all|Vigie API> %time%_"
			}
		]
	},
	{
		"type": "divider"
	}
]
`
