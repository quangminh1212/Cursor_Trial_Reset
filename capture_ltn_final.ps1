# Script cuoi cung - Chup man hinh LTN AI Manager
# Su dung sau khi da mo cua so LTN

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  CHUP MAN HINH LTN AI MANAGER" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

Write-Host "HUONG DAN:" -ForegroundColor Yellow
Write-Host "1. Mo ung dung LTN AI Manager (double-click ltnapp.exe)" -ForegroundColor White
Write-Host "2. Doi 3 giay roi script se tu dong chup man hinh`n" -ForegroundColor White

Write-Host "Dang cho..." -ForegroundColor Cyan
Start-Sleep -Seconds 3

# Chup toan man hinh
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$outputFile = "LTN_Screenshot_$timestamp.png"

Write-Host "Dang chup man hinh...`n" -ForegroundColor Yellow

$screen = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds
$bitmap = New-Object System.Drawing.Bitmap($screen.Width, $screen.Height)
$graphics = [System.Drawing.Graphics]::FromImage($bitmap)
$graphics.CopyFromScreen($screen.Location, [System.Drawing.Point]::Empty, $screen.Size)
$graphics.Dispose()
$bitmap.Save($outputFile, [System.Drawing.Imaging.ImageFormat]::Png)
$bitmap.Dispose()

Write-Host "========================================" -ForegroundColor Green
Write-Host "  THANH CONG!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host "`nDa luu: $outputFile" -ForegroundColor Cyan
Write-Host "`nCac nut trong giao dien LTN AI Manager:" -ForegroundColor Yellow
Write-Host "  - Nut 'Chuyen tai khoan Cursor' (nut chinh)" -ForegroundColor White
Write-Host "  - Icon Refresh (goc phai tren)" -ForegroundColor White
Write-Host "  - Icon Open External (goc phai tren)" -ForegroundColor White
Write-Host "`n========================================`n" -ForegroundColor Green

# Mo anh
Invoke-Item $outputFile

