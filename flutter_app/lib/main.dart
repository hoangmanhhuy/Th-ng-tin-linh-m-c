import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/app_theme.dart';
import 'viewmodels/viewmodels.dart';
import 'models/models.dart';
import 'views/home_screen.dart';
import 'views/login_screen.dart';
import 'views/history_screen.dart';
import 'views/settings_screen.dart';
import 'views/nfc_screen.dart';
import 'views/scan_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => LiturgicalViewModel()),
      ],
      child: const DigitalEcclesiaApp(),
    ),
  );
}

class DigitalEcclesiaApp extends StatelessWidget {
  const DigitalEcclesiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Thông Tin Linh Mục',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('vi', 'VN'),
        Locale('en', 'US'),
      ],
      locale: const Locale('vi', 'VN'),
      home: const RootScreen(),
    );
  }
}

class RootScreen extends StatelessWidget {
  const RootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authViewModel = context.watch<AuthViewModel>();
    if (authViewModel.role == UserRole.priest) {
      return const PriestMainLayout();
    }
    return const PublicHomeScreen();
  }
}

class PriestMainLayout extends StatefulWidget {
  const PriestMainLayout({super.key});

  @override
  State<PriestMainLayout> createState() => _PriestMainLayoutState();
}

class _PriestMainLayoutState extends State<PriestMainLayout> {
  int _currentIndex = 0;

  void _switchTab(int index) => setState(() => _currentIndex = index);

  static const _tabs = [
    _TabItem(label: 'Trang chủ', icon: Icons.home_rounded, activeColor: AppColors.primary),
    _TabItem(label: 'Quét thẻ', icon: Icons.nfc_rounded, activeColor: AppColors.orange500),
    _TabItem(label: 'Quét QR', icon: Icons.qr_code_scanner_rounded, activeColor: Color(0xFF2563EB)),
    _TabItem(label: 'Lịch sử', icon: Icons.history_rounded, activeColor: AppColors.emerald),
    _TabItem(label: 'Cài đặt', icon: Icons.settings_rounded, activeColor: AppColors.primary),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          PriestHomeScreen(onSwitchToScan: () => _switchTab(2)),
          const NfcScreen(),
          ScanScreen(isActive: _currentIndex == 2),
          const HistoryScreen(),
          const SettingsScreen(),
        ],
      ),
      bottomNavigationBar: _BottomNav(
        currentIndex: _currentIndex,
        tabs: _tabs,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}

class _TabItem {
  final String label;
  final IconData icon;
  final Color activeColor;
  const _TabItem({required this.label, required this.icon, required this.activeColor});
}

class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final List<_TabItem> tabs;
  final ValueChanged<int> onTap;

  const _BottomNav({
    required this.currentIndex,
    required this.tabs,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 24,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(tabs.length, (i) {
              final tab = tabs[i];
              final isActive = i == currentIndex;
              return GestureDetector(
                onTap: () => onTap(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  padding: EdgeInsets.symmetric(
                    horizontal: isActive ? 16 : 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isActive ? tab.activeColor : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: isActive
                        ? [
                            BoxShadow(
                              color: tab.activeColor.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        tab.icon,
                        size: 20,
                        color: isActive ? Colors.white : AppColors.gray400,
                      ),
                      if (isActive) ...[
                        const SizedBox(width: 6),
                        Text(
                          tab.label,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
