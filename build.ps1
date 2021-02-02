param (
    [string]$version = '0.0'
)

$rev="_v$version"
$pkg="C:\Temp\dm_staging\dmmission1\hareinthesnare$rev"

# clean staging directory and copy latest code
remove-item -path C:\Temp\dm_staging\* -Filter * -Force -Recurse
copy-item -path C:\games\darkmod_latest\fms\dmmission1 -destination C:\Temp\dm_staging -recurse

# remove unwanted files
remove-item -path C:\Temp\dm_staging\dmmission1 -include .git,models,savegames,.gitignore,build.ps1,consolehistory.dat,man2.darkradiant,man2.darkradiant.bak,man2.xd.bkup -Force -Recurse

# compress and rename
$compress = @{
    Path = "C:\Temp\dm_staging\dmmission1\*"
    CompressionLevel = "Optimal"
    DestinationPath = "$pkg.zip"
}
Compress-Archive @compress

rename-item -path "$pkg.zip" -newname "$pkg.pk4"