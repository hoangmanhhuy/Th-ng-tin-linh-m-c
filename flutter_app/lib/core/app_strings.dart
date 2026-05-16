import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/language_provider.dart';

class AppStrings {
  final bool isEn;
  const AppStrings(this.isEn);

  static AppStrings of(BuildContext context) {
    final lang = context.watch<LanguageProvider>().languageCode;
    return AppStrings(lang == 'en');
  }

  // ── App title ───────────────────────────────────────────────────────────────
  String get appTitle => isEn ? 'Priest Information' : 'Thông Tin Linh Mục';
  String get appTitleShort => isEn ? 'PRIEST INFO' : 'THÔNG TIN LINH MỤC';

  // ── Bottom navigation ────────────────────────────────────────────────────────
  String get navHome => isEn ? 'Home' : 'Trang chủ';
  String get navScanCard => isEn ? 'Scan Card' : 'Quét thẻ';
  String get navScanQr => isEn ? 'Scan QR' : 'Quét QR';
  String get navHistory => isEn ? 'History' : 'Lịch sử';
  String get navSettings => isEn ? 'Settings' : 'Cài đặt';

  // ── Common actions ───────────────────────────────────────────────────────────
  String get login => isEn ? 'Sign In' : 'Đăng nhập';
  String get logout => isEn ? 'Sign Out' : 'Đăng xuất';
  String get logoutUppercase => isEn ? 'SIGN OUT' : 'ĐĂNG XUẤT';
  String get exit => isEn ? 'EXIT' : 'THOÁT';
  String get search => isEn ? 'SEARCH' : 'TÌM KIẾM';
  String get close => isEn ? 'Close' : 'Đóng';
  String get cancel => isEn ? 'Cancel' : 'Hủy';
  String get confirm => isEn ? 'Confirm' : 'Xác nhận';
  String get done => isEn ? 'Done' : 'Xong';
  String get retry => isEn ? 'RETRY' : 'THỬ LẠI';
  String get retryLower => isEn ? 'Try again' : 'Thử lại';
  String get back => isEn ? 'BACK' : 'QUAY LẠI';
  String get details => isEn ? 'DETAILS' : 'CHI TIẾT';
  String get approve => isEn ? 'APPROVE' : 'DUYỆT';
  String get reject => isEn ? 'Reject' : 'Từ chối';
  String get delete => isEn ? 'Delete' : 'Xoá';
  String get add => isEn ? 'Add' : 'Thêm';
  String get save => isEn ? 'Save image' : 'Lưu ảnh';
  String get share => isEn ? 'Share' : 'Chia sẻ';
  String get copy => isEn ? 'Copied' : 'Đã sao chép';
  String get callNow => isEn ? 'CALL NOW' : 'GỌI NGAY';
  String get openSettings => isEn ? 'Open Settings' : 'Mở Cài đặt';
  String get select => isEn ? 'Select' : 'Chọn';
  String get sendRequest => isEn ? 'SEND REQUEST' : 'GỬI YÊU CẦU';
  String get updatePassword => isEn ? 'UPDATE PASSWORD' : 'CẬP NHẬT MẬT KHẨU';
  String get submitRequest => isEn ? 'SUBMIT REQUEST' : 'GỬI ĐỀ NGHỊ';
  String get sendSupportRequest => isEn ? 'SEND SUPPORT REQUEST' : 'GỬI YÊU CẦU HỖ TRỢ';
  String get markAllRead => isEn ? 'Mark all as read' : 'Đánh dấu đã đọc tất cả';

  // ── Home screen ──────────────────────────────────────────────────────────────
  String get searchPriest => isEn ? 'Find a Priest' : 'Tìm kiếm linh mục';
  String get searchPriestHint => isEn ? 'Enter priest name' : 'Nhập tên linh mục';
  String get searchPriestHintDots => isEn ? 'Enter priest name...' : 'Nhập tên Linh mục...';
  String get chooseDiocese => isEn ? 'Choose Diocese' : 'Chọn giáo phận';
  String get chooseDioceseAlt => isEn ? 'Choose Diocese' : 'Chọn Giáo phận';
  String get popularPriests => isEn ? 'Popular Priests' : 'Linh mục tìm nhiều';
  String get viewAll => isEn ? 'View all' : 'Xem tất cả';

  // Emergency card
  String get emergencyLabel => isEn ? 'FOR EMERGENCY CASES' : 'DÀNH CHO TRƯỜNG HỢP KHẨN CẤP';
  String get emergencyTitle => isEn ? 'Emergency Anointing' : 'Liên hệ xức dầu';
  String get emergencySubtitle => isEn ? 'Find the nearest priest to celebrate the sacrament' : 'Tìm linh mục gần nhất để cử hành bí tích';

  // Info section
  String get infoNeedToKnow => isEn ? 'Information' : 'Thông tin cần biết';
  String get infoOfficialData => isEn ? 'Official Data' : 'Dữ liệu chính thức';
  String get infoOfficialDataDesc => isEn ? 'Information verified by diocesan offices.' : 'Thông tin được xác thực bởi văn phòng các Giáo phận.';
  String get infoSearchGuide => isEn ? 'Search Guide' : 'Hướng dẫn tìm kiếm';
  String get infoSearchGuideDesc => isEn ? 'Use the holy name or full name for the most accurate results.' : 'Sử dụng tên thánh hoặc tên thật để có kết quả chính xác nhất.';

  // Priest ID card
  String get priestIdCard => isEn ? 'PRIEST ID CARD' : 'CĂN CƯỚC LINH MỤC';
  String get priestInfo => isEn ? 'INFO' : 'THÔNG TIN';

  // Action bar
  String get actionScanCard => isEn ? 'Scan Card' : 'Quét thẻ';
  String get actionMassRequest => isEn ? 'Mass Req.' : 'Xin lễ';
  String get actionQrCode => isEn ? 'QR Code' : 'Mã QR';
  String get actionFaceId => isEn ? 'Face ID' : 'FaceID';

  // Mass request card (home)
  String get minutesAgo => isEn ? '5 MINUTES AGO' : '5 PHÚT TRƯỚC';
  String get massNotificationSample => isEn
      ? 'Fr. Paul Hoang Manh Huy, Diocese of Phu Cuong, requests a Funeral Mass.'
      : 'Linh mục Phaolô Hoàng Mạnh Huy Giáo phận Phú Cường xin dâng lễ an táng.';

  // Search section (priest home)
  String get searchPriestSection => isEn ? 'Search Priest' : 'Tìm kiếm Linh mục';

  // Liturgical section
  String get liturgicalDay => isEn ? 'LITURGICAL DAY' : 'NGÀY PHỤNG VỤ';
  String get feastDay => isEn ? 'FEAST / MEMORIAL' : 'LỄ KÍNH / KỶ NIỆM';

  // Help button
  String get helpGuide => isEn ? 'Priest ID Card User Guide' : 'Hướng dẫn sử dụng Căn cước Linh mục';

  // ── Settings screen ──────────────────────────────────────────────────────────
  String get settingsTitle => isEn ? 'Settings' : 'Cài đặt';
  String get sectionAccountSecurity => isEn ? 'ACCOUNT & SECURITY' : 'TÀI KHOẢN & BẢO MẬT';
  String get sectionAppSupport => isEn ? 'APP & SUPPORT' : 'ỨNG DỤNG & HỖ TRỢ';
  String get menuPersonalInfo => isEn ? 'Personal Info' : 'Thông tin cá nhân';
  String get menuBiometrics => isEn ? 'Biometrics' : 'Sinh trắc học';
  String get menuChangePassword => isEn ? 'Change Password' : 'Đổi mật khẩu';
  String get menuLanguage => isEn ? 'Language' : 'Ngôn ngữ';
  String get menuUpdateRequest => isEn ? 'Request Update' : 'Đề nghị cập nhật';
  String get menuSupport => isEn ? 'Support' : 'Hỗ trợ';

  // ── Login screen ─────────────────────────────────────────────────────────────
  String get loginTitle => isEn ? 'Priest Information' : 'Thông Tin Linh Mục';
  String get loginSubtitle => isEn ? 'PRIEST SIGN IN' : 'ĐĂNG NHẬP LINH MỤC';
  String get loginUsernameLabel => isEn ? 'USERNAME OR EMAIL' : 'TÊN ĐĂNG NHẬP HOẶC EMAIL';
  String get loginPasswordLabel => isEn ? 'PASSWORD' : 'MẬT KHẨU';
  String get forgotPassword => isEn ? 'Forgot password?' : 'Quên mật khẩu?';
  String get orUseNfcCard => isEn ? 'OR USE YOUR MINISTRY CARD' : 'HOẶC SỬ DỤNG THẺ TÁC VỤ';
  String get tapPriestCard => isEn ? 'Tap Priest Card' : 'Chạm thẻ Linh mục';
  String get notAPriest => isEn ? 'Not a priest?' : 'Không phải là Linh mục?';
  String get backToLaityHome => isEn ? 'Back to Laity Home' : 'Quay lại Trang chủ Giáo dân';

  // ── Scan screen ──────────────────────────────────────────────────────────────
  String get scanQr => isEn ? 'Scan QR Code' : 'Quét mã QR';
  String get scanInstruction => isEn ? 'Point camera at the priest\'s QR code' : 'Hướng camera vào mã QR của linh mục';
  String get scanAutoDetect => isEn ? 'The app will automatically detect a valid code' : 'App sẽ tự động nhận dạng khi phát hiện mã hợp lệ';
  String get scanInvalidQr => isEn ? 'Invalid or unrecognized QR code' : 'Mã QR không hợp lệ hoặc chưa có dữ liệu';
  String get cameraPermissionDenied => isEn ? 'Camera permission denied' : 'Chưa cấp quyền camera';
  String get cameraCannotOpen => isEn ? 'Cannot open camera' : 'Không thể mở camera';
  String get cameraPermissionInstruction => isEn ? 'Go to Settings → Priest Info\n→ Camera → allow access' : 'Vào Cài đặt → Thông Tin Linh Mục\n→ Camera → bật quyền truy cập';
  String get cameraNotSupported => isEn ? 'Device does not support camera\nor camera is in use by another app' : 'Thiết bị không hỗ trợ camera\nhoặc camera đang được dùng bởi app khác';

  // ── NFC screen ───────────────────────────────────────────────────────────────
  String get scanNfcCard => isEn ? 'Scan NFC Card' : 'Quét thẻ NFC';
  String get touchPriestCard => isEn ? 'Touch Priest Card' : 'Chạm thẻ Linh mục';
  String get nfcInstruction => isEn ? 'Hold the NFC card near the back of the phone to verify priest identity.' : 'Giữ thẻ NFC gần mặt sau điện thoại để xác thực danh tính linh mục.';
  String get nfcChecking => isEn ? 'Checking NFC...' : 'Đang kiểm tra NFC...';
  String get nfcNotAvailable => isEn ? 'NFC not available on this device' : 'Thiết bị không hỗ trợ NFC';
  String get nfcWaiting => isEn ? 'Waiting for card...' : 'Đang chờ quét thẻ...';
  String get nfcReadSuccess => isEn ? 'Card read successfully!' : 'Đã đọc thẻ thành công!';
  String get nfcPriestNotFound => isEn ? 'Priest information not found' : 'Không tìm thấy thông tin linh mục';
  String get nfcInvalidFormat => isEn ? 'Card format not recognized' : 'Thẻ không đúng định dạng';
  String get nfcInvalidData => isEn ? 'Card contains no valid data' : 'Thẻ không chứa dữ liệu hợp lệ';
  String get nfcReadError => isEn ? 'Card read error' : 'Lỗi đọc thẻ';
  String get nfcStartFailed => isEn ? 'Cannot start NFC' : 'Không thể khởi động NFC';
  String get nfcNeedsDeveloper => isEn ? 'Apple Developer account required for NFC' : 'Cần tài khoản Apple Developer để dùng NFC';
  String get noNfcCard => isEn ? 'No NFC card?' : 'Không có thẻ NFC?';
  String get loginWithPassword => isEn ? 'Sign in with password' : 'Đăng nhập bằng mật khẩu';

  // ── History screen ───────────────────────────────────────────────────────────
  String get historyTitle => isEn ? 'Activity History' : 'Lịch sử hoạt động';
  String get historySubtitle => isEn ? 'Track your requests and updates.' : 'Theo dõi các yêu cầu và cập nhật của bạn.';
  String get historySearch => isEn ? 'Search history...' : 'Tìm kiếm lịch sử...';
  String get filterAll => isEn ? 'All' : 'Tất cả';
  String get filterUpdate => isEn ? 'Update' : 'Cập nhật';
  String get filterMass => isEn ? 'Mass' : 'Dâng lễ';
  String get filterContribution => isEn ? 'Contribution' : 'Đóng góp';
  // History item statuses
  String get statusCompleted => isEn ? 'Completed' : 'Đã hoàn thành';
  String get statusProcessing => isEn ? 'Processing' : 'Đang xử lý';
  String get statusRejected => isEn ? 'Rejected' : 'Đã từ chối';
  // History item titles
  String get historyUpdateRequest => isEn ? 'Information update request' : 'Yêu cầu cập nhật thông tin';
  String get historyMassThanksgiving => isEn ? 'Mass of Thanksgiving request' : 'Xin dâng lễ tạ ơn';
  String get historyMassPeace => isEn ? 'Mass for Peace request' : 'Xin dâng lễ cầu bình an';

  // ── Biometrics screen ────────────────────────────────────────────────────────
  String get biometricsTitle => isEn ? 'Biometrics' : 'Sinh trắc học';
  String get biometricsSecurity => isEn ? 'Biometric Security' : 'Bảo mật sinh trắc học';
  String get biometricsDesc => isEn ? 'Use Face ID or fingerprint to unlock the app quickly and securely.' : 'Dùng Face ID hoặc vân tay để mở khóa ứng dụng nhanh và bảo mật.';
  String get sectionAuthMethod => isEn ? 'AUTHENTICATION METHOD' : 'PHƯƠNG THỨC XÁC THỰC';
  String get sectionLockSettings => isEn ? 'LOCK SETTINGS' : 'CÀI ĐẶT KHÓA';
  String get faceIdSubtitle => isEn ? 'Unlock with face recognition' : 'Mở khóa bằng khuôn mặt';
  String get touchId => isEn ? 'Fingerprint (Touch ID)' : 'Vân tay (Touch ID)';
  String get touchIdSubtitle => isEn ? 'Unlock with fingerprint' : 'Mở khóa bằng dấu vân tay';
  String get autoLock => isEn ? 'Auto Lock' : 'Tự động khóa';
  String get autoLockSubtitle => isEn ? 'Require authentication when reopening app' : 'Yêu cầu xác thực khi mở lại app';
  String get faceIdEnabled => isEn ? 'Face ID enabled' : 'Face ID đã bật';
  String get touchIdEnabled => isEn ? 'Touch ID enabled' : 'Touch ID đã bật';
  String get biometricsNote => isEn ? 'Biometrics use the device\'s secure hardware. Fingerprint / Face ID data is never stored on the server.' : 'Sinh trắc học sử dụng phần cứng bảo mật của thiết bị. Dữ liệu vân tay / Face ID không được lưu trữ trên máy chủ.';

