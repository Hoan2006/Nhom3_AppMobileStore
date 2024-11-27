# Nhom3_AppMobileStore
## 1. Thành viên nhóm 3:
+ Trần Khải Hoàn - 21110827
+ Phạm Ngọc Đăng Khoa - 21110214
## 2. Đề tài: Ứng dụng kinh doanh thiết bị di động
## 3. Đặc tả use case:
**1. Đặc tả use case “Đăng ký”**
- Short Description: Cho phép user đăng ký tài khoản
- Actor: User
- Post-Conditions: User đăng ký tài khoản thành công
- Main Flow
1. Tại trang Đăng ký, User nhập các thông tin vào các trường để Đăng ký bao gồm: Email, Mật khẩu, Nhập lại mật khẩu và nhấn nút "Đăng Ký".
2. Hệ thống kiểm tra thông tin đăng ký của User.
3. Hệ thống gửi mã OTP 6 chữ số qua Email đã nhập ở bước 1 và hiển thị thông báo "Mã OTP đã được gửi".
4. Tại trang nhập OTP, User nhập mã OTP và nhấn nút "Xác nhận".
5. Hệ thống kiểm tra mã OTP đã nhập.
6. Hệ thống thông báo "Đăng ký thành công", chuyển User qua trang Đăng nhập và lưu thông tin tài khoản vào cơ sở dữ liệu.
- Alternate Flow(s)
1.1. User có thể nhấn vào chữ "Đã có tài khoản?Đăng nhập".
2.1. Hệ thống chuyển User qua trang Đăng nhập.
- Exception Flow(s)
2.1. Thông tin nhập không hợp lệ.
3.1. Hệ thống cảnh báo, đưa user quay lại bước 2 của Main Flow và yêu cầu nhập lại.
5.1. Mã OTP đã  nhập không hợp lệ.
6.1.  Hệ thống cảnh báo, đưa user quay lại bước 4 của Main Flow và yêu cầu nhập lại, tối đa được nhập sai mã OTP 3 lần.
  
**2. Đặc tả use case “Đăng nhập”**
- Short description: Cho phép user đăng nhập vào trang chủ
- Actor: User 
- Post-Conditions: User đăng nhập thành công vào trang chủ
- Main Flow: 
1. Tại trang Đăng nhập, User nhập các thông tin vào các trường để Đăng nhập bao gồm: Email, Mật khẩu và nhấn nút "ĐĂNG NHẬP".
2. Hệ thống kiểm tra thông tin đăng nhập của User.
3. Hệ thống chuyển User qua trang chủ.
- Alternate Flow(s): 
1.1. User có thể nhấn vào chữ "Quên mật khẩu".
2.1. Hệ thống chuyển User qua trang Quên mật khẩu.
1.2. User có thể nhấn vào chữ "Chưa có tài khoản? Đăng ký".
2.2. Hệ thống chuyển User qua trang Đăng ký.
- Exception Flow(s):          
2.1. Thông tin nhập không hợp lệ.
3.1. Hệ thống hiện thông báo Đăng nhập thất bại, đưa User quay lại bước 1 của Main Flow và yêu cầu User nhập lại.

**3. Đặc tả use case “Đăng nhập”**
- Short Description: Cho phép admin đăng nhập vào trang quản lý
- Actor: Admin
- Post-Conditions: Admin đăng nhập thành công vào trang quản lý
- Main Flow: 
1. Tại trang Đăng nhập, Admin nhập các thông tin vào các trường để Đăng nhập bao gồm: Email, Mật khẩu và nhấn nút "ĐĂNG NHẬP".
2. Hệ thống kiểm tra thông tin đăng nhập của Admin.
3. Hệ thống chuyển Admin qua trang quản lý.
- Exception Flow(s):          
2.1. Thông tin nhập không hợp lệ.
3.1. Hệ thống hiện thông báo Đăng nhập thất bại, đưa Admin quay lại bước 1 của Main Flow và yêu cầu Admin nhập lại.
2.2. Thông tin đăng nhập có role là User.
3.2. Hệ thống thông báo “Tài khoản của bạn không phải là tài khoản Admin”, đưa Admin quay lại bước 1 của Main Flow và yêu cầu Admin nhập lại.


