# Verification Script for Microservices (using curl and temp files)

$ErrorActionPreference = "Stop"

function Assert-Success {
    param($Process, $ErrorMessage)
    if ($Process.ExitCode -ne 0) {
        Write-Host " [FAILED]" -ForegroundColor Red
        throw "$ErrorMessage (Exit Code: $($Process.ExitCode))"
    }
}

function Test-Endpoint {
    param(
        [string]$Name,
        [scriptblock]$ScriptBlock
    )
    Write-Host " Testing $Name..." -NoNewline
    try {
        & $ScriptBlock
        Write-Host " [OK]" -ForegroundColor Green
    } catch {
        Write-Host " [FAILED]" -ForegroundColor Red
        Write-Host "Error: $_"
        exit 1
    }
}

# 1. Auth Service: Register
$email = "testuser_$(Get-Random)@example.com"
$password = "password123"
Test-Endpoint "Auth: Register" {
    $jsonFile = [System.IO.Path]::GetTempFileName()
    '{"name":"Test User","email":"' + $email + '","password":"' + $password + '"}' | Set-Content $jsonFile -Encoding ASCII

    $output = & curl.exe -s -X POST "http://127.0.0.1:8080/auth/register" -H "Content-Type: application/json" -d "@$jsonFile" 2>&1
    Remove-Item $jsonFile

    try {
        $response = $output | ConvertFrom-Json
    } catch {
        throw "Failed to parse JSON: $output"
    }
    
    if (-not $response.id) { throw "No user ID in response: $output" }
    $global:userId = $response.id
    Write-Host " (User ID: $global:userId)" -NoNewline
}

# 2. Auth Service: Login
Test-Endpoint "Auth: Login" {
    $jsonFile = [System.IO.Path]::GetTempFileName()
    '{"email":"' + $email + '","password":"' + $password + '"}' | Set-Content $jsonFile -Encoding ASCII
    
    $output = & curl.exe -s -X POST "http://127.0.0.1:8080/auth/login" -H "Content-Type: application/json" -d "@$jsonFile" 2>&1
    Remove-Item $jsonFile

    try {
        $response = $output | ConvertFrom-Json
    } catch {
        throw "Failed to parse JSON: $output"
    }

    if (-not $response.token) { throw "No token in response: $output" }
    $global:token = $response.token
    Write-Host " (Token received)" -NoNewline
}

# 3. Credit Service: Add Credit
Test-Endpoint "Credit: Add" {
    $jsonFile = [System.IO.Path]::GetTempFileName()
    '{"user_id":"' + $global:userId + '","amount":100.0}' | Set-Content $jsonFile -Encoding ASCII
    
    $output = & curl.exe -s -X POST "http://127.0.0.1:8081/credit/add" -H "Content-Type: application/json" -d "@$jsonFile" 2>&1
    Remove-Item $jsonFile
    
    # Check for success (curl doesn't exit non-zero on 404/500 usually, but output is JSON)
    if ($output -match "error") { throw "API Error: $output" }
}

# 4. Credit Service: Get Balance
Test-Endpoint "Credit: Get Balance" {
    $output = & curl.exe -s -X GET "http://127.0.0.1:8081/credit/balance/$global:userId" 2>&1
    
    try {
        $response = $output | ConvertFrom-Json
    } catch {
        throw "Failed to parse JSON: $output"
    }
    
    if ($response.balance -ne 100) { throw "Expected balance 100, got $($response.balance)" }
}

# 5. Payment Service: Initiate Payment
Test-Endpoint "Payment: Initiate" {
    $jsonFile = [System.IO.Path]::GetTempFileName()
    '{"user_id":"' + $global:userId + '","amount":50.0,"currency":"USD","type":"PAYMENT","reference":"REF123"}' | Set-Content $jsonFile -Encoding ASCII
    
    $output = & curl.exe -s -X POST "http://127.0.0.1:8082/payment/initiate" -H "Content-Type: application/json" -d "@$jsonFile" 2>&1
    Remove-Item $jsonFile
    
    try {
        $response = $output | ConvertFrom-Json
    } catch {
        throw "Failed to parse JSON: $output"
    }

    if ($response.status -ne "COMPLETED") { throw "Payment status not COMPLETED: $output" }
}

# 6. Payment Service: Get History
Test-Endpoint "Payment: History" {
    $output = & curl.exe -s -X GET "http://127.0.0.1:8082/payment/history/$global:userId" 2>&1
    
    try {
        $response = $output | ConvertFrom-Json
    } catch {
        throw "Failed to parse JSON: $output"
    }

    if ($response.Count -eq 0) { throw "No payment history found" }
}

# 7. KYC Service: Submit (Mock Image)
Test-Endpoint "KYC: Submit" {
    $dummyImage = "dummy.jpg"
    "fake image content" | Set-Content $dummyImage

    $output = & curl.exe -s -X POST "http://127.0.0.1:8083/kyc/submit" `
        -H "Authorization: Bearer $global:token" `
        -F "type=PASSPORT" `
        -F "document_number=DOC12345" `
        -F "images=@$dummyImage" 2>&1
    
    Remove-Item $dummyImage -ErrorAction SilentlyContinue

    # The mock verification service always returns 'true' when API key is empty.
    # So this should succeed.
    if ($output -match "error") { throw "API Error: $output" }
    
    # Optional: Verify output JSON
}

# 8. KYC Service: Status
Test-Endpoint "KYC: Status" {
    $output = & curl.exe -s -X GET "http://127.0.0.1:8083/kyc/status" -H "Authorization: Bearer $global:token" 2>&1
    
    try {
        $response = $output | ConvertFrom-Json
    } catch {
        throw "Failed to parse JSON: $output"
    }
    
    if ($response.type -ne "PASSPORT") { throw "KYC Type mismatch" }
}

Write-Host "`nAll verification tests passed!" -ForegroundColor Cyan