  // ── Change password ──────────────────────────────────────────────────────────
  String get changePasswordTitle => isEn ? 'Change Password' : 'Đổi mật khẩu';
  String get accountSecurity => isEn ? 'Account Security' : 'Bảo mật tài khoản';
  String get passwordRequirements => isEn ? 'Password must be at least 8 characters, including uppercase, lowercase, and numbers.' : 'Mật khẩu nên có ít nhất 8 ký tự, bao gồm chữ hoa, chữ thường và số.';
  String get currentPassword => isEn ? 'Current Password' : 'Mật khẩu hiện tại';
  String get currentPasswordHint => isEn ? 'Enter your current password' : 'Nhập mật khẩu đang dùng';
  String get newPassword => isEn ? 'New Password' : 'Mật khẩu mới';
  String get newPasswordHint => isEn ? 'Minimum 8 characters' : 'Tối thiểu 8 ký tự';
  String get confirmNewPassword => isEn ? 'Confirm New Password' : 'Xác nhận mật khẩu mới';
  String get confirmPasswordHint => isEn ? 'Re-enter new password' : 'Nhập lại mật khẩu mới';
  String get passwordChangedSuccess => isEn ? 'Password changed successfully!' : 'Đổi mật khẩu thành công!';
  String get passwordChangedDesc => isEn ? 'Your new password has been updated. Please use the new password for your next sign in.' : 'Mật khẩu mới của vị đã được cập nhật. Vui lòng sử dụng mật khẩu mới cho lần đăng nhập tiếp theo.';
  // Validators
  String get validCurrentPasswordRequired => isEn ? 'Please enter your current password' : 'Vui lòng nhập mật khẩu hiện tại';
  String get validPasswordTooShort => isEn ? 'Password is too short' : 'Mật khẩu quá ngắn';
  String get validNewPasswordRequired => isEn ? 'Please enter a new password' : 'Vui lòng nhập mật khẩu mới';
  String get validPasswordMin8 => isEn ? 'Password must be at least 8 characters' : 'Mật khẩu phải có ít nhất 8 ký tự';
  String get validPasswordSameAsCurrent => isEn ? 'New password must differ from the current one' : 'Mật khẩu mới phải khác mật khẩu cũ';
  String get validConfirmRequired => isEn ? 'Please confirm your new password' : 'Vui lòng xác nhận mật khẩu mới';
  String get validConfirmMismatch => isEn ? 'Passwords do not match' : 'Mật khẩu xác nhận không khớp';

  // ── Notifications screen ─────────────────────────────────────────────────────
  String get notificationsTitle => isEn ? 'Notifications' : 'Thông báo';
  String get notifLatest => isEn ? 'LATEST' : 'MỚI NHẤT';

  // ── Personal info screen ─────────────────────────────────────────────────────
  String get personalInfoTitle => isEn ? 'Personal Info' : 'Thông tin cá nhân';
  String get holyName => isEn ? 'HOLY NAME' : 'TÊN THÁNH';
  String get activeStatus => isEn ? 'Active' : 'Đang hoạt động';
  String get sectionIdentity => isEn ? 'IDENTITY INFORMATION' : 'THÔNG TIN ĐỊNH DANH';
  String get sectionPersonal => isEn ? 'PERSONAL INFORMATION' : 'THÔNG TIN CÁ NHÂN';
  String get sectionContact => isEn ? 'CONTACT' : 'LIÊN LẠC';
  String get fieldId => isEn ? 'ID Code' : 'Mã định danh';
  String get fieldDiocese => isEn ? 'Diocese' : 'Giáo phận';
  String get fieldParish => isEn ? 'Parish' : 'Giáo xứ';
  String get fieldRole => isEn ? 'Position' : 'Chức vụ';
  String get fieldBirthDate => isEn ? 'Date of Birth' : 'Ngày sinh';
  String get fieldOrdinationDate => isEn ? 'Ordination Date' : 'Ngày thụ phong';
  String get fieldDegree => isEn ? 'Academic Degree' : 'Học vị';
  String get fieldEmail => isEn ? 'Email' : 'Email';
  String get fieldPhone => isEn ? 'Phone' : 'Điện thoại';
  String get copiedValue => isEn ? 'Copied' : 'Đã sao chép';
  String get personalInfoNote => isEn ? 'To update personal information, please submit an "Update Request" or contact the diocesan office.' : 'Để cập nhật thông tin cá nhân, vui lòng gửi "Đề nghị cập nhật" hoặc liên hệ văn phòng Giáo phận.';

  // ── Priest profile screen ────────────────────────────────────────────────────
  String get priestIdCode => isEn ? 'ID CODE' : 'MÃ ĐỊNH DANH';
  String get dioceseLabel => isEn ? 'DIOCESE' : 'GIÁO PHẬN';
  String get sectionDetailedInfo => isEn ? 'DETAILED INFORMATION' : 'THÔNG TIN CHI TIẾT';
  String get sectionWorkHistory => isEn ? 'WORK HISTORY' : 'LỊCH SỬ CÔNG TÁC';
  String get sectionUpdateHistory => isEn ? 'UPDATE HISTORY' : 'LỊCH SỬ CẬP NHẬT';
  String get labelBirthDate => isEn ? 'Date of Birth' : 'Ngày sinh';
  String get labelOrdination => isEn ? 'Ordination' : 'Thụ phong';
  String get labelCurrentParish => isEn ? 'Current Parish' : 'Giáo xứ hiện tại';
  String get labelDegree => isEn ? 'Academic Degree' : 'Học hàm/Học vị';
  String get labelEmail => isEn ? 'Contact Email' : 'Email liên hệ';
  String get qrIdCode => isEn ? 'ID QR Code' : 'Mã QR định danh';
  String get qrIdCodeModal => isEn ? 'ID QR Code' : 'Mã QR Định Danh';
  String get qrUsageDesc => isEn ? 'Use this code to check in at diocesan checkpoints or verify Mass rights.' : 'Sử dụng mã này để quét tại các cổng\nkiểm soát giáo phận hoặc xác thực quyền hành lễ.';
  String get updateRoleNew => isEn ? 'New position update' : 'Cập nhật chức vụ mới';
  String get updateContactChange => isEn ? 'Contact address changed' : 'Thay đổi địa chỉ liên lạc';
  String get toPresent => isEn ? 'Present' : 'Nay';
  String get vicePriest => isEn ? 'Associate Pastor' : 'Phó xứ';
  String get parishOf => isEn ? 'Parish of' : 'Giáo xứ';

  // ── Priest result sheet ──────────────────────────────────────────────────────
  String get verified => isEn ? 'Verified' : 'Đã xác thực';
  String get sectionBasicInfo => isEn ? 'BASIC INFORMATION' : 'THÔNG TIN CƠ BẢN';
  String get birthAndOrdination => isEn ? 'Birth & Ordination' : 'Ngày sinh & Thụ phong';
  String get ordinationPrefix => isEn ? 'Ordained:' : 'Thụ phong:';
  String get callPhone => isEn ? 'Call' : 'Gọi điện';
  String get sendEmail => isEn ? 'Email' : 'Email';
  String get idCode => isEn ? 'ID:' : 'Mã số:';

