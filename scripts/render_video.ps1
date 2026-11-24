param(
    [Parameter(Mandatory = $true)][string]$Pptx,
    [Parameter(Mandatory = $true)][string]$Out,
    [int]$SlideSeconds = 3,
    [int]$Height = 1080,
    [int]$Fps = 30,
    [int]$Quality = 85
)

# Export a .pptx to MP4 through PowerPoint COM. Includes transitions and timings.
# Can take as long as the video; run in the background for long decks.
# Usage: powershell -ExecutionPolicy Bypass -File render_video.ps1 -Pptx deck.pptx -Out preview.mp4

$ErrorActionPreference = "Stop"
$pptxPath = (Resolve-Path $Pptx).Path
$outPath = [System.IO.Path]::GetFullPath($Out)
if (Test-Path $outPath) { Remove-Item $outPath -Force }

$app = New-Object -ComObject PowerPoint.Application
$app.Visible = -1
$app.DisplayAlerts = 1
try {
    $pres = $app.Presentations.Open($pptxPath, $false, $false, $false)
    try {
        $pres.CreateVideo($outPath, $true, $SlideSeconds, $Height, $Fps, $Quality)
        $deadline = (Get-Date).AddMinutes(10)
        while ($pres.CreateVideoStatus -ne 3 -and (Get-Date) -lt $deadline) {
            Start-Sleep -Milliseconds 700
        }
        if ($pres.CreateVideoStatus -ne 3) {
            throw "Video export timed out (CreateVideoStatus=$($pres.CreateVideoStatus))"
        }
    }
    finally {
        $pres.Close()
    }
}
finally {
    $app.Quit()
    [System.Runtime.InteropServices.Marshal]::ReleaseComObject($app) | Out-Null
}

Write-Output ("video {0}" -f $outPath)
