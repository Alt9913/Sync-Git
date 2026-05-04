$config = Get-Content "$PSScriptRoot\..\config\settings.json" | ConvertFrom-Json

. "$PSScriptRoot\sync.ps1"

Sync-Files $config