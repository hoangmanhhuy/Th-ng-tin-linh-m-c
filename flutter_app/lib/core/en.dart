import 'app_strings.dart';

class AppStringsEn extends AppStrings {
  const AppStringsEn();

  @override
  bool get isEn => true;

  // ── App title ───────────────────────────────────────────────────────────────
  @override
  String get appTitle => 'Priest Information';
  @override
  String get appTitleShort => 'PRIEST INFO';

  // ── Bottom navigation ────────────────────────────────────────────────────────
  @override
  String get navHome => 'Home';
  @override
  String get navScanCard => 'Scan Card';
  @override
  String get navScanQr => 'Scan QR';
  @override
  String get navHistory => 'History';
  @override
  String get navSettings => 'Settings';

  // ── Common actions ───────────────────────────────────────────────────────────
  @override
  String get login => 'Sign In';
  @override
  String get logout => 'Sign Out';
  @override
  String get logoutUppercase => 'SIGN OUT';
  @override
  String get exit => 'EXIT';
  @override
  String get search => 'SEARCH';
  @override
  String get close => 'Close';
  @override
  String get cancel => 'Cancel';
  @override
  String get confirm => 'Confirm';
  @override
  String get done => 'Done';
  @override
  String get retry => 'RETRY';
  @override
  String get retryLower => 'Try again';
  @override
  String get back => 'BACK';
  @override
  String get details => 'DETAILS';
  @override
  String get approve => 'APPROVE';
  @override
  String get reject => 'Reject';
  @override
  String get delete => 'Delete';
  @override
  String get add => 'Add';
  @override
  String get save => 'Save image';
  @override
  String get share => 'Share';
  @override
  String get copy => 'Copied';
  @override
  String get callNow => 'CALL NOW';
  @override
  String get openSettings => 'Open Settings';
  @override
  String get select => 'Select';
  @override
  String get sendRequest => 'SEND REQUEST';
  @override
  String get updatePassword => 'UPDATE PASSWORD';
  @override
  String get submitRequest => 'SUBMIT REQUEST';
  @override
  String get sendSupportRequest => 'SEND SUPPORT REQUEST';
  @override
  String get markAllRead => 'Mark all as read';

  // ── Home screen ──────────────────────────────────────────────────────────────
  @override
  String get searchPriest => 'Find a Priest';
  @override
  String get searchPriestHint => 'Enter priest name';
  @override
  String get searchPriestHintDots => 'Enter priest name...';
  @override
  String get chooseDiocese => 'Choose Diocese';
  @override
  String get chooseDioceseAlt => 'Choose Diocese';
  @override
  String get popularPriests => 'Popular Priests';
  @override
  String get viewAll => 'View all';

  // Emergency card
  @override
  String get emergencyLabel => 'FOR EMERGENCY CASES';
  @override
  String get emergencyTitle => 'Emergency Anointing';
  @override
  String get emergencySubtitle => 'Find the nearest priest to celebrate the sacrament';

  // Info section
  @override
  String get infoNeedToKnow => 'Information';
  @override
  String get infoOfficialData => 'Official Data';
  @override
  String get infoOfficialDataDesc => 'Information verified by diocesan offices.';
  @override
  String get infoSearchGuide => 'Search Guide';
  @override
  String get infoSearchGuideDesc => 'Use the holy name or full name for the most accurate results.';

  // Priest ID card
  @override
  String get priestIdCard => 'PRIEST ID CARD';
  @override
  String get priestInfo => 'INFO';

  // Action bar
  @override
  String get actionScanCard => 'Scan Card';
  @override
  String get actionMassRequest => 'Mass Req.';
  @override
  String get actionQrCode => 'QR Code';
  @override
  String get actionFaceId => 'Face ID';

  // Mass request card (home)
  @override
  String get minutesAgo => '5 MINUTES AGO';
  @override
  String get massNotificationSample =>
      'Fr. Paul Hoang Manh Huy, Diocese of Phu Cuong, requests a Funeral Mass.';