  // ── QR screen ────────────────────────────────────────────────────────────────
  String get qrScreenTitle => isEn ? 'ID QR Code' : 'Mã QR Định danh';
  String get identityVerified => isEn ? 'IDENTITY VERIFIED' : 'ĐÃ XÁC THỰC DANH TÍNH';
  String get qrIdNumber => isEn ? 'ID code:' : 'Mã định danh:';
  String get qrUsageNote => isEn ? 'USE THIS QR CODE FOR CHECK-IN OR TO SHARE OFFICIAL PASTORAL INFORMATION.' : 'SỬ DỤNG MÃ QR NÀY ĐỂ ĐIỂM DANH HOẶC CHIA SẺ THÔNG TIN MỤC VỤ CHÍNH THỨC.';

  // ── Search detail screen ─────────────────────────────────────────────────────
  String get priestInfoTitle => isEn ? 'Priest Information' : 'Thông tin linh mục';
  String get noData => isEn ? 'No data available' : 'Không có dữ liệu';
  String get copiedPhone => isEn ? 'Phone number copied' : 'Đã sao chép số điện thoại';
  String get copiedEmail => isEn ? 'Email copied' : 'Đã sao chép email';
  String get callAction => isEn ? 'CALL' : 'GỌI ĐIỆN';
  String get emailAction => isEn ? 'EMAIL' : 'GỬI EMAIL';
  String get birthAndOrdinationLabel => isEn ? 'Birth & Ordination' : 'Ngày sinh & Thụ phong';
  String get currentParishLabel => isEn ? 'Current Parish' : 'Giáo xứ hiện tại';
  String get degreeLabel => isEn ? 'Degree' : 'Học vị';
  String get roleLabel => isEn ? 'Position' : 'Chức vụ';

  // ── Search results screen ─────────────────────────────────────────────────────
  String get searchResultsTitle => isEn ? 'Search Results' : 'Kết quả tìm kiếm';
  String get allResults => isEn ? 'All' : 'Tất cả';
  String get resultCount => isEn ? 'results' : 'kết quả';
  String get noResultsTitle => isEn ? 'No priests found' : 'Không tìm thấy linh mục';
  String get noResultsDesc => isEn ? 'Try searching with a different name or\nchange the diocese.' : 'Thử tìm kiếm với tên khác hoặc\nthay đổi giáo phận.';
  String get resetPasswordAction => isEn ? 'Reset PW' : 'Reset MK';
  String get nfcCardAction => isEn ? 'NFC Card' : 'Thẻ NFC';
  String get massRequestAction => isEn ? 'Mass Req.' : 'Xin lễ';
  String get resetPasswordTitle => isEn ? 'Reset password?' : 'Reset mật khẩu?';
  String get resetPasswordDesc => isEn ? 'Password will be reset to default. The priest will need to change it on next sign in.' : 'Mật khẩu sẽ được đặt lại về mặc định. Linh mục cần đổi mật khẩu khi đăng nhập lại.';
  String resetPasswordConfirm(String holyName, String fullName) =>
      isEn ? 'Password reset for Fr. $holyName $fullName' : 'Đã reset mật khẩu cho LM. $holyName $fullName';

  // ── Mass request screen ──────────────────────────────────────────────────────
  String get massRequestTitle => isEn ? 'Mass Request' : 'Xin dâng lễ';
  String get massRequestSubtitle => isEn ? 'Submit a Mass request' : 'Gửi yêu cầu xin dâng thánh lễ';
  String get massFor => isEn ? 'MASS FOR' : 'XIN LỄ CHO';
  String get massType => isEn ? 'MASS TYPE' : 'LOẠI LỄ';
  String get scheduledTime => isEn ? 'SCHEDULED TIME' : 'THỜI GIAN DỰ KIẾN';
  String get location => isEn ? 'LOCATION' : 'ĐỊA ĐIỂM';
  String get locationHint => isEn ? 'Enter parish or location name...' : 'Nhập tên giáo xứ hoặc địa điểm...';
  String get intentionNote => isEn ? 'INTENTION / NOTES' : 'Ý CHỈ / GHI CHÚ';
  String get intentionHint => isEn ? 'Enter Mass intention...' : 'Nhập ý chỉ dâng lễ...';
  String get massRequestSent => isEn ? 'Request sent!' : 'Đã gửi yêu cầu!';
  String get massRequestSentDesc => isEn ? 'The Mass request has been sent to the diocesan office. We will confirm as soon as possible.' : 'Yêu cầu dâng lễ của vị đã được gửi đến văn phòng giáo phận. Chúng tôi sẽ xác nhận sớm nhất.';
  // Mass types
  String get massThanksgiving => isEn ? 'Thanksgiving' : 'Tạ ơn';
  String get massPeace => isEn ? 'For Peace' : 'Cầu bình an';
  String get massFuneral => isEn ? 'Funeral' : 'An táng';
  String get massWedding => isEn ? 'Wedding' : 'Hôn phối';
  String get massOther => isEn ? 'Other' : 'Khác';
  // Weekdays
  String get monday => isEn ? 'Monday' : 'Thứ Hai';
  String get tuesday => isEn ? 'Tuesday' : 'Thứ Ba';
  String get wednesday => isEn ? 'Wednesday' : 'Thứ Tư';
  String get thursday => isEn ? 'Thursday' : 'Thứ Năm';
  String get friday => isEn ? 'Friday' : 'Thứ Sáu';
  String get saturday => isEn ? 'Saturday' : 'Thứ Bảy';
  String get sunday => isEn ? 'Sunday' : 'Chúa Nhật';
  List<String> get weekdays => [monday, tuesday, wednesday, thursday, friday, saturday, sunday];

  // Mass request detail
  String get massDetailTitle => isEn ? 'Request Details' : 'Chi tiết yêu cầu';
  String get massNewRequest => isEn ? 'NEW REQUEST' : 'YÊU CẦU MỚI';
  String get massNewRequestDesc => isEn ? 'A Mass request from another priest needs approval.' : 'Yêu cầu dâng lễ từ linh mục khác cần được duyệt.';
  String get sectionSenderInfo => isEn ? 'REQUESTING PRIEST INFORMATION' : 'THÔNG TIN LINH MỤC GỬI YÊU CẦU';
  String get sectionMassDetails => isEn ? 'MASS DETAILS' : 'CHI TIẾT DÂNG LỄ';
  String get massTypeLabel => isEn ? 'MASS TYPE' : 'LOẠI LỄ';
  String get estimatedTime => isEn ? 'ESTIMATED TIME' : 'THỜI GIAN DỰ KIẾN';
  String get intentionLabel => isEn ? 'INTENTION / NOTES' : 'Ý CHỈ / GHI CHÚ';
  String get approveRequest => isEn ? 'Approve Request' : 'Duyệt yêu cầu';
  String get senderNameLabel => isEn ? 'HOLY NAME & FULL NAME' : 'TÊN THÁNH & HỌ TÊN';
  String get currentParishContact => isEn ? 'CURRENT PARISH' : 'GIÁO XỨ HIỆN TẠI';
  String get phoneContact => isEn ? 'CONTACT PHONE' : 'SỐ ĐIỆN THOẠI LIÊN HỆ';

