[cmdletbinding()]
param()

$TranscriptLogFile = 'AU_Save_Game.log'
$StartTime = Get-Date -Format 'yyyy-mm-dd hh:mm:ss.fff'
Start-Transcript -Path $TranscriptLogFile -Append -NoClobber
Write-information "Script started at: $StartTime"

$auHostConfigFolder = ($env:userprofile + "\appdata\locallow\innersloth\Among Us")
$auHostConfigFile = "gameHostOptions"
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
            l { start-loadMenu } # write load menu function 
            s { write-saveFile } # write save function
            e { $interacting = $false }
            default { write-host "input $($userChoice) not valid. Please try again" }
        }
    }
    
}

function set-up {
    write-debug "In set up"
    if ( -not (Test-Path $auHostConfigFolder)) {
        Write-Error "set-up Among us configuration folder can't be found at $($auHostConfigFolder)"
        exit
    }
    if( -not (Test-Path ($auSavePath + "\" + $auSaveFolder))){
        Write-Information "set-up save folder not found, creating $($auSavePath)\$($auSaveFolder)"
        New-Item -Path $auSavePath -name $auSaveFolder -ItemType "directory"
    }
    if( -not (Test-Path ($auSavePath + "\" + $auSaveFolder + "\" + $auSaveRecords))){
        Write-Information "set-up records file not found, creating $($auSavePath)\$($auSaveFolder)\$($auSaveRecords)"
        ConvertTo-Json @() > "$($auSavePath)\$($auSaveFolder)\$($auSaveRecords)"
    }
}

function get-savedRecords {
    return Get-Content "$($auSavePath)\$($auSaveFolder)\$($auSaveRecords)" | ConvertFrom-Json
}
function start-loadMenu {
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
            write-loadfile $savedRecords[($userSelection - 1)]
            return # another option would be to change the $loadMenuLoop to $false, but if this works I might be able to remove that vaiable
        }
        else {
            Write-host "Invalid selection Please try again."
        }
    }
    
}

function write-loadfile {
    param(
        [PSCustomObject]$saveRecord
    )
    Move-Item $saveRecord.filename "$($auHostConfigFolder)\$($auHostConfigFile)"
}

function write-saveFile{
    $saveName = ""
    $saveDescription = ""

    while($true){
        $saveName = Read-Host "Save Name: "
        $saveDescription = Read-Host "optional description: "
        
        if ( -not ($saveName -eq "")){
            break
        }
    }

    $savedRecords = get-savedRecords

    Copy-Item "$($auHostConfigFolder)\$($auHostConfigFile)" "$($auSavePath)\$($auSaveFolder)\$($saveName)"

    $newRecord = New-Object -TypeName PSCustomObject
    $newRecord | Add-Member -MemberType NoteProperty -Name SaveName -Value $saveName
    $newRecord | Add-Member -MemberType NoteProperty -Name Description -Value $saveDescription
    $newRecord | Add-Member -MemberType NoteProperty -Name filename -Value $saveName
    
    $savedRecords += $newRecord
    # todo when powershell only has one object in the array it outputs the json object as a single object like:
    # {
    #     "SaveName":  "test",
    #     "Description":  "this is a test",
    #     "filename":  "test"
    # }
    # When it should look like 
    # [
    #     {
    #         "SaveName":  "test",
    #         "Description":  "this is a test",
    #         "filename":  "test"
    #     }
    # ]
    # The problem here is that if there are no items in the array [] powershell saves the file incorrectly as an object instead of an object of arrays.
    # The next save will have a pscustomobject as the type for $saveRecords when it should be type Object[], therefore the $savedRecords += $newRecord line
    # throws an exception.

    Convertto-Json $savedRecords > "$($auSavePath)\$($auSaveFolder)\$($auSaveRecords)"
}

main

$EndTime = Get-Date -Format 'yyyy-mm-dd hh:mm:ss.fff'
Write-information "$EndTime Script finished"
#$TimeSpan = New-TimeSpan -Start $StartTime -End $EndTime
#Write-information "Script runtime was $($TimeSpan.Hours) hours, $($TimeSpan.Minutes) minutes, $($TimeSpan.Seconds) seconds."
Stop-Transcript