  // Search section (priest home)
  @override
  String get searchPriestSection => 'Search Priest';

  // Liturgical section
  @override
  String get liturgicalDay => 'LITURGICAL DAY';
  @override
  String get feastDay => 'FEAST / MEMORIAL';

  // Help button
  @override
  String get helpGuide => 'Priest ID Card User Guide';

  // ── Settings screen ──────────────────────────────────────────────────────────
  @override
  String get settingsTitle => 'Settings';
  @override
  String get sectionAccountSecurity => 'ACCOUNT & SECURITY';
  @override
  String get sectionAppSupport => 'APP & SUPPORT';
  @override
  String get menuPersonalInfo => 'Personal Info';
  @override
  String get menuBiometrics => 'Biometrics';
  @override
  String get menuChangePassword => 'Change Password';
  @override
  String get menuLanguage => 'Language';
  @override
  String get menuUpdateRequest => 'Request Update';
  @override
  String get menuSupport => 'Support';

  // ── Login screen ─────────────────────────────────────────────────────────────
  @override
  String get loginTitle => 'Priest Information';
  @override
  String get loginSubtitle => 'PRIEST SIGN IN';
  @override
  String get loginUsernameLabel => 'USERNAME OR EMAIL';
  @override
  String get loginPasswordLabel => 'PASSWORD';
  @override
  String get forgotPassword => 'Forgot password?';
  @override
  String get orUseNfcCard => 'OR USE YOUR MINISTRY CARD';
  @override
  String get tapPriestCard => 'Tap Priest Card';
  @override
  String get notAPriest => 'Not a priest?';
  @override
  String get backToLaityHome => 'Back to Laity Home';

  // ── Scan screen ──────────────────────────────────────────────────────────────
  @override
  String get scanQr => 'Scan QR Code';
  @override
  String get scanInstruction => 'Point camera at the priest\'s QR code';
  @override
  String get scanAutoDetect => 'The app will automatically detect a valid code';
  @override
  String get scanInvalidQr => 'Invalid or unrecognized QR code';
  @override
  String get cameraPermissionDenied => 'Camera permission denied';
  @override
  String get cameraCannotOpen => 'Cannot open camera';
  @override
  String get cameraPermissionInstruction =>
      'Go to Settings → Priest Info\n→ Camera → allow access';
  @override
  String get cameraNotSupported =>
      'Device does not support camera\nor camera is in use by another app';

  // ── NFC screen ───────────────────────────────────────────────────────────────
  @override
  String get scanNfcCard => 'Scan NFC Card';
  @override
  String get touchPriestCard => 'Touch Priest Card';
  @override
  String get nfcInstruction =>
      'Hold the NFC card near the back of the phone to verify priest identity.';
  @override
  String get nfcChecking => 'Checking NFC...';
  @override
  String get nfcNotAvailable => 'NFC not available on this device';
  @override
  String get nfcWaiting => 'Waiting for card...';
  @override
  String get nfcReadSuccess => 'Card read successfully!';
  @override
  String get nfcPriestNotFound => 'Priest information not found';
  @override
  String get nfcInvalidFormat => 'Card format not recognized';
  @override
  String get nfcInvalidData => 'Card contains no valid data';
  @override
  String get nfcReadError => 'Card read error';
  @override
  String get nfcStartFailed => 'Cannot start NFC';
  @override
  String get nfcNeedsDeveloper => 'Apple Developer account required for NFC';
  @override
  String get noNfcCard => 'No NFC card?';
  @override
  String get loginWithPassword => 'Sign in with password';

  // ── History screen ───────────────────────────────────────────────────────────
  @override
  String get historyTitle => 'Activity History';
  @override
  String get historySubtitle => 'Track your requests and updates.';
  @override
  String get historySearch => 'Search history...';
  @override
  String get filterAll => 'All';
  @override
  String get filterUpdate => 'Update';
  @override
  String get filterMass => 'Mass';
  @override
  String get filterContribution => 'Contribution';
  @override
  String get statusCompleted => 'Completed';
  @override
  String get statusProcessing => 'Processing';
  @override
  String get statusRejected => 'Rejected';
  @override
  String get historyUpdateRequest => 'Information update request';
  @override
  String get historyMassThanksgiving => 'Mass of Thanksgiving request';
  @override
  String get historyMassPeace => 'Mass for Peace request';

  // ── Biometrics screen ────────────────────────────────────────────────────────
  @override
  String get biometricsTitle => 'Biometrics';
  @override
  String get biometricsSecurity => 'Biometric Security';
  @override
  String get biometricsDesc =>
      'Use Face ID or fingerprint to unlock the app quickly and securely.';
  @override
  String get sectionAuthMethod => 'AUTHENTICATION METHOD';
  @override
  String get sectionLockSettings => 'LOCK SETTINGS';
  @override
  String get faceIdSubtitle => 'Unlock with face recognition';
  @override
  String get touchId => 'Fingerprint (Touch ID)';
  @override
  String get touchIdSubtitle => 'Unlock with fingerprint';
  @override
  String get autoLock => 'Auto Lock';
  @override
  String get autoLockSubtitle => 'Require authentication when reopening app';
  @override
  String get faceIdEnabled => 'Face ID enabled';
  @override
  String get touchIdEnabled => 'Touch ID enabled';
  @override
  String get biometricsNote =>
      'Biometrics use the device\'s secure hardware. Fingerprint / Face ID data is never stored on the server.';

  // ── Change password ──────────────────────────────────────────────────────────
  @override
  String get changePasswordTitle => 'Change Password';
  @override
  String get accountSecurity => 'Account Security';
  @override
  String get passwordRequirements =>
      'Password must be at least 8 characters, including uppercase, lowercase, and numbers.';
  @override
  String get currentPassword => 'Current Password';
  @override
  String get currentPasswordHint => 'Enter your current password';
  @override
  String get newPassword => 'New Password';
  @override
  String get newPasswordHint => 'Minimum 8 characters';
  @override
  String get confirmNewPassword => 'Confirm New Password';
  @override
  String get confirmPasswordHint => 'Re-enter new password';
  @override
  String get passwordChangedSuccess => 'Password changed successfully!';
  @override
  String get passwordChangedDesc =>
      'Your new password has been updated. Please use the new password for your next sign in.';
  @override
  String get validCurrentPasswordRequired => 'Please enter your current password';
  @override
  String get validPasswordTooShort => 'Password is too short';
  @override
  String get validNewPasswordRequired => 'Please enter a new password';
  @override
  String get validPasswordMin8 => 'Password must be at least 8 characters';
  @override
  String get validPasswordSameAsCurrent => 'New password must differ from the current one';
  @override
  String get validConfirmRequired => 'Please confirm your new password';
  @override
  String get validConfirmMismatch => 'Passwords do not match';

  // ── Notifications screen ─────────────────────────────────────────────────────
  @override
  String get notificationsTitle => 'Notifications';
  @override
  String get notifLatest => 'LATEST';

  // ── Personal info screen ─────────────────────────────────────────────────────
  @override
  String get personalInfoTitle => 'Personal Info';
  @override
  String get holyName => 'HOLY NAME';
  @override
  String get activeStatus => 'Active';
  @override
  String get sectionIdentity => 'IDENTITY INFORMATION';
  @override
  String get sectionPersonal => 'PERSONAL INFORMATION';
  @override
  String get sectionContact => 'CONTACT';
  @override
  String get fieldId => 'ID Code';
  @override
  String get fieldDiocese => 'Diocese';
  @override
  String get fieldParish => 'Parish';
  @override
  String get fieldRole => 'Position';
  @override
  String get fieldBirthDate => 'Date of Birth';
  @override
  String get fieldOrdinationDate => 'Ordination Date';
  @override
  String get fieldDegree => 'Academic Degree';
  @override
  String get fieldEmail => 'Email';
  @override
  String get fieldPhone => 'Phone';
  @override
  String get copiedValue => 'Copied';
  @override
  String get personalInfoNote =>
      'To update personal information, please submit an "Update Request" or contact the diocesan office.';

