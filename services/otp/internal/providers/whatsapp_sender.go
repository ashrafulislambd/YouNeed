package providers

import (
	"bytes"
	"context"
	"encoding/json"
	"fmt"
	"io"
	"log"
	"net/http"
)

// WhatsAppSender implements domain.OTPSender via the WhatsApp Cloud API.
// Requires a valid access token, phone number ID, and an approved auth template.
// Note: This is a PAID service (~$0.03-0.08 per authentication message).
type WhatsAppSender struct {
	token        string
	phoneNumID   string
	templateName string
	httpClient   *http.Client
}

// NewWhatsAppSender creates a new WhatsApp sender.
func NewWhatsAppSender(token, phoneNumID, templateName string) *WhatsAppSender {
	return &WhatsAppSender{
		token:        token,
		phoneNumID:   phoneNumID,
		templateName: templateName,
		httpClient:   &http.Client{},
	}
}

// whatsappRequest is the payload for the WhatsApp Cloud API messages endpoint.
type whatsappRequest struct {
	MessagingProduct string           `json:"messaging_product"`
	To               string           `json:"to"`
	Type             string           `json:"type"`
	Template         whatsappTemplate `json:"template"`
}

type whatsappTemplate struct {
	Name       string              `json:"name"`
	Language   whatsappLanguage    `json:"language"`
	Components []whatsappComponent `json:"components"`
}

type whatsappLanguage struct {
	Code string `json:"code"`
}

type whatsappComponent struct {
	Type       string              `json:"type"`
	Parameters []whatsappParameter `json:"parameters,omitempty"`
	SubType    string              `json:"sub_type,omitempty"`
	Index      string              `json:"index,omitempty"`
}

type whatsappParameter struct {
	Type string `json:"type"`
	Text string `json:"text,omitempty"`
}

// SendOTP sends the OTP code to the phone number via WhatsApp Cloud API.
func (s *WhatsAppSender) SendOTP(ctx context.Context, phone string, code string) error {
	url := fmt.Sprintf("https://graph.facebook.com/v21.0/%s/messages", s.phoneNumID)

	payload := whatsappRequest{
		MessagingProduct: "whatsapp",
		To:               phone,
		Type:             "template",
		Template: whatsappTemplate{
			Name:     s.templateName,
			Language: whatsappLanguage{Code: "en"},
			Components: []whatsappComponent{
				{
					Type: "body",
					Parameters: []whatsappParameter{
						{Type: "text", Text: code},
					},
				},
				{
					Type:    "button",
					SubType: "url",
					Index:   "0",
					Parameters: []whatsappParameter{
						{Type: "text", Text: code},
					},
				},
			},
		},
	}

	body, err := json.Marshal(payload)
	if err != nil {
		return fmt.Errorf("failed to marshal WhatsApp request: %w", err)
	}

	req, err := http.NewRequestWithContext(ctx, http.MethodPost, url, bytes.NewReader(body))
	if err != nil {
		return fmt.Errorf("failed to create WhatsApp request: %w", err)
	}

	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("Authorization", "Bearer "+s.token)

	resp, err := s.httpClient.Do(req)
	if err != nil {
		return fmt.Errorf("WhatsApp API request failed: %w", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		respBody, _ := io.ReadAll(resp.Body)
		log.Printf("WhatsApp API error (status %d): %s", resp.StatusCode, string(respBody))
		return fmt.Errorf("WhatsApp API returned status %d", resp.StatusCode)
	}

	log.Printf("OTP sent via WhatsApp to %s", phone)
	return nil
}
