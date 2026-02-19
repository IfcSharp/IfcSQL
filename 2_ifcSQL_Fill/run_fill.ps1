# run_fill.ps1
# Runs ifcSQL FILL scripts in a fixed, dependency-safe order against Azure SQL Database.
# Includes "resume from file" support.

$ErrorActionPreference = "Stop"

$server   = "builder-ifcsql-aue.database.windows.net"
$database = "ifcSQL"
$user     = "builderadmin"

# Prefer env var over hardcoding a password:
#   $env:SQL_PASSWORD="..."
$password = $env:SQL_PASSWORD
if (-not $password) { throw "Set SQL_PASSWORD first (e.g. `$env:SQL_PASSWORD='...')" }

# Folder containing the SQL files (relative to this script)
$DIR = $PSScriptRoot

# --- resume control ---
# Set to $null to run from the start, or set to the exact filename to resume from.
$resumeFrom = $null
$started = $false

function Run-File([string]$fileName) {
    if ($resumeFrom -and -not $started) {
        if ($fileName.ToLower() -eq $resumeFrom.ToLower()) { $started = $true } else { return }
    } elseif (-not $resumeFrom) {
        $started = $true
    }

    $full = Join-Path $DIR $fileName
    if (-not (Test-Path $full)) { throw "Missing file: $full" }

    Write-Host "----------------------------------------------------------"
    Write-Host "Running file: $fileName"
    Write-Host "----------------------------------------------------------"
    sqlcmd -S $server -d $database -U $user -P $password -N -b -i $full
    if ($LASTEXITCODE -ne 0) { throw "sqlcmd failed on file: $fileName" }
}

function Run-Query([string]$query) {
    # Skip queries until resume starts (since resume is file-based)
    if ($resumeFrom -and -not $started) { return }

    Write-Host "----------------------------------------------------------"
    Write-Host "Running query: $query"
    Write-Host "----------------------------------------------------------"
    sqlcmd -S $server -d $database -U $user -P $password -N -b -Q $query
    if ($LASTEXITCODE -ne 0) { throw "sqlcmd failed on query: $query" }
}

# -------- FILL ORDER (ported from the bash script) --------

Run-File "ifcSQL.Licence.Table.sql"
Run-File "ifcSQL.Release.Table.sql"
Run-File "ifcSQL.Issues.Table.sql"
Run-File "ifcSQL.BaseTypeGroup.Table.sql"
Run-File "ifcSQL.EntityAttributeTable.Table.sql"

Run-File "ifcAPI.ComputerLanguage.Table.sql"
Run-File "ifcDocumentation.NaturalLanguage.Table.sql"

Run-File "ifcSpecification.SpecificationGroup.Table.sql"
Run-File "ifcSpecification.Specification.Table.sql"

Run-File "ifcSchemaTool.ChangeLogType.Table.sql"

Run-File "ifcProject.ProjectType.Table.sql"
Run-File "ifcProject.ProjectGroupType.Table.sql"
Run-File "ifcProject.ProjectGroup.Table.sql"
Run-File "ifcProject.Project.Table.sql"

Run-File "ifcSchema.TypeGroup.Table.sql"
Run-File "ifcSchema.LayerGroup.Table.sql"
Run-File "ifcSchema.Layer.Table.sql"

Run-File "ifcSchema.Type.DROP_CONSTRAINT.sql"
Run-File "ifcSchema.Type.Table.sql"
Run-File "ifcSchema.Type.CREATE_CONSTRAINT.sql"

Run-File "ifcSchema.EntityAttribute.Table.sql"
Run-File "ifcSchema.EntityInverseAssignment.Table.sql"
Run-File "ifcSchema.EnumItem.Table.sql"
Run-File "ifcSchema.SelectItem.Table.sql"

Run-Query "EXEC [ifcSchemaTool].[ReFill_ifcSchemaDerived_EntityAttributeInstance];"

Run-File "ifcProperty.PropertySetDef.Table.sql"
Run-File "ifcProperty.PropertyDef.Table.sql"
Run-File "ifcProperty.PropertyDefAlias.Table.sql"
Run-File "ifcProperty.PropertySetDefAlias.Table.sql"
Run-File "ifcProperty.PropertySetDefApplicable.Table.sql"
Run-File "ifcProperty.TypePropertyReferenceValue.Table.sql"
Run-File "ifcProperty.TypePropertySingleValue.Table.sql"

Run-File "ifcQuantityTakeOff.Type.Table.sql"
Run-File "ifcAPI.TypeComputerLanguageAssignment.Table.sql"
Run-File "ifcSpecification.TypeSpecificationAssignment.Table.sql"

Run-File "ifcUnit.Unit.Table.sql"
Run-File "ifcUnit.SIUnitNameUnitOfMeasureEnumAssignment.Table.sql"
Run-File "ifcUnit.SIUnitNameEnumDimensionsExponentAssignment.Table.sql"
Run-File "ifcUnit.SIPrefixEnumExponentAssigment.Table.sql"

Run-File "ifcInstance.Entity.Table.sql"

Run-File "ifcInstance.EntityAttributeOfEnum.Table.sql"
Run-File "ifcInstance.EntityAttributeOfFloat.Table.sql"
Run-File "ifcInstance.EntityAttributeOfInteger.Table.sql"
Run-File "ifcInstance.EntityAttributeOfList.Table.sql"
Run-File "ifcInstance.EntityAttributeOfString.Table.sql"
Run-File "ifcInstance.EntityAttributeOfVector.Table.sql"
Run-File "ifcInstance.EntityAttributeOfEntityRef.Table.sql"
Run-File "ifcInstance.EntityAttributeListElementOfEntityRef.Table.sql"

Run-File "ifcProject.EntityInstanceIdAssignment.Table.sql"
Run-File "ifcProject.LastGlobalEntityInstanceId.Table.sql"

Run-Query "EXEC app.CreateNewUserIfNotExist;"
Run-Query "EXEC app.SelectProject 1006;"

Write-Host " FILL phase complete."