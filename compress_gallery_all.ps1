Add-Type -AssemblyName System.Drawing
$folder = 'img\galeria'
if (-not (Test-Path $folder)) { Write-Host "MISSING $folder"; exit 1 }
$files = Get-ChildItem -Path $folder -Filter *.jpg | Sort-Object Name
foreach ($f in $files) {
    $in = $f.FullName
    try {
        $img = [System.Drawing.Image]::FromFile($in)
        $bmp = New-Object System.Drawing.Bitmap $img.Width, $img.Height
        $g = [System.Drawing.Graphics]::FromImage($bmp)
        $g.DrawImage($img, 0, 0, $img.Width, $img.Height)
        $g.Dispose()
        $img.Dispose()
        $encoder = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq 'image/jpeg' }
        $encParams = New-Object System.Drawing.Imaging.EncoderParameters 1
        $qualityParam = New-Object System.Drawing.Imaging.EncoderParameter ([System.Drawing.Imaging.Encoder]::Quality), 60L
        $encParams.Param[0] = $qualityParam
        $bmp.Save($in, $encoder, $encParams)
        $bmp.Dispose()
        $fi = Get-Item $in
        Write-Host "saved $($fi.FullName) $($fi.Length)"
    } catch {
        Write-Host "error processing $in $_"
    }
}