  // ── Priest profile screen ────────────────────────────────────────────────────
  @override
  String get priestIdCode => 'ID CODE';
  @override
  String get dioceseLabel => 'DIOCESE';
  @override
  String get sectionDetailedInfo => 'DETAILED INFORMATION';
  @override
  String get sectionWorkHistory => 'WORK HISTORY';
  @override
  String get sectionUpdateHistory => 'UPDATE HISTORY';
  @override
  String get labelBirthDate => 'Date of Birth';
  @override
  String get labelOrdination => 'Ordination';
  @override
  String get labelCurrentParish => 'Current Parish';
  @override
  String get labelDegree => 'Academic Degree';
  @override
  String get labelEmail => 'Contact Email';
  @override
  String get qrIdCode => 'ID QR Code';
  @override
  String get qrIdCodeModal => 'ID QR Code';
  @override
  String get qrUsageDesc =>
      'Use this code to check in at diocesan checkpoints or verify Mass rights.';
  @override
  String get updateRoleNew => 'New position update';
  @override
  String get updateContactChange => 'Contact address changed';
  @override
  String get toPresent => 'Present';
  @override
  String get vicePriest => 'Associate Pastor';
  @override
  String get parishOf => 'Parish of';

  // ── Priest result sheet ──────────────────────────────────────────────────────
  @override
  String get verified => 'Verified';
  @override
  String get sectionBasicInfo => 'BASIC INFORMATION';
  @override
  String get birthAndOrdination => 'Birth & Ordination';
  @override
  String get ordinationPrefix => 'Ordained:';
  @override
  String get callPhone => 'Call';
  @override
  String get sendEmail => 'Email';
  @override
  String get idCode => 'ID:';

  // ── QR screen ────────────────────────────────────────────────────────────────
  @override
  String get qrScreenTitle => 'ID QR Code';
  @override
  String get identityVerified => 'IDENTITY VERIFIED';
  @override
  String get qrIdNumber => 'ID code:';
  @override
  String get qrUsageNote =>
      'USE THIS QR CODE FOR CHECK-IN OR TO SHARE OFFICIAL PASTORAL INFORMATION.';

  // ── Search detail screen ─────────────────────────────────────────────────────
  @override
  String get priestInfoTitle => 'Priest Information';
  @override
  String get noData => 'No data available';
  @override
  String get copiedPhone => 'Phone number copied';
  @override
  String get copiedEmail => 'Email copied';
  @override
  String get callAction => 'CALL';
  @override
  String get emailAction => 'EMAIL';
  @override
  String get birthAndOrdinationLabel => 'Birth & Ordination';
  @override
  String get currentParishLabel => 'Current Parish';
  @override
  String get degreeLabel => 'Degree';
  @override
  String get roleLabel => 'Position';

  // ── Search results screen ─────────────────────────────────────────────────────
  @override
  String get searchResultsTitle => 'Search Results';
  @override
  String get allResults => 'All';
  @override
  String get resultCount => 'results';
  @override
  String get noResultsTitle => 'No priests found';
  @override
  String get noResultsDesc => 'Try searching with a different name or\nchange the diocese.';
  @override
  String get resetPasswordAction => 'Reset PW';
  @override
  String get nfcCardAction => 'NFC Card';
  @override
  String get massRequestAction => 'Mass Req.';
  @override
  String get resetPasswordTitle => 'Reset password?';
  @override
  String get resetPasswordDesc =>
      'Password will be reset to default. The priest will need to change it on next sign in.';
  @override
  String resetPasswordConfirm(String holyName, String fullName) =>
      'Password reset for Fr. $holyName $fullName';