  // ── NFC management screen ─────────────────────────────────────────────────────
  String get nfcManagementTitle => isEn ? 'Manage NFC Cards' : 'Quản lý thẻ NFC';
  String get registeredCards => isEn ? 'REGISTERED CARDS' : 'DANH SÁCH THẺ ĐÃ ĐĂNG KÝ';
  String get addCard => isEn ? 'Add Card' : 'Thêm thẻ';
  String get addNfcCard => isEn ? 'Add NFC Card' : 'Thêm thẻ NFC';
  String get addNfcCardTitle => isEn ? 'Add NFC Card' : 'Thêm thẻ NFC';
  String get addNfcCardDesc => isEn ? 'Enter the NFC card code or tap the card on the phone.' : 'Nhập mã thẻ NFC hoặc chạm thẻ vào điện thoại.';
  String get nfcCardHint => isEn ? 'e.g. NFC-ABC123' : 'VD: NFC-ABC123';
  String get scanNfcCardButton => isEn ? 'Scan NFC Card' : 'Quét thẻ NFC';
  String get noNfcCards => isEn ? 'No NFC cards' : 'Chưa có thẻ NFC';
  String get noNfcCardsDesc => isEn ? 'Tap "Add Card" to register\nan NFC card for this priest.' : 'Nhấn "Thêm thẻ" để đăng ký\nthẻ NFC cho linh mục này.';
  String get cardActive => isEn ? 'Active' : 'Hoạt động';
  String get cardInactive => isEn ? 'Off' : 'Tắt';
  String get addedOn => isEn ? 'Added on' : 'Thêm ngày';
  String get deleteNfcCard => isEn ? 'Delete NFC Card?' : 'Xoá thẻ NFC?';
  String deleteNfcCardDesc(String id) => isEn
      ? 'Card "$id" will be removed from the system. The priest will no longer be able to use this card for verification.'
      : 'Thẻ "$id" sẽ bị xoá khỏi hệ thống. Linh mục sẽ không thể dùng thẻ này để xác thực.';
  String cardCount(int n) => isEn ? '$n card${n == 1 ? '' : 's'}' : '$n thẻ';
  String cardAdded(String id) => isEn ? 'Card $id added' : 'Đã thêm thẻ $id';
  String cardDeleted(String id) => isEn ? 'Card $id deleted' : 'Đã xoá thẻ ${id}';

  // ── Emergency anointing screen ────────────────────────────────────────────────
  String get emergencyBadge => isEn ? 'EMERGENCY' : 'KHẨN CẤP';
  String get emergencyAnointingTitle => isEn ? 'Emergency Anointing' : 'Liên hệ Xức Dầu';
  String get emergencyAnointingSubtitle => isEn ? 'Find the nearest priest to celebrate the sacrament' : 'Tìm linh mục gần nhất để cử hành bí tích';
  String get locating => isEn ? 'Locating...' : 'Đang xác định vị trí...';
  String get locatingDesc => isEn ? 'Finding the nearest church\nwithin a 10km radius' : 'Hệ thống đang tìm nhà thờ\ngần nhất trong bán kính 10km';
  String nearbyChurchesFound(int n) => isEn ? 'Found $n church${n == 1 ? '' : 'es'}' : 'Tìm thấy $n nhà thờ';
  String get nearbyRadius => isEn ? 'Within 10km from your location' : 'Trong bán kính 10km từ vị trí của bạn';
  String get nearestChurches => isEn ? 'NEAREST CHURCHES' : 'NHÀ THỜ GẦN NHẤT';
  String get nearest => isEn ? 'NEAREST' : 'GẦN NHẤT';
  String get noChurchFound => isEn ? 'No churches found' : 'Không tìm thấy nhà thờ';
  String get noChurchFoundDesc => isEn ? 'No churches within 10km.\nPlease contact the diocese directly.' : 'Không có nhà thờ nào trong bán kính 10km.\nVui lòng liên hệ trực tiếp với giáo phận.';
  String get locationPermissionRequired => isEn ? 'Location permission required' : 'Cần quyền truy cập vị trí';
  String get locationPermissionDesc => isEn ? 'Go to Settings → Priest Info\n→ Location → Allow while using app' : 'Vào Cài đặt → Thông Tin Linh Mục\n→ Vị trí → Cho phép khi dùng app';
  String get cannotGetLocation => isEn ? 'Cannot get location' : 'Không lấy được vị trí';
  String get cannotGetLocationDesc => isEn ? 'Make sure GPS is on\nand try again.' : 'Hãy đảm bảo GPS đang bật\nvà thử lại.';
  String cannotCall(String phone) => isEn ? 'Cannot call $phone' : 'Không thể gọi $phone';

  // ── Help screen ───────────────────────────────────────────────────────────────
  String get helpTitle => isEn ? 'User Guide' : 'Hướng dẫn sử dụng';
  String get helpWelcome => isEn ? 'Welcome, Father,' : 'Chào mừng Linh mục,';
  String get helpWelcomeDesc => isEn ? 'The Digital Priest ID system makes pastoral management and church connectivity more convenient and secure than ever.' : 'Hệ thống Căn cước Linh mục kỹ thuật số giúp việc quản lý mục vụ và kết nối trong giáo hội trở nên thuận tiện và bảo mật hơn bao giờ hết.';
  String get helpNeedMore => isEn ? 'NEED MORE HELP?' : 'CẦN HỖ TRỢ THÊM?';
  String get helpNeedMoreDesc => isEn ? 'If you need direct guidance or encounter a technical issue, please contact the Diocesan Communications Office.' : 'Nếu vị cần được hướng dẫn trực tiếp hoặc gặp sự cố kỹ thuật, vui lòng liên hệ Ban Truyền thông Giáo phận.';
  // Help items
  String get helpNfcTitle => isEn ? 'NFC Verification' : 'Xác thực NFC';
  String get helpNfcDesc => isEn ? 'The highest security technology — tap the priest card on the back of the phone to verify official identity.' : 'Công nghệ bảo mật cao nhất bằng cách chạm thẻ linh mục vào mặt sau điện thoại để xác thực danh tính chính thức.';
  String get helpQrTitle => isEn ? 'ID QR Code' : 'Mã QR Định danh';
  String get helpQrDesc => isEn ? 'Each priest has a unique QR code. Scan to share contact information quickly or check in at church events.' : 'Mỗi linh mục có một mã QR riêng. Quét mã để chia sẻ thông tin liên lạc nhanh chóng hoặc điểm danh tại các sự kiện giáo hội.';
  String get helpMassTitle => isEn ? 'Mass Request Management' : 'Quản lý Xin lễ';
  String get helpMassDesc => isEn ? 'Submit Mass requests online to the diocesan office or receive and approve requests from parishioners.' : 'Gửi yêu cầu dâng lễ trực tuyến đến văn phòng giáo phận hoặc nhận và duyệt các yêu cầu dâng lễ từ giáo dân gửi đến.';
  String get helpNotifTitle => isEn ? 'Notification System' : 'Hệ thống Thông báo';
  String get helpNotifDesc => isEn ? 'Stay updated with urgent notifications, schedule reminders, and important news from the Diocese.' : 'Luôn cập nhật các thông báo khẩn, nhắc lịch công tác và tin tức quan trọng từ Giáo phận thông qua trung tâm thông báo.';
  String get helpSearchTitle => isEn ? 'Priest Search' : 'Tìm kiếm Linh mục';
  String get helpSearchDesc => isEn ? 'Easily look up contact information and positions of priests across the national Digital Ecclesia system.' : 'Dễ dàng tra cứu thông tin liên lạc và chức vụ của các linh mục trong hệ thống Digital Ecclesia toàn quốc.';
  String get helpBioTitle => isEn ? 'Biometric Security' : 'Bảo mật Sinh trắc học';
  String get helpBioDesc => isEn ? 'Use Face ID or Fingerprint to protect the app, ensuring only the owner can access sensitive information.' : 'Sử dụng FaceID hoặc Fingerprint để bảo vệ ứng dụng, đảm bảo chỉ chính chủ mới có thể truy cập thông tin nhạy cảm.';

