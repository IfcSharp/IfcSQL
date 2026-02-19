$server = "builder-ifcsql-aue.database.windows.net"
$database = "ifcSQL"
$user = "builderadmin"
$password = "Hopnop123!"

$scriptPath = $PSScriptRoot   # folder containing this .ps1

Get-ChildItem $scriptPath -Filter "ifcSQL_*.sql" |
  Where-Object { $_.Name -match '^ifcSQL_(\d+)_' -and $_.Name -notlike 'ifcSQL_1_*' } |
  Sort-Object { [int]([regex]::Match($_.Name, '^ifcSQL_(\d+)_').Groups[1].Value) }, Name |
  ForEach-Object {
    Write-Host "Running $($_.Name)..."
    sqlcmd -S $server -d $database -U $user -P $password -N -b -i $_.FullName

    if ($LASTEXITCODE -ne 0) {
      Write-Host "❌ Error running $($_.Name). Stopping."
      exit 1
    }
  }

Write-Host " CREATE scripts completed successfully."
