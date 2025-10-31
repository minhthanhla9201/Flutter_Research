Cấu trúc source:
lib/
 ├── main.dart
 ├── config/
 │    └── api.dart               // URL API, cấu hình chung
 │    └── app_routes.dart		   // Định nghĩa route cho các màn hình
 ├── middleware/
 │    └── auth_guard.dart			// Xử lý check login
 ├── models/
 │    └── movie.dart             // Định nghĩa Movie model
 │    └── ticket.dart            // Định nghĩa Ticket model
 ├── providers/
 │    └── auth_provider.dart	  // Quản lý đăng nhập
 ├── screens/
 │    ├── home_screen.dart       // Trang danh sách banner
 │    └── login_screen.dart      // Trang login
 │    └── movie_detail_screen.dart     // Trang chi tiết phim
 ├── services/
 │    └── api_auth_service.dart	// Gọi API sử dụng cho đăng nhập từ server Node.js
 │    └── api_movie_service.dart	// Gọi API sử dụng cho movie từ server Node.js

 └── widgets/
      ├── movie_banner_slider.dart // Widget hiển thị banner phim slider (dùng thư viện carousel_slider)
      └── app_footer.dart      	// Widget hiển thị footer
      └── horizontal_movie_list.dart    // Widget hiển danh sách phim trong tab
assets/
 ├── images	// Thư mục chứa hình ảnh


Kỹ thuật sửa dụng
- Cài thêm thư viện [http] để lấy dữ liệu từ api
- Bõ comment out assets để sử dụng ảnh từ ứng dụng
- shared_preferences: lưu thông tin toàn cục cho app
- local_session_timeout: quản lý timeout dữ liệu của app (sử dụng cho timeout trong login) -> tự động logout sau khi không thao tác nữa
pubspec.yaml
	dependencies:
  		flutter:
    			sdk: flutter

  		# The following adds the Cupertino Icons font to your application.
  		# Use with the CupertinoIcons class for iOS style icons.
  		cupertino_icons: ^1.0.8
  		http: ^1.2.2
		carousel_slider: ^5.0.0
		shared_preferences: ^2.2.2
	flutter:
		assets:
    			- assets/images/

Chạy project:
	chạy lệnh sau cho android
		flutter run -d emulator-5554
	web
		flutter run -d Chrome


Server:
 Sử dụng container + NextJS (chạy trực tiếp, xóa container khi đóng)
 Bổ sung next.config.ts để có thể lấy dữ liệu từ domain khác
  async headers() {
    return [
      {
        source: '/api/:path*',
        headers: [
          { key: 'Access-Control-Allow-Origin', value: '*' },
          { key: 'Access-Control-Allow-Methods', value: 'GET, POST, PUT, DELETE, OPTIONS' },
          { key: 'Access-Control-Allow-Headers', value: 'Content-Type, Authorization' },
          { key: 'Access-Control-Allow-Credentials', value: 'true' },
        ],
      },
    ];
  }
  Thêm file middleware.ts để xử lý chung của các request
  Cài thêm thư viện để tạo id: npm install uuid

Khởi động sever
	docker run -it --rm -v "%cd%":/app -w /app -p 3000:3000 --entrypoint sh node:20-alpine
	Xóa cache: rm -rf .next
	start: npm run dev
