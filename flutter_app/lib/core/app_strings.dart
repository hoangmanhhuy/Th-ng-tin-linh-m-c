import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/language_provider.dart';
import 'en.dart';
import 'vi.dart';

abstract class AppStrings {
  const AppStrings();

  static AppStrings of(BuildContext context) {
    final lang = context.watch<LanguageProvider>().languageCode;
    return lang == 'en' ? const AppStringsEn() : const AppStringsVi();
  }

  bool get isEn;

  // ── App title ───────────────────────────────────────────────────────────────
  String get appTitle;
  String get appTitleShort;

  // ── Bottom navigation ────────────────────────────────────────────────────────
  String get navHome;
  String get navScanCard;
  String get navScanQr;
  String get navHistory;
  String get navSettings;

  // ── Common actions ───────────────────────────────────────────────────────────
  String get login;
  String get logout;
  String get logoutUppercase;
  String get exit;
  String get search;
  String get close;
  String get cancel;
  String get confirm;
  String get done;
  String get retry;
  String get retryLower;
  String get back;
  String get details;
  String get approve;
  String get reject;
  String get delete;
  String get add;
  String get save;
  String get share;
  String get copy;
  String get callNow;
  String get openSettings;
  String get select;
  String get sendRequest;
  String get updatePassword;
  String get submitRequest;
  String get sendSupportRequest;
  String get markAllRead;

  // ── Home screen ──────────────────────────────────────────────────────────────
  String get searchPriest;
  String get searchPriestHint;
  String get searchPriestHintDots;
  String get chooseDiocese;
  String get chooseDioceseAlt;
  String get popularPriests;
  String get viewAll;

  // Emergency card
  String get emergencyLabel;
  String get emergencyTitle;
  String get emergencySubtitle;

  // Info section
  String get infoNeedToKnow;
  String get infoOfficialData;
  String get infoOfficialDataDesc;
  String get infoSearchGuide;
  String get infoSearchGuideDesc;

  // Priest ID card
  String get priestIdCard;
  String get priestInfo;

  // Action bar
  String get actionScanCard;
  String get actionMassRequest;
  String get actionQrCode;
  String get actionFaceId;

  // Mass request card (home)
  String get minutesAgo;
  String get massNotificationSample;

  // Search section (priest home)
  String get searchPriestSection;

  // Liturgical section
  String get liturgicalDay;
  String get feastDay;

  // Help button
  String get helpGuide;

  // ── Settings screen ──────────────────────────────────────────────────────────
  String get settingsTitle;
  String get sectionAccountSecurity;
  String get sectionAppSupport;
  String get menuPersonalInfo;
  String get menuBiometrics;
  String get menuChangePassword;
  String get menuLanguage;
  String get menuUpdateRequest;
  String get menuSupport;

  // ── Login screen ─────────────────────────────────────────────────────────────
  String get loginTitle;
  String get loginSubtitle;
  String get loginUsernameLabel;
  String get loginPasswordLabel;
  String get forgotPassword;
  String get orUseNfcCard;
  String get tapPriestCard;
  String get notAPriest;
  String get backToLaityHome;

  // ── Scan screen ──────────────────────────────────────────────────────────────
  String get scanQr;
  String get scanInstruction;
  String get scanAutoDetect;
  String get scanInvalidQr;
  String get cameraPermissionDenied;
  String get cameraCannotOpen;
  String get cameraPermissionInstruction;
  String get cameraNotSupported;

  // ── NFC screen ───────────────────────────────────────────────────────────────
  String get scanNfcCard;
  String get touchPriestCard;
  String get nfcInstruction;
  String get nfcChecking;
  String get nfcNotAvailable;
  String get nfcWaiting;
  String get nfcReadSuccess;
  String get nfcPriestNotFound;
  String get nfcInvalidFormat;
  String get nfcInvalidData;
  String get nfcReadError;
  String get nfcStartFailed;
  String get nfcNeedsDeveloper;
  String get noNfcCard;
  String get loginWithPassword;

