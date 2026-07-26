$folder='img\galeria'
$files = Get-ChildItem -Path $folder -Filter *.jpg | Sort-Object Name
# rename to tmp to avoid collisions
$i=1
foreach($f in $files){ $tmp = Join-Path $folder ("tmp-{0:D4}.jpg" -f $i); Rename-Item -Path $f.FullName -NewName (Split-Path $tmp -Leaf); $i++ }
# rename tmp to gallery-1..N
$tmps = Get-ChildItem -Path $folder -Filter tmp-*.jpg | Sort-Object Name
$j=1
foreach($t in $tmps){ $new = Join-Path $folder ("gallery-{0}.jpg" -f $j); Rename-Item -Path $t.FullName -NewName (Split-Path $new -Leaf); $j++ }
Write-Host 'renamed' (Get-ChildItem -Path $folder -Filter gallery-*.jpg | Sort-Object Name | ForEach-Object { $_.Name })