**4. Đặc tả use case “Quên mật khẩu”**
- Short Description: Cho phép user đổi mật khẩu
- Actor: User
- Post-Conditions: User đổi mật khẩu thành công
- Main Flow:
1. Tại trang Quên mật khẩu, User nhập Email và nhấn nút "Gửi OTP".
2. Hệ thống kiểm tra Email đã nhập.
3. Hệ thống gửi mã OTP 6 chữ số qua Email đã nhập ở bước 1 và hiển thị thông báo "Mã OTP đã được gửi".
4. Tại trang Đặt lại mật khẩu, User nhập mã OTP và nhấn nút "Đặt lại mật khẩu".
5. Hệ thống kiểm tra mã OTP đã nhập.
6. Hệ thống gửi Email đặt lại mật khẩu thông báo "Đã gửi email đặt lại mật khẩu".
7. User truy cập vào trang Đổi mật khẩu thông qua link được gửi qua Email.
8. Tại trang Đổi mật khẩu, User nhập mật khẩu mới và nhấn "Save".
9. Hệ thống kiểm tra mật khẩu đã nhập.
10. Hệ thống thông báo đổi mật khẩu thành công và lưu thông tin tài khoản vào cơ sở dữ liệu.
- Alternate Flow:
1.1. User có thể nhấn vào chữ "Quay lại Đăng nhập".
2.1. Hệ thống chuyển User qua trang Đăng nhập..
- Exception Flow:           
2.1. Email đã nhập không hợp lệ
3.1. Hệ thống cảnh báo, đưa User quay lại bước 1 của Main Flow và yêu cầu User nhập lại Email hợp lệ.
5.1. Mã OTP đã nhập không hợp lệ
6.1. Hệ thống cảnh báo, đưa User quay lại bước 4 của Main Flow và yêu cầu User nhập lại mã OTP..

**5. Đặc tả use case “Đăng xuất”**
- Short Description: Cho phép user đăng xuất khỏi trang chủ
- Actor: User
- Pre-Conditions: User đã thực hiện use case “Đăng nhập” thành công
- Post-Conditions: User đăng xuất khỏi trang chủ thành công 
- Main Flow: 
1. Tại trang Cập nhật thông tin cá nhân, user nhấn nút “Đăng xuất”
2. Hệ thống xác nhận là user đã đăng xuất và chuyển user trở lại trang đăng nhập. 

**6. Đặc tả use case “Đăng xuất”**
- Short Description: Cho phép admin đăng xuất khỏi trang quản lý
- Actor: Admin
- Pre-Conditions: Admin đã thực hiện use case “Đăng nhập” thành công
- Post-Conditions: Admin đăng xuất khỏi trang quản lý thành công 
- Main Flow: 
1. Tại giao diện trang chủ, Admin nhấn nút “Đăng xuất”
2. Hệ thống xác nhận là admin đã đăng xuất và chuyển admin trở lại trang đăng nhập. 

**7. Đặc tả use case “Cập nhật thông tin cá nhân”**
- Short Description: Cho phép user xem và cập nhật thông tin cá nhân
- Actor: User
- Pre-Conditions: User đã thực hiện use case “Đăng nhập” thành công
- Post-Conditions: User cập nhật thông tin cá nhân thành công 
- Main Flow: 
1. Tại trang Cập nhật thông tin cá nhân, User có thể thay đổi ảnh đại hiện và nhập các thông tin vào các trường bao gồm: Tên người dùng, Ngày sinh, Số điện thoại, Địa chỉ và nhấn nút "Cập nhật thông tin cá nhân".
2. Hệ thống hiển thị thông báo xác nhận, User bấm "Lưu".
3. Hệ thống chuyển User qua trang xác nhận cập nhật và gửi mã OTP qua email User đã đăng ký.
4. Tại trang nhập OTP, User nhập mã OTP đã gửi và nhấn nút "Xác nhận OTP"
5. Hệ thống kiểm tra mã OTP đã nhập.
6. Hệ thống thông báo cập nhật thông tin cá nhân thành công và lưu thông tin cá nhân vào cơ sở dữ liệu.
- Exception Flow:            
5.1. Mã OTP đã nhập không hợp lệ.
6.1. Hệ thống cảnh báo, đưa User quay lại bước 4 của Main Flow và yêu cầu User nhập lại mã OTP.

**8. Đặc tả use case “Xem chi tiết sản phẩm”**
- Short Description: Cho phép user xem chi tiết sản phẩm
- Actor: User
- Pre-Conditions: User đã thực hiện use case “Đăng nhập” thành công
-Post-Conditions: User xem chi tiết sản phẩm thành công
- Main Flow:
1. Tại trang chủ, User nhấn vào sản phẩm muốn xem thông tin chi tiết.
2. Hệ thống chuyển User qua trang xem thông tin chi tiết sản phẩm đó.
3. User xem thông tin chi tiết sản phẩm.

