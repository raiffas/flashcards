# Stops the Flask backend and Vite frontend started by start.ps1 / start.sh.
# Usage: .\stop.ps1   (useful if a terminal was closed and left servers running)

$ports = @{ 5000 = "backend"; 5173 = "frontend" }  # Must match the ports in start.ps1

foreach ($port in $ports.Keys) {
    # Only look at sockets in the Listen state; skips TIME_WAIT and client connections
    $listeners = Get-NetTCPConnection -LocalPort $port -State Listen -ErrorAction SilentlyContinue
    if (-not $listeners) {
        Write-Host "No $($ports[$port]) listening on port $port." -ForegroundColor DarkGray
        continue
    }
    foreach ($procId in ($listeners.OwningProcess | Sort-Object -Unique)) {
        # Flask debug mode runs a reloader parent; stop it too so it can't respawn the server
        $parentId = (Get-CimInstance Win32_Process -Filter "ProcessId=$procId").ParentProcessId
        $parent = Get-Process -Id $parentId -ErrorAction SilentlyContinue
        if ($parent -and $parent.ProcessName -match '^(python|node)') {
            taskkill /PID $parentId /T /F | Out-Null
        }
        # /T kills the whole tree; /F is needed because dev servers ignore a polite close
        taskkill /PID $procId /T /F 2>$null | Out-Null
    }
    Write-Host "Stopped $($ports[$port]) on port $port." -ForegroundColor Yellow
}
