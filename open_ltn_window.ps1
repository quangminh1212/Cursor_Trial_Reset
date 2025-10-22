# Script de mo cua so LTN App tu system tray
Add-Type -AssemblyName System.Windows.Forms

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  MO CUA SO LTN AI MANAGER" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

Write-Host "HUONG DAN:" -ForegroundColor Yellow
Write-Host "  1. Tim icon LTN AI Manager trong system tray" -ForegroundColor White
Write-Host "     (goc duoi ben phai taskbar, canh dong ho)" -ForegroundColor Gray
Write-Host ""
Write-Host "  2. Cach mo cua so chinh:" -ForegroundColor White
Write-Host "     - Double-click vao icon" -ForegroundColor Gray
Write-Host "     - Hoac click phai -> chon 'Open' hoac 'Show'" -ForegroundColor Gray
Write-Host ""

# Chay lai ltnapp.exe de dam bao app dang chay
Write-Host "Dang khoi dong lai ltnapp.exe...`n" -ForegroundColor Yellow

try {
    # Tat process cu (neu co)
    $oldProcess = Get-Process -Name "ltnapp" -ErrorAction SilentlyContinue
    if ($oldProcess) {
        Write-Host "Dong process cu..." -ForegroundColor Gray
        $oldProcess | Stop-Process -Force
        Start-Sleep -Seconds 2
    }
    
    # Khoi dong moi
    Write-Host "Khoi dong ltnapp.exe..." -ForegroundColor Green
    $appPath = ".\ltnapp.exe"
    
    if (Test-Path $appPath) {
        Start-Process -FilePath $appPath
        Start-Sleep -Seconds 2
        
        Write-Host "Da khoi dong thanh cong!`n" -ForegroundColor Green
    } else {
        Write-Host "KHONG tim thay ltnapp.exe!`n" -ForegroundColor Red
        exit
    }
    
} catch {
    Write-Host "Loi: $($_.Exception.Message)`n" -ForegroundColor Red
}

Write-Host "========================================" -ForegroundColor Yellow
Write-Host "  CAC BUOC TIEP THEO:" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Yellow
Write-Host ""
Write-Host "1. Tim ICON trong SYSTEM TRAY:" -ForegroundColor White
Write-Host "   - Nhin goc duoi ben phai man hinh" -ForegroundColor Gray
Write-Host "   - Tim icon LTN AI Manager" -ForegroundColor Gray
Write-Host "   - Neu khong thay, click mui ten ^ de xem them" -ForegroundColor Gray
Write-Host ""
Write-Host "2. MO CUA SO CHINH:" -ForegroundColor White
Write-Host "   - DOUBLE-CLICK vao icon" -ForegroundColor Green
Write-Host "   - Hoac CLICK PHAI -> chon menu 'Open'" -ForegroundColor Green
Write-Host ""
Write-Host "3. SAU KHI MO CUA SO, CHUP MAN HINH:" -ForegroundColor White
Write-Host "   - Chay: .\capture_ltn_simple.ps1" -ForegroundColor Green
Write-Host ""
Write-Host "========================================`n" -ForegroundColor Yellow

# Cho 5 giay de nguoi dung mo cua so
Write-Host "Dang cho 10 giay de ban mo cua so..." -ForegroundColor Cyan
Write-Host "(Sau 10s se tu dong chup man hinh)`n" -ForegroundColor Gray

for ($i = 10; $i -gt 0; $i--) {
    Write-Host "`rCon $i giay...  " -NoNewline -ForegroundColor Yellow
    Start-Sleep -Seconds 1
}

Write-Host "`n`nDang chup man hinh...`n" -ForegroundColor Green

# Chup man hinh toan bo
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
$outputFile = "ltn_after_open_$timestamp.png"

$screen = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds
$bitmap = New-Object System.Drawing.Bitmap($screen.Width, $screen.Height)
$graphics = [System.Drawing.Graphics]::FromImage($bitmap)
$graphics.CopyFromScreen($screen.Location, [System.Drawing.Point]::Empty, $screen.Size)
$graphics.Dispose()
$bitmap.Save($outputFile, [System.Drawing.Imaging.ImageFormat]::Png)
$bitmap.Dispose()

Write-Host "Da luu: $outputFile`n" -ForegroundColor Green

# Mo anh
Invoke-Item $outputFile

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Kiem tra anh xem co thay cua so LTN khong?" -ForegroundColor Yellow
Write-Host "Neu KHONG thay cua so lon:" -ForegroundColor Red
Write-Host "  -> App chi chay o system tray" -ForegroundColor Gray
Write-Host "  -> Can click vao icon de mo cua so chinh" -ForegroundColor Gray
Write-Host "========================================`n" -ForegroundColor Cyan

