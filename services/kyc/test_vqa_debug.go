package main

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"log"
	"net/http"
	"os"

	"github.com/joho/godotenv"
)

func main() {
	godotenv.Load()
	apiKey := os.Getenv("HUGGINGFACE_API_KEY")
	// URL from user snippet + standard chat completion path
	url := "https://router.huggingface.co/v1/chat/completions"
	model := "google/gemma-3-27b-it:nebius"

	// Tiny 1x1 transparent GIF
	// dummyImageBytes := []byte{0x47, 0x49, 0x46, 0x38, 0x39, 0x61, 0x01, 0x00, 0x01, 0x00, 0x80, 0x00, 0x00, 0xff, 0xff, 0xff, 0x00, 0x00, 0x00, 0x2c, 0x00, 0x00, 0x00, 0x00, 0x01, 0x00, 0x01, 0x00, 0x00, 0x02, 0x02, 0x44, 0x01, 0x00, 0x3b}
	// base64Image := base64.StdEncoding.EncodeToString(dummyImageBytes)
	// dataURI := "data:image/gif;base64," + base64Image
	// Construct OpenAI-compatible payload
	payload := map[string]interface{}{
		"model": model,
		"messages": []map[string]interface{}{
			{
				"role": "user",
				"content": []map[string]interface{}{
					{
						"type": "text",
						"text": "Describe this image in one sentence.",
					},
					{
						"type": "image_url",
						"image_url": map[string]string{
							"url": "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAUAAAAFCAYAAACNbyblAAAAHElEQVQI12P4//8/w38GIAXDIBKE0DHxgljNBAAO9TXL0Y4OHwAAAABJRU5ErkJggg==",
						},
					},
				},
			},
		},
		"max_tokens": 10,
	}

	jsonPayload, _ := json.Marshal(payload)

	fmt.Printf("Testing Model: %s\nURL: %s\n", model, url)

	req, err := http.NewRequest("POST", url, bytes.NewReader(jsonPayload))
	if err != nil {
		log.Fatal(err)
	}

	req.Header.Set("Authorization", "Bearer "+apiKey)
	req.Header.Set("Content-Type", "application/json")

	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		log.Fatal(err)
	}
	defer resp.Body.Close()

	body, _ := io.ReadAll(resp.Body)
	fmt.Printf("Status: %d\nBody: %s\n", resp.StatusCode, string(body))
}