  // ── Update request screen ─────────────────────────────────────────────────────
  String get updateRequestTitle => isEn ? 'Request Update' : 'Đề nghị cập nhật';
  String get updateRequestBannerTitle => isEn ? 'Profile Update Request' : 'Yêu cầu cập nhật hồ sơ';
  String get updateRequestBannerDesc => isEn ? 'Describe the information to be changed. The admin will verify and update it in the system.' : 'Mô tả thông tin cần thay đổi. Ban Quản trị sẽ xác minh và cập nhật trong hệ thống.';
  String get infoTypeLabel => isEn ? 'INFORMATION TYPE' : 'LOẠI THÔNG TIN';
  String get requestContentLabel => isEn ? 'REQUEST CONTENT' : 'NỘI DUNG ĐỀ NGHỊ';
  String get requestContentHint => isEn ? 'Example: Update parish from "Parish A" to "Parish B" as of 01/01/2025...' : 'Ví dụ: Cập nhật giáo xứ từ "Giáo xứ A" sang "Giáo xứ B" kể từ ngày 01/01/2025...';
  String get processTitle => isEn ? 'PROCESSING STEPS' : 'QUY TRÌNH XỬ LÝ';
  String get step1 => isEn ? 'Submit request → Admin receives it' : 'Gửi đề nghị → Ban Quản trị nhận được';
  String get step2 => isEn ? 'Verify information (1–2 business days)' : 'Xác minh thông tin (1–2 ngày làm việc)';
  String get step3 => isEn ? 'Update system and notify you' : 'Cập nhật hệ thống và thông báo cho vị';
  String get requestSent => isEn ? 'Request sent!' : 'Đã gửi đề nghị!';
  String get requestSentDesc => isEn ? 'The update request has been sent to the admin. We will review and respond within 3–5 business days.' : 'Đề nghị cập nhật của vị đã được gửi đến Ban Quản trị. Chúng tôi sẽ xem xét và phản hồi trong vòng 3–5 ngày làm việc.';
  // Categories
  String get catPersonalInfo => isEn ? 'Personal Information' : 'Thông tin cá nhân';
  String get catParishDiocese => isEn ? 'Parish / Diocese' : 'Giáo xứ / Giáo phận';
  String get catDegreeRole => isEn ? 'Degree / Position' : 'Học vị / Chức vụ';
  String get catBirthOrdination => isEn ? 'Birth / Ordination Date' : 'Ngày sinh / Thụ phong';
  String get catEmailPhone => isEn ? 'Email / Phone' : 'Email / Điện thoại';
  String get catOther => isEn ? 'Other' : 'Khác';
  // Validators
  String get validContentRequired => isEn ? 'Please describe the information to be updated' : 'Vui lòng mô tả nội dung cần cập nhật';
  String get validContentTooShort => isEn ? 'Please describe in more detail (minimum 10 characters)' : 'Vui lòng mô tả chi tiết hơn (tối thiểu 10 ký tự)';

  // ── Language screen ──────────────────────────────────────────────────────────
  String get languageTitle => isEn ? 'Language' : 'Ngôn ngữ';
  String get chooseLanguage => isEn ? 'Choose Language' : 'Chọn ngôn ngữ';
  String get languageSupportDesc => isEn ? 'Display language for the entire app. Supports Vietnamese and English.' : 'Ngôn ngữ hiển thị trên toàn bộ ứng dụng. Hỗ trợ Tiếng Việt và English.';
  String get availableLanguages => isEn ? 'AVAILABLE LANGUAGES' : 'NGÔN NGỮ CÓ SẴN';
  String get comingSoon => isEn ? 'Coming soon' : 'Sắp ra mắt';
  String languageSwitched(String name) => isEn ? 'Switched to $name' : 'Đã chuyển sang $name';
  String get languageChanged => isEn ? 'Language updated!' : 'Đã cập nhật ngôn ngữ!';

  // ── Liturgical date translation ──────────────────────────────────────────────
  String translateLiturgicalDate(String viDate) {
    if (!isEn) return viDate;
    var s = viDate
        .replaceFirst('Thứ Hai', 'Monday')
        .replaceFirst('Thứ Ba', 'Tuesday')
        .replaceFirst('Thứ Tư', 'Wednesday')
        .replaceFirst('Thứ Năm', 'Thursday')
        .replaceFirst('Thứ Sáu', 'Friday')
        .replaceFirst('Thứ Bảy', 'Saturday')
        .replaceFirst('Chúa Nhật', 'Sunday');
    // "15 Tháng 5" → "May 15"
    s = s.replaceAllMapped(RegExp(r'(\d+) Tháng (\d+)'), (m) {
      const months = ['January','February','March','April','May','June',
          'July','August','September','October','November','December'];
      final day = m.group(1)!;
      final monthIdx = int.tryParse(m.group(2)!) ?? 1;
      return '${months[monthIdx - 1]} $day';
    });
    return s;
  }

  // ── Liturgical season / week badge translation ───────────────────────────────
  String translateLiturgicalSeason(String viSeason) {
    if (!isEn) return viSeason;
    const exact = <String, String>{
      'Thứ Tư Lễ Tro': 'Ash Wednesday',
      'Mùa Giáng Sinh': 'Christmas Season',
      'Mùa Thường Niên': 'Ordinary Time',
      'Chúa Nhật Phục Sinh': 'Easter Sunday',
      'Lễ Thăng Thiên': 'Ascension',
      'Lễ Hiện Xuống': 'Pentecost',
      'Lễ Chúa Ba Ngôi': 'Trinity Sunday',
      'Lễ Mình Máu Thánh': 'Corpus Christi',
      'Lễ Thánh Tâm': 'Sacred Heart',
      'Lễ Chúa Kitô Vua': 'Christ the King',
      'Lễ Hiển Linh': 'Epiphany',
      'Lễ Chúa Giêsu Chịu Phép Rửa': 'Baptism of the Lord',
      'Lễ Giáng Sinh': 'Christmas',
      'CN II Phục Sinh - Lòng Thương Xót': 'Divine Mercy Sunday',
    };
    if (exact.containsKey(viSeason)) return exact[viSeason]!;
    // Pattern: "Tuần X Mùa Vọng/Mùa Chay/Phục Sinh/Thường Niên"
    var s = viSeason
        .replaceAll('Mùa Vọng', 'Advent')
        .replaceAll('Mùa Chay', 'Lent')
        .replaceAll('Phục Sinh', 'Easter')
        .replaceAll('Thường Niên', 'Ordinary Time')
        .replaceAll('Mùa Giáng Sinh', 'Christmas Season')
        .replaceAll('Tuần ', 'Week ');
    s = s.replaceAllMapped(
      RegExp(r'Week ([IVXLCDM]+) (Advent|Lent|Easter|Ordinary Time)'),
      (m) => 'Week ${m.group(1)} of ${m.group(2)}',
    );
    return s;
  }

