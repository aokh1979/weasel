# Penang Hokkien Keyboard: replace Weasel's bundled schemes with ours.
# Run by build.bat after the plum data step.
$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$data = Join-Path $root 'output\data'
$src = Join-Path $PSScriptRoot 'rime'
$drop = '*.schema.yaml', '*.dict.yaml', '*.txt', '*.gram'
Get-ChildItem $data -File | Where-Object {
  $n = $_.Name; ($drop | Where-Object { $n -like $_ }).Count -gt 0
} | Remove-Item
Get-ChildItem $src -File | Where-Object { $_.Name -ne 'default.yaml' } |
  Copy-Item -Destination $data
$def = Join-Path $data 'default.yaml'
$text = [IO.File]::ReadAllText($def)
$new = "schema_list:`n  - schema: penang_hokkien`n"
$text = [regex]::Replace($text, '(?ms)^schema_list:.*?(?=^\S)', $new)
if ($text -notmatch 'schema: penang_hokkien') { throw 'schema_list not set' }
[IO.File]::WriteAllText($def, $text, (New-Object Text.UTF8Encoding $false))
Write-Host 'Penang Hokkien data applied.'
