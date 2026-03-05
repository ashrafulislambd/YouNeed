package main

import (
	"bytes"
	"fmt"
	"io"
	"log"
	"net/http"
	"os"

	"github.com/joho/godotenv"
)

func main() {
	// Load .env
	godotenv.Load()

	apiKey := os.Getenv("HUGGINGFACE_API_KEY")

	// Models to test
	models := []string{
		"https://router.huggingface.co/models/gpt2",                                                // Sanity check
		"https://router.huggingface.co/models/Salesforce/blip-image-captioning-large",              // Target
		"https://router.huggingface.co/v1/models/Salesforce/blip-image-captioning-large",           // V1 Variant
		"https://router.huggingface.co/hf-inference/models/Salesforce/blip-image-captioning-large", // Guess
	}

	dummyImage := []byte{0x47, 0x49, 0x46, 0x38, 0x39, 0x61, 0x01, 0x00, 0x01, 0x00, 0x80, 0x00, 0x00, 0xff, 0xff, 0xff, 0x00, 0x00, 0x00, 0x2c, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x01, 0x00, 0x00, 0x02, 0x02, 0x44, 0x01, 0x00, 0x3b}
	dummyText := []byte(`{"inputs": "Hello"}`)

	for _, url := range models {
		fmt.Printf("\nTesting: %s\n", url)

		var payload []byte
		if url == models[0] {
			payload = dummyText
		} else {
			payload = dummyImage
		}

		req, err := http.NewRequest("POST", url, bytes.NewReader(payload))
		if err != nil {
			log.Printf("Req Error: %v", err)
			continue
		}

		req.Header.Set("Authorization", "Bearer "+apiKey)
		if url == models[0] {
			req.Header.Set("Content-Type", "application/json")
		} else {
			req.Header.Set("Content-Type", "application/octet-stream")
		}

		client := &http.Client{}
		resp, err := client.Do(req)
		if err != nil {
			log.Printf("Net Error: %v", err)
			continue
		}
		defer resp.Body.Close()

		body, _ := io.ReadAll(resp.Body)
		sample := string(body)
		if len(sample) > 300 {
			sample = sample[:300] + "..."
		}
		fmt.Printf("Status: %d\nBody: %s\n", resp.StatusCode, sample)
	}
}
