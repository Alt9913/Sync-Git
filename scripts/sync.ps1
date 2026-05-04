. "$PSScriptRoot\db.ps1"

function Get-FileHashString($filePath) {
    return (Get-FileHash $filePath -Algorithm SHA256).Hash
}

function Sync-Files($config) {
    # Unklar
    $connection = Open-Database
    Initialize-Database $connection

    $files = Get-ChildItem $config.sourcePath -Filter *.png -Recurse

    foreach ($file in $files) {
        $hash = Get-FileHashString $file.FullName

        $result = Insert-Hash $connection $hash $file.Name

        if ($result -eq 0) {
            # Unklar
            Write-Host "Skip duplicate: $($file.Name)"
            continue
        }

        # Zielpfad
        # Unklar
        $date = Get-Date $file.LastWriteTime
        $targetPath = "DataType/png/$($date.Year)/$($date.Month)/$($date.Day)"

        New-Item -ItemType Directory -Force -Path $targetPath | Out-Null
        Copy-Item $file.FullName "$targetPath\$($file.Name)"

        git add .
    }

    git commit -m "Auto sync $(Get-Date)"
    git push

    $connection.Close()
}