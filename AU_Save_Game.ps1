[cmdletbinding()]
param()

$TranscriptLogFile = ''
$StartTime = Get-Date -Format 'yyyy-mm-dd hh:mm:ss.fff'
Start-Transcript -Path $TranscriptLogFile -Append -NoClobber
Write-information "Script started at: $StartTime"

$auHostConfigFile = ($env:userprofile + "\appdata\locallow\innersloth\Among Us")
$auSavePath = ($env:userprofile + "\appdata\locallow")
$auSaveFolder = "AU_Saves"
$auSaveRecords = "AU_Saves.json"

function main {
    set-up
    $interacting = $true
    while ($interacting) {
        Write-Host ""
    }
    
}

function set-up {
    if ( -not (Test-Path $auHostConfigFile)) {
        Write-Error "set-up Among us configuration folder can't be found at $($auHostConfigFile)"
        exit
    }
    if( -not (Test-Path ($auSavePath + "\" + $auSaveFolder))){
        Write-Information "set-up save folder not found, creating $($auSavePath)\$($auSaveFolder)"
        New-Item -Path $auSavePath -name $auSaveFolder -ItemType "directory"
    }
    if( -not (Test-Path ($auSavePath + "\" + $auSaveRecords))){
        Write-Information "set-up records file not found, creating $($auSavePath)\$($auSaveRecords)"
        ConvertTo-Json @[] > test.json
    }
}

main

$EndTime = Get-Date -Format 'yyyy-mm-dd hh:mm:ss.fff'
Write-information "$EndTime Script finished"
#$TimeSpan = New-TimeSpan -Start $StartTime -End $EndTime
#Write-information "Script runtime was $($TimeSpan.Hours) hours, $($TimeSpan.Minutes) minutes, $($TimeSpan.Seconds) seconds."
Stop-Transcript