  // ── Mass request screen ──────────────────────────────────────────────────────
  @override
  String get massRequestTitle => 'Mass Request';
  @override
  String get massRequestSubtitle => 'Submit a Mass request';
  @override
  String get massFor => 'MASS FOR';
  @override
  String get massType => 'MASS TYPE';
  @override
  String get scheduledTime => 'SCHEDULED TIME';
  @override
  String get location => 'LOCATION';
  @override
  String get locationHint => 'Enter parish or location name...';
  @override
  String get intentionNote => 'INTENTION / NOTES';
  @override
  String get intentionHint => 'Enter Mass intention...';
  @override
  String get massRequestSent => 'Request sent!';
  @override
  String get massRequestSentDesc =>
      'The Mass request has been sent to the diocesan office. We will confirm as soon as possible.';
  @override
  String get massThanksgiving => 'Thanksgiving';
  @override
  String get massPeace => 'For Peace';
  @override
  String get massFuneral => 'Funeral';
  @override
  String get massWedding => 'Wedding';
  @override
  String get massOther => 'Other';

  // Weekdays
  @override
  String get monday => 'Monday';
  @override
  String get tuesday => 'Tuesday';
  @override
  String get wednesday => 'Wednesday';
  @override
  String get thursday => 'Thursday';
  @override
  String get friday => 'Friday';
  @override
  String get saturday => 'Saturday';
  @override
  String get sunday => 'Sunday';
  @override
  List<String> get weekdays => [monday, tuesday, wednesday, thursday, friday, saturday, sunday];

  // Mass request detail
  @override
  String get massDetailTitle => 'Request Details';
  @override
  String get massNewRequest => 'NEW REQUEST';
  @override
  String get massNewRequestDesc => 'A Mass request from another priest needs approval.';
  @override
  String get sectionSenderInfo => 'REQUESTING PRIEST INFORMATION';
  @override
  String get sectionMassDetails => 'MASS DETAILS';
  @override
  String get massTypeLabel => 'MASS TYPE';
  @override
  String get estimatedTime => 'ESTIMATED TIME';
  @override
  String get intentionLabel => 'INTENTION / NOTES';
  @override
  String get approveRequest => 'Approve Request';
  @override
  String get senderNameLabel => 'HOLY NAME & FULL NAME';
  @override
  String get currentParishContact => 'CURRENT PARISH';
  @override
  String get phoneContact => 'CONTACT PHONE';

  // ── NFC management screen ─────────────────────────────────────────────────────
  @override
  String get nfcManagementTitle => 'Manage NFC Cards';
  @override
  String get registeredCards => 'REGISTERED CARDS';
  @override
  String get addCard => 'Add Card';
  @override
  String get addNfcCard => 'Add NFC Card';
  @override
  String get addNfcCardTitle => 'Add NFC Card';
  @override
  String get addNfcCardDesc => 'Enter the NFC card code or tap the card on the phone.';
  @override
  String get nfcCardHint => 'e.g. NFC-ABC123';
  @override
  String get scanNfcCardButton => 'Scan NFC Card';
  @override
  String get noNfcCards => 'No NFC cards';
  @override
  String get noNfcCardsDesc => 'Tap "Add Card" to register\nan NFC card for this priest.';
  @override
  String get cardActive => 'Active';
  @override
  String get cardInactive => 'Off';
  @override
  String get addedOn => 'Added on';
  @override
  String get deleteNfcCard => 'Delete NFC Card?';
  @override
  String deleteNfcCardDesc(String id) =>
      'Card "$id" will be removed from the system. The priest will no longer be able to use this card for verification.';
  @override
  String cardCount(int n) => '$n card${n == 1 ? '' : 's'}';
  @override
  String cardAdded(String id) => 'Card $id added';
  @override
  String cardDeleted(String id) => 'Card $id deleted';

