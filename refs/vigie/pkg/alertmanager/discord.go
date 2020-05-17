package alertmanager

import (
	"bytes"
	"encoding/json"
	"fmt"
	"net/http"
	"time"

	"github.com/vincoll/vigie/pkg/teststruct"
)

// Discord Documentation:
// Webhook : https://discordapp.com/developers/docs/resources/webhook#execute-webhook
// Embeded Message : https://discordapp.com/developers/docs/resources/channel#embed-object

type discordAlert struct {
	webhookURL string
}

func (da *discordAlert) send(tamsg teststruct.TotalAlertMessage, at alertType) error {

	data, _ := createDiscordPayload(tamsg, at)

	payloadBytes, err := json.Marshal(data)
	if err != nil {
		return fmt.Errorf("fail to marshall the payload : %s", err)
	}
	body := bytes.NewReader(payloadBytes)

	req, err := http.NewRequest("POST", da.webhookURL, body)
	if err != nil {
		return fmt.Errorf("fail to build a POST request : %s", err)
	}
	req.Header.Set("Content-Type", "application/json")

	resp, err := http.DefaultClient.Do(req)
	if err != nil {
		return fmt.Errorf("fail to send a payload to Discord: %s", err)
	}
	if resp.StatusCode > 400 {
		return fmt.Errorf("discord fail to process the payload : %s", resp.Status)
	}
	defer resp.Body.Close()

	return nil

}

func (da *discordAlert) name() string {
	return "discord"
}

type discordPayload struct {
	Username  string   `json:"username"`
	AvatarUrl string   `json:"avatar_url"`
	Content   string   `json:"content"`
	Embeds    []embeds `json:"embeds"`
}

// https://discordapp.com/developers/docs/resources/channel#embed-object
type embeds struct {
	Title       string   `json:"title"`
	Url         string   `json:"url"`
	Description string   `json:"description"`
	Timestamp   string   `json:"timestamp"`
	Color       int      `json:"color"`
	Fields      []fields `json:"fields"`
}

// https://discordapp.com/developers/docs/resources/channel#embed-object-embed-field-structure
// No url :(
type fields struct {
	Name   string `json:"name"`
	Value  string `json:"value"`
	Inline bool   `json:"inline"`
}

func createDiscordPayload(tamsg teststruct.TotalAlertMessage, at alertType) (discordPayload, error) {

	// The Discord Payload is created starting with the leaves.

	var pFields []fields
	// Conditionals Values
	var color, errTSCount int
	var contentTitle, description string
	//var status string

	errTSCount = len(tamsg.TestSuites)

	if errTSCount == 0 {

		color = 1234323
		description = fmt.Sprintf("%s", time.Now().UTC().String())
		contentTitle = fmt.Sprintf("%s\nAll Testsuites are healthy.", AM.vigieInstanceName)

	} else {

		// prepare KO Message
		color = 15158332
		description = fmt.Sprintf(":sos: %s", time.Now().UTC().String())

		if errTSCount > 1 {
			contentTitle = fmt.Sprintf("%s \n %d Testsuites are not healthy:", AM.vigieInstanceName, errTSCount)
		} else {
			contentTitle = fmt.Sprintf("%s \n %d  Testsuite is not healthy:", AM.vigieInstanceName, errTSCount)
		}
	}

	// Add (Reminder) at the end of the title if needed.
	if at == reminder {
		contentTitle = fmt.Sprintf("(Reminder) %s", contentTitle)
	}

	// Field Details
	// prepare Full Message
	for _, ts := range tamsg.TestSuites {

		tsas := generateField(ts)
		pFields = append(pFields, tsas)

	}

	emb := embeds{
		Title:       fmt.Sprintf(contentTitle),
		Description: description,
		Url:         AM.vigieURL,
		Color:       color,
		Fields:      pFields,
	}

	var pEmbeds []embeds
	pEmbeds = append(pEmbeds, emb)

	// Final Payload
	payload := discordPayload{
		Username:  "Vigie",
		AvatarUrl: "https://vigie.dev",
		Content:   "",
		Embeds:    pEmbeds,
	}

	return payload, nil

}

func generateField(tsas teststruct.TSAlertShort) (tsField fields) {

	genStr := ""

	for _, tc := range tsas.TestCases {

		tcLink := fmt.Sprintf("%s/api/id/%d/%d", AM.vigieURL, tsas.ID, tc.ID)
		genStr += fmt.Sprintf("**  [%s](%s)**", tc.Name, tcLink)

		str2 := "```"

		for _, tstp := range tc.TestSteps {

			str2 += fmt.Sprintf("%s (%s)\n", tstp.Name, tstp.Status)
			//str2 += fmt.Sprintf( "[%s](%s) \n", tstp.Name, "http://foo.tld")
		}

		genStr += str2
		genStr += "```"

	}

	tsField = fields{
		Name: fmt.Sprintf("**%s**", tsas.Name),
		//URL:    fmt.Sprintf("%s/api/id/%d", AM.vigieURL, tsas.ID),
		Value:  genStr,
		Inline: true,
	}

	return tsField
}