  // ── History screen ───────────────────────────────────────────────────────────
  String get historyTitle;
  String get historySubtitle;
  String get historySearch;
  String get filterAll;
  String get filterUpdate;
  String get filterMass;
  String get filterContribution;
  String get statusCompleted;
  String get statusProcessing;
  String get statusRejected;
  String get historyUpdateRequest;
  String get historyMassThanksgiving;
  String get historyMassPeace;

  // ── Biometrics screen ────────────────────────────────────────────────────────
  String get biometricsTitle;
  String get biometricsSecurity;
  String get biometricsDesc;
  String get sectionAuthMethod;
  String get sectionLockSettings;
  String get faceIdSubtitle;
  String get touchId;
  String get touchIdSubtitle;
  String get autoLock;
  String get autoLockSubtitle;
  String get faceIdEnabled;
  String get touchIdEnabled;
  String get biometricsNote;

  // ── Change password ──────────────────────────────────────────────────────────
  String get changePasswordTitle;
  String get accountSecurity;
  String get passwordRequirements;
  String get currentPassword;
  String get currentPasswordHint;
  String get newPassword;
  String get newPasswordHint;
  String get confirmNewPassword;
  String get confirmPasswordHint;
  String get passwordChangedSuccess;
  String get passwordChangedDesc;
  String get validCurrentPasswordRequired;
  String get validPasswordTooShort;
  String get validNewPasswordRequired;
  String get validPasswordMin8;
  String get validPasswordSameAsCurrent;
  String get validConfirmRequired;
  String get validConfirmMismatch;

  // ── Notifications screen ─────────────────────────────────────────────────────
  String get notificationsTitle;
  String get notifLatest;

  // ── Personal info screen ─────────────────────────────────────────────────────
  String get personalInfoTitle;
  String get holyName;
  String get activeStatus;
  String get sectionIdentity;
  String get sectionPersonal;
  String get sectionContact;
  String get fieldId;
  String get fieldDiocese;
  String get fieldParish;
  String get fieldRole;
  String get fieldBirthDate;
  String get fieldOrdinationDate;
  String get fieldDegree;
  String get fieldEmail;
  String get fieldPhone;
  String get copiedValue;
  String get personalInfoNote;

  // ── Priest profile screen ────────────────────────────────────────────────────
  String get priestIdCode;
  String get dioceseLabel;
  String get sectionDetailedInfo;
  String get sectionWorkHistory;
  String get sectionUpdateHistory;
  String get labelBirthDate;
  String get labelOrdination;
  String get labelCurrentParish;
  String get labelDegree;
  String get labelEmail;
  String get qrIdCode;
  String get qrIdCodeModal;
  String get qrUsageDesc;
  String get updateRoleNew;
  String get updateContactChange;
  String get toPresent;
  String get vicePriest;
  String get parishOf;

  // ── Priest result sheet ──────────────────────────────────────────────────────
  String get verified;
  String get sectionBasicInfo;
  String get birthAndOrdination;
  String get ordinationPrefix;
  String get callPhone;
  String get sendEmail;
  String get idCode;

  // ── QR screen ────────────────────────────────────────────────────────────────
  String get qrScreenTitle;
  String get identityVerified;
  String get qrIdNumber;
  String get qrUsageNote;

  // ── Search detail screen ─────────────────────────────────────────────────────
  String get priestInfoTitle;
  String get noData;
  String get copiedPhone;
  String get copiedEmail;
  String get callAction;
  String get emailAction;
  String get birthAndOrdinationLabel;
  String get currentParishLabel;
  String get degreeLabel;
  String get roleLabel;

  // ── Search results screen ─────────────────────────────────────────────────────
  String get searchResultsTitle;
  String get allResults;
  String get resultCount;
  String get noResultsTitle;
  String get noResultsDesc;
  String get resetPasswordAction;
  String get nfcCardAction;
  String get massRequestAction;
  String get resetPasswordTitle;
  String get resetPasswordDesc;
  String resetPasswordConfirm(String holyName, String fullName);

  // ── Mass request screen ──────────────────────────────────────────────────────
  String get massRequestTitle;
  String get massRequestSubtitle;
  String get massFor;
  String get massType;
  String get scheduledTime;
  String get location;
  String get locationHint;
  String get intentionNote;
  String get intentionHint;
  String get massRequestSent;
  String get massRequestSentDesc;
  String get massThanksgiving;
  String get massPeace;
  String get massFuneral;
  String get massWedding;
  String get massOther;

  // Weekdays
  String get monday;
  String get tuesday;
  String get wednesday;
  String get thursday;
  String get friday;
  String get saturday;
  String get sunday;
  List<String> get weekdays;

  // Mass request detail
  String get massDetailTitle;
  String get massNewRequest;
  String get massNewRequestDesc;
  String get sectionSenderInfo;
  String get sectionMassDetails;
  String get massTypeLabel;
  String get estimatedTime;
  String get intentionLabel;
  String get approveRequest;
  String get senderNameLabel;
  String get currentParishContact;
  String get phoneContact;

  // ── NFC management screen ─────────────────────────────────────────────────────
  String get nfcManagementTitle;
  String get registeredCards;
  String get addCard;
  String get addNfcCard;
  String get addNfcCardTitle;
  String get addNfcCardDesc;
  String get nfcCardHint;
  String get scanNfcCardButton;
  String get noNfcCards;
  String get noNfcCardsDesc;
  String get cardActive;
  String get cardInactive;
  String get addedOn;
  String get deleteNfcCard;
  String deleteNfcCardDesc(String id);
  String cardCount(int n);
  String cardAdded(String id);
  String cardDeleted(String id);

  // ── Emergency anointing screen ────────────────────────────────────────────────
  String get emergencyBadge;
  String get emergencyAnointingTitle;
  String get emergencyAnointingSubtitle;
  String get locating;
  String get locatingDesc;
  String nearbyChurchesFound(int n);
  String get nearbyRadius;
  String get nearestChurches;
  String get nearest;
  String get noChurchFound;
  String get noChurchFoundDesc;
  String get locationPermissionRequired;
  String get locationPermissionDesc;
  String get cannotGetLocation;
  String get cannotGetLocationDesc;
  String cannotCall(String phone);

  // ── Help screen ───────────────────────────────────────────────────────────────
  String get helpTitle;
  String get helpWelcome;
  String get helpWelcomeDesc;
  String get helpNeedMore;
  String get helpNeedMoreDesc;
  String get helpNfcTitle;
  String get helpNfcDesc;
  String get helpQrTitle;
  String get helpQrDesc;
  String get helpMassTitle;
  String get helpMassDesc;
  String get helpNotifTitle;
  String get helpNotifDesc;
  String get helpSearchTitle;
  String get helpSearchDesc;
  String get helpBioTitle;
  String get helpBioDesc;

  // ── Update request screen ─────────────────────────────────────────────────────
  String get updateRequestTitle;
  String get updateRequestBannerTitle;
  String get updateRequestBannerDesc;
  String get infoTypeLabel;
  String get requestContentLabel;
  String get requestContentHint;
  String get processTitle;
  String get step1;
  String get step2;
  String get step3;
  String get requestSent;
  String get requestSentDesc;
  String get catPersonalInfo;
  String get catParishDiocese;
  String get catDegreeRole;
  String get catBirthOrdination;
  String get catEmailPhone;
  String get catOther;
  String get validContentRequired;
  String get validContentTooShort;

  // ── Language screen ──────────────────────────────────────────────────────────
  String get languageTitle;
  String get chooseLanguage;
  String get languageSupportDesc;
  String get availableLanguages;
  String get comingSoon;
  String languageSwitched(String name);
  String get languageChanged;

  // ── Translation methods ──────────────────────────────────────────────────────
  String translateLiturgicalDate(String viDate);
  String translateLiturgicalSeason(String viSeason);
  String translateFeast(String viFeast);
  String translateReadingLabel(String viLabel);
  String translateReadingText(String viText);
  String translateMassType(String viType);
  String translateHolyName(String name);
  String translateDiocese(String diocese);
  String translateRole(String role);
  String translateDegree(String degree);
}