  // ── Emergency anointing screen ────────────────────────────────────────────────
  @override
  String get emergencyBadge => 'EMERGENCY';
  @override
  String get emergencyAnointingTitle => 'Emergency Anointing';
  @override
  String get emergencyAnointingSubtitle => 'Find the nearest priest to celebrate the sacrament';
  @override
  String get locating => 'Locating...';
  @override
  String get locatingDesc => 'Finding the nearest church\nwithin a 10km radius';
  @override
  String nearbyChurchesFound(int n) => 'Found $n church${n == 1 ? '' : 'es'}';
  @override
  String get nearbyRadius => 'Within 10km from your location';
  @override
  String get nearestChurches => 'NEAREST CHURCHES';
  @override
  String get nearest => 'NEAREST';
  @override
  String get noChurchFound => 'No churches found';
  @override
  String get noChurchFoundDesc =>
      'No churches within 10km.\nPlease contact the diocese directly.';
  @override
  String get locationPermissionRequired => 'Location permission required';
  @override
  String get locationPermissionDesc =>
      'Go to Settings → Priest Info\n→ Location → Allow while using app';
  @override
  String get cannotGetLocation => 'Cannot get location';
  @override
  String get cannotGetLocationDesc => 'Make sure GPS is on\nand try again.';
  @override
  String cannotCall(String phone) => 'Cannot call $phone';

  // ── Help screen ───────────────────────────────────────────────────────────────
  @override
  String get helpTitle => 'User Guide';
  @override
  String get helpWelcome => 'Welcome, Father,';
  @override
  String get helpWelcomeDesc =>
      'The Digital Priest ID system makes pastoral management and church connectivity more convenient and secure than ever.';
  @override
  String get helpNeedMore => 'NEED MORE HELP?';
  @override
  String get helpNeedMoreDesc =>
      'If you need direct guidance or encounter a technical issue, please contact the Diocesan Communications Office.';
  @override
  String get helpNfcTitle => 'NFC Verification';
  @override
  String get helpNfcDesc =>
      'The highest security technology — tap the priest card on the back of the phone to verify official identity.';
  @override
  String get helpQrTitle => 'ID QR Code';
  @override
  String get helpQrDesc =>
      'Each priest has a unique QR code. Scan to share contact information quickly or check in at church events.';
  @override
  String get helpMassTitle => 'Mass Request Management';
  @override
  String get helpMassDesc =>
      'Submit Mass requests online to the diocesan office or receive and approve requests from parishioners.';
  @override
  String get helpNotifTitle => 'Notification System';
  @override
  String get helpNotifDesc =>
      'Stay updated with urgent notifications, schedule reminders, and important news from the Diocese.';
  @override
  String get helpSearchTitle => 'Priest Search';
  @override
  String get helpSearchDesc =>
      'Easily look up contact information and positions of priests across the national Digital Ecclesia system.';
  @override
  String get helpBioTitle => 'Biometric Security';
  @override
  String get helpBioDesc =>
      'Use Face ID or Fingerprint to protect the app, ensuring only the owner can access sensitive information.';

  // ── Update request screen ─────────────────────────────────────────────────────
  @override
  String get updateRequestTitle => 'Request Update';
  @override
  String get updateRequestBannerTitle => 'Profile Update Request';
  @override
  String get updateRequestBannerDesc =>
      'Describe the information to be changed. The admin will verify and update it in the system.';
  @override
  String get infoTypeLabel => 'INFORMATION TYPE';
  @override
  String get requestContentLabel => 'REQUEST CONTENT';
  @override
  String get requestContentHint =>
      'Example: Update parish from "Parish A" to "Parish B" as of 01/01/2025...';
  @override
  String get processTitle => 'PROCESSING STEPS';
  @override
  String get step1 => 'Submit request → Admin receives it';
  @override
  String get step2 => 'Verify information (1–2 business days)';
  @override
  String get step3 => 'Update system and notify you';
  @override
  String get requestSent => 'Request sent!';
  @override
  String get requestSentDesc =>
      'The update request has been sent to the admin. We will review and respond within 3–5 business days.';
  @override
  String get catPersonalInfo => 'Personal Information';
  @override
  String get catParishDiocese => 'Parish / Diocese';
  @override
  String get catDegreeRole => 'Degree / Position';
  @override
  String get catBirthOrdination => 'Birth / Ordination Date';
  @override
  String get catEmailPhone => 'Email / Phone';
  @override
  String get catOther => 'Other';
  @override
  String get validContentRequired => 'Please describe the information to be updated';
  @override
  String get validContentTooShort => 'Please describe in more detail (minimum 10 characters)';

