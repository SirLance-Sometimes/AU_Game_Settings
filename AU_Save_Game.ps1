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
    write-host "********** AU Game Settings Saver **********"
    write-host "********************************************"
    write-host "* When loading game setting this should be *"
    write-host "*    done before the launching the game.   *" 
    write-host "*  Saving can be done will the game is     *"
    write-host "*                 running.                 *"
    write-host "********************************************"
    while ($interacting) {
        write-host "***************** Main Menu ****************"
        $userChoice = Read-Host "Do you wish to [L]oad, [S]ave, or [E]xit"
        switch ($userChoice.ToLower()){
            l {} # write load menu function 
            s {} # write save function
            e { $interacting = $false }
            default { write-host "input $($userChoice) not valid. Please try again" }
        }
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

function get-savedRecords {
    return Get-Content "$($auSavePath)\$($auSaveRecords)" | ConvertFrom-Json
}
function start-loadMenue {
    $savedRecords = get-savedRecords
    if ($savedRecords.length -eq 0) {
        Write-Host "There are no save files.  Returning to main menu"
        return
    }
    $loadMenuLoop = $true
    while ($loadMenuLoop) {
        for ($i = 0; $i -lt $savedRecords.Count; $i++) {
            write-host "Press:$($i + 1) for $($savedRecords[$i].SaveName) Description: $($savedRecords[$i].Description)"
        }
        $userSelection = Read-Host "Select a Save # or [e]xit: "
        if($userSelection.ToLower() -eq "e"){
            break
        }
        elseif($userSelection -is [int] -and $userChoice -ge 1 -and $userChoice -le $savedRecords.count) {
            write-loadfile $savedRecords[$userSelection]
            return # another option would be to change the $loadMenuLoop to $false, but if this works I might be able to remove that vaiable
        }
        else {
            Write-host "Invalid selection Please try again."
        }
    }
    
}

function write-loadfile {


}

main

$EndTime = Get-Date -Format 'yyyy-mm-dd hh:mm:ss.fff'
Write-information "$EndTime Script finished"
#$TimeSpan = New-TimeSpan -Start $StartTime -End $EndTime
#Write-information "Script runtime was $($TimeSpan.Hours) hours, $($TimeSpan.Minutes) minutes, $($TimeSpan.Seconds) seconds."
Stop-Transcript