**9. Đặc tả use case “Xem chi tiết sản phẩm”**
- Short Description: Cho phép admin xem chi tiết sản phẩm
- Actor: Admin
- Pre-Conditions:Admin đã thực hiện use case “Đăng nhập” thành công
- Post-Conditions: Admin xem chi tiết sản phẩm thành công
- Main Flow:
1. Tại trang quản lý sản phẩm, Admin nhấn vào sản phẩm muốn xem thông tin chi tiết.
2. Hệ thống chuyển Admin qua trang xem thông tin chi tiết sản phẩm đó.
3. Admin xem thông tin chi tiết sản phẩm.

**10. Đặc tả use case “Tìm kiếm sản phẩm”**
- Short Description: Cho phép user tìm kiếm sản phẩm
- Actor: User
- Pre-Conditions: User đã thực hiện use case “Đăng nhập” thành công
- Post-Conditions: User tìm kiếm sản phẩm thành công
- Main Flow: 
1. Tại trang chủ, User nhập tên sản phẩm muốn tìm kiếm.
2. Hệ thống hiển thị những sản phẩm có tên giống với tên đã nhập.

**11. Đặc tả use case “Lọc sản phẩm”**
- Short Description: Cho phép user lọc sản phẩm
- Actor: User
- Pre-Conditions: User đã thực hiện use case “Đăng nhập” thành công
- Post-Conditions: User lọc sản phẩm thành công
- Main Flow: 
1. Tại trang chủ, User nhấn vào icon "☰".
2. Hệ thống chuyển User qua trang lọc sản phẩm.
3. User có thể chọn các danh mục, thương hiệu muốn tìm kiếm hoặc cũng có thể chọn "Giá: Thấp đến Cao" hoặc "Giá: Cao đến Thấp" để lọc theo giá và bấm "Xong".
4. Hệ thống hiển thị những sản phẩm theo bộ lọc.

**12. Đặc tả use case “Hủy đơn hàng”**
- Short Description: Cho phép user hủy đơn hàng
- Actor: User
- Pre-Conditions: User đã thực hiện use case “Đặt hàng” thành công và đơn hàng muốn hủy trong trạng thái “Đang xử lý”
- Post-Conditions: User hủy đơn hàng thành công
- Main Flow: 
1. Tại trang Đơn hàng, User nhấn vào nút “Hủy đơn hàng” trong đơn hàng mình muốn hủy.
2. Hệ thống cập nhật trạng thái của đơn hàng thành “Đã hủy” vào cơ sở dữ liệu.
3. Hệ thống chuyển đơn hàng đó vô tab Bị Hủy ở trang quản lý đơn hàng bên trang quản lý.

**13. Đặc tả use case “Đánh giá sản phẩm đã mua”**
- Short Description: Cho phép user đánh giá sản phẩm đã mua
- Actor: User
- Pre-Conditions: User đã thực hiện use case “Đặt hàng” thành công và sản phẩm muốn đánh giá trong trạng thái “Đã giao thành công”
- Post-Conditions: User đánh giá sản phẩm đã mua thành công
- Main Flow: 
1. Tại trang Đơn hàng, User nhấn vào nút “Đánh giá sản phẩm” trong đơn hàng mình muốn đánh giá.
2. Tại trang Đánh giá, User có thể chọn số sao và nhập đánh giá (tối thiểu 10 ký tự).
3. User nhấn nút “Gửi đánh giá”
4. Hệ thống lưu lại thông tin đánh giá vào cơ sở dữ liệu.

**14. Đặc tả use case “Yêu thích sản phẩm”**
- Short Description: Cho phép user yêu thích sản phẩm
- Actor: User
- Pre-Conditions: User đã thực hiện use case “Đăng nhập” thành công
- Post-Conditions: User yêu thích sản phẩm thành công
- Main Flow: 
1. Tại trang chủ, User nhấn vào sản phẩm muốn yêu thích để xem chi tiết sản phẩm đó.
2. Tại trang chi tiết sản phẩm, User nhấn vào nút Yêu thích.
3. Hệ thống thêm sản phẩm vào tab Yêu Thích và cập nhật cơ sở dữ liệu.

