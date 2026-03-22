
$content = Get-Content "analysis_clean.txt"
$errors = $content -match "error -"
foreach ($err in $errors) {
    Write-Host $err
}
