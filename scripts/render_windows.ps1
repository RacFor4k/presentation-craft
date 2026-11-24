param(
    [Parameter(Mandatory = $true)][string]$Pptx,
    [string]$OutDir = "slides",
    [int]$Width = 1600,
    [int]$Height = 900
)

# Render a .pptx to PNG through PowerPoint COM (Windows, PowerPoint 2019/365).
# OutDir is a dedicated render folder: existing PNGs there are removed.
# Usage: powershell -ExecutionPolicy Bypass -File render_windows.ps1 -Pptx deck.pptx -OutDir slides

$ErrorActionPreference = "Stop"

$pptxPath = (Resolve-Path $Pptx).Path
if (-not (Test-Path $OutDir)) { New-Item -ItemType Directory -Path $OutDir | Out-Null }
$outPath = (Resolve-Path $OutDir).Path

Get-ChildItem $outPath -File -Filter *.PNG -ErrorAction SilentlyContinue | Remove-Item -Force

$app = New-Object -ComObject PowerPoint.Application
$app.Visible = -1
$app.DisplayAlerts = 1
try { $app.WindowState = 2 } catch {}
try {
    $pres = $app.Presentations.Open($pptxPath, $true, $false, $false)
    try {
        $pres.Export($outPath, "PNG", $Width, $Height)
    }
    finally {
        $pres.Close()
    }
}
finally {
    $app.Quit()
    [System.Runtime.InteropServices.Marshal]::ReleaseComObject($app) | Out-Null
}

# PowerPoint names files by slide in the UI language ("Slide1.PNG", "Слайд1.PNG").
# Sort by the numeric part, never by name, then rename to s-01.png, s-02.png, ...
$files = Get-ChildItem $outPath -File -Filter *.PNG |
    Sort-Object { [int]([regex]::Match($_.BaseName, '\d+').Value) }

$i = 0
foreach ($f in $files) {
    $i++
    $target = Join-Path $outPath ("s-{0:d2}.png" -f $i)
    Move-Item $f.FullName $target -Force
}

Write-Output ("rendered {0} slides into {1}" -f $i, $outPath)
