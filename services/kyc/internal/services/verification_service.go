package services

import (
	"bytes"
	"encoding/base64" // Added base64
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"os"
	"strings"
	"time"
)

type VerificationService struct {
	apiKey   string
	modelURL string
	modelID  string // Added model ID
	client   *http.Client
}

func NewVerificationService(apiKey, modelURL, modelID string) *VerificationService {
	return &VerificationService{
		apiKey:   apiKey,
		modelURL: modelURL,
		modelID:  modelID,
		client:   &http.Client{},
	}
}

// VerifyImage checks if the image at the given path is a valid ID document.
// It returns true if valid, false otherwise.
func (s *VerificationService) VerifyImage(imagePath string) (bool, error) {
	if s.apiKey == "" {
		// Mock behavior if no API Key provided
		return true, nil
	}

	// Read image file
	fileBytes, err := os.ReadFile(imagePath)
	if err != nil {
		return false, fmt.Errorf("failed to read image: %w", err)
	}

	// Detect Content Type (approximate)
	contentType := http.DetectContentType(fileBytes)
	base64Image := base64.StdEncoding.EncodeToString(fileBytes)
	dataURI := fmt.Sprintf("data:%s;base64,%s", contentType, base64Image)

	// Construct OpenAI-compatible Payload
	payload := map[string]interface{}{
		"model": s.modelID,
		"messages": []map[string]interface{}{
			{
				"role": "user",
				"content": []map[string]interface{}{
					{
						"type": "text",
						"text": "Analyze this image. Is it a valid official identity document (National ID, Passport, Driving License, Visa)?\n\nIf YES, output strictly one of: 'VALID_NID', 'VALID_PASSPORT', 'VALID_LICENSE', 'VALID_VISA'.\nIf NO, output strictly: 'IRRELEVANT'.\n\nDo not provide any other text or explanation.",
					},
					{
						"type": "image_url",
						"image_url": map[string]string{
							"url": dataURI,
						},
					},
				},
			},
		},
		"max_tokens": 50, // Enough for a short description
	}

	jsonPayload, err := json.Marshal(payload)
	if err != nil {
		return false, fmt.Errorf("failed to marshal payload: %w", err)
	}

	// Retry logic for "Model is loading" or server errors
	maxRetries := 3
	for i := 0; i < maxRetries; i++ {
		req, err := http.NewRequest("POST", s.modelURL, bytes.NewReader(jsonPayload))
		if err != nil {
			return false, err
		}

		req.Header.Set("Authorization", "Bearer "+s.apiKey)
		req.Header.Set("Content-Type", "application/json")

		resp, err := s.client.Do(req)
		if err != nil {
			return false, err
		}
		defer resp.Body.Close()

		if resp.StatusCode == http.StatusOK {
			// Parse OpenAI-style response
			var result struct {
				Choices []struct {
					Message struct {
						Content string `json:"content"`
					} `json:"message"`
				} `json:"choices"`
			}

			if err := json.NewDecoder(resp.Body).Decode(&result); err != nil {
				return false, fmt.Errorf("failed to decode response: %w", err)
			}

			if len(result.Choices) > 0 {
				text := strings.TrimSpace(result.Choices[0].Message.Content)
				fmt.Printf("AI Response: %s\n", text) // Log the response

				// Strict Label approach
				// The model might still be chatty, so we look for the specific tokens at the start or end,
				// or just presence of the positive tokens without negation.
				// Given the prompt instruction "strictly one of", we check specific prefixes.

				validPrefixes := []string{"VALID_NID", "VALID_PASSPORT", "VALID_LICENSE", "VALID_VISA"}
				upperText := strings.ToUpper(text)

				for _, prefix := range validPrefixes {
					if strings.Contains(upperText, prefix) {
						return true, nil
					}
				}

				fmt.Printf("AI Rejected: %s\n", text)
				return false, nil
			}
			return false, nil // Default reject
		}

		// Handle Retry-able Errors
		if resp.StatusCode == http.StatusServiceUnavailable || resp.StatusCode == http.StatusTooManyRequests { // 429 is StatusTooManyRequests
			bodyBytes, _ := io.ReadAll(resp.Body)
			errMsg := string(bodyBytes)
			fmt.Printf("Attempt %d: API %d Error: %s. Retrying...\n", i+1, resp.StatusCode, errMsg)
			time.Sleep(5 * time.Second)
			continue
		}

		// Permanent Errors
		bodyBytes, _ := io.ReadAll(resp.Body)
		return false, fmt.Errorf("API error (status %d): %s", resp.StatusCode, string(bodyBytes))
	}

	return false, fmt.Errorf("max retries exceeded for AI service")
}
