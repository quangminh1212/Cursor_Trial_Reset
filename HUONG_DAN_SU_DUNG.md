# 📖 Hướng Dẫn Sử Dụng - LTN AI Manager Tools

## ✅ Đã Hoàn Thành

Đã **CHỤP THÀNH CÔNG** giao diện LTN AI Manager và tạo đầy đủ công cụ để tìm nút!

---

## 🎯 Tóm Tắt Vấn Đề Đã Giải Quyết

### **Vấn đề ban đầu:**
- Ứng dụng LTN AI Manager là Flutter app
- Không thể dùng UI Automation truyền thống
- Cửa sổ ban đầu chỉ 159x27 pixels (minimize hoặc system tray)

### **Giải pháp:**
1. ✅ Tìm ra cách mở cửa sổ đầy đủ
2. ✅ Chụp được screenshot giao diện
3. ✅ Xác định được các nút trong giao diện
4. ✅ Tạo công cụ để tự động tìm và click nút

---

## 📁 Các File Quan Trọng

### **📸 Screenshot**
| File | Mô tả |
|------|-------|
| `ltn_after_open_20251022_203249.png` | **Screenshot giao diện đầy đủ LTN AI Manager** ⭐ |

### **📜 Scripts**
| File | Công dụng |
|------|-----------|
| `capture_ltn_simple.ps1` | Chụp màn hình LTN app (đơn giản) |
| `capture_ltn_final.ps1` | Chụp màn hình sau khi mở app |
| `open_ltn_window.ps1` | Hướng dẫn mở cửa sổ từ system tray |
| `get_mouse_position.ps1` | Ghi lại vị trí chuột và màu pixel |
| `find_button_pyautogui.py` | Tìm nút tự động bằng Python (image recognition) |

### **📚 Tài Liệu**
| File | Nội dung |
|------|----------|
| `THONG_TIN_GIAO_DIEN_LTN.md` | **Thông tin chi tiết về giao diện** ⭐ |
| `CACH_TIM_NUT_TRONG_LTNAPP.md` | 7 phương pháp tìm nút |
| `README_TIM_NUT.md` | Hướng dẫn tổng hợp |
| `HUONG_DAN_SU_DUNG.md` | File này |

---

## 🚀 Quy Trình Sử Dụng

### **Bước 1: Mở Ứng Dụng LTN AI Manager**

```powershell
# Cách 1: Double-click
.\ltnapp.exe

# Cách 2: Dùng PowerShell
Start-Process -FilePath ".\ltnapp.exe"

# Cách 3: Dùng script tự động
powershell -ExecutionPolicy Bypass -File .\open_ltn_window.ps1
```

**Lưu ý**: Sau khi mở, nếu không thấy cửa sổ lớn:
- Tìm icon **LTN AI Manager** trong **System Tray** (góc dưới phải)
- **Double-click** vào icon để mở cửa sổ chính

---

### **Bước 2: Chụp Màn Hình Giao Diện**

```powershell
# Chụp màn hình LTN app
powershell -ExecutionPolicy Bypass -File .\capture_ltn_final.ps1
```

Kết quả: File `LTN_Screenshot_[timestamp].png`

---

### **Bước 3: Tìm Vị Trí Nút**

#### **Phương pháp A: Ghi vị trí bằng chuột (PowerShell)**

```powershell
powershell -ExecutionPolicy Bypass -File .\get_mouse_position.ps1
```

**Hướng dẫn:**
1. Di chuột đến nút bạn muốn
2. Nhấn **SPACE** để ghi vị trí
3. Nhấn **Ctrl+C** để kết thúc

**Kết quả:**
- File `mouse_positions.txt`: Danh sách vị trí đã lưu
- File `auto_click.ps1`: Script click tự động

---

#### **Phương pháp B: Image Recognition (Python)**

**Cài đặt:**
```bash
pip install pyautogui pillow opencv-python
```

**Sử dụng:**
```bash
python find_button_pyautogui.py
```

**Hướng dẫn:**
1. Chụp ảnh nút (dùng **Windows + Shift + S**)
2. Lưu ảnh thành `button.png`
3. Chạy script Python
4. Chọn chức năng:
   - **1**: Tìm và click nút
   - **2**: Tìm tất cả nút giống nhau
   - **3**: Theo dõi vị trí chuột

---

## 📊 Thông Tin Giao Diện LTN AI Manager

### **Các Nút Trong Giao Diện:**

| Nút | Vị Trí | Chức Năng |
|-----|--------|-----------|
| **Chuyển tài khoản Cursor** | Trung tâm, dưới phần Hạn mức | Nút chính - Chuyển/reset tài khoản ⭐ |
| **Icon Refresh (↻)** | Góc phải trên | Làm mới thông tin |
| **Icon Open External (↗)** | Góc phải trên | Mở link dashboard |

### **Thông Tin Hiển Thị:**

```
┌─────────────────────────────────────────┐
│  Cursor - Chào mừng, Vương Minh         │
├─────────────────────────────────────────┤
│  💎 Gói: pro                            │
│  👤 Vai trò: USER                       │
│  ⏰ Hết hạn: 11/11/2025 15:59           │
├─────────────────────────────────────────┤
│  Hạn mức:  3/3 (100%)                   │
│  ████████████████████████████████       │
│  Reset: 22/10/2025 00:00                │
├─────────────────────────────────────────┤
│  [ 🔄 Chuyển tài khoản Cursor ]         │
└─────────────────────────────────────────┘
```

Chi tiết xem file: `THONG_TIN_GIAO_DIEN_LTN.md`

---

## 🔧 Troubleshooting

### **Vấn đề 1: Không thấy cửa sổ LTN**
**Giải pháp:**
- Kiểm tra **System Tray** (góc dưới phải taskbar)
- Tìm icon LTN AI Manager
- Click phải → chọn "Open" hoặc double-click

### **Vấn đề 2: Script PowerShell bị chặn**
**Giải pháp:**
```powershell
# Chạy với ExecutionPolicy Bypass
powershell -ExecutionPolicy Bypass -File .\script.ps1

# Hoặc thay đổi policy tạm thời
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```

### **Vấn đề 3: PyAutoGUI không tìm thấy nút**
**Giải pháp:**
- Giảm `confidence` xuống 0.6-0.7
- Chụp lại ảnh nút rõ hơn
- Đảm bảo nút visible trên màn hình (không bị che)

### **Vấn đề 4: Cửa sổ vẫn nhỏ (159x27)**
**Giải pháp:**
- Ứng dụng đang minimize hoặc trong system tray
- Phải **double-click icon** trong system tray để mở đầy đủ
- Không thể maximize bằng code (cần tương tác thủ công)

---

## 📋 Checklist Hoàn Chỉnh

- ✅ Tìm được process ltnapp
- ✅ Xác định được cửa sổ trong system tray
- ✅ Chụp được screenshot giao diện đầy đủ
- ✅ Xác định được vị trí các nút
- ✅ Tạo script PowerShell để ghi vị trí chuột
- ✅ Tạo script Python cho image recognition
- ✅ Viết tài liệu chi tiết về giao diện
- ✅ Tạo hướng dẫn sử dụng

---

## 💡 Tips & Best Practices

### **Khi chụp màn hình:**
1. Đảm bảo cửa sổ LTN **không bị che** bởi cửa sổ khác
2. Mở cửa sổ **đầy đủ** (không minimize)
3. Đợi giao diện **load xong** trước khi chụp

### **Khi dùng Image Recognition:**
1. Chụp ảnh nút với **background rõ ràng**
2. Không chụp quá nhiều phần xung quanh
3. Đặt tên file **có ý nghĩa** (vd: `button_chuyen_tai_khoan.png`)

### **Khi automation:**
1. Thêm **delay** giữa các thao tác (0.5-1s)
2. Kiểm tra **vị trí cửa sổ** trước khi click
3. Dùng **try-catch** để xử lý lỗi

---

## 🎓 Kiến Thức Đã Học

### **Flutter Desktop Apps:**
- Không sử dụng native Windows controls
- UI Automation truyền thống không hoạt động
- Phải dùng image recognition hoặc pixel-based detection

### **System Tray Apps:**
- Process có thể chạy nhưng cửa sổ minimized
- Cần tương tác với system tray icon để mở cửa sổ
- Kích thước cửa sổ minimize thường rất nhỏ (<200px)

### **PowerShell & Windows API:**
- Sử dụng Win32 API để tương tác với cửa sổ
- `PrintWindow` không hoạt động tốt với Flutter apps
- Screen capture là cách đáng tin cậy nhất

---

## 📞 Liên Hệ & Đóng Góp

Nếu bạn có thắc mắc hoặc đóng góp:
- Tạo issue trong repository
- Hoặc liên hệ trực tiếp

---

## 📝 Changelog

### Version 1.0 - 22/10/2025
- ✅ Hoàn thành khảo sát giao diện LTN AI Manager
- ✅ Tạo đầy đủ công cụ chụp màn hình
- ✅ Viết tài liệu chi tiết
- ✅ Tạo script automation cơ bản

---

**🎉 Chúc bạn sử dụng thành công!**

Xem thêm:
- **Giao diện chi tiết**: `THONG_TIN_GIAO_DIEN_LTN.md`
- **Phương pháp tìm nút**: `CACH_TIM_NUT_TRONG_LTNAPP.md`
- **Screenshot**: `ltn_after_open_20251022_203249.png`

