import 'app_strings.dart';

class AppStringsVi extends AppStrings {
  const AppStringsVi();

  @override
  bool get isEn => false;

  // ── App title ───────────────────────────────────────────────────────────────
  @override
  String get appTitle => 'Thông Tin Linh Mục';
  @override
  String get appTitleShort => 'THÔNG TIN LINH MỤC';

  // ── Bottom navigation ────────────────────────────────────────────────────────
  @override
  String get navHome => 'Trang chủ';
  @override
  String get navScanCard => 'Quét thẻ';
  @override
  String get navScanQr => 'Quét QR';
  @override
  String get navHistory => 'Lịch sử';
  @override
  String get navSettings => 'Cài đặt';

  // ── Common actions ───────────────────────────────────────────────────────────
  @override
  String get login => 'Đăng nhập';
  @override
  String get logout => 'Đăng xuất';
  @override
  String get logoutUppercase => 'ĐĂNG XUẤT';
  @override
  String get exit => 'THOÁT';
  @override
  String get search => 'TÌM KIẾM';
  @override
  String get close => 'Đóng';
  @override
  String get cancel => 'Hủy';
  @override
  String get confirm => 'Xác nhận';
  @override
  String get done => 'Xong';
  @override
  String get retry => 'THỬ LẠI';
  @override
  String get retryLower => 'Thử lại';
  @override
  String get back => 'QUAY LẠI';
  @override
  String get details => 'CHI TIẾT';
  @override
  String get approve => 'DUYỆT';
  @override
  String get reject => 'Từ chối';
  @override
  String get delete => 'Xoá';
  @override
  String get add => 'Thêm';
  @override
  String get save => 'Lưu ảnh';
  @override
  String get share => 'Chia sẻ';
  @override
  String get copy => 'Đã sao chép';
  @override
  String get callNow => 'GỌI NGAY';
  @override
  String get openSettings => 'Mở Cài đặt';
  @override
  String get select => 'Chọn';
  @override
  String get sendRequest => 'GỬI YÊU CẦU';
  @override
  String get updatePassword => 'CẬP NHẬT MẬT KHẨU';
  @override
  String get submitRequest => 'GỬI ĐỀ NGHỊ';
  @override
  String get sendSupportRequest => 'GỬI YÊU CẦU HỖ TRỢ';
  @override
  String get markAllRead => 'Đánh dấu đã đọc tất cả';

  // ── Home screen ──────────────────────────────────────────────────────────────
  @override
  String get searchPriest => 'Tìm kiếm linh mục';
  @override
  String get searchPriestHint => 'Nhập tên linh mục';
  @override
  String get searchPriestHintDots => 'Nhập tên Linh mục...';
  @override
  String get chooseDiocese => 'Chọn giáo phận';
  @override
  String get chooseDioceseAlt => 'Chọn Giáo phận';
  @override
  String get popularPriests => 'Linh mục tìm nhiều';
  @override
  String get viewAll => 'Xem tất cả';

  // Emergency card
  @override
  String get emergencyLabel => 'DÀNH CHO TRƯỜNG HỢP KHẨN CẤP';
  @override
  String get emergencyTitle => 'Liên hệ xức dầu';
  @override
  String get emergencySubtitle => 'Tìm linh mục gần nhất để cử hành bí tích';

  // Info section
  @override
  String get infoNeedToKnow => 'Thông tin cần biết';
  @override
  String get infoOfficialData => 'Dữ liệu chính thức';
  @override
  String get infoOfficialDataDesc => 'Thông tin được xác thực bởi văn phòng các Giáo phận.';
  @override
  String get infoSearchGuide => 'Hướng dẫn tìm kiếm';
  @override
  String get infoSearchGuideDesc =>
      'Sử dụng tên thánh hoặc tên thật để có kết quả chính xác nhất.';

  // Priest ID card
  @override
  String get priestIdCard => 'CĂN CƯỚC LINH MỤC';
  @override
  String get priestInfo => 'THÔNG TIN';

  // Action bar
  @override
  String get actionScanCard => 'Quét thẻ';
  @override
  String get actionMassRequest => 'Xin lễ';
  @override
  String get actionQrCode => 'Mã QR';
  @override
  String get actionFaceId => 'FaceID';

  // Mass request card (home)
  @override
  String get minutesAgo => '5 PHÚT TRƯỚC';
  @override
  String get massNotificationSample =>
      'Linh mục Phaolô Hoàng Mạnh Huy Giáo phận Phú Cường xin dâng lễ an táng.';

  // Search section (priest home)
  @override
  String get searchPriestSection => 'Tìm kiếm Linh mục';

  // Liturgical section
  @override
  String get liturgicalDay => 'NGÀY PHỤNG VỤ';
  @override
  String get feastDay => 'LỄ KÍNH / KỶ NIỆM';

  // Help button
  @override
  String get helpGuide => 'Hướng dẫn sử dụng Căn cước Linh mục';

  // ── Settings screen ──────────────────────────────────────────────────────────
  @override
  String get settingsTitle => 'Cài đặt';
  @override
  String get sectionAccountSecurity => 'TÀI KHOẢN & BẢO MẬT';
  @override
  String get sectionAppSupport => 'ỨNG DỤNG & HỖ TRỢ';
  @override
  String get menuPersonalInfo => 'Thông tin cá nhân';
  @override
  String get menuBiometrics => 'Sinh trắc học';
  @override
  String get menuChangePassword => 'Đổi mật khẩu';
  @override
  String get menuLanguage => 'Ngôn ngữ';
  @override
  String get menuUpdateRequest => 'Đề nghị cập nhật';
  @override
  String get menuSupport => 'Hỗ trợ';

  // ── Login screen ─────────────────────────────────────────────────────────────
  @override
  String get loginTitle => 'Thông Tin Linh Mục';
  @override
  String get loginSubtitle => 'ĐĂNG NHẬP LINH MỤC';
  @override
  String get loginUsernameLabel => 'TÊN ĐĂNG NHẬP HOẶC EMAIL';
  @override
  String get loginPasswordLabel => 'MẬT KHẨU';
  @override
  String get forgotPassword => 'Quên mật khẩu?';
  @override
  String get orUseNfcCard => 'HOẶC SỬ DỤNG THẺ TÁC VỤ';
  @override
  String get tapPriestCard => 'Chạm thẻ Linh mục';
  @override
  String get notAPriest => 'Không phải là Linh mục?';
  @override
  String get backToLaityHome => 'Quay lại Trang chủ Giáo dân';

  // ── Scan screen ──────────────────────────────────────────────────────────────
  @override
  String get scanQr => 'Quét mã QR';
  @override
  String get scanInstruction => 'Hướng camera vào mã QR của linh mục';
  @override
  String get scanAutoDetect => 'App sẽ tự động nhận dạng khi phát hiện mã hợp lệ';
  @override
  String get scanInvalidQr => 'Mã QR không hợp lệ hoặc chưa có dữ liệu';
  @override
  String get cameraPermissionDenied => 'Chưa cấp quyền camera';
  @override
  String get cameraCannotOpen => 'Không thể mở camera';
  @override
  String get cameraPermissionInstruction =>
      'Vào Cài đặt → Thông Tin Linh Mục\n→ Camera → bật quyền truy cập';
  @override
  String get cameraNotSupported =>
      'Thiết bị không hỗ trợ camera\nhoặc camera đang được dùng bởi app khác';

  // ── NFC screen ───────────────────────────────────────────────────────────────
  @override
  String get scanNfcCard => 'Quét thẻ NFC';
  @override
  String get touchPriestCard => 'Chạm thẻ Linh mục';
  @override
  String get nfcInstruction =>
      'Giữ thẻ NFC gần mặt sau điện thoại để xác thực danh tính linh mục.';
  @override
  String get nfcChecking => 'Đang kiểm tra NFC...';
  @override
  String get nfcNotAvailable => 'Thiết bị không hỗ trợ NFC';
  @override
  String get nfcWaiting => 'Đang chờ quét thẻ...';
  @override
  String get nfcReadSuccess => 'Đã đọc thẻ thành công!';
  @override
  String get nfcPriestNotFound => 'Không tìm thấy thông tin linh mục';
  @override
  String get nfcInvalidFormat => 'Thẻ không đúng định dạng';
  @override
  String get nfcInvalidData => 'Thẻ không chứa dữ liệu hợp lệ';
  @override
  String get nfcReadError => 'Lỗi đọc thẻ';
  @override
  String get nfcStartFailed => 'Không thể khởi động NFC';
  @override
  String get nfcNeedsDeveloper => 'Cần tài khoản Apple Developer để dùng NFC';
  @override
  String get noNfcCard => 'Không có thẻ NFC?';
  @override
  String get loginWithPassword => 'Đăng nhập bằng mật khẩu';

  // ── History screen ───────────────────────────────────────────────────────────
  @override
  String get historyTitle => 'Lịch sử hoạt động';
  @override
  String get historySubtitle => 'Theo dõi các yêu cầu và cập nhật của bạn.';
  @override
  String get historySearch => 'Tìm kiếm lịch sử...';
  @override
  String get filterAll => 'Tất cả';
  @override
  String get filterUpdate => 'Cập nhật';
  @override
  String get filterMass => 'Dâng lễ';
  @override
  String get filterContribution => 'Đóng góp';
  @override
  String get statusCompleted => 'Đã hoàn thành';
  @override
  String get statusProcessing => 'Đang xử lý';
  @override
  String get statusRejected => 'Đã từ chối';
  @override
  String get historyUpdateRequest => 'Yêu cầu cập nhật thông tin';
  @override
  String get historyMassThanksgiving => 'Xin dâng lễ tạ ơn';
  @override
  String get historyMassPeace => 'Xin dâng lễ cầu bình an';

  // ── Biometrics screen ────────────────────────────────────────────────────────
  @override
  String get biometricsTitle => 'Sinh trắc học';
  @override
  String get biometricsSecurity => 'Bảo mật sinh trắc học';
  @override
  String get biometricsDesc =>
      'Dùng Face ID hoặc vân tay để mở khóa ứng dụng nhanh và bảo mật.';
  @override
  String get sectionAuthMethod => 'PHƯƠNG THỨC XÁC THỰC';
  @override
  String get sectionLockSettings => 'CÀI ĐẶT KHÓA';
  @override
  String get faceIdSubtitle => 'Mở khóa bằng khuôn mặt';
  @override
  String get touchId => 'Vân tay (Touch ID)';
  @override
  String get touchIdSubtitle => 'Mở khóa bằng dấu vân tay';
  @override
  String get autoLock => 'Tự động khóa';
  @override
  String get autoLockSubtitle => 'Yêu cầu xác thực khi mở lại app';
  @override
  String get faceIdEnabled => 'Face ID đã bật';
  @override
  String get touchIdEnabled => 'Touch ID đã bật';
  @override
  String get biometricsNote =>
      'Sinh trắc học sử dụng phần cứng bảo mật của thiết bị. Dữ liệu vân tay / Face ID không được lưu trữ trên máy chủ.';

  // ── Change password ──────────────────────────────────────────────────────────
  @override
  String get changePasswordTitle => 'Đổi mật khẩu';
  @override
  String get accountSecurity => 'Bảo mật tài khoản';
  @override
  String get passwordRequirements =>
      'Mật khẩu nên có ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường và số.';
  @override
  String get currentPassword => 'Mật khẩu hiện tại';
  @override
  String get currentPasswordHint => 'Nhập mật khẩu đang dùng';
  @override
  String get newPassword => 'Mật khẩu mới';
  @override
  String get newPasswordHint => 'Tối thiểu 8 ký tự';
  @override
  String get confirmNewPassword => 'Xác nhận mật khẩu mới';
  @override
  String get confirmPasswordHint => 'Nhập lại mật khẩu mới';
  @override
  String get passwordChangedSuccess => 'Đổi mật khẩu thành công!';
  @override
  String get passwordChangedDesc =>
      'Mật khẩu mới của vị đã được cập nhật. Vui lòng sử dụng mật khẩu mới cho lần đăng nhập tiếp theo.';
  @override
  String get validCurrentPasswordRequired => 'Vui lòng nhập mật khẩu hiện tại';
  @override
  String get validPasswordTooShort => 'Mật khẩu quá ngắn';
  @override
  String get validNewPasswordRequired => 'Vui lòng nhập mật khẩu mới';
  @override
  String get validPasswordMin8 => 'Mật khẩu phải có ít nhất 8 ký tự';
  @override
  String get validPasswordSameAsCurrent => 'Mật khẩu mới phải khác mật khẩu cũ';
  @override
  String get validConfirmRequired => 'Vui lòng xác nhận mật khẩu mới';
  @override
  String get validConfirmMismatch => 'Mật khẩu xác nhận không khớp';

  // ── Notifications screen ─────────────────────────────────────────────────────
  @override
  String get notificationsTitle => 'Thông báo';
  @override
  String get notifLatest => 'MỚI NHẤT';

  // ── Personal info screen ─────────────────────────────────────────────────────
  @override
  String get personalInfoTitle => 'Thông tin cá nhân';
  @override
  String get holyName => 'TÊN THÁNH';
  @override
  String get activeStatus => 'Đang hoạt động';
  @override
  String get sectionIdentity => 'THÔNG TIN ĐỊNH DANH';
  @override
  String get sectionPersonal => 'THÔNG TIN CÁ NHÂN';
  @override
  String get sectionContact => 'LIÊN LẠC';
  @override
  String get fieldId => 'Mã định danh';
  @override
  String get fieldDiocese => 'Giáo phận';
  @override
  String get fieldParish => 'Giáo xứ';
  @override
  String get fieldRole => 'Chức vụ';
  @override
  String get fieldBirthDate => 'Ngày sinh';
  @override
  String get fieldOrdinationDate => 'Ngày thụ phong';
  @override
  String get fieldDegree => 'Học vị';
  @override
  String get fieldEmail => 'Email';
  @override
  String get fieldPhone => 'Điện thoại';
  @override
  String get copiedValue => 'Đã sao chép';
  @override
  String get personalInfoNote =>
      'Để cập nhật thông tin cá nhân, vui lòng gửi "Đề nghị cập nhật" hoặc liên hệ văn phòng Giáo phận.';

  // ── Priest profile screen ────────────────────────────────────────────────────
  @override
  String get priestIdCode => 'MÃ ĐỊNH DANH';
  @override
  String get dioceseLabel => 'GIÁO PHẬN';
  @override
  String get sectionDetailedInfo => 'THÔNG TIN CHI TIẾT';
  @override
  String get sectionWorkHistory => 'LỊCH SỬ CÔNG TÁC';
  @override
  String get sectionUpdateHistory => 'LỊCH SỬ CẬP NHẬT';
  @override
  String get labelBirthDate => 'Ngày sinh';
  @override
  String get labelOrdination => 'Thụ phong';
  @override
  String get labelCurrentParish => 'Giáo xứ hiện tại';
  @override
  String get labelDegree => 'Học hàm/Học vị';
  @override
  String get labelEmail => 'Email liên hệ';
  @override
  String get qrIdCode => 'Mã QR định danh';
  @override
  String get qrIdCodeModal => 'Mã QR Định Danh';
  @override
  String get qrUsageDesc =>
      'Sử dụng mã này để quét tại các cổng\nkiểm soát giáo phận hoặc xác thực quyền hành lễ.';
  @override
  String get updateRoleNew => 'Cập nhật chức vụ mới';
  @override
  String get updateContactChange => 'Thay đổi địa chỉ liên lạc';
  @override
  String get toPresent => 'Nay';
  @override
  String get vicePriest => 'Phó xứ';
  @override
  String get parishOf => 'Giáo xứ';

