# Script để tìm, maximize và chụp màn hình LTN App
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Import Win32 API
Add-Type @"
using System;
using System.Runtime.InteropServices;
using System.Text;

public class WinAPI {
    // Window management
    [DllImport("user32.dll")]
    public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
    
    [DllImport("user32.dll")]
    public static extern bool SetForegroundWindow(IntPtr hWnd);
    
    [DllImport("user32.dll")]
    public static extern bool IsIconic(IntPtr hWnd);
    
    [DllImport("user32.dll")]
    public static extern bool IsWindowVisible(IntPtr hWnd);
    
    [DllImport("user32.dll")]
    public static extern bool GetWindowRect(IntPtr hWnd, out RECT lpRect);
    
    [DllImport("user32.dll")]
    public static extern bool PrintWindow(IntPtr hWnd, IntPtr hdcBlt, int nFlags);
    
    [DllImport("user32.dll")]
    public static extern IntPtr GetWindowDC(IntPtr hWnd);
    
    [DllImport("user32.dll")]
    public static extern int ReleaseDC(IntPtr hWnd, IntPtr hDC);
    
    [DllImport("user32.dll")]
    public static extern bool UpdateWindow(IntPtr hWnd);
    
    [DllImport("user32.dll")]
    public static extern uint GetWindowThreadProcessId(IntPtr hWnd, out uint lpdwProcessId);
    
    [DllImport("user32.dll")]
    public static extern bool EnumWindows(EnumWindowsProc lpEnumFunc, IntPtr lParam);
    
    [DllImport("user32.dll")]
    public static extern int GetWindowText(IntPtr hWnd, StringBuilder lpString, int nMaxCount);
    
    [DllImport("user32.dll")]
    public static extern int GetClassName(IntPtr hWnd, StringBuilder lpClassName, int nMaxCount);
    
    [DllImport("user32.dll")]
    public static extern IntPtr SendMessage(IntPtr hWnd, uint Msg, IntPtr wParam, IntPtr lParam);
    
    [DllImport("gdi32.dll")]
    public static extern IntPtr CreateCompatibleDC(IntPtr hdc);
    
    [DllImport("gdi32.dll")]
    public static extern IntPtr CreateCompatibleBitmap(IntPtr hdc, int nWidth, int nHeight);
    
    [DllImport("gdi32.dll")]
    public static extern IntPtr SelectObject(IntPtr hdc, IntPtr hgdiobj);
    
    [DllImport("gdi32.dll")]
    public static extern bool BitBlt(IntPtr hdcDest, int nXDest, int nYDest, int nWidth, int nHeight, 
                                      IntPtr hdcSrc, int nXSrc, int nYSrc, int dwRop);
    
    [DllImport("gdi32.dll")]
    public static extern bool DeleteDC(IntPtr hdc);
    
    [DllImport("gdi32.dll")]
    public static extern bool DeleteObject(IntPtr hObject);
    
    public delegate bool EnumWindowsProc(IntPtr hWnd, IntPtr lParam);
    
    // Window messages
    public const uint WM_SYSCOMMAND = 0x0112;
    public const uint SC_RESTORE = 0xF120;
    public const uint SC_MAXIMIZE = 0xF030;
    
    // ShowWindow commands
    public const int SW_HIDE = 0;
    public const int SW_SHOWNORMAL = 1;
    public const int SW_SHOWMINIMIZED = 2;
    public const int SW_SHOWMAXIMIZED = 3;
    public const int SW_MAXIMIZE = 3;
    public const int SW_SHOWNOACTIVATE = 4;
    public const int SW_SHOW = 5;
    public const int SW_MINIMIZE = 6;
    public const int SW_SHOWMINNOACTIVE = 7;
    public const int SW_SHOWNA = 8;
    public const int SW_RESTORE = 9;
    public const int SW_SHOWDEFAULT = 10;
    public const int SW_FORCEMINIMIZE = 11;
}

public struct RECT {
    public int Left;
    public int Top;
    public int Right;
    public int Bottom;
}
"@

function Find-AllProcessWindows {
    param([int]$ProcessId)
    
    $windows = @()
    
    $callback = {
        param($hwnd, $lParam)
        
        $processId = 0
        [WinAPI]::GetWindowThreadProcessId($hwnd, [ref]$processId) | Out-Null
        
        if ($processId -eq $script:targetPID) {
            $title = New-Object System.Text.StringBuilder 256
            [WinAPI]::GetWindowText($hwnd, $title, 256) | Out-Null
            
            $className = New-Object System.Text.StringBuilder 256
            [WinAPI]::GetClassName($hwnd, $className, 256) | Out-Null
            
            $isVisible = [WinAPI]::IsWindowVisible($hwnd)
            $isIconic = [WinAPI]::IsIconic($hwnd)
            
            $rect = New-Object RECT
            [WinAPI]::GetWindowRect($hwnd, [ref]$rect) | Out-Null
            
            $script:windows += [PSCustomObject]@{
                Handle = $hwnd
                Title = $title.ToString()
                ClassName = $className.ToString()
                IsVisible = $isVisible
                IsMinimized = $isIconic
                Left = $rect.Left
                Top = $rect.Top
                Width = $rect.Right - $rect.Left
                Height = $rect.Bottom - $rect.Top
            }
        }
        
        return $true
    }
    
    $script:targetPID = $ProcessId
    $script:windows = @()
    
    [WinAPI]::EnumWindows($callback, [IntPtr]::Zero) | Out-Null
    
    return $script:windows
}

