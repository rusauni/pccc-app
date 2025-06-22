
# 🔥 Kiểm Tra Yêu Cầu Trang Bị Hệ Thống PCCC Theo TCVN 3890:2023

## 🎯 Mục Tiêu
Xác định các yêu cầu trang bị hệ thống phòng cháy chữa cháy cho công trình theo tiêu chuẩn TCVN 3890:2023.

---

## 🧩 Tổng Hợp Trường Dữ Liệu Theo Hạng Mục

### 1. Hệ Thống Chữa Cháy Tự Động

- `LoaiNha`: Loại công trình/nhà
- `ChieuCao`: Chiều cao công trình (m)
- `TongDienTichSan`: Tổng diện tích sàn (m²)
- `KhoiTich`: Tổng khối tích (m³)
- `HangNguyHiemChay`: Hạng nguy hiểm cháy/nổ
- `TiLePhongCanCC`: Tỷ lệ phòng cần chữa cháy (%)
- `CoHangMucDacBiet`: Có hạng mục đặc biệt (karaoke, gara, tầng hầm...)

### 2. Hệ Thống Báo Cháy Tự Động

- `LoaiNha`, `ChieuCao`, `SoTang`, `DienTichSan`, `KhoiTich`
- `CoTangHam`, `HangNguyHiemChay`, `ChoPhepThayTheCucBo`

### 3. Hệ Thống Cấp Nước Chữa Cháy Ngoài Nhà

- `KhoangCachNguonCap`, `LuuLuongCapNuoc`, `TruLuongCapNuoc`
- `CoHeThongNuocNgoaiNha`, `KetHopCapNuocSinhHoat`, `LoaiNha`

### 4. Hệ Thống Họng Nước Chữa Cháy Trong Nhà

- `LoaiNha`, `ChieuCao`, `HangNguyHiemChay`, `CoTangHam`
- `SuDungChatKiNuoc`, `YeuCauDuyTriApSuat`

### 5. Thiết Bị Chữa Cháy Ban Đầu

- `DienTichKhuVuc`, `CoVatCan`, `LoaiNha`, `KhuVucNgotNgach`, `LoaiBinhChuaChay`

### 6. Thiết Bị Thoát Nạn & Thông Báo

- `LoaiNha`, `SoNguoiSuDung`, `CoPhongNgu`, `CoPhongOnLon`

### 7. Phương Tiện Chữa Cháy Cơ Giới

- `LoaiCoSo`, `DienTichCoSo`, `LoaiPhuongTienCoGioi`

### 8. Thiết Bị Phá Dỡ Thô Sơ & Mặt Nạ Phòng Độc

- `LoaiNha`, `ViTriBoTriPhongTruc`, `CoKhuyenKhichMatNaLocDoc`

---

## 💻 Mô Tả Giao Diện UI (Đề Xuất)

### A. Form nhập thông tin

- Dropdown: `Loại công trình`
- Input số: `Chiều cao`, `Diện tích`, `Khối tích`, `Số tầng`
- Dropdown hoặc checkbox: `Hạng nguy hiểm cháy`
- Checkbox: `Có tầng hầm`, `Có chức năng đặc biệt`, `Cho phép thay thế cục bộ`
- Checkbox: `Sử dụng chất kỵ nước`, `Yêu cầu duy trì áp suất`
- Checkbox: `Đã có hệ thống nước ngoài`, `Kết hợp nước sinh hoạt`
- Checkbox: `Có phòng ngủ`, `Có khu vực ồn cao`

### B. Nút hành động

- `PHÂN TÍCH` → Kết luận tự động:
  - ✅ Bắt buộc
  - ⚠️ Cân nhắc
  - ❌ Không bắt buộc

### C. Kết quả

- Màu sắc: đỏ (bắt buộc), vàng (cân nhắc), xanh (không yêu cầu)
- Gợi ý dẫn chiếu tiêu chuẩn cụ thể

---

## 📚 Trích Dẫn TCVN

- TCVN 3890:2023 – mục 4, 5, phụ lục A, B, C, D, E, F, G
- TCVN 5738, 5760, 6101, 7161, 7336, 7435, 13456, 12314, 13333...
