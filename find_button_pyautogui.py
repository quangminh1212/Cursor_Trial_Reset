"""
Script Python để tìm và tương tác với nút trong LTN App
Sử dụng PyAutoGUI cho image recognition và automation

Cài đặt:
    pip install pyautogui pillow opencv-python

Hướng dẫn:
    1. Chụp ảnh nút bạn muốn tìm (có thể dùng Snipping Tool)
    2. Lưu ảnh với tên 'button.png' trong cùng thư mục
    3. Chạy script này
"""

import pyautogui
import time
import sys
from pathlib import Path

def find_and_click_button(button_image, confidence=0.8, timeout=10):
    """
    Tìm và click vào nút dựa trên hình ảnh
    
    Args:
        button_image: Đường dẫn đến ảnh nút
        confidence: Độ chính xác (0.0 - 1.0), mặc định 0.8
        timeout: Thời gian chờ tối đa (giây)
    
    Returns:
        True nếu tìm thấy và click được, False nếu không
    """
    print(f"Đang tìm nút: {button_image}")
    print(f"Độ chính xác: {confidence * 100}%")
    print(f"Timeout: {timeout}s")
    print("-" * 50)
    
    start_time = time.time()
    
    while time.time() - start_time < timeout:
        try:
            # Tìm nút trên màn hình
            location = pyautogui.locateOnScreen(button_image, confidence=confidence)
            
            if location:
                # Tính vị trí trung tâm của nút
                center = pyautogui.center(location)
                
                print(f"✓ Đã tìm thấy nút tại vị trí:")
                print(f"  - X: {center.x}")
                print(f"  - Y: {center.y}")
                print(f"  - Kích thước: {location.width}x{location.height}")
                print(f"  - Vùng: left={location.left}, top={location.top}")
                
                # Di chuột đến nút
                pyautogui.moveTo(center.x, center.y, duration=0.5)
                print("  - Đã di chuyển chuột đến nút")
                
                time.sleep(0.2)
                
                # Click
                pyautogui.click()
                print("  - Đã click!")
                
                return True
                
        except pyautogui.ImageNotFoundException:
            pass
        except Exception as e:
            print(f"Lỗi: {e}")
            
        time.sleep(0.5)
        print(".", end="", flush=True)
    
    print(f"\n✗ Không tìm thấy nút sau {timeout}s")
    return False


def find_all_buttons(button_image, confidence=0.8):
    """
    Tìm tất cả các nút giống nhau trên màn hình
    
    Args:
        button_image: Đường dẫn đến ảnh nút
        confidence: Độ chính xác (0.0 - 1.0)
    
    Returns:
        List các vị trí tìm thấy
    """
    print(f"Đang tìm tất cả nút: {button_image}")
    print("-" * 50)
    
    try:
        locations = list(pyautogui.locateAllOnScreen(button_image, confidence=confidence))
        
        if locations:
            print(f"✓ Tìm thấy {len(locations)} nút:")
            for i, loc in enumerate(locations, 1):
                center = pyautogui.center(loc)
                print(f"  [{i}] Vị trí: ({center.x}, {center.y}) | Kích thước: {loc.width}x{loc.height}")
            return locations
        else:
            print("✗ Không tìm thấy nút nào")
            return []
            
    except Exception as e:
        print(f"Lỗi: {e}")
        return []


def get_screen_info():
    """Lấy thông tin màn hình"""
    width, height = pyautogui.size()
    print("Thông tin màn hình:")
    print(f"  - Kích thước: {width}x{height}")
    print(f"  - Vị trí chuột hiện tại: {pyautogui.position()}")
    return width, height


def screenshot_region(x, y, width, height, filename='region.png'):
    """Chụp một vùng trên màn hình"""
    screenshot = pyautogui.screenshot(region=(x, y, width, height))
    screenshot.save(filename)
    print(f"Đã lưu screenshot vùng: {filename}")
    return filename


