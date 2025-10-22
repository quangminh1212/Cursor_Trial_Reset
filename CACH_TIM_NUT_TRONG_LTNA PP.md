# Các Cách Tìm Nút Trong Cửa Sổ LTN App (Flutter)

## Tổng quan
LTN AI Manager là ứng dụng Flutter desktop. Ứng dụng Flutter không sử dụng native Windows controls nên công cụ UI Automation của Windows **KHÔNG** hoạt động được.

## Hiện trạng
- **Process Name**: ltnapp
- **Window Title**: LTN AI Manager  
- **Window Size**: 159x27 pixels (rất nhỏ - có thể là system tray app)
- **UI Automation**: Không tìm thấy controls

---

## Các Phương Pháp Tìm Nút

### ✅ Phương Pháp 1: Chụp Màn Hình & Phân Tích Thủ Công
**Mô tả**: Chụp toàn bộ màn hình hoặc cửa sổ ứng dụng, sau đó xem giao diện.

```powershell
# Chụp toàn màn hình
powershell -ExecutionPolicy Bypass -File .\maximize_and_capture.ps1
# Kết quả: fullscreen_screenshot.png
```

**Ưu điểm**:
- Đơn giản, dễ thực hiện
- Thấy được giao diện thực tế

**Nhược điểm**:
- Phải phân tích thủ công
- Không biết được thuộc tính/vị trí chính xác của nút

---

### ✅ Phương Pháp 2: Sử dụng OCR (Optical Character Recognition)
**Mô tả**: Dùng OCR để nhận dạng text trên màn hình, từ đó xác định vị trí các nút.

```powershell
# Cài đặt Tesseract OCR
choco install tesseract -y

# Hoặc tải về từ: https://github.com/UB-Mannheim/tesseract/wiki

# Sau khi chụp màn hình, dùng PowerShell + Tesseract để quét text
```

**Ưu điểm**:
- Có thể tự động hóa việc tìm text trên nút
- Phù hợp với automation testing

**Nhược điểm**:
- Cần cài đặt thêm tool
- Độ chính xác phụ thuộc vào font chữ

---

### ✅ Phương Pháp 3: Flutter DevTools (Nếu App Ở Debug Mode)
**Mô tả**: Nếu ứng dụng được build ở debug mode, có thể dùng Flutter DevTools để inspect UI.

```bash
# Kích hoạt Flutter DevTools
flutter pub global activate devtools

# Chạy DevTools
flutter pub global run devtools
```

**Cách kiểm tra**:
1. Mở DevTools trong browser
2. Kết nối với app (nếu app đang chạy ở debug mode)
3. Sử dụng Flutter Inspector để xem cấu trúc UI

**Ưu điểm**:
- Rất mạnh mẽ, xem được toàn bộ widget tree
- Có thể inspect properties của từng widget

**Nhược điểm**:
- Chỉ hoạt động với debug/profile build
- App hiện tại là release build (không có debug info)

---

### ✅ Phương Pháp 4: Image Recognition / Computer Vision
**Mô tả**: Sử dụng thư viện computer vision như OpenCV hoặc Sikuli để tìm nút dựa trên hình ảnh.

**Tools**:
- **Sikuli**: https://sikulix.github.io/
- **PyAutoGUI** (Python): Image recognition + automation

```python
# Cài đặt
pip install pyautogui pillow opencv-python

# Ví dụ tìm và click nút
import pyautogui

# Tìm nút dựa trên hình ảnh
button_location = pyautogui.locateOnScreen('button_image.png')
if button_location:
    pyautogui.click(button_location)
```

**Ưu điểm**:
- Hoạt động với mọi loại ứng dụng
- Có thể automation hoàn toàn

**Nhược điểm**:
- Cần ảnh mẫu của nút
- Phụ thuộc vào resolution và theme

---

### ✅ Phương Pháp 5: Decompile/Reverse Engineering (Nâng Cao)
**Mô tả**: Decompile file APK/binary để xem source code.

**Tools**:
- **ReFlutter**: Reverse engineering Flutter apps
- **Ghidra**: Reverse engineering tool

```bash
# Cài đặt ReFlutter
pip install reflutter

# Decompile
reflutter ltnapp.exe
```

**Ưu điểm**:
- Xem được toàn bộ code logic
- Hiểu rõ cấu trúc app

**Nhược điểm**:
- Phức tạp, cần kỹ năng reverse engineering
- Có thể vi phạm bản quyền

---

### ✅ Phương Pháp 6: Accessibility Features
**Mô tả**: Sử dụng tính năng accessibility của Windows (Narrator, Inspect.exe).

```powershell
# Chạy Windows Accessibility Insights
# Tải về: https://accessibilityinsights.io/

# Hoặc dùng Inspect.exe (Windows SDK)
"C:\Program Files (x86)\Windows Kits\10\bin\10.0.22621.0\x64\inspect.exe"
```

**Cách dùng**:
1. Chạy Inspect.exe
2. Di chuột qua các element trong app
3. Xem thông tin accessibility

**Lưu ý**: Flutter apps thường không expose accessibility info đầy đủ.

---

### ✅ Phương Pháp 7: Mouse Position & Pixel Color Detection
**Mô tả**: Ghi lại vị trí chuột và màu pixel để xác định vị trí nút.

```powershell
# Script PowerShell để lấy vị trí chuột và màu pixel
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

while ($true) {
    $pos = [System.Windows.Forms.Cursor]::Position
    Write-Host "Mouse: X=$($pos.X), Y=$($pos.Y)"
    Start-Sleep -Milliseconds 500
}
```

**Ưu điểm**:
- Đơn giản
- Không cần tool phức tạp

**Nhược điểm**:
- Thủ công, phải test nhiều lần
- Vị trí có thể thay đổi khi resize window

---

## Khuyến Nghị

### Dựa trên hiện trạng app LTN AI Manager (cửa sổ 159x27px):

1. **Kiểm tra System Tray**: 
   - App có thể chạy ở system tray (góc dưới bên phải taskbar)
   - Click phải vào icon trong system tray để xem menu

2. **Thử Double-Click App**:
   ```powershell
   # Mở lại app để xem cửa sổ đầy đủ
   .\ltnapp.exe
   ```

3. **Sử dụng PyAutoGUI** (Khuyến nghị):
   - Chụp ảnh các nút trong app
   - Dùng PyAutoGUI để tự động tìm và click

4. **Xem Log/Debug Output**:
   - Dùng DebugView để xem debug messages của app
   - App có thể in ra thông tin về UI elements

---

## Script Mẫu: Tìm Vị Trí Chuột & Click

### get_mouse_position.ps1
```powershell
Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

Write-Host "Di chuột đến nút bạn muốn và nhấn Ctrl+C để ghi lại vị trí`n" -ForegroundColor Green

$positions = @()

try {
    while ($true) {
        $pos = [System.Windows.Forms.Cursor]::Position
        
        # Lấy màu pixel tại vị trí chuột
        $bitmap = New-Object System.Drawing.Bitmap 1, 1
        $graphics = [System.Drawing.Graphics]::FromImage($bitmap)
        $graphics.CopyFromScreen($pos.X, $pos.Y, 0, 0, $bitmap.Size)
        $pixel = $bitmap.GetPixel(0, 0)
        $graphics.Dispose()
        $bitmap.Dispose()
        
        Write-Host "`rMouse: X=$($pos.X), Y=$($pos.Y) | Color: R=$($pixel.R) G=$($pixel.G) B=$($pixel.B)    " -NoNewline -ForegroundColor Cyan
        
        Start-Sleep -Milliseconds 100
    }
} catch {
    Write-Host "`n`nĐã dừng." -ForegroundColor Yellow
}
```

---

## Kết Luận

Với ứng dụng Flutter như LTN AI Manager:
- **Không thể** dùng UI Automation truyền thống
- **Khuyến nghị**: Dùng **image recognition** (PyAutoGUI) hoặc **chụp màn hình** + OCR
- **Cách nhanh nhất**: Mở app, chụp ảnh các nút, ghi lại vị trí chuột

---

## Tài Liệu Tham Khảo

- Flutter DevTools: https://flutter.dev/docs/development/tools/devtools
- PyAutoGUI: https://pyautogui.readthedocs.io/
- Sikuli: https://sikulix.github.io/
- ReFlutter: https://github.com/Impact-I/reFlutter
- Windows Accessibility Insights: https://accessibilityinsights.io/


