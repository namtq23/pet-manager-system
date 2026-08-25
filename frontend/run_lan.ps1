$port = 8090
$flutterProcesses = Get-CimInstance Win32_Process | Where-Object {
  $_.Name -eq 'dart.exe' -and
  $_.CommandLine -match 'flutter_tools.snapshot.*run' -and
  $_.CommandLine -match "--web-port $port"
}

$flutterProcesses | ForEach-Object {
  Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue
}

Set-Location $PSScriptRoot
flutter run -d web-server --web-hostname 0.0.0.0 --web-port $port