def monitor_mouse_position(duration=10):
    """
    Theo dõi và hiển thị vị trí chuột trong thời gian duration giây
    Nhấn Ctrl+C để dừng
    """
    print(f"Đang theo dõi vị trí chuột trong {duration}s...")
    print("Nhấn Ctrl+C để dừng")
    print("-" * 50)
    
    start_time = time.time()
    
    try:
        while time.time() - start_time < duration:
            x, y = pyautogui.position()
            pixel_color = pyautogui.pixel(x, y)
            
            print(f"\rX: {x:4d} | Y: {y:4d} | RGB: {pixel_color}   ", end="", flush=True)
            time.sleep(0.1)
            
    except KeyboardInterrupt:
        print("\n\nĐã dừng theo dõi")
    
    print()


def main():
    """Hàm chính"""
    print("=" * 60)
    print("  CÔNG CỤ TÌM VÀ CLICK NÚT TRONG LTN APP")
    print("=" * 60)
    print()
    
    # Lấy thông tin màn hình
    get_screen_info()
    print()
    
    # Menu
    print("Chọn chức năng:")
    print("  1. Tìm và click nút (từ ảnh)")
    print("  2. Tìm tất cả nút (từ ảnh)")
    print("  3. Theo dõi vị trí chuột")
    print("  4. Chụp vùng màn hình")
    print("  0. Thoát")
    print()
    
    choice = input("Nhập lựa chọn (0-4): ").strip()
    
    if choice == "1":
        image_path = input("Nhập đường dẫn đến ảnh nút (mặc định: button.png): ").strip()
        if not image_path:
            image_path = "button.png"
        
        if not Path(image_path).exists():
            print(f"Lỗi: Không tìm thấy file {image_path}")
            return
        
        confidence = float(input("Nhập độ chính xác (0.1-1.0, mặc định 0.8): ").strip() or "0.8")
        find_and_click_button(image_path, confidence=confidence)
        
    elif choice == "2":
        image_path = input("Nhập đường dẫn đến ảnh nút (mặc định: button.png): ").strip()
        if not image_path:
            image_path = "button.png"
        
        if not Path(image_path).exists():
            print(f"Lỗi: Không tìm thấy file {image_path}")
            return
        
        confidence = float(input("Nhập độ chính xác (0.1-1.0, mặc định 0.8): ").strip() or "0.8")
        find_all_buttons(image_path, confidence=confidence)
        
    elif choice == "3":
        duration = int(input("Thời gian theo dõi (giây, mặc định 10): ").strip() or "10")
        monitor_mouse_position(duration)
        
    elif choice == "4":
        print("Di chuột đến góc trên bên trái của vùng muốn chụp...")
        time.sleep(3)
        x1, y1 = pyautogui.position()
        print(f"Góc trên trái: ({x1}, {y1})")
        
        print("Di chuột đến góc dưới bên phải của vùng muốn chụp...")
        time.sleep(3)
        x2, y2 = pyautogui.position()
        print(f"Góc dưới phải: ({x2}, {y2})")
        
        width = abs(x2 - x1)
        height = abs(y2 - y1)
        
        filename = input("Nhập tên file (mặc định: region.png): ").strip() or "region.png"
        screenshot_region(min(x1, x2), min(y1, y2), width, height, filename)
        
    elif choice == "0":
        print("Tạm biệt!")
    else:
        print("Lựa chọn không hợp lệ")


if __name__ == "__main__":
    try:
        # Cảnh báo an toàn
        pyautogui.FAILSAFE = True  # Di chuột đến góc trên trái để dừng khẩn cấp
        pyautogui.PAUSE = 0.5  # Tạm dừng 0.5s giữa các lệnh
        
        main()
        
    except KeyboardInterrupt:
        print("\n\nĐã hủy bởi người dùng")
    except Exception as e:
        print(f"\n\nLỗi: {e}")
        import traceback
        traceback.print_exc()


