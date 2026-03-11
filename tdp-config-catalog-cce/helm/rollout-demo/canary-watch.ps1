$v1 = 0
$v2 = 0

while ($true) {

    $response = Invoke-WebRequest -Uri http://localhost:8080 -UseBasicParsing
    $content = $response.Content

    if ($content -match "version1") {
        $v1++
    }

    if ($content -match "version2") {
        $v2++
    }

    Clear-Host

    Write-Host "Version1: $v1"
    Write-Host "Version2: $v2"

    Start-Sleep -Milliseconds 500
}