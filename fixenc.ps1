# Fix double-encoded UTF-8 (emojis got corrupted by PowerShell Set-Content)
$filePath = Join-Path $PSScriptRoot "index.html"

# Read as UTF-8 (current state - has garbled emojis)
$text = [System.IO.File]::ReadAllText($filePath, [System.Text.Encoding]::UTF8)

# Convert chars back to Windows-1252 bytes, then re-interpret as UTF-8
$win1252 = [System.Text.Encoding]::GetEncoding(1252)
$bytes = $win1252.GetBytes($text)
$fixed = [System.Text.Encoding]::UTF8.GetString($bytes)

# Write back without BOM
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
[System.IO.File]::WriteAllText($filePath, $fixed, $utf8NoBom)

Write-Host "Fixed! Emojis restored."
