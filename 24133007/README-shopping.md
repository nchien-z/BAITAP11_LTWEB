# Giỏ hàng, COD và lịch sử đặt hàng — 24133007

Sản phẩm là khóa học video. Mỗi suất khóa học được mua bằng COD có một mã kích hoạt, được in trên phiếu giao đến địa chỉ trong đơn. Video public xem miễn phí; video private yêu cầu đăng nhập và đã kích hoạt đúng khóa học.

## Khởi chạy

1. Dùng JDK 21 trở lên, Tomcat 11 và SQL Server. Cấu hình kết nối hiện có nằm trong `DBConnection_24133007.java`.
2. Nếu chưa có database, chạy `database.sql` **chỉ để khởi tạo mới**. Script cũ xóa bảng/dữ liệu, không dùng để cập nhật database đang sử dụng.
3. Chạy `database-shopping.sql`, sau đó `database-courses.sql` trên SQL Server. Script bổ sung `Products`, `Orders`, `OrderItems`, `ActivationCodes`, liên kết khóa học với video và phân quyền mẫu; có thể chạy lại, không xóa dữ liệu hiện có.
4. Chạy `mvn package`, triển khai `target/24133007.war` vào Tomcat 11.
5. Mở `http://localhost:8080/24133007/products`. Menu có Khóa học, Giỏ hàng, Đơn hàng, Kích hoạt và Khóa học của tôi.

Giỏ hàng lưu trong session và sử dụng được trước khi đăng nhập. Thanh toán và lịch sử yêu cầu đăng nhập; sau đăng nhập sẽ quay về trang đang yêu cầu. Đăng xuất hoặc hết session sẽ xóa giỏ. Có thể dùng tài khoản mẫu trong `database.sql` nếu database được khởi tạo bằng script đó.

## Chức năng

- Thêm sản phẩm, gộp số lượng sản phẩm đã có, cập nhật số lượng, xóa từng sản phẩm hoặc toàn bộ giỏ.
- Số lượng từ 1 đến `min(tồn kho, 99)` cho từng sản phẩm; kiểm tra cả phía server. Số lượng 0 không thay cho thao tác xóa.
- COD yêu cầu tên người nhận, điện thoại 10–11 chữ số, địa chỉ; ghi chú tùy chọn. Phí giao hàng mẫu bằng 0.
- Giá và tồn kho được đọc lại lúc đặt hàng. Đơn, chi tiết và trừ tồn kho được ghi trong một transaction; lỗi sẽ rollback, giữ giỏ để sửa/thử lại.
- Token thanh toán ngăn đơn trùng; thay đổi giỏ làm mất hiệu lực trang thanh toán cũ. Biểu mẫu có CSRF token.
- Lịch sử chỉ đọc đơn của tài khoản hiện tại, chứa giá/tên sản phẩm tại thời điểm mua, lọc tám trạng thái và đọc lại database mỗi lần tải trang.

## Khóa học, giao mã và quyền xem video

1. Người mua chọn số suất khóa học, đặt COD, nhập địa chỉ giao phiếu mã. Đặt hàng chưa mở quyền xem private.
2. Mỗi suất sinh một mã ngẫu nhiên riêng trong cùng transaction đặt hàng. Mã chỉ xuất hiện cho admin tại `/admin/course-codes`, không hiện trong lịch sử của người mua.
3. Admin in phiếu có mã, khóa học và địa chỉ; giao phiếu và thu tiền COD. Đây là phiếu phục vụ giao hàng thực tế, chưa có tích hợp hãng vận chuyển.
4. Khi giao và thu tiền xong, cập nhật `Orders.Status='DELIVERED'` trong database.
5. Người nhận đăng nhập, mở `/activate`, nhập mã trên phiếu. Mỗi mã dùng một lần và gắn với tài khoản nhập mã; có thể mua nhiều suất để tặng các tài khoản khác. Mã của đơn chưa giao, hủy hoặc hoàn không dùng được.
6. `/my-courses` liệt kê khóa học đã mở và liên kết bài học. Quyền private được kiểm tra lại ở server mỗi lần mở video. Đơn chuyển sang `CANCELLED` hoặc `RETURNED` sẽ thu hồi quyền; mã đã dùng không được tái sử dụng.

Admin quản lý video tại `/admin/videos/edit`: chọn khóa học và **Public / Private**. Video private phải liên kết khóa học; trạng thái **Hiển thị / Tạm ẩn** là lựa chọn riêng. Admin được xem video để quản lý. Các video mẫu VID001, VID002, VID003, VID005 là private; VID004, VID006 và video giải trí còn lại là public.

