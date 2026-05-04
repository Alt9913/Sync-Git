function Open-Database {
    # Unklar
    Add-Type -Path "$PSScriptRoot\..\lib\System.Data.SQLite.dll"

    # Noch Parametrisieren
    $dbPath = "$PSScriptRoot\..\db\images.db"
    $connection = New-Object System.Data.SQLite.SQLiteConnection("Data Source=$dbPath")
    $connection.Open()

    return $connection
}

function Initialize-Database($connection) {
    $cmd = $connection.CreateCommand()
    $cmd.CommandText = @"
    CREATE TABLE IF NOT EXISTS images (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        hash TEXT UNIQUE,
        file_name TEXT,
        CREATE_DATE DATETIME
    );
"@
    $cmd.ExecuteNonQuery()
}

function Insert-Hash($connection, $hash, $fileName) {
    $cmd = $connection.CreateCommand()
    # Unklar
    $cmd.CommandText = @"
    INSERT OR IGNORE INTO images (hash, file_name, CREATE_DATE)
    VALUES (@hash, @file, datetime('now'));
"@

    $cmd.Parameters.AddWithValue("@hash", $hash) | Out-Null
    $cmd.Parameters.AddWithValue("@file", $fileName) | Out-Null

    return $cmd.ExecuteNonQuery()  # 1 = neu, 0 = duplikat
}