**15. Đặc tả use case “Thêm vào giỏ hàng”**
- Short Description: Cho phép user thêm sản phẩm vào giỏ hàng
- Actor: User
- Pre-Conditions: User đã thực hiện use case “Đăng nhập” thành công
- Post-Conditions: User thêm sản phẩm vào giỏ hàng thành công
- Main Flow: 
1. Tại trang chủ, User nhấn vào sản phẩm muốn thêm để xem chi tiết sản phẩm đó.
2. Tại trang chi tiết sản phẩm, User nhấn vào nút Giỏ hàng.
3. Hệ thống thêm sản phẩm vào tab Giỏ hàng và cập nhật cơ sở dữ liệu.

**16. Đặc tả use case “Đặt hàng”**
- Short Description: Cho phép user đặt hàng
- Actor: User
- Pre-Conditions: User đã thực hiện use case “Đăng nhập” thành công
- Post-Conditions: User đặt hàng thành công
- Main Flow: 
1. Tại trang Giỏ hàng, User chỉnh sửa số lượng sản phẩm mình muốn đặt hàng
2. User tick vào check box ở bên trái sản phẩm mình muốn đặt hàng.
3. Hệ thống thực hiện tính toán tổng số tiền phải trả và hiện lên.
4. User bấm vào nút “Đặt hàng”
5. Hệ thống thông báo “Đặt hàng thành công”, tạo ra đơn hàng ở bên tab Đơn hàng và cập nhật cơ sở dữ liệu.
- Alternate Flow:
1.1. User có thể ấn vào biểu tượng thùng rác ở bên phải sản phẩm.
2.1. Hệ thống xóa sản phẩm khỏi đơn hàng.

**17. Đặc tả use case “Xác nhận đặt hàng”**
- Short Description: Cho phép người dùng xác nhận đặt hàng với các sản phẩm đã chọn trong giỏ hàng.
- Actor: User
- Pre-Conditions: 
1. Người dùng đã đăng nhập thành công.
2. Người dùng đã chọn ít nhất một sản phẩm trong giỏ hàng.
- Post-Conditions: 
1. Đơn hàng của người dùng được tạo thành công.
2. Thông tin đơn hàng được lưu vào cơ sở dữ liệu.
3. Điểm tích lũy của người dùng được cập nhật.
- Main Flow: 
1. Tại màn hình xác nhận đặt hàng, người dùng thấy danh sách các sản phẩm đã chọn cùng thông tin tổng giá tiền.
2. Người dùng chọn phương thức thanh toán, nhập địa chỉ giao hàng, và quyết định số điểm tích lũy cần sử dụng (nếu có).
3. Người dùng nhấn nút “Đặt hàng”.
4. Hệ thống kiểm tra thông tin đặt hàng.
5. Hệ thống tạo đơn hàng trong cơ sở dữ liệu và cập nhật điểm tích lũy của người dùng.
6. Hệ thống thông báo đặt hàng thành công và điều hướng người dùng về màn hình Giỏ hàng.
- Alternate Flow:
2.1. Người dùng không muốn sử dụng điểm tích lũy: Hệ thống bỏ qua bước trừ điểm và giữ nguyên tổng giá tiền.
- Exception Flow:            
4.1. Thông tin đặt hàng không đầy đủ hoặc không hợp lệ:
  4.1.1. Hệ thống hiển thị thông báo lỗi, yêu cầu người dùng kiểm tra lại thông tin.
  4.1.2. Hệ thống quay lại bước 2 của Main Flow.
5.1. Lỗi khi lưu đơn hàng vào cơ sở dữ liệu: Hệ thống hiển thị thông báo lỗi và yêu cầu thử lại sau.

**18. Đặc tả use case “Thêm sản phẩm”**
- Short Description: Cho phép admin thêm sản phẩm
- Actor: Admin
- Pre-Conditions: Admin đã thực hiện use case “Đăng nhập” thành công
- Post-Conditions: Admin thêm sản phẩm thành công
- Main Flow: 
1. Tại trang quản lý sản phẩm, Admin nhấn vào nút “Thêm sản phẩm”.
2. Hệ thống chuyển Admin qua trang Thêm sản phẩm.
3. Admin chọn ảnh, danh mục và nhập thông tin vào các trường bao gồm: Tên thiết bị, Hãng sản xuất, Mô tả sản phẩm, Giá sản phẩm và bấm vào nút “Thêm sản phẩm”.
4. Hệ thống kiểm tra thông tin sản phẩm.
5. Hệ thống thông báo thêm sản phẩm thành công và lưu vào cơ sở dữ liệu.
- Exception Flow:            
4.1. Thông tin sản phẩm không hợp lệ.
5.1. Hệ thống cảnh báo, đưa Admin quay lại bước 3 của Main Flow và yêu cầu nhập lại.

**19. Đặc tả use case “Xóa sản phẩm”**
- Short Description: Cho phép admin xóa sản phẩm
- Actor: Admin
- Pre-Conditions: Admin đã thực hiện use case “Đăng nhập” thành công
- Post-Conditions: Admin xóa sản phẩm thành công
- Main Flow: 
1. Tại trang quản lý sản phẩm, Admin nhấn vào sản phẩm muốn xóa để xem chi tiết sản phẩm.
2. Hệ thống chuyển Admin qua trang Chi tiết sản phẩm.
3. Admin nhấn vào nút Xóa.
4. Hệ thống hiển thị thông báo xác nhận xóa sản phẩm.
5. Admin chọn Xóa.
6. Hệ thống thông báo xóa sản phẩm thành công và cập nhật cơ sở dữ liệu.
- Alternate Flow:            
5.1. Admin chọn Hủy
6.1. Hệ thống đưa Admin quay lại bước 2 của Main Flow.

**20. Đặc tả use case “Chỉnh sửa sản phẩm”**
- Short Description: Cho phép admin chỉnh sửa sản phẩm
- Actor: Admin
- Pre-Conditions: Admin đã thực hiện use case “Đăng nhập” thành công
- Post-Conditions: Admin chỉnh sửa sản phẩm thành công
- Main Flow: 
1. Tại trang quản lý sản phẩm, Admin nhấn vào sản phẩm muốn chỉnh sửa để xem chi tiết sản phẩm.
2. Hệ thống chuyển Admin qua trang Chi tiết sản phẩm.
3. Admin nhấn vào nút Sửa.
4. Hệ thống chuyển Admin qua trang Chỉnh sửa sản phẩm và hiển thị thông tin chỉnh sửa sản phẩm.
5. Admin chỉnh sửa các thông tin như: Ảnh, Tên thiết bị, Hãng sản xuất, Danh mục, Mô tả sản phẩm, Giá sản phẩm và bấm nút “Lưu”
6. Hệ thống thông báo sản phẩm đã được cập nhật thành công thành công và lưu vào cơ sở dữ liệu.
- Alternate Flow:
5.1. Admin bấm nút “Trở lại”
6.1. Hệ thống đưa Admin quay lại trang Chi tiết sản phẩm.

**21. Đặc tả use case “Quản lý doanh số sản phẩm”**
- Short Description: Cho phép admin chỉnh sửa doanh số sản phẩm
- Actor: Admin
- Pre-Conditions: Admin đã thực hiện use case “Đăng nhập” thành công
- Post-Conditions: Admin chỉnh sửa doanh số sản phẩm thành công
- Main Flow: 
1. Tại trang quản lý doanh số, Admin nhấn vào trường Nhập doanh số của sản phẩm muốn chỉnh sửa.
2. Admin chỉnh sửa doanh số sản phẩm.
3. Admin nhấn vào nút Cập nhật.
4. Hệ thống thông báo Cập nhật doanh số thành công thành công và lưu vào cơ sở dữ liệu.

**22. Đặc tả use case “Chỉnh sửa trạng thái đơn hàng”**
- Short Description: Cho phép admin chỉnh sửa trạng thái đơn hàng
- Actor: Admin
- Pre-Conditions: Admin đã thực hiện use case “Đăng nhập” thành công
- Post-Conditions: Admin chỉnh sửa trạng thái đơn hàng thành công
- Main Flow: 
1. Tại trang quản lý đơn hàng, Admin chỉnh sửa trạng thái đơn hàng và bấm nút “Cập nhật”.
2. Hệ thống thông báo Cập nhật trạng thái đơn hàng thành công và lưu vào cơ sở dữ liệu.
3. Hệ thống chuyển đơn hàng qua tab tương ứng với trạng thái đơn hàng (Đang xử lý thì vô tab Mới; Đã xác nhận đơn hàng, Shop đang chuẩn bị đơn hàng, Đang giao hàng thì vô tab Xử lý; Đã giao thành công thì vô tab Đã giao.
