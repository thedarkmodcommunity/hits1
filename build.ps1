$rev="_v0.15"

$devMissionName = 'dmmission1'
$missionName = 'hareinthesnare'
$missionDir = "C:\games\darkmod_latest\fms\$devMissionName"
$stagingDir = 'C:\Temp\dm_staging'
$stagingMissionDir = "$stagingDir\$devMissionName"

$pkg = "$stagingMissionDir\$missionName$rev"
$i18npkg = "$stagingMissionDir\$missionName$rev" + "_i18n"

# clean staging directory and copy latest code
remove-item -path $stagingDir\* -Filter * -Force -Recurse
copy-item -path $missionDir -destination $stagingDir -recurse

# remove unwanted files
remove-item -path $stagingMissionDir -include .git,models,savegames,.gitignore,build.ps1,changelog.txt,consolehistory.dat,man2.darkradiant,man2.bak,man2.darkradiant.bak,man2.xd.bkup -Force -Recurse

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