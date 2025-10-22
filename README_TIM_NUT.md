# Hướng Dẫn Tìm Nút Trong LTN AI Manager

## 📋 Tổng Quan

Ứng dụng **LTN AI Manager** là ứng dụng Flutter desktop. Ứng dụng Flutter **không sử dụng** Windows native controls nên các công cụ UI Automation truyền thống (như Inspect.exe, UIAutomation) **KHÔNG hoạt động**.

### Thông tin ứng dụng:
- **Tên Process**: `ltnapp`
- **Tiêu đề cửa sổ**: LTN AI Manager
- **Kích thước cửa sổ**: 159x27 pixels (rất nhỏ - có thể là system tray app)

---

## 🛠️ Công Cụ Đã Tạo

Trong thư mục này có 3 công cụ chính:

### 1️⃣ `get_mouse_position.ps1` - Lấy Vị Trí Chuột (PowerShell)
**Mục đích**: Giúp bạn ghi lại vị trí và màu sắc của các nút trong ứng dụng.

**Cách dùng**:
```powershell
powershell -ExecutionPolicy Bypass -File .\get_mouse_position.ps1
```

**Hướng dẫn**:
1. Mở ứng dụng LTN AI Manager
2. Chạy script
3. Di chuột đến vị trí nút bạn muốn
4. Nhấn **SPACE** để ghi lại vị trí
5. Lặp lại cho các nút khác
6. Nhấn **Ctrl+C** để kết thúc

**Kết quả**:
- Hiển thị tọa độ X, Y và màu RGB/Hex
- Lưu vào file `mouse_positions.txt`
- Tạo script tự động `auto_click.ps1`

---

### 2️⃣ `find_button_pyautogui.py` - Tìm Nút Tự Động (Python)
**Mục đích**: Sử dụng image recognition để tự động tìm và click nút.

**Yêu cầu**:
```bash
pip install pyautogui pillow opencv-python
```

**Cách dùng**:
```bash
python find_button_pyautogui.py
```

**Hướng dẫn**:
1. **Chụp ảnh nút**: Dùng Snipping Tool (Windows + Shift + S) để chụp ảnh nút
2. **Lưu ảnh**: Lưu với tên `button.png` trong cùng thư mục
3. **Chạy script**: Chọn chức năng từ menu
   - Tùy chọn 1: Tìm và click nút
   - Tùy chọn 2: Tìm tất cả nút giống nhau
   - Tùy chọn 3: Theo dõi vị trí chuột
   - Tùy chọn 4: Chụp vùng màn hình

**Ví dụ**:
```python
# Trong script Python của bạn
import pyautogui

# Tìm nút
button_location = pyautogui.locateOnScreen('button.png', confidence=0.8)

if button_location:
    # Click nút
    pyautogui.click(button_location)
```

---

### 3️⃣ `CACH_TIM_NUT_TRONG_LTNAPP.md` - Tài Liệu Chi Tiết
**Mục đích**: Giải thích chi tiết 7 phương pháp khác nhau để tìm nút trong ứng dụng Flutter.

**Nội dung bao gồm**:
1. Chụp màn hình & phân tích thủ công
2. OCR (Optical Character Recognition)
3. Flutter DevTools (debug mode)
4. Image Recognition / Computer Vision
5. Decompile / Reverse Engineering
6. Accessibility Features
7. Mouse Position & Pixel Color Detection

---

## 🚀 Quy Trình Khuyến Nghị

### Bước 1: Kiểm tra System Tray
Ứng dụng có thể chạy ở **system tray** (góc dưới bên phải taskbar):
- Tìm icon LTN AI Manager trong system tray
- Click phải để xem menu
- Double-click để mở cửa sổ chính (nếu có)

### Bước 2: Mở Ứng Dụng Đầy Đủ
```powershell
# Chạy lại ứng dụng
.\ltnapp.exe
```

Kiểm tra xem có cửa sổ lớn hơn hiện ra không.

### Bước 3: Ghi Lại Vị Trí Nút
Sử dụng `get_mouse_position.ps1`:
```powershell
powershell -ExecutionPolicy Bypass -File .\get_mouse_position.ps1
```

### Bước 4: Automation (Tùy Chọn)
Sử dụng Python + PyAutoGUI để automation:
```bash
python find_button_pyautogui.py
```

---

## 📸 Ví Dụ Thực Tế

### Tình huống: Tìm và click nút "Start"

**Cách 1: Dùng PowerShell (Ghi vị trí)**
```powershell
# Chạy script
.\get_mouse_position.ps1

# Di chuột đến nút "Start", nhấn SPACE
# Kết quả: X=500, Y=300

# Dùng vị trí đã lưu để click
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point(500, 300)
# Thực hiện click tại đây
```

**Cách 2: Dùng Python (Image Recognition)**
```python
import pyautogui

# Chụp ảnh nút "Start" và lưu thành start_button.png

# Tìm và click
location = pyautogui.locateOnScreen('start_button.png', confidence=0.8)
if location:
    pyautogui.click(location)
    print("Đã click nút Start!")
else:
    print("Không tìm thấy nút Start")
```

---

## ⚠️ Lưu Ý Quan Trọng

### 1. Độ chính xác của Image Recognition
- Phụ thuộc vào **resolution** màn hình
- Phụ thuộc vào **theme** và màu sắc
- Khuyến nghị: `confidence=0.7-0.9`

### 2. Failsafe trong PyAutoGUI
PyAutoGUI có tính năng **FAILSAFE**: Di chuột đến góc trên trái màn hình để **dừng khẩn cấp** script.

### 3. Vị trí chuột thay đổi
Nếu resize window hoặc thay đổi position, vị trí các nút sẽ thay đổi.

### 4. Ứng dụng chạy nhiều monitor
Nếu có nhiều monitor, tọa độ có thể khác nhau.

---

## 🔍 Debug & Troubleshooting

### Vấn đề: Không tìm thấy cửa sổ lớn
**Giải pháp**:
- Kiểm tra system tray
- Thử double-click vào ltnapp.exe
- Kiểm tra taskbar có minimize không

### Vấn đề: PyAutoGUI không tìm thấy nút
**Giải pháp**:
- Giảm `confidence` xuống 0.6-0.7
- Chụp lại ảnh nút rõ hơn
- Đảm bảo nút visible trên màn hình

### Vấn đề: Script PowerShell bị chặn
**Giải pháp**:
```powershell
# Thay đổi execution policy tạm thời
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```

---

## 📚 Tài Liệu Tham Khảo

- **PyAutoGUI Documentation**: https://pyautogui.readthedocs.io/
- **Flutter DevTools**: https://flutter.dev/docs/development/tools/devtools
- **Sikuli (Image Recognition)**: https://sikulix.github.io/
- **Windows Accessibility Insights**: https://accessibilityinsights.io/

---

## 📝 Kết Luận

Với ứng dụng Flutter như **LTN AI Manager**, bạn có 2 cách chính:

### ✅ Cách 1: Ghi vị trí thủ công (Nhanh)
Dùng `get_mouse_position.ps1` để ghi lại vị trí, sau đó automation bằng PowerShell hoặc Python.

### ✅ Cách 2: Image Recognition (Mạnh mẽ)
Chụp ảnh nút, dùng PyAutoGUI để tự động tìm và click.

### ✅ Khuyến nghị
Kết hợp cả 2 cách:
1. Dùng Cách 1 để hiểu layout
2. Dùng Cách 2 để automation mạnh mẽ hơn

---

**Chúc bạn thành công! 🎉**