  // ── Priest result sheet ──────────────────────────────────────────────────────
  @override
  String get verified => 'Đã xác thực';
  @override
  String get sectionBasicInfo => 'THÔNG TIN CƠ BẢN';
  @override
  String get birthAndOrdination => 'Ngày sinh & Thụ phong';
  @override
  String get ordinationPrefix => 'Thụ phong:';
  @override
  String get callPhone => 'Gọi điện';
  @override
  String get sendEmail => 'Email';
  @override
  String get idCode => 'Mã số:';

  // ── QR screen ────────────────────────────────────────────────────────────────
  @override
  String get qrScreenTitle => 'Mã QR Định danh';
  @override
  String get identityVerified => 'ĐÃ XÁC THỰC DANH TÍNH';
  @override
  String get qrIdNumber => 'Mã định danh:';
  @override
  String get qrUsageNote =>
      'SỬ DỤNG MÃ QR NÀY ĐỂ ĐIỂM DANH HOẶC CHIA SẺ THÔNG TIN MỤC VỤ CHÍNH THỨC.';

  // ── Search detail screen ─────────────────────────────────────────────────────
  @override
  String get priestInfoTitle => 'Thông tin linh mục';
  @override
  String get noData => 'Không có dữ liệu';
  @override
  String get copiedPhone => 'Đã sao chép số điện thoại';
  @override
  String get copiedEmail => 'Đã sao chép email';
  @override
  String get callAction => 'GỌI ĐIỆN';
  @override
  String get emailAction => 'GỬI EMAIL';
  @override
  String get birthAndOrdinationLabel => 'Ngày sinh & Thụ phong';
  @override
  String get currentParishLabel => 'Giáo xứ hiện tại';
  @override
  String get degreeLabel => 'Học vị';
  @override
  String get roleLabel => 'Chức vụ';

  // ── Search results screen ─────────────────────────────────────────────────────
  @override
  String get searchResultsTitle => 'Kết quả tìm kiếm';
  @override
  String get allResults => 'Tất cả';
  @override
  String get resultCount => 'kết quả';
  @override
  String get noResultsTitle => 'Không tìm thấy linh mục';
  @override
  String get noResultsDesc => 'Thử tìm kiếm với tên khác hoặc\nthay đổi giáo phận.';
  @override
  String get resetPasswordAction => 'Reset MK';
  @override
  String get nfcCardAction => 'Thẻ NFC';
  @override
  String get massRequestAction => 'Xin lễ';
  @override
  String get resetPasswordTitle => 'Reset mật khẩu?';
  @override
  String get resetPasswordDesc =>
      'Mật khẩu sẽ được đặt lại về mặc định. Linh mục cần đổi mật khẩu khi đăng nhập lại.';
  @override
  String resetPasswordConfirm(String holyName, String fullName) =>
      'Đã reset mật khẩu cho LM. $holyName $fullName';

  // ── Mass request screen ──────────────────────────────────────────────────────
  @override
  String get massRequestTitle => 'Xin dâng lễ';
  @override
  String get massRequestSubtitle => 'Gửi yêu cầu xin dâng thánh lễ';
  @override
  String get massFor => 'XIN LỄ CHO';
  @override
  String get massType => 'LOẠI LỄ';
  @override
  String get scheduledTime => 'THỜI GIAN DỰ KIẾN';
  @override
  String get location => 'ĐỊA ĐIỂM';
  @override
  String get locationHint => 'Nhập tên giáo xứ hoặc địa điểm...';
  @override
  String get intentionNote => 'Ý CHỈ / GHI CHÚ';
  @override
  String get intentionHint => 'Nhập ý chỉ dâng lễ...';
  @override
  String get massRequestSent => 'Đã gửi yêu cầu!';
  @override
  String get massRequestSentDesc =>
      'Yêu cầu dâng lễ của vị đã được gửi đến văn phòng giáo phận. Chúng tôi sẽ xác nhận sớm nhất.';
  @override
  String get massThanksgiving => 'Tạ ơn';
  @override
  String get massPeace => 'Cầu bình an';
  @override
  String get massFuneral => 'An táng';
  @override
  String get massWedding => 'Hôn phối';
  @override
  String get massOther => 'Khác';

  // Weekdays
  @override
  String get monday => 'Thứ Hai';
  @override
  String get tuesday => 'Thứ Ba';
  @override
  String get wednesday => 'Thứ Tư';
  @override
  String get thursday => 'Thứ Năm';
  @override
  String get friday => 'Thứ Sáu';
  @override
  String get saturday => 'Thứ Bảy';
  @override
  String get sunday => 'Chúa Nhật';
  @override
  List<String> get weekdays => [monday, tuesday, wednesday, thursday, friday, saturday, sunday];

  // Mass request detail
  @override
  String get massDetailTitle => 'Chi tiết yêu cầu';
  @override
  String get massNewRequest => 'YÊU CẦU MỚI';
  @override
  String get massNewRequestDesc => 'Yêu cầu dâng lễ từ linh mục khác cần được duyệt.';
  @override
  String get sectionSenderInfo => 'THÔNG TIN LINH MỤC GỬI YÊU CẦU';
  @override
  String get sectionMassDetails => 'CHI TIẾT DÂNG LỄ';
  @override
  String get massTypeLabel => 'LOẠI LỄ';
  @override
  String get estimatedTime => 'THỜI GIAN DỰ KIẾN';
  @override
  String get intentionLabel => 'Ý CHỈ / GHI CHÚ';
  @override
  String get approveRequest => 'Duyệt yêu cầu';
  @override
  String get senderNameLabel => 'TÊN THÁNH & HỌ TÊN';
  @override
  String get currentParishContact => 'GIÁO XỨ HIỆN TẠI';
  @override
  String get phoneContact => 'SỐ ĐIỆN THOẠI LIÊN HỆ';

  // ── NFC management screen ─────────────────────────────────────────────────────
  @override
  String get nfcManagementTitle => 'Quản lý thẻ NFC';
  @override
  String get registeredCards => 'DANH SÁCH THẺ ĐÃ ĐĂNG KÝ';
  @override
  String get addCard => 'Thêm thẻ';
  @override
  String get addNfcCard => 'Thêm thẻ NFC';
  @override
  String get addNfcCardTitle => 'Thêm thẻ NFC';
  @override
  String get addNfcCardDesc => 'Nhập mã thẻ NFC hoặc chạm thẻ vào điện thoại.';
  @override
  String get nfcCardHint => 'VD: NFC-ABC123';
  @override
  String get scanNfcCardButton => 'Quét thẻ NFC';
  @override
  String get noNfcCards => 'Chưa có thẻ NFC';
  @override
  String get noNfcCardsDesc => 'Nhấn "Thêm thẻ" để đăng ký\nthẻ NFC cho linh mục này.';
  @override
  String get cardActive => 'Hoạt động';
  @override
  String get cardInactive => 'Tắt';
  @override
  String get addedOn => 'Thêm ngày';
  @override
  String get deleteNfcCard => 'Xoá thẻ NFC?';
  @override
  String deleteNfcCardDesc(String id) =>
      'Thẻ "$id" sẽ bị xoá khỏi hệ thống. Linh mục sẽ không thể dùng thẻ này để xác thực.';
  @override
  String cardCount(int n) => '$n thẻ';
  @override
  String cardAdded(String id) => 'Đã thêm thẻ $id';
  @override
  String cardDeleted(String id) => 'Đã xoá thẻ $id';

  // ── Emergency anointing screen ────────────────────────────────────────────────
  @override
  String get emergencyBadge => 'KHẨN CẤP';
  @override
  String get emergencyAnointingTitle => 'Liên hệ Xức Dầu';
  @override
  String get emergencyAnointingSubtitle => 'Tìm linh mục gần nhất để cử hành bí tích';
  @override
  String get locating => 'Đang xác định vị trí...';
  @override
  String get locatingDesc => 'Hệ thống đang tìm nhà thờ\ngần nhất trong bán kính 10km';
  @override
  String nearbyChurchesFound(int n) => 'Tìm thấy $n nhà thờ';
  @override
  String get nearbyRadius => 'Trong bán kính 10km từ vị trí của bạn';
  @override
  String get nearestChurches => 'NHÀ THỜ GẦN NHẤT';
  @override
  String get nearest => 'GẦN NHẤT';
  @override
  String get noChurchFound => 'Không tìm thấy nhà thờ';
  @override
  String get noChurchFoundDesc =>
      'Không có nhà thờ nào trong bán kính 10km.\nVui lòng liên hệ trực tiếp với giáo phận.';
  @override
  String get locationPermissionRequired => 'Cần quyền truy cập vị trí';
  @override
  String get locationPermissionDesc =>
      'Vào Cài đặt → Thông Tin Linh Mục\n→ Vị trí → Cho phép khi dùng app';
  @override
  String get cannotGetLocation => 'Không lấy được vị trí';
  @override
  String get cannotGetLocationDesc => 'Hãy đảm bảo GPS đang bật\nvà thử lại.';
  @override
  String cannotCall(String phone) => 'Không thể gọi $phone';

  // ── Help screen ───────────────────────────────────────────────────────────────
  @override
  String get helpTitle => 'Hướng dẫn sử dụng';
  @override
  String get helpWelcome => 'Chào mừng Linh mục,';
  @override
  String get helpWelcomeDesc =>
      'Hệ thống Căn cước Linh mục kỹ thuật số giúp việc quản lý mục vụ và kết nối trong giáo hội trở nên thuận tiện và bảo mật hơn bao giờ hết.';
  @override
  String get helpNeedMore => 'CẦN HỖ TRỢ THÊM?';
  @override
  String get helpNeedMoreDesc =>
      'Nếu vị cần được hướng dẫn trực tiếp hoặc gặp sự cố kỹ thuật, vui lòng liên hệ Ban Truyền thông Giáo phận.';
  @override
  String get helpNfcTitle => 'Xác thực NFC';
  @override
  String get helpNfcDesc =>
      'Công nghệ bảo mật cao nhất bằng cách chạm thẻ linh mục vào mặt sau điện thoại để xác thực danh tính chính thức.';
  @override
  String get helpQrTitle => 'Mã QR Định danh';
  @override
  String get helpQrDesc =>
      'Mỗi linh mục có một mã QR riêng. Quét mã để chia sẻ thông tin liên lạc nhanh chóng hoặc điểm danh tại các sự kiện giáo hội.';
  @override
  String get helpMassTitle => 'Quản lý Xin lễ';
  @override
  String get helpMassDesc =>
      'Gửi yêu cầu dâng lễ trực tuyến đến văn phòng giáo phận hoặc nhận và duyệt các yêu cầu dâng lễ từ giáo dân gửi đến.';
  @override
  String get helpNotifTitle => 'Hệ thống Thông báo';
  @override
  String get helpNotifDesc =>
      'Luôn cập nhật các thông báo khẩn, nhắc lịch công tác và tin tức quan trọng từ Giáo phận thông qua trung tâm thông báo.';
  @override
  String get helpSearchTitle => 'Tìm kiếm Linh mục';
  @override
  String get helpSearchDesc =>
      'Dễ dàng tra cứu thông tin liên lạc và chức vụ của các linh mục trong hệ thống Digital Ecclesia toàn quốc.';
  @override
  String get helpBioTitle => 'Bảo mật Sinh trắc học';
  @override
  String get helpBioDesc =>
      'Sử dụng FaceID hoặc Fingerprint để bảo vệ ứng dụng, đảm bảo chỉ chính chủ mới có thể truy cập thông tin nhạy cảm.';