Người chưa kích hoạt chỉ thấy thông báo khóa, không nhận iframe, thẻ video hoặc URL private trong HTML. URL YouTube/MP4 bên ngoài vẫn phụ thuộc quyền truy cập của dịch vụ lưu video; muốn bảo vệ cả đường dẫn nguồn cần kho video riêng hoặc URL có thời hạn. Chức năng hiện tại kiểm soát quyền xem trong ứng dụng.

Ví dụ đổi quyền bằng SQL:

```sql
UPDATE Videos SET IsPrivate=1, CourseId=1 WHERE VideoId='VID001';
UPDATE Videos SET IsPrivate=0 WHERE VideoId='VID004';
-- Chỉ admin được xem các mã chưa giao; dùng trang quản trị để in phiếu.
SELECT Code, OrderId, ProductId, ActivatedBy, ActivatedAt FROM ActivationCodes;
```

## Đổi trạng thái trong database để quan sát

Sau khi đặt đơn, lấy mã đơn hiển thị trong lịch sử. Chạy ví dụ sau trong SSMS, thay `@OrderId` bằng mã đơn của bạn:

```sql
USE WebVideo_24133007;
DECLARE @OrderId BIGINT = 1;
UPDATE Orders SET Status = 'CONFIRMED' WHERE OrderId = @OrderId;
SELECT OrderId, Username, Status, PaymentMethod, Total FROM Orders WHERE OrderId = @OrderId;
```

| Mã trong database | Nhãn trên giao diện |
| --- | --- |
| NEW | Đơn hàng mới |
| CONFIRMED | Đã xác nhận |
| PREPARING | Chuẩn bị hàng |
| SHIPPING | Vận chuyển |
| DELIVERING | Giao hàng |
| DELIVERED | Đã giao |
| CANCELLED | Đơn hàng hủy |
| RETURNED | Đơn hàng hoàn |

Lần lượt đổi `Status` bằng các mã trên, mở `/orders`, chọn trạng thái tương ứng và bấm **Lọc / Tải lại**. Bộ lọc cũ sẽ không còn hiển thị đơn đã chuyển trạng thái. Các lệnh SQL này chỉ đổi trạng thái để minh họa; không tự hoàn tồn kho cho đơn hủy/hoàn.

## Kiểm tra

```powershell
mvn test
mvn '-Dtest=ShoppingDatabaseIT' test
```

Lệnh thứ hai cần SQL Server đã chạy migration. Test tạo tài khoản/sản phẩm/đơn riêng và xóa dữ liệu test khi kết thúc. Kiểm tra COD, chống tạo đơn trùng, lọc đủ tám trạng thái, cách ly lịch sử theo tài khoản, rollback khi lỗi và đặt đồng thời không vượt tồn kho.

Sau khi build và triển khai Tomcat, có thể chạy kiểm tra HTTP tự động (Windows):

```powershell
java -cp 'target/classes;target/24133007/WEB-INF/lib/*' scripts/ShoppingHttpSmoke.java http://localhost:8080/24133007
```

Script kiểm tra các JSP, giỏ/COD/lịch sử, CSRF, video public/private, không lộ URL private, giao mã theo địa chỉ, chặn kích hoạt trước khi giao, kích hoạt một lần, thư viện khóa học, thu hồi quyền khi hoàn và trang quản trị in mã/chỉnh video. Dữ liệu test riêng được dọn sau khi chạy. Bộ kiểm tra gồm 8 unit test, 5 database integration test và luồng HTTP trên Tomcat 11.

Trong workspace hiện tại, Maven cache phục vụ kiểm tra nằm ở `target/maven-repository`; có thể dùng `mvn -o '-Dmaven.repo.local=target/maven-repository' test` để chạy offline. Thư mục cache này không đưa vào Git.

Kiểm tra giao diện: thêm cùng sản phẩm hai lần; đổi số lượng tới giới hạn; thử 0, số âm, vượt tồn kho bằng request; xóa một dòng và toàn bộ giỏ; đăng nhập rồi đặt COD; xác nhận giỏ trống, đơn mới xuất hiện và tải lại POST không tạo đơn thứ hai. Thử đổi tồn kho/ngừng bán trong SQL trước khi đặt để quan sát lỗi và sửa giỏ.

## Mốc nộp theo đề

- Giỏ hàng và COD: commit trước **10:45 ngày 05/10/2026**.
- Lịch sử lọc trạng thái: commit trước **07:45 ngày 07/10/2026**.
- Link GitHub hoặc bài còn thiếu từ bài 3 đến bài 9: nộp vào bài tập 11.

Thư mục nhận được chưa có `.git`, nên chưa tạo commit hoặc push. Khi đưa mã vào repository GitHub của bạn, bỏ qua `target/` và các cấu hình IDE cục bộ.