  // ── Feast name translation ───────────────────────────────────────────────────
  String translateFeast(String viFeast) {
    if (!isEn) return viFeast;
    const exact = <String, String>{
      'Thứ Tư Lễ Tro': 'Ash Wednesday',
      'Chúa Nhật Lễ Lá - Cuộc Thương Khó': 'Palm Sunday',
      'Thứ Năm Tuần Thánh - Lễ Tiệc Ly': 'Holy Thursday',
      'Thứ Sáu Tuần Thánh - Cuộc Khổ Nạn Chúa': 'Good Friday',
      'Thứ Bảy Tuần Thánh - Vọng Phục Sinh': 'Holy Saturday',
      'Chúa Nhật Phục Sinh': 'Easter Sunday',
      'CN II Phục Sinh - Lòng Thương Xót Chúa': 'Divine Mercy Sunday',
      'Lễ Thăng Thiên': 'Ascension of the Lord',
      'Lễ Chúa Thánh Thần Hiện Xuống': 'Pentecost Sunday',
      'Lễ Chúa Ba Ngôi': 'Most Holy Trinity',
      'Lễ Mình Máu Thánh Chúa Kitô': 'Corpus Christi',
      'Lễ Thánh Tâm Chúa Giêsu': 'Sacred Heart of Jesus',
      'Lễ Chúa Giêsu Kitô, Vua Vũ Trụ': 'Christ the King',
      'Lễ Hiển Linh': 'Epiphany of the Lord',
      'Lễ Chúa Giêsu Chịu Phép Rửa': 'Baptism of the Lord',
      'Lễ Giáng Sinh': 'Christmas',
      'Lễ Thánh Gia Thất': 'Holy Family',
      // Advent Sundays
      'Chúa Nhật I Mùa Vọng': '1st Sunday of Advent',
      'Chúa Nhật II Mùa Vọng': '2nd Sunday of Advent',
      'Chúa Nhật III Mùa Vọng': '3rd Sunday of Advent',
      'Chúa Nhật IV Mùa Vọng': '4th Sunday of Advent',
      // Lent Sundays
      'Chúa Nhật I Mùa Chay': '1st Sunday of Lent',
      'Chúa Nhật II Mùa Chay': '2nd Sunday of Lent',
      'Chúa Nhật III Mùa Chay': '3rd Sunday of Lent',
      'Chúa Nhật IV Mùa Chay': '4th Sunday of Lent',
      'Chúa Nhật V Mùa Chay': '5th Sunday of Lent',
      // Easter Sundays
      'Chúa Nhật III Phục Sinh': '3rd Sunday of Easter',
      'Chúa Nhật IV Phục Sinh': '4th Sunday of Easter',
      'Chúa Nhật V Phục Sinh': '5th Sunday of Easter',
      'Chúa Nhật VI Phục Sinh': '6th Sunday of Easter',
      'Chúa Nhật VII Phục Sinh': '7th Sunday of Easter',
      // Easter octave
      'Ngày II Bát Nhật Phục Sinh': 'Monday of Easter Week',
      'Ngày III Bát Nhật Phục Sinh': 'Tuesday of Easter Week',
      'Ngày IV Bát Nhật Phục Sinh': 'Wednesday of Easter Week',
      'Ngày V Bát Nhật Phục Sinh': 'Thursday of Easter Week',
      'Ngày VI Bát Nhật Phục Sinh': 'Friday of Easter Week',
      'Ngày VII Bát Nhật Phục Sinh': 'Saturday of Easter Week',
      'Ngày VIII Bát Nhật Phục Sinh': 'Divine Mercy Sunday',
      // Fixed solemnities
      'Đức Maria, Mẹ Thiên Chúa': 'Mary, Mother of God',
      'Dâng Chúa Vào Đền Thánh': 'Presentation of the Lord',
      'Thánh Giuse Bạn Đức Mẹ': 'St. Joseph, Spouse of Mary',
      'Truyền Tin': 'Annunciation of the Lord',
      'Sinh nhật Thánh Gioan Tẩy Giả': 'Birth of St. John the Baptist',
      'Thánh Phêrô và Thánh Phaolô': 'Sts. Peter and Paul',
      'Đức Mẹ Hồn Xác Lên Trời': 'Assumption of the Blessed Virgin Mary',
      'Suy Tôn Thánh Giá': 'Exaltation of the Holy Cross',
      'Các Thánh Nam Nữ': 'All Saints',
      'Cầu cho các Tín hữu đã qua đời': 'All Souls',
      'Lễ Cầu Cho Các Tín Hữu Đã Qua Đời': 'All Souls',
      'Các Thánh Tử Đạo Việt Nam': 'Vietnamese Martyrs',
      'Đức Mẹ Vô Nhiễm Nguyên Tội': 'Immaculate Conception',
      'Kính Suy Tôn Thánh Giá (11/09)': 'Exaltation of the Holy Cross (Sep 14)',
    };
    if (exact.containsKey(viFeast)) return exact[viFeast]!;
    // Pattern: weekday + season
    var s = viFeast
        .replaceAll('Thứ Hai. ', 'Monday. ')
        .replaceAll('Thứ Ba. ', 'Tuesday. ')
        .replaceAll('Thứ Tư. ', 'Wednesday. ')
        .replaceAll('Thứ Năm. ', 'Thursday. ')
        .replaceAll('Thứ Sáu. ', 'Friday. ')
        .replaceAll('Thứ Bảy. ', 'Saturday. ')
        .replaceAll('Chúa Nhật. ', 'Sunday. ');
    s = translateLiturgicalSeason(s);
    // "Lễ Kính — X" → "Feast — X"
    s = s.replaceAll('Lễ Kính — ', 'Feast — ')
         .replaceAll('Lễ Trọng — ', 'Solemnity — ')
         .replaceAll('Lễ Nhớ — ', 'Memorial — ');
    // Translate saint names in remaining text
    s = _translateSaintPhrase(s);
    return s;
  }

  String _translateSaintPhrase(String s) {
    // "Thánh X" → "St. X"
    var result = s;
    _saintNameMap.forEach((vi, en) {
      result = result.replaceAll('Thánh $vi', 'St. $en');
      result = result.replaceAll(vi, en);
    });
    result = result.replaceAll('Đức Bà', 'Our Lady');
    result = result.replaceAll('Đức Mẹ', 'Our Lady');
    result = result.replaceAll('Chúa Nhật', 'Sunday');
    result = result.replaceAll('Lễ Kính', 'Feast');
    result = result.replaceAll('Lễ Nhớ', 'Memorial');
    return result;
  }

  // ── Reading label / text translation ────────────────────────────────────────
  String translateReadingLabel(String viLabel) {
    if (!isEn) return viLabel;
    switch (viLabel) {
      case 'Bài Đọc I': return 'First Reading';
      case 'Bài Đọc II': return 'Second Reading';
      case 'Đáp Ca': return 'Responsorial Psalm';
      case 'Tin Mừng': return 'Gospel';
      default: return viLabel;
    }
  }