  // ── Language screen ──────────────────────────────────────────────────────────
  @override
  String get languageTitle => 'Language';
  @override
  String get chooseLanguage => 'Choose Language';
  @override
  String get languageSupportDesc =>
      'Display language for the entire app. Supports Vietnamese and English.';
  @override
  String get availableLanguages => 'AVAILABLE LANGUAGES';
  @override
  String get comingSoon => 'Coming soon';
  @override
  String languageSwitched(String name) => 'Switched to $name';
  @override
  String get languageChanged => 'Language updated!';

  // ── Saint name map ───────────────────────────────────────────────────────────
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

  // ── Liturgical date translation ──────────────────────────────────────────────
  @override
  String translateLiturgicalDate(String viDate) {
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
      const months = [
        'January', 'February', 'March', 'April', 'May', 'June',
        'July', 'August', 'September', 'October', 'November', 'December'
      ];
      final day = m.group(1)!;
      final monthIdx = int.tryParse(m.group(2)!) ?? 1;
      return '${months[monthIdx - 1]} $day';
    });
    return s;
  }

  // ── Liturgical season / week badge translation ───────────────────────────────
  @override
  String translateLiturgicalSeason(String viSeason) {
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
  @override
  String translateFeast(String viFeast) {
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
    var s = viFeast
        .replaceAll('Thứ Hai. ', 'Monday. ')
        .replaceAll('Thứ Ba. ', 'Tuesday. ')
        .replaceAll('Thứ Tư. ', 'Wednesday. ')
        .replaceAll('Thứ Năm. ', 'Thursday. ')
        .replaceAll('Thứ Sáu. ', 'Friday. ')
        .replaceAll('Thứ Bảy. ', 'Saturday. ')
        .replaceAll('Chúa Nhật. ', 'Sunday. ');
    s = translateLiturgicalSeason(s);
    s = s
        .replaceAll('Lễ Kính — ', 'Feast — ')
        .replaceAll('Lễ Trọng — ', 'Solemnity — ')
        .replaceAll('Lễ Nhớ — ', 'Memorial — ');
    s = _translateSaintPhrase(s);
    return s;
  }

  String _translateSaintPhrase(String s) {
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
  @override
  String translateReadingLabel(String viLabel) {
    switch (viLabel) {
      case 'Bài Đọc I':
        return 'First Reading';
      case 'Bài Đọc II':
        return 'Second Reading';
      case 'Đáp Ca':
        return 'Responsorial Psalm';
      case 'Tin Mừng':
        return 'Gospel';
      default:
        return viLabel;
    }
  }

  @override
  String translateReadingText(String viText) {
    if (viText == 'Thánh vịnh') return 'Psalm';
    return viText
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
  }

  // ── Mass type translation ────────────────────────────────────────────────────
  @override
  String translateMassType(String viType) {
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

  // ── Holy name translation ────────────────────────────────────────────────────
  @override
  String translateHolyName(String name) => _saintNameMap[name] ?? name;

  // ── Diocese / parish / role translation ─────────────────────────────────────
  @override
  String translateDiocese(String diocese) {
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

  @override
  String translateRole(String role) {
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

  @override
  String translateDegree(String degree) {
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
