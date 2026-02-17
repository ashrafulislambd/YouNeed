package providers

import (
	"context"
	"fmt"
	"os"
)

// ConsoleSender implements domain.OTPSender by logging the OTP to stdout.
// This is the free, default provider — ideal for development and demos.
type ConsoleSender struct{}

// NewConsoleSender creates a new ConsoleSender instance.
func NewConsoleSender() *ConsoleSender {
	return &ConsoleSender{}
}

// SendOTP prints the OTP code to the console log and writes it to a file.
func (s *ConsoleSender) SendOTP(ctx context.Context, phone string, code string) error {
	// 1. Print to console (stdout)
	fmt.Printf("╔══════════════════════════════════════╗\n")
	fmt.Printf("║        OTP VERIFICATION CODE         ║\n")
	fmt.Printf("╠══════════════════════════════════════╣\n")
	fmt.Printf("║  Phone: %-28s ║\n", phone)
	fmt.Printf("║  Code:  %-28s ║\n", code)
	fmt.Printf("╚══════════════════════════════════════╝\n")

	// 2. Write to file for easy access
	err := os.WriteFile("otp_code.txt", []byte(code), 0644)
	if err != nil {
		fmt.Printf("Failed to write OTP to file: %v\n", err)
	}

	return nil
}
