# Script don gian de chup man hinh LTN App
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

Add-Type @"
using System;
using System.Runtime.InteropServices;
using System.Text;

public class Win32 {
    [DllImport("user32.dll")]
    public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
    
    [DllImport("user32.dll")]
    public static extern bool SetForegroundWindow(IntPtr hWnd);
    
    [DllImport("user32.dll")]
    public static extern bool GetWindowRect(IntPtr hWnd, out RECT lpRect);
    
    [DllImport("user32.dll")]
    public static extern bool PrintWindow(IntPtr hWnd, IntPtr hdcBlt, int nFlags);
    
    [DllImport("user32.dll")]
    public static extern uint GetWindowThreadProcessId(IntPtr hWnd, out uint processId);
    
    [DllImport("user32.dll")]
    public static extern bool EnumWindows(EnumWindowsProc lpEnumFunc, IntPtr lParam);
    
    [DllImport("user32.dll")]
    public static extern int GetWindowText(IntPtr hWnd, StringBuilder lpString, int nMaxCount);
    
    [DllImport("user32.dll")]
    public static extern bool IsWindowVisible(IntPtr hWnd);
    
    public delegate bool EnumWindowsProc(IntPtr hWnd, IntPtr lParam);
}

public struct RECT {
    public int Left;
    public int Top;
    public int Right;
    public int Bottom;
}
"@

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  CHUP MAN HINH LTN AI MANAGER" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

# Tim process
$process = Get-Process -Name "ltnapp" -ErrorAction SilentlyContinue

if (-not $process) {
    Write-Host "KHONG tim thay process ltnapp!" -ForegroundColor Red
    Write-Host "Vui long mo ung dung truoc`n" -ForegroundColor Yellow
    exit
}

Write-Host "Da tim thay process: $($process.ProcessName)" -ForegroundColor Green
Write-Host "Process ID: $($process.Id)" -ForegroundColor Gray
Write-Host "Main Window: $($process.MainWindowTitle)`n" -ForegroundColor Gray

# Tim tat ca cua so
$allWindows = @()
$targetPID = $process.Id

$callback = {
    param($hwnd, $lParam)
    
    $procId = 0
    [Win32]::GetWindowThreadProcessId($hwnd, [ref]$procId) | Out-Null
    
    if ($procId -eq $script:targetPID) {
        $title = New-Object System.Text.StringBuilder 256
        [Win32]::GetWindowText($hwnd, $title, 256) | Out-Null
        
        $isVisible = [Win32]::IsWindowVisible($hwnd)
        
        $rect = New-Object RECT
        [Win32]::GetWindowRect($hwnd, [ref]$rect) | Out-Null
        
        $width = $rect.Right - $rect.Left
        $height = $rect.Bottom - $rect.Top
        
        $script:allWindows += [PSCustomObject]@{
            Handle = $hwnd
            Title = $title.ToString()
            IsVisible = $isVisible
            Width = $width
            Height = $height
            Left = $rect.Left
            Top = $rect.Top
        }
    }
    
    return $true
}

$script:targetPID = $targetPID
$script:allWindows = @()

[Win32]::EnumWindows($callback, [IntPtr]::Zero) | Out-Null
$allWindows = $script:allWindows

Write-Host "Tim thay $($allWindows.Count) cua so`n" -ForegroundColor Yellow

foreach ($w in $allWindows) {
    Write-Host "- Title: $($w.Title)" -ForegroundColor White
    Write-Host "  Size: $($w.Width)x$($w.Height) | Visible: $($w.IsVisible)" -ForegroundColor Gray
}

Write-Host ""

# Chon cua so lon nhat
$mainWin = $allWindows | Sort-Object {$_.Width * $_.Height} -Descending | Select-Object -First 1

if (-not $mainWin) {
    Write-Host "KHONG tim thay cua so phu hop!`n" -ForegroundColor Red
    exit
}

Write-Host "Cua so chinh: $($mainWin.Title)" -ForegroundColor Green
Write-Host "Kich thuoc: $($mainWin.Width)x$($mainWin.Height)`n" -ForegroundColor Cyan

# Restore va activate cua so
Write-Host "Dang restore cua so..." -ForegroundColor Yellow
[Win32]::ShowWindow($mainWin.Handle, 9) | Out-Null
Start-Sleep -Milliseconds 500

[Win32]::SetForegroundWindow($mainWin.Handle) | Out-Null
Start-Sleep -Milliseconds 500

