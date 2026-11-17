# Starts the Flask backend and Vite frontend with one command.
# Usage: .\start.ps1   (Ctrl+C stops both)

$ErrorActionPreference = "Stop"
$root = $PSScriptRoot  # Resolve paths relative to this script, not the caller's cwd

# Install dependencies only when missing, to keep startup fast
if (-not (Test-Path "$root\frontend\node_modules")) {
    Write-Host "Installing frontend dependencies..." -ForegroundColor Cyan
    Push-Location "$root\frontend"; npm install; Pop-Location
}
Write-Host "Checking backend dependencies..." -ForegroundColor Cyan
pip install -q -r "$root\backend\requirements.txt"

# Backend runs as a child process in this same window so logs are interleaved
Write-Host "Starting backend on http://localhost:5000" -ForegroundColor Green
$backend = Start-Process python -ArgumentList "app.py" -WorkingDirectory "$root\backend" `
    -NoNewWindow -PassThru

try {
    # Frontend runs in the foreground; Ctrl+C ends it and triggers the cleanup below
    Write-Host "Starting frontend on http://localhost:5173" -ForegroundColor Green
    Push-Location "$root\frontend"
    npm run dev
}
finally {
    Pop-Location
    # /T kills the whole tree: Flask debug mode spawns a reloader child process
    if ($backend -and -not $backend.HasExited) {
        taskkill /PID $backend.Id /T /F | Out-Null
    }
    Write-Host "Backend stopped." -ForegroundColor Yellow
}
