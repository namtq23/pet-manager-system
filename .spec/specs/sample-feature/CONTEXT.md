# Context Discovery: Feature Product Review & Rating

Tài liệu này ghi nhận kết quả khám phá bối cảnh của tính năng Đánh giá sản phẩm (Product Review & Rating) cho ứng dụng e-commerce.

---

## 1. Problem Statement (Vấn đề thực tế)
*   **Nỗi đau người dùng:** Người mua hàng trên trang web e-commerce hiện tại cảm thấy thiếu niềm tin khi quyết định mua hàng vì không thấy ý kiến đánh giá trực quan từ những người đã mua trước đó.
*   **Nhu cầu kinh doanh:** Tăng tỷ lệ chuyển đổi đơn hàng thành công (Conversion Rate) bằng cách tạo lập bằng chứng xã hội (Social Proof) đáng tin cậy.

## 2. Domain Knowledge (Kiến thức nghiệp vụ)
*   **Người mua thực tế (Verified Buyer):** Chỉ những khách hàng đã mua sản phẩm này và trạng thái đơn hàng đã chuyển sang `DELIVERED` (Đã giao hàng thành công) mới được phép đánh giá sản phẩm. Điều này giúp ngăn chặn hoàn toàn review rác (fake reviews).
*   **Thang điểm đánh giá (Rating Scale):** Sử dụng thang điểm số nguyên từ 1 đến 5 sao.

## 3. Stakeholders (Bên liên quan)
*   **Buyer (Người mua):** Người tạo đánh giá, viết nhận xét và chấm sao sản phẩm.
*   **Merchant (Người bán):** Người xem đánh giá của sản phẩm mình bán, có nhu cầu phản hồi phản biện đánh giá của người mua.
*   **Admin/Moderator (Quản trị viên):** Người kiểm duyệt nội dung đánh giá nếu phát hiện từ ngữ thô tục hoặc spam.

## 4. Constraints (Ràng buộc cứng không thể thay đổi)
*   **Tech Constraint:** Bắt buộc sử dụng Prisma ORM và DB PostgreSQL hiện tại để lưu thông tin đánh giá.
*   **Business Constraint:** Hệ thống tính toán điểm trung bình sản phẩm phải cập nhật bất đồng bộ (Asynchronous) hoặc cập nhật trong vòng tối đa 5 phút để tránh nghẽn DB khi có hàng triệu lượt truy cập.

## 5. Assumptions & Open Questions (Giả định & Câu hỏi mở)
*   *Câu hỏi mở:* Nếu một người mua đặt mua cùng một sản phẩm trong 2 đơn hàng khác nhau và cả hai đơn hàng đều đã giao thành công, người dùng đó được phép đánh giá mấy lần?
    *   ➔ *Quyết định nghiệp vụ:* Cho phép đánh giá tối đa 1 lần duy nhất cho mỗi mã sản phẩm (`product_id`) để tránh spam điểm số, bất kể số lượng đơn hàng đã đặt.
*   *Giả định:* Giả định rằng hệ thống kiểm duyệt thô tục tự động chưa cần thiết cho pha 1, quản trị viên sẽ tự kiểm duyệt thủ công nếu có báo cáo.