  // ── Update request screen ─────────────────────────────────────────────────────
  @override
  String get updateRequestTitle => 'Đề nghị cập nhật';
  @override
  String get updateRequestBannerTitle => 'Yêu cầu cập nhật hồ sơ';
  @override
  String get updateRequestBannerDesc =>
      'Mô tả thông tin cần thay đổi. Ban Quản trị sẽ xác minh và cập nhật trong hệ thống.';
  @override
  String get infoTypeLabel => 'LOẠI THÔNG TIN';
  @override
  String get requestContentLabel => 'NỘI DUNG ĐỀ NGHỊ';
  @override
  String get requestContentHint =>
      'Ví dụ: Cập nhật giáo xứ từ "Giáo xứ A" sang "Giáo xứ B" kể từ ngày 01/01/2025...';
  @override
  String get processTitle => 'QUY TRÌNH XỬ LÝ';
  @override
  String get step1 => 'Gửi đề nghị → Ban Quản trị nhận được';
  @override
  String get step2 => 'Xác minh thông tin (1–2 ngày làm việc)';
  @override
  String get step3 => 'Cập nhật hệ thống và thông báo cho vị';
  @override
  String get requestSent => 'Đã gửi đề nghị!';
  @override
  String get requestSentDesc =>
      'Đề nghị cập nhật của vị đã được gửi đến Ban Quản trị. Chúng tôi sẽ xem xét và phản hồi trong vòng 3–5 ngày làm việc.';
  @override
  String get catPersonalInfo => 'Thông tin cá nhân';
  @override
  String get catParishDiocese => 'Giáo xứ / Giáo phận';
  @override
  String get catDegreeRole => 'Học vị / Chức vụ';
  @override
  String get catBirthOrdination => 'Ngày sinh / Thụ phong';
  @override
  String get catEmailPhone => 'Email / Điện thoại';
  @override
  String get catOther => 'Khác';
  @override
  String get validContentRequired => 'Vui lòng mô tả nội dung cần cập nhật';
  @override
  String get validContentTooShort => 'Vui lòng mô tả chi tiết hơn (tối thiểu 10 ký tự)';

  // ── Language screen ──────────────────────────────────────────────────────────
  @override
  String get languageTitle => 'Ngôn ngữ';
  @override
  String get chooseLanguage => 'Chọn ngôn ngữ';
  @override
  String get languageSupportDesc =>
      'Ngôn ngữ hiển thị trên toàn bộ ứng dụng. Hỗ trợ Tiếng Việt và English.';
  @override
  String get availableLanguages => 'NGÔN NGỮ CÓ SẴN';
  @override
  String get comingSoon => 'Sắp ra mắt';
  @override
  String languageSwitched(String name) => 'Đã chuyển sang $name';
  @override
  String get languageChanged => 'Đã cập nhật ngôn ngữ!';

  // ── Translation methods — return input unchanged ─────────────────────────────
  @override
  String translateLiturgicalDate(String viDate) => viDate;
  @override
  String translateLiturgicalSeason(String viSeason) => viSeason;
  @override
  String translateFeast(String viFeast) => viFeast;
  @override
  String translateReadingLabel(String viLabel) => viLabel;
  @override
  String translateReadingText(String viText) => viText;
  @override
  String translateMassType(String viType) => viType;
  @override
  String translateHolyName(String name) => name;
  @override
  String translateDiocese(String diocese) => diocese;
  @override
  String translateRole(String role) => role;
  @override
  String translateDegree(String degree) => degree;
}