# Lay lai kich thuoc sau khi restore
$rect = New-Object RECT
[Win32]::GetWindowRect($mainWin.Handle, [ref]$rect) | Out-Null

$newWidth = $rect.Right - $rect.Left
$newHeight = $rect.Bottom - $rect.Top

Write-Host "Kich thuoc moi: ${newWidth}x${newHeight}`n" -ForegroundColor Cyan

# Chup man hinh
$timestamp = Get-Date -Format "yyyyMMdd_HHmmss"

Write-Host "========================================" -ForegroundColor Magenta
Write-Host "  DANG CHUP MAN HINH..." -ForegroundColor Magenta
Write-Host "========================================`n" -ForegroundColor Magenta

# Phuong phap 1: PrintWindow
if ($newWidth -gt 0 -and $newHeight -gt 0) {
    $output1 = "ltn_window_$timestamp.png"
    Write-Host "[1] PrintWindow API" -ForegroundColor Yellow
    
    try {
        $bitmap = New-Object System.Drawing.Bitmap($newWidth, $newHeight)
        $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
        $hdc = $graphics.GetHdc()
        
        $result = [Win32]::PrintWindow($mainWin.Handle, $hdc, 0)
        
        $graphics.ReleaseHdc($hdc)
        $graphics.Dispose()
        
        if ($result) {
            $bitmap.Save($output1, [System.Drawing.Imaging.ImageFormat]::Png)
            Write-Host "    + Da luu: $output1" -ForegroundColor Green
            $saved1 = $true
        } else {
            Write-Host "    - PrintWindow that bai" -ForegroundColor Red
            $saved1 = $false
        }
        
        $bitmap.Dispose()
        
    } catch {
        Write-Host "    - Loi: $($_.Exception.Message)" -ForegroundColor Red
        $saved1 = $false
    }
} else {
    Write-Host "[1] PrintWindow: BO QUA (cua so qua nho)`n" -ForegroundColor Gray
    $saved1 = $false
}

# Phuong phap 2: Chup vung man hinh
if ($newWidth -gt 10 -and $newHeight -gt 10) {
    $output2 = "ltn_region_$timestamp.png"
    Write-Host "`n[2] Screen Region Capture" -ForegroundColor Yellow
    
    try {
        $bitmap = New-Object System.Drawing.Bitmap($newWidth, $newHeight)
        $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
        $graphics.CopyFromScreen($rect.Left, $rect.Top, 0, 0, $bitmap.Size)
        $graphics.Dispose()
        
        $bitmap.Save($output2, [System.Drawing.Imaging.ImageFormat]::Png)
        $bitmap.Dispose()
        
        Write-Host "    + Da luu: $output2" -ForegroundColor Green
        $saved2 = $true
        
    } catch {
        Write-Host "    - Loi: $($_.Exception.Message)" -ForegroundColor Red
        $saved2 = $false
    }
} else {
    Write-Host "`n[2] Screen Region: BO QUA (cua so qua nho)" -ForegroundColor Gray
    $saved2 = $false
}

# Phuong phap 3: Toan man hinh
$output3 = "ltn_fullscreen_$timestamp.png"
Write-Host "`n[3] Full Screen Capture" -ForegroundColor Yellow

try {
    $screen = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds
    $bitmap = New-Object System.Drawing.Bitmap($screen.Width, $screen.Height)
    $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
    $graphics.CopyFromScreen($screen.Location, [System.Drawing.Point]::Empty, $screen.Size)
    $graphics.Dispose()
    
    $bitmap.Save($output3, [System.Drawing.Imaging.ImageFormat]::Png)
    $bitmap.Dispose()
    
    Write-Host "    + Da luu: $output3" -ForegroundColor Green
    $saved3 = $true
    
} catch {
    Write-Host "    - Loi: $($_.Exception.Message)" -ForegroundColor Red
    $saved3 = $false
}

# Ket qua
Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  KET QUA" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

if ($saved1) { Write-Host "  + Window: $output1" -ForegroundColor Green }
if ($saved2) { Write-Host "  + Region: $output2" -ForegroundColor Green }
if ($saved3) { Write-Host "  + Full Screen: $output3" -ForegroundColor Green }

Write-Host "`n========================================`n" -ForegroundColor Cyan

# Mo file anh tot nhat
if ($saved1) {
    Invoke-Item $output1
} elseif ($saved2) {
    Invoke-Item $output2
} elseif ($saved3) {
    Invoke-Item $output3
}

