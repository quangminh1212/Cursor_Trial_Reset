# Thông Tin Giao Diện LTN AI Manager

## 🎯 Tổng Quan

**LTN AI Manager** là ứng dụng Flutter desktop để quản lý tài khoản Cursor trial.

---

## 📸 Screenshot

Xem file: `ltn_after_open_20251022_203249.png`

---

## 🖼️ Cấu Trúc Giao Diện

### **1. Header (Phần Đầu)**
```
┌─────────────────────────────────────────────────────┐
│ 🎯 Cursor                              ↻    ↗      │
│    Chào mừng, Vương Minh                            │
└─────────────────────────────────────────────────────┘
```

**Thành phần:**
- **Logo Cursor** (icon hình hộp 3D)
- **Text chào mừng**: "Cursor - Chào mừng, Vương Minh"
- **Icon Refresh** (↻) - Nút làm mới thông tin
- **Icon Open External** (↗) - Nút mở liên kết ngoài

---

### **2. Thông Tin Tài Khoản**
```
┌─────────────────────────────────────────────┐
│  💎 Gói: pro                               │
│  👤 Vai trò: USER                          │
│  ⏰ Hết hạn: 11/11/2025 15:59              │
└─────────────────────────────────────────────┘
```

**Badges (Nhãn):**
- **Gói**: pro (có thể là: free, pro, trial)
- **Vai trò**: USER (có thể là: USER, ADMIN)
- **Hết hạn**: Ngày giờ hết hạn trial

---

### **3. Hạn Mức (Quota)**
```
┌─────────────────────────────────────────────┐
│  Hạn mức                                   │
│                                            │
│  3/3                              100%     │
│  ████████████████████████████████████      │
│                                            │
│  ⏱ Reset: 22/10/2025 00:00                │
└─────────────────────────────────────────────┘
```

**Thành phần:**
- **Tiêu đề**: "Hạn mức"
- **Số lượt**: "3/3" (đã dùng/tổng số)
- **Phần trăm**: "100%"
- **Progress Bar**: Thanh tiến trình màu đỏ (100% = đầy)
- **Thời gian reset**: "Reset: 22/10/2025 00:00"

---

### **4. Nút Hành Động**
```
┌─────────────────────────────────────────────┐
│  ╔═══════════════════════════════════════╗ │
│  ║  🔄 Chuyển tài khoản Cursor          ║ │
│  ╚═══════════════════════════════════════╝ │
└─────────────────────────────────────────────┘
```

**Nút chính:**
- **Text**: "Chuyển tài khoản Cursor"
- **Màu**: Gradient xanh-tím (từ tím #8B5CF6 đến xanh #06B6D4)
- **Icon**: 🔄 (có icon mũi tên chuyển)
- **Chức năng**: Chuyển đổi/reset tài khoản Cursor

---

## 🎨 Màu Sắc & Thiết Kế

### **Bảng Màu:**
- **Background**: Đen (#000000) hoặc xám đậm
- **Card**: Navy đậm (#1E293B, #334155)
- **Primary Button**: Gradient (Purple #8B5CF6 → Cyan #06B6D4)
- **Progress Bar (Full)**: Đỏ (#EF4444)
- **Text**: Trắng (#FFFFFF)
- **Badge**: Background xám đậm với viền

### **Font:**
- Font chữ: Sans-serif (có thể là Inter, SF Pro)
- Size: Medium cho text thông thường, Large cho số liệu

---

## 📍 Vị Trí Các Nút (Tọa Độ Tương Đối)

### **Nếu cửa sổ có kích thước 1200x800:**

1. **Icon Refresh (↻)**
   - Vị trí: Góc phải trên
   - Ước tính: X ≈ 1100, Y ≈ 115
   - Kích thước: ~40x40 px

2. **Icon Open External (↗)**
   - Vị trí: Góc phải trên, bên phải icon Refresh
   - Ước tính: X ≈ 1150, Y ≈ 115
   - Kích thước: ~40x40 px

3. **Nút "Chuyển tài khoản Cursor"**
   - Vị trí: Dưới section Hạn mức
   - Ước tính: X ≈ 600 (center), Y ≈ 465
   - Kích thước: ~850x60 px
   - Màu: Gradient xanh-tím

---

## 🔍 Cách Tìm Nút

### **Phương pháp 1: Theo màu sắc**
```python
import pyautogui

# Tìm theo màu gradient (tím hoặc xanh)
locations = pyautogui.locateAllOnScreen(grayscale=False)
for loc in locations:
    pixel = pyautogui.pixel(loc.x, loc.y)
    if pixel[0] > 100 and pixel[2] > 180:  # Purple/Cyan
        print(f"Found button at: {loc}")
```

### **Phương pháp 2: Theo text**
```python
# Sử dụng OCR để tìm text "Chuyển tài khoản Cursor"
import pytesseract
from PIL import Image

screenshot = pyautogui.screenshot()
text = pytesseract.image_to_string(screenshot, lang='vie')
if "Chuyển tài khoản" in text:
    # Tìm vị trí text này
    pass
```

### **Phương pháp 3: Chụp ảnh nút và dùng Image Recognition**
```python
import pyautogui

# Chụp ảnh nút "Chuyển tài khoản Cursor" và lưu thành button.png
button_location = pyautogui.locateOnScreen('button.png', confidence=0.8)

if button_location:
    pyautogui.click(button_location)
    print("Đã click nút!")
```

---

## 🚀 Script Tự Động Click Nút

### **click_chuyen_tai_khoan.ps1**
```powershell
# Tim va click nut "Chuyen tai khoan Cursor"
Add-Type -AssemblyName System.Windows.Forms

# Gia su cua so co kich thuoc 1200x800
# Nut o vi tri trung tam, duoi phan Han muc

# Tinh toan vi tri nut (trung tam man hinh, Y khoang 465)
$screenWidth = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Width
$screenHeight = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds.Height

# Vi tri nut (gia su cua so o giua man hinh)
$buttonX = $screenWidth / 2
$buttonY = $screenHeight / 2 + 100  # Duoi trung tam mot chut

# Di chuot den nut
[System.Windows.Forms.Cursor]::Position = New-Object System.Drawing.Point($buttonX, $buttonY)

Write-Host "Da di chuot den vi tri nut. Kiem tra vi tri truoc khi click!"
```

---

## 📊 Thông Tin Kỹ Thuật

### **Ứng dụng:**
- **Công nghệ**: Flutter Desktop (Windows)
- **File thực thi**: `ltnapp.exe`
- **Process name**: `ltnapp`
- **Window title**: "LTN AI Manager"

### **Đặc điểm:**
- **Không hỗ trợ UI Automation**: Flutter vẽ trực tiếp lên canvas
- **Chạy system tray**: Có thể minimize về system tray
- **Kích thước cửa sổ**: Tự động (responsive)

---

## 🎯 Các Tính Năng

Dựa trên giao diện, ứng dụng có các tính năng:

1. **Xem thông tin tài khoản**: Gói, vai trò, hết hạn
2. **Xem hạn mức**: Số lượt đã dùng và thời gian reset
3. **Chuyển tài khoản**: Nút chính để reset/chuyển tài khoản Cursor
4. **Làm mới**: Icon Refresh để cập nhật thông tin
5. **Mở link ngoài**: Icon Open External (có thể mở dashboard web)

---

## 🔗 File Liên Quan

- **Screenshot**: `ltn_after_open_20251022_203249.png`
- **Script chụp màn hình**: `capture_ltn_final.ps1`
- **Script tìm nút**: `find_button_pyautogui.py`
- **Tài liệu phương pháp**: `CACH_TIM_NUT_TRONG_LTNAPP.md`

---

## 📝 Ghi Chú

- Giao diện có thể thay đổi tùy phiên bản
- Màu sắc có thể khác nhau tùy theme
- Vị trí nút phụ thuộc vào kích thước cửa sổ
- Cần mở cửa sổ đầy đủ (không minimize) để tương tác

---

**Cập nhật**: 22/10/2025 20:32

