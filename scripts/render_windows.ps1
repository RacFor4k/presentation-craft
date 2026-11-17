param(
    [Parameter(Mandatory = $true)][string]$Pptx,
    [string]$OutDir = "slides",
    [int]$Width = 1600,
    [int]$Height = 900
)

# Render a .pptx to PNG slides through PowerPoint COM (Windows).
# Usage: powershell -ExecutionPolicy Bypass -File render_windows.ps1 -Pptx deck.pptx

$ErrorActionPreference = "Stop"

$pptxPath = (Resolve-Path $Pptx).Path
if (-not (Test-Path $OutDir)) { New-Item -ItemType Directory -Path $OutDir | Out-Null }
$outPath = (Resolve-Path $OutDir).Path

Get-ChildItem $outPath -Filter *.png -ErrorAction SilentlyContinue | Remove-Item -Force

$app = New-Object -ComObject PowerPoint.Application
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
}

# PowerPoint names files by slide in the UI language ("Slide1.PNG", "Слайд1.PNG").
# Sort by the numeric part and rename to s-01.png, s-02.png, ...
$files = Get-ChildItem $outPath -Filter *.png |
    Sort-Object { [int]([regex]::Match($_.BaseName, '\d+').Value) }

$i = 0
foreach ($f in $files) {
    $i++
    $target = Join-Path $outPath ("s-{0:d2}.png" -f $i)
    Move-Item $f.FullName $target -Force
}

Write-Output ("rendered {0} slides into {1}" -f $i, $outPath)
