$rev = "0.18.9"
$revSuffix="_v$rev"

$devMissionName = 'dmmission1'
$missionName = 'hareinthesnare'
$missionDir = "C:\games\darkmod_latest\fms\$devMissionName"
$stagingDir = 'C:\Temp\dm_staging'
$stagingMissionDir = "$stagingDir\$devMissionName"
$darkmodtxt = "$stagingMissionDir\darkmod.txt"

$pkg = "$stagingMissionDir\$missionName$revSuffix"
$i18npkg = "$stagingMissionDir\$missionName$revSuffix" + "_i18n"

$dmap = Read-Host -Prompt 'Did you delete and recompile the map files?'
if ( $dmap -notin "Y","y") {
    exit 1
}

$playerStart = Read-Host -Prompt 'Did you reset the player start position?'
if ( $playerStart -notin "Y","y") {
    exit 1
}

$masterKey = Read-Host -Prompt 'Did you disable the master key?'
if ( $masterKey -notin "Y","y") {
    exit 1
}

# clean staging directory and copy latest code
remove-item -path $stagingDir\* -Filter * -Force -Recurse
copy-item -path $missionDir -destination $stagingDir -recurse

# remove unwanted files
remove-item -path $stagingMissionDir -include .git,savegames,.gitignore,build.ps1,changelog.txt,consolehistory.dat,man2.darkradiant,man2.bak,man2.darkradiant.bak,man2.xd.bkup,HITS_Readables.txt -Force -Recurse

# token replace version
(Get-Content $darkmodtxt).replace('[VERSION]', $rev) | Set-Content $darkmodtxt 

# compress and rename main pk4
$compress = @{
    Path = "$stagingMissionDir\*"
    CompressionLevel = "Optimal"
    DestinationPath = "$pkg.zip"
}
Compress-Archive @compress
rename-item -path "$pkg.zip" -newname "$pkg.pk4"

# compress and rename i18n pl4
$compressi18n = @{
    Path =  "$stagingMissionDir\strings"
    CompressionLevel = "Optimal"
    DestinationPath = "$i18npkg.zip"
}
Compress-Archive @compressi18n
rename-item -path "$i18npkg.zip" -newname "$i18npkg.pk4"
