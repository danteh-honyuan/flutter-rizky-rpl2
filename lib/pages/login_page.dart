
import 'dart:async';
import 'package:flutter/material.dart';
import '../services/api_exception.dart';
import '../services/auth_service.dart';
import 'home_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with WidgetsBindingObserver {

  final _emailC = TextEditingController();
  final _passC = TextEditingController();
  final _auth = AuthService();

  bool _loading = false;
  bool _obscurePassword = true;

  int _currentCanto = 0;
  Timer? _cantoTimer;

  final List<Map<String, String>> _cantos = [
    {
      'title': 'THE OUTCAST',
      'subtitle': 'A journey begins.',
      'image': 'assets/canto/canto_1.jpg',
    },
    {
      'title': 'THE UNLOVING',
      'subtitle': 'A city of forgotten memories.',
      'image': 'assets/canto/canto_2.jpg',
    },
    {
      'title': 'THE UNCONFRONTING',
      'subtitle': 'Faith becomes a battlefield.',
      'image': 'assets/canto/canto_3.jpg',
    },
    {
      'title': 'THE UNYIELDING',
      'subtitle': 'The past refuses to disappear.',
      'image': 'assets/canto/canto_4.jpg',
    },
    {
      'title': 'THE UNFINISHING',
      'subtitle': 'A dream lost at sea.',
      'image': 'assets/canto/canto_5.jpg',
    },
    {
      'title': 'THE HEARTBREAKING',
      'subtitle': 'Some stories never end.',
      'image': 'assets/canto/canto_6.jpg',
    },
    {
      'title': 'THE DREAM ENDING',
      'subtitle': 'A dream beyond the horizon.',
      'image': 'assets/canto/canto_7.jpg',
    },
    {
      'title': 'THE MERCILESS',
      'subtitle': 'The journey continues.',
      'image': 'assets/canto/canto_8.jpg',
    },
  ];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    _startCantoRotation();
  }

  void _startCantoRotation() {
    _cantoTimer?.cancel();

    _cantoTimer = Timer.periodic(
      const Duration(seconds: 15),
      (timer) {
        if (!mounted) return;

        setState(() {
          _currentCanto =
              (_currentCanto + 1) % _cantos.length;
        });
      },
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _startCantoRotation();
    } else {
      _cantoTimer?.cancel();
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF8B2929),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _login() async {
    if (_emailC.text.trim().isEmpty ||
        _passC.text.isEmpty) {
      _showMessage('Email dan password wajib diisi');
      return;
    }

    setState(() => _loading = true);

    try {
      await _auth.login(
        email: _emailC.text.trim(),
        password: _passC.text,
      );

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const HomePage(),
        ),
      );
    } on ApiException catch (e) {
      if (mounted) _showMessage(e.message);
    } catch (_) {
      if (mounted) {
        _showMessage('Terjadi kesalahan tak terduga');
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    _cantoTimer?.cancel();

    _emailC.dispose();
    _passC.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canto = _cantos[_currentCanto];

    return Scaffold(
      backgroundColor: const Color(0xFF11100F),
      body: Stack(
        fit: StackFit.expand,
        children: [

          // BACKGROUND IMAGE
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 1500),
            switchInCurve: Curves.easeInOut,
            switchOutCurve: Curves.easeInOut,
            child: Container(
              key: ValueKey(_currentCanto),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(canto['image']!),
                  fit: BoxFit.cover,
                  onError: (_, __) {},
                ),
              ),
            ),
          ),

          // DARK CINEMATIC OVERLAY
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.65),
                  Colors.black.withValues(alpha: 0.45),
                  Colors.black.withValues(alpha: 0.85),
                ],
              ),
            ),
          ),

          // LOGIN CONTENT
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 30,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 430,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      // COMPANY TITLE
                      const Text(
                        'LIMBUS COMPANY',
                        style: TextStyle(
                          color: Color(0xFFD8B979),
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 5,
                        ),
                      ),

                      const SizedBox(height: 8),

                      const Text(
                        'BUS DEPARTURE TERMINAL',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                          letterSpacing: 4,
                        ),
                      ),

                      const SizedBox(height: 35),

                      // CANTO INFORMATION
                      AnimatedSwitcher(
                        duration: const Duration(
                          milliseconds: 800,
                        ),
                        child: Column(
                          key: ValueKey(_currentCanto),
                          children: [
                            Text(
                              'NOW PASSING THROUGH',
                              style: TextStyle(
                                color: Colors.white.withValues(
                                  alpha: 0.7,
                                ),
                                fontSize: 11,
                                letterSpacing: 3,
                              ),
                            ),

                            const SizedBox(height: 10),

                            Text(
                              'CANTO ${_currentCanto + 1}',
                              style: const TextStyle(
                                color: Color(0xFFD8B979),
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 5,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Text(
                              canto['title']!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 3,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Text(
                              canto['subtitle']!,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 35),

                      // LOGIN PANEL
                      Container(
                        padding: const EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          color: const Color(0xFF171614)
                              .withValues(alpha: 0.94),
                          border: Border.all(
                            color: const Color(0xFF9B7946),
                            width: 1.2,
                          ),
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(
                                alpha: 0.5,
                              ),
                              blurRadius: 25,
                              spreadRadius: 3,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.stretch,
                          children: [

                            const Text(
                              'PASSENGER IDENTIFICATION',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color(0xFFD8B979),
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                              ),
                            ),

                            const SizedBox(height: 8),

                            const Text(
                              'Please provide your credentials to board.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 12,
                              ),
                            ),

                            const SizedBox(height: 30),

                            // EMAIL
                            _buildLabel('EMAIL ADDRESS'),

                            const SizedBox(height: 8),

                            TextField(
                              controller: _emailC,
                              keyboardType:
                                  TextInputType.emailAddress,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                              decoration: _inputDecoration(
                                hint: 'Enter your email',
                                icon: Icons.email_outlined,
                              ),
                            ),

                            const SizedBox(height: 20),

                            // PASSWORD
                            _buildLabel('PASSWORD'),

                            const SizedBox(height: 8),

                            TextField(
                              controller: _passC,
                              obscureText: _obscurePassword,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                              decoration: _inputDecoration(
                                hint: 'Enter your password',
                                icon: Icons.lock_outline,
                              ).copyWith(
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword =
                                          !_obscurePassword;
                                    });
                                  },
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: Colors.white54,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 30),

                            // LOGIN BUTTON
                            SizedBox(
                              height: 52,
                              child: ElevatedButton(
                                onPressed:
                                    _loading ? null : _login,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      const Color(0xFF8B2929),
                                  disabledBackgroundColor:
                                      Colors.grey.shade800,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(4),
                                    side: const BorderSide(
                                      color: Color(0xFFD8B979),
                                      width: 0.8,
                                    ),
                                  ),
                                ),
                                child: _loading
                                    ? const SizedBox(
                                        height: 22,
                                        width: 22,
                                        child:
                                            CircularProgressIndicator(
                                          color: Colors.white,
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Text(
                                        'BOARD MEPhISTOPHELES',
                                        style: TextStyle(
                                          fontWeight:
                                              FontWeight.bold,
                                          letterSpacing: 2,
                                        ),
                                      ),
                              ),
                            ),

                            const SizedBox(height: 18),

                            // REGISTER
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const RegisterPage(),
                                  ),
                                );
                              },
                              child: const Text(
                                'NEW PASSENGER? REGISTER HERE',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFFD8B979),
                                  fontSize: 11,
                                  letterSpacing: 1,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 25),

                      // FOOTER
                      const Text(
                        'THE CITY NEVER STOPS MOVING.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 10,
                          letterSpacing: 3,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        'MEPHISTOPHELES • DESTINATION UNKNOWN',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withValues(
                            alpha: 0.35,
                          ),
                          fontSize: 9,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Color(0xFFD8B979),
        fontSize: 11,
        fontWeight: FontWeight.bold,
        letterSpacing: 2,
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(
        color: Colors.white38,
        fontSize: 13,
      ),
      prefixIcon: Icon(
        icon,
        color: const Color(0xFFD8B979),
      ),
      filled: true,
      fillColor: const Color(0xFF252321),
      contentPadding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 12,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(
          color: Color(0xFF514638),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(4),
        borderSide: const BorderSide(
          color: Color(0xFFD8B979),
          width: 1.5,
        ),
      ),
    );
  }
}