  String translateReadingText(String viText) {
    if (!isEn) return viText;
    if (viText == 'Thánh vịnh') return 'Psalm';
    // Translate inline liturgical notes that appear in reading references
    var s = viText
        .replaceAll('Các bài đọc: lấy ở chính ngày lễ.', 'Readings: taken from the feast day itself.')
        .replaceAll('Chiều:', 'Evening (Vespers):')
        .replaceAll('Sáng:', 'Morning:')
        .replaceAll('LỄ VỌNG CHÚA GIÊSU CHỊU PHÉP RỬA', 'Vigil of the Baptism of the Lord')
        .replaceAll('LỄ VỌNG CHÚA THĂNG THIÊN', 'Vigil of the Ascension of the Lord')
        .replaceAll('LỄ VỌNG HIỆN XUỐNG', 'Vigil of Pentecost')
        .replaceAll('LỄ VỌNG CHÚA GIÁNG SINH', 'Vigil of the Nativity of the Lord')
        .replaceAll('LỄ VỌNG PHỤC SINH', 'Easter Vigil')
        .replaceAll('CHÚA THĂNG THIÊN', 'Ascension of the Lord')
        .replaceAll('HIỆN XUỐNG', 'Pentecost')
        .replaceAll('MÌNH MÁU THÁNH CHÚA', 'Corpus Christi')
        .replaceAll('THÁNH TÂM CHÚA', 'Sacred Heart')
        .replaceAll('CHÚA KITÔ VUA', 'Christ the King')
        .replaceAll('ĐỨC MẸ VÔ NHIỄM', 'Immaculate Conception')
        .replaceAll('ĐỨC MẸ HỒN XÁC LÊN TRỜI', 'Assumption of Mary')
        .replaceAll('SINH NHẬT ĐỨC MẸ', 'Nativity of Mary')
        .replaceAll('(Tr)', '(W)')
        .replaceAll('(Đỏ)', '(R)')
        .replaceAll('(Xanh)', '(G)')
        .replaceAll('(Tím)', '(V)')
        .replaceAll('(Hồng)', '(Pk)');
    return s;
  }

  // ── Mass type translation ────────────────────────────────────────────────────
  String translateMassType(String viType) {
    if (!isEn) return viType;
    const massTypeMap = <String, String>{
      'Lễ Cầu Hồn': 'Mass for the Dead',
      'Lễ An Táng': 'Funeral Mass',
      'Lễ Giỗ': 'Anniversary Mass',
      'Lễ Cưới': 'Wedding Mass',
      'Lễ Tạ Ơn': 'Thanksgiving Mass',
      'Lễ Cầu Bình An': 'Mass for Peace',
      'Lễ Cầu Cho Bệnh Nhân': 'Mass for the Sick',
      'Lễ Mở Tay': 'First Mass',
      'Lễ Thường': 'Ordinary Mass',
    };
    return massTypeMap[viType] ?? viType;
  }

  // ── Saint (holy) name translation ────────────────────────────────────────────
  static const _saintNameMap = <String, String>{
    'Phaolô': 'Paul',
    'Phêrô': 'Peter',
    'Gioan': 'John',
    'Giuse': 'Joseph',
    'Maria': 'Mary',
    'Anrê': 'Andrew',
    'Matthêu': 'Matthew',
    'Luca': 'Luke',
    'Maccô': 'Mark',
    'Giacôbê': 'James',
    'Tôma': 'Thomas',
    'Philipphê': 'Philip',
    'Batôlômêô': 'Bartholomew',
    'Simôn': 'Simon',
    'Giuđa': 'Jude',
    'Matthia': 'Matthias',
    'Barnaba': 'Barnabas',
    'Têphanô': 'Stephen',
    'Augustinô': 'Augustine',
    'Têrêxa': 'Therese',
    'Antôn': 'Anthony',
    'Phanxicô': 'Francis',
    'Đaminh': 'Dominic',
    'Inhaxiô': 'Ignatius',
    'Lôrenxô': 'Lawrence',
    'Grêgôriô': 'Gregory',
    'Lêô': 'Leo',
    'Bênêđictô': 'Benedict',
    'Luxia': 'Lucy',
    'Catarina': 'Catherine',
    'Mácthê': 'Martha',
    'Nicôla': 'Nicholas',
    'Vincentê': 'Vincent',
    'Carôlô': 'Charles',
    'Rôcô': 'Roch',
    'Annê': 'Anne',
    'Giôakêm': 'Joachim',
    'Êlisabét': 'Elizabeth',
    'Gioan Tẩy Giả': 'John the Baptist',
    'Cêcilia': 'Cecilia',
    'Monica': 'Monica',
    'Agata': 'Agatha',
    'Anê': 'Agnes',
    'Bônaventura': 'Bonaventure',
    'Bênađô': 'Bernard',
    'Piô': 'Pius',
    'Micae': 'Michael',
    'Raphaen': 'Raphael',
    'Gabrien': 'Gabriel',
    'Cyrillô': 'Cyril',
    'Mêthôđiô': 'Methodius',
    'Giêrônimô': 'Jerome',
    'Ambrôxiô': 'Ambrose',
    'Clêmentê': 'Clement',
    'Xixtô': 'Sixtus',
    'Đa Minh': 'Dominic',
    'Anrê Dũng Lạc': 'Andrew Dung-Lac',
    'Gioan Phaolô': 'John Paul',
    'Phanxicô Xaviê': 'Francis Xavier',
    'Phanxicô Salê': 'Francis de Sales',
  };

  String translateHolyName(String name) {
    if (!isEn) return name;
    return _saintNameMap[name] ?? name;
  }

  // ── Diocese / parish / role translation ─────────────────────────────────────
  String translateDiocese(String diocese) {
    if (!isEn) return diocese;
    return diocese
        .replaceFirst('Tổng Giáo phận TP.HCM', 'Archdiocese of Ho Chi Minh City')
        .replaceFirst('Tổng Giáo phận Hà Nội', 'Archdiocese of Hanoi')
        .replaceFirst('Tổng Giáo phận Huế', 'Archdiocese of Hue')
        .replaceFirst('Tổng Giáo phận', 'Archdiocese of')
        .replaceAll('TGP ', 'Archdiocese of ')
        .replaceFirst('Giáo phận', 'Diocese of')
        .replaceAll('GP ', 'Diocese of ')
        .replaceFirst('Giáo xứ', 'Parish of');
  }

  String translateRole(String role) {
    if (!isEn) return role;
    const roleMap = <String, String>{
      'Trưởng ban Truyền thông': 'Head of Communications',
      'Quản xứ': 'Parish Priest',
      'Phó xứ': 'Associate Pastor',
      'Chính xứ': 'Pastor',
      'Giám mục': 'Bishop',
      'Hồng y': 'Cardinal',
      'Tổng Giám mục': 'Archbishop',
      'Linh mục': 'Priest',
      'Phó tế': 'Deacon',
      'Tu sĩ': 'Religious',
      'Bề trên': 'Superior',
      'Giám đốc': 'Director',
    };
    return roleMap[role] ?? role;
  }

  String translateDegree(String degree) {
    if (!isEn) return degree;
    const degreeMap = <String, String>{
      'Thạc sĩ Mục vụ': 'Master of Pastoral Ministry',
      'Tiến sĩ Thần học': 'Doctor of Theology',
      'Thạc sĩ Thần học': 'Master of Theology',
      'Cử nhân Thần học': 'Bachelor of Theology',
      'Tiến sĩ Triết học': 'Doctor of Philosophy',
      'Thạc sĩ Triết học': 'Master of Philosophy',
    };
    return degreeMap[degree] ?? degree;
  }
}
