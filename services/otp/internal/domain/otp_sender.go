package domain

import "context"

// OTPSender defines the interface for delivering OTP codes.
// This is the core boundary — all providers must implement this interface.
// Business logic depends on this interface, not on any concrete provider.
type OTPSender interface {
	SendOTP(ctx context.Context, phone string, code string) error
}
