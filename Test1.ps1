try
{
    $folder = Get-Item -Path C:\Window -ErrorAction Stop
    $files = Get-ChildItem -Path $folder
    Write-Host "File count: $($files.Count)"
}
catch
{
    Write-Host "Folder not found or inaccessible."
}