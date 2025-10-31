import 'dart:async';
import 'package:flutter_application/middleware/auth_guard.dart';
import 'package:flutter_application/screens/booking_screen.dart';
import 'package:flutter_application/screens/my_tickets_screen.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'providers/auth_provider.dart';
import 'config/app_routes.dart';
import 'screens/home_screen.dart';
import 'screens/movie_detail_screen.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final SessionConfig _sessionConfig;
  late final StreamController<SessionState> _sessionStateStream;

  @override
  void initState() {
    super.initState();

    // Stream để điều khiển listener (dừng khi ở login)
    _sessionStateStream = StreamController<SessionState>.broadcast();

    // CẤU HÌNH SESSION TIMEOUT
    _sessionConfig = SessionConfig(
      invalidateSessionForAppLostFocus: const Duration(minutes: 2),
      invalidateSessionForUserInactivity: const Duration(minutes: 5),
    );

    // LẮNG NGHE TIMEOUT
    _sessionConfig.stream.listen((SessionTimeoutState state) {
      debugPrint('Session timeout event: $state');
      if (context.mounted){
        if (state == SessionTimeoutState.userInactivityTimeout ||
            state == SessionTimeoutState.appFocusTimeout) {
          _handleSessionTimeout();
        }
      }
    });
  }

  @override
  void dispose() {
    _sessionStateStream.close();
    super.dispose();
  }

  /// Xử lý khi hết hạn phiên
  Future<void> _handleSessionTimeout() async {
    // Dừng listener để tránh loop
    _sessionStateStream.add(SessionState.stopListening);

    // Giữ auth và navigator trước khi có async gap
    final auth = context.read<AuthProvider>();
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final currentRoute = ModalRoute.of(context)?.settings.name;

    await auth.logout();

    if (!context.mounted) return;

    if (currentRoute != '/' && currentRoute != null) {
      navigator.pushNamedAndRemoveUntil('/', (route) => false);
    }

    // Hiển thị thông báo
    messenger.showSnackBar(
      const SnackBar(
        content: Text('Phiên đăng nhập đã hết hạn'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 4),
      ),
    );

    // Khởi động lại listener sau 1 giây
    Future.delayed(const Duration(seconds: 1), () {
      debugPrint('SessionState.startListening...');
      if (!_sessionStateStream.isClosed) {
        _sessionStateStream.add(SessionState.startListening);
      }
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return SessionTimeoutManager(
      sessionConfig: _sessionConfig,
      sessionStateStream: _sessionStateStream.stream,
      child: ChangeNotifierProvider(
        create: (_)=> AuthProvider(),
        child: MaterialApp(
          title: 'Flutter Demo',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
            scaffoldBackgroundColor: Colors.grey[50]
          ),
          initialRoute: AppRoutes.home,
          routes: {
            AppRoutes.home: (context) => const HomeScreen(),
            AppRoutes.detail: (context) => const MovieDetailScreen(),
            AppRoutes.login: (context) => LoginScreen(onLogin: (user, token) {
              context.read<AuthProvider>().login(user, token);
            }),
            AppRoutes.myTickets: (context) => AuthGuard(
              child: const MyTicketsScreen(),
            ),
            AppRoutes.booking: (context) => AuthGuard(
              child: const BookingScreen(),
            )
          }
        ),
      ),
    );
  }
}