function Capture-WindowImage {
    param(
        [IntPtr]$WindowHandle,
        [string]$OutputPath
    )
    
    try {
        # Lấy kích thước cửa sổ
        $rect = New-Object RECT
        [WinAPI]::GetWindowRect($WindowHandle, [ref]$rect) | Out-Null
        
        $width = $rect.Right - $rect.Left
        $height = $rect.Bottom - $rect.Top
        
        if ($width -le 0 -or $height -le 0) {
            Write-Host "  - Kich thuoc khong hop le: ${width}x${height}" -ForegroundColor Red
            return $false
        }
        
        Write-Host "  - Kich thuoc: ${width}x${height}" -ForegroundColor Cyan
        
        # Tạo bitmap
        $bitmap = New-Object System.Drawing.Bitmap($width, $height)
        $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
        $hdc = $graphics.GetHdc()
        
        # Chụp cửa sổ
        $result = [WinAPI]::PrintWindow($WindowHandle, $hdc, 0)
        
        $graphics.ReleaseHdc($hdc)
        $graphics.Dispose()
        
        if ($result) {
            # Lưu ảnh
            $bitmap.Save($OutputPath, [System.Drawing.Imaging.ImageFormat]::Png)
            $bitmap.Dispose()
            
            Write-Host "  - Da luu: $OutputPath" -ForegroundColor Green
            return $true
        } else {
            $bitmap.Dispose()
            Write-Host "  - PrintWindow that bai" -ForegroundColor Red
            return $false
        }
        
    } catch {
        Write-Host "  - Loi: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

function Capture-ScreenRegion {
    param(
        [int]$X,
        [int]$Y,
        [int]$Width,
        [int]$Height,
        [string]$OutputPath
    )
    
    try {
        $bitmap = New-Object System.Drawing.Bitmap($Width, $Height)
        $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
        $graphics.CopyFromScreen($X, $Y, 0, 0, $bitmap.Size)
        $graphics.Dispose()
        
        $bitmap.Save($OutputPath, [System.Drawing.Imaging.ImageFormat]::Png)
        $bitmap.Dispose()
        
        Write-Host "  ✓ Đã lưu screenshot vùng: $OutputPath" -ForegroundColor Green
        return $true
        
    } catch {
        Write-Host "  ✗ Lỗi chụp vùng: $($_.Exception.Message)" -ForegroundColor Red
        return $false
    }
}

# ====================================================================================
# MAIN SCRIPT
# ====================================================================================

Write-Host @"

╔════════════════════════════════════════════════════════════════════╗
║          CÔNG CỤ CHỤP MÀN HÌNH LTN AI MANAGER                      ║
╚════════════════════════════════════════════════════════════════════╝

"@ -ForegroundColor Cyan

# Tìm process
$process = Get-Process | Where-Object { $_.ProcessName -eq "ltnapp" } | Select-Object -First 1

if ($null -eq $process) {
    Write-Host "✗ Không tìm thấy process ltnapp đang chạy!" -ForegroundColor Red
    Write-Host "`nKhởi động ứng dụng trước khi chạy script này." -ForegroundColor Yellow
    exit
}

Write-Host "✓ Đã tìm thấy process ltnapp" -ForegroundColor Green
Write-Host "  - Process ID: $($process.Id)" -ForegroundColor Gray
Write-Host "  - Main Window: $($process.MainWindowTitle)" -ForegroundColor Gray
Write-Host ""

# Tìm tất cả cửa sổ
Write-Host "Đang quét tất cả cửa sổ..." -ForegroundColor Yellow
$windows = Find-AllProcessWindows -ProcessId $process.Id

if ($windows.Count -eq 0) {
    Write-Host "✗ Không tìm thấy cửa sổ nào!" -ForegroundColor Red
    exit
}

Write-Host "✓ Tìm thấy $($windows.Count) cửa sổ`n" -ForegroundColor Green

# Hiển thị danh sách cửa sổ
Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
foreach ($win in $windows) {
    Write-Host "Cửa sổ: " -NoNewline -ForegroundColor Yellow
    Write-Host "$($win.Title)" -ForegroundColor White
    Write-Host "  - Handle: $($win.Handle)" -ForegroundColor Gray
    Write-Host "  - Class: $($win.ClassName)" -ForegroundColor Gray
    Write-Host "  - Visible: $($win.IsVisible) | Minimized: $($win.IsMinimized)" -ForegroundColor Gray
    Write-Host "  - Size: $($win.Width)x$($win.Height)" -ForegroundColor Gray
    Write-Host "  - Position: ($($win.Left), $($win.Top))" -ForegroundColor Gray
    Write-Host ""
}
Write-Host "═══════════════════════════════════════════════════════════════`n" -ForegroundColor Cyan

# Tìm cửa sổ chính (cửa sổ lớn nhất và visible)
$mainWindow = $windows | 
    Where-Object { $_.IsVisible -eq $true } |
    Sort-Object -Property @{Expression={$_.Width * $_.Height}; Descending=$true} |
    Select-Object -First 1

if ($null -eq $mainWindow) {
    Write-Host "⚠ Không tìm thấy cửa sổ visible, thử tìm cửa sổ lớn nhất..." -ForegroundColor Yellow
    $mainWindow = $windows | 
        Sort-Object -Property @{Expression={$_.Width * $_.Height}; Descending=$true} |
        Select-Object -First 1
}

if ($null -eq $mainWindow) {
    Write-Host "✗ Không tìm thấy cửa sổ phù hợp!" -ForegroundColor Red
    exit
}

Write-Host "Cửa sổ chính đã chọn: $($mainWindow.Title)" -ForegroundColor Green
Write-Host "  - Kích thước: $($mainWindow.Width)x$($mainWindow.Height)`n" -ForegroundColor Cyan

# Thử restore/maximize cửa sổ
Write-Host "Đang restore/maximize cửa sổ..." -ForegroundColor Yellow

if ($mainWindow.IsMinimized) {
    Write-Host "  - Cửa sổ đang minimized, restore..." -ForegroundColor Gray
    [WinAPI]::SendMessage($mainWindow.Handle, [WinAPI]::WM_SYSCOMMAND, [IntPtr][WinAPI]::SC_RESTORE, [IntPtr]::Zero) | Out-Null
    Start-Sleep -Milliseconds 500
}

[WinAPI]::ShowWindow($mainWindow.Handle, [WinAPI]::SW_RESTORE) | Out-Null
Start-Sleep -Milliseconds 300

[WinAPI]::SetForegroundWindow($mainWindow.Handle) | Out-Null
Start-Sleep -Milliseconds 500

[WinAPI]::UpdateWindow($mainWindow.Handle) | Out-Null
Start-Sleep -Milliseconds 200

Write-Host "✓ Đã activate cửa sổ`n" -ForegroundColor Green

# Lấy lại kích thước sau khi restore
$rect = New-Object RECT
[WinAPI]::GetWindowRect($mainWindow.Handle, [ref]$rect) | Out-Null

$newWidth = $rect.Right - $rect.Left
$newHeight = $rect.Bottom - $rect.Top

Write-Host "Kích thước sau khi restore: ${newWidth}x${newHeight}`n" -ForegroundColor Cyan

# Chụp màn hình
Write-Host "Đang chụp màn hình..." -ForegroundColor Yellow

$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"

# Phương pháp 1: PrintWindow
$output1 = "ltn_window_${timestamp}.png"
Write-Host "`n[1] PrintWindow API:" -ForegroundColor Magenta
$success1 = Capture-WindowImage -WindowHandle $mainWindow.Handle -OutputPath $output1

# Phương pháp 2: Screen capture (nếu cửa sổ đủ lớn)
if ($newWidth -gt 50 -and $newHeight -gt 50) {
    $output2 = "ltn_screen_${timestamp}.png"
    Write-Host "`n[2] Screen Capture:" -ForegroundColor Magenta
    $success2 = Capture-ScreenRegion -X $rect.Left -Y $rect.Top -Width $newWidth -Height $newHeight -OutputPath $output2
} else {
    Write-Host "`n[2] Screen Capture: Bỏ qua (cửa sổ quá nhỏ)" -ForegroundColor Yellow
    $success2 = $false
}

# Phương pháp 3: Toàn màn hình
$output3 = "ltn_fullscreen_${timestamp}.png"
Write-Host "`n[3] Full Screen Capture:" -ForegroundColor Magenta
$screen = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds
$bitmap = New-Object System.Drawing.Bitmap($screen.Width, $screen.Height)
$graphics = [System.Drawing.Graphics]::FromImage($bitmap)
$graphics.CopyFromScreen($screen.Location, [System.Drawing.Point]::Empty, $screen.Size)
$graphics.Dispose()
$bitmap.Save($output3, [System.Drawing.Imaging.ImageFormat]::Png)
$bitmap.Dispose()
Write-Host "  ✓ Đã lưu: $output3" -ForegroundColor Green

Write-Host "`n" + ("═" * 70) -ForegroundColor Cyan
Write-Host "✓ HOÀN THÀNH!" -ForegroundColor Green
Write-Host ("═" * 70) -ForegroundColor Cyan

Write-Host "`nKết quả:" -ForegroundColor Yellow
if ($success1) { Write-Host "  ✓ PrintWindow: $output1" -ForegroundColor Green }
if ($success2) { Write-Host "  ✓ Screen Region: $output2" -ForegroundColor Green }
Write-Host "  ✓ Full Screen: $output3" -ForegroundColor Green

Write-Host "`nMở file để xem..." -ForegroundColor Cyan

# Mở file ảnh tốt nhất
if ($success1 -and (Test-Path $output1)) {
    & $output1
} elseif ($success2 -and (Test-Path $output2)) {
    & $output2
} else {
    & $output3
}

