param(
    [Parameter(Mandatory = $true)][string]$Pptx,
    [Parameter(Mandatory = $true)][string]$Pdf
)

# Export a .pptx to PDF through PowerPoint COM. Transitions are not preserved.
# Usage: powershell -ExecutionPolicy Bypass -File export_pdf.ps1 -Pptx deck.pptx -Pdf deck.pdf

$ErrorActionPreference = "Stop"
$pptxPath = (Resolve-Path $Pptx).Path
$pdfPath = [System.IO.Path]::GetFullPath($Pdf)
if (Test-Path $pdfPath) { Remove-Item $pdfPath -Force }

$app = New-Object -ComObject PowerPoint.Application
$app.Visible = -1
$app.DisplayAlerts = 1
try {
    $pres = $app.Presentations.Open($pptxPath, $false, $false, $false)
    try {
        $pres.SaveAs($pdfPath, 32)   # ppSaveAsPDF
    }
    finally {
        $pres.Close()
    }
}
finally {
    $app.Quit()
    [System.Runtime.InteropServices.Marshal]::ReleaseComObject($app) | Out-Null
}

Write-Output ("pdf {0}" -f $pdfPath)
