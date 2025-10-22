# Script để lấy vị trí chuột và màu pixel
# Hướng dẫn: Di chuột đến nút bạn muốn, sau đó nhấn SPACE để ghi lại

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

Write-Host @"

=================================================================
   CÔNG CỤ LẤY VỊ TRÍ CHUỘT VÀ MÀU PIXEL
=================================================================

Hướng dẫn:
1. Di chuột đến vị trí nút bạn muốn tìm
2. Xem tọa độ X, Y và màu pixel hiển thị
3. Nhấn SPACE để ghi lại vị trí
4. Nhấn Ctrl+C để kết thúc

-----------------------------------------------------------------

"@ -ForegroundColor Cyan

$positions = @()
$index = 1

# Import thư viện để check key press
Add-Type @"
using System;
using System.Runtime.InteropServices;

public class KeyboardCheck {
    [DllImport("user32.dll")]
    public static extern short GetAsyncKeyState(int vKey);
}
"@

$SPACE_KEY = 0x20

try {
    while ($true) {
        # Lấy vị trí chuột
        $pos = [System.Windows.Forms.Cursor]::Position
        
        # Lấy màu pixel tại vị trí chuột
        $bitmap = New-Object System.Drawing.Bitmap 1, 1
        $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
        $graphics.CopyFromScreen($pos.X, $pos.Y, 0, 0, $bitmap.Size)
        $pixel = $bitmap.GetPixel(0, 0)
        $graphics.Dispose()
        $bitmap.Dispose()
        
        # Hiển thị thông tin
        Write-Host "`rX: $($pos.X.ToString().PadLeft(4)) | Y: $($pos.Y.ToString().PadLeft(4)) | RGB: ($($pixel.R.ToString().PadLeft(3)), $($pixel.G.ToString().PadLeft(3)), $($pixel.B.ToString().PadLeft(3))) | Hex: #$($pixel.R.ToString('X2'))$($pixel.G.ToString('X2'))$($pixel.B.ToString('X2'))   " -NoNewline -ForegroundColor Yellow
        
        # Check nếu nhấn SPACE
        if ([KeyboardCheck]::GetAsyncKeyState($SPACE_KEY) -ne 0) {
            $positions += [PSCustomObject]@{
                Index = $index
                X = $pos.X
                Y = $pos.Y
                ColorRGB = "($($pixel.R), $($pixel.G), $($pixel.B))"
                ColorHex = "#$($pixel.R.ToString('X2'))$($pixel.G.ToString('X2'))$($pixel.B.ToString('X2'))"
            }
            
            Write-Host "`n[$index] Đã lưu: X=$($pos.X), Y=$($pos.Y)" -ForegroundColor Green
            $index++
            
            # Chờ nhả phím SPACE
            Start-Sleep -Milliseconds 300
        }
        
        Start-Sleep -Milliseconds 50
    }
} catch {
    # Khi nhấn Ctrl+C
}

Write-Host "`n`n=================================================================`n" -ForegroundColor Cyan

if ($positions.Count -gt 0) {
    Write-Host "CÁC VỊ TRÍ ĐÃ GHI LẠI:" -ForegroundColor Green
    Write-Host "-----------------------------------------------------------------" -ForegroundColor Cyan
    
    $positions | Format-Table -AutoSize
    
    # Lưu vào file
    $outputFile = "mouse_positions.txt"
    $positions | Out-File -FilePath $outputFile -Encoding UTF8
    
    Write-Host "`nĐã lưu vào file: $outputFile" -ForegroundColor Green
    
    # Tạo script click tự động
    $clickScript = @"
# Script click tự động các vị trí đã lưu
Add-Type -AssemblyName System.Windows.Forms

"@
    
    foreach ($p in $positions) {
        $clickScript += @"

# Click vị trí [$($p.Index)]: ($($p.X), $($p.Y))
[System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($($p.X), $($p.Y))
Start-Sleep -Milliseconds 100
# Uncomment dòng dưới để thực hiện click:
# Add-Type -AssemblyName System.Runtime.InteropServices
# [System.Runtime.InteropServices.Marshal]::PreleasedComObject([System.Windows.Forms.Application]::DoEvents())

"@
    }
    
    $clickScriptFile = "auto_click.ps1"
    $clickScript | Out-File -FilePath $clickScriptFile -Encoding UTF8
    
    Write-Host "Đã tạo script click tự động: $clickScriptFile" -ForegroundColor Green
    
} else {
    Write-Host "Không có vị trí nào được ghi lại." -ForegroundColor Yellow
}

Write-Host "`n=================================================================" -ForegroundColor Cyan


