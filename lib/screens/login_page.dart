import 'package:flutter/material.dart';
import '../config/app_theme.dart';
import '../database/database_service.dart'; // Import database service
import 'dashboard_page.dart';
import 'register_page.dart';
import 'forgot_password_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final DatabaseService _db = DatabaseService(); // Instance database service
  bool _obscurePassword = true;
  bool _isLoading = false;

  /// Method untuk login dengan authentication real menggunakan Hive
  void _login() async {
    // Validasi: username dan password tidak boleh kosong
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Masukkan username dan password')));
      return;
    }

    // Set loading state
    setState(() => _isLoading = true);

    // Simulasi delay network (opsional, untuk UX)
    await Future.delayed(Duration(milliseconds: 800));

    // Coba login menggunakan database
    // loginUser() akan return true jika username & password benar
    bool success = await _db.loginUser(
      _usernameController.text.trim(), // trim() untuk hapus spasi
      _passwordController.text,
    );

    // Clear loading state
    setState(() => _isLoading = false);

    if (success) {
      // Login berhasil! Navigate ke Dashboard
      // Menggunakan pushReplacement agar user tidak bisa back ke login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DashboardPage()),
      );
    } else {
      // Login gagal - username atau password salah
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Username atau password salah!'),
          backgroundColor: AppTheme.warningRed,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: LayoutBuilder(
              builder: (context, constraints) {
                bool isDesktop = constraints.maxWidth > 650;

                return Container(
                  constraints: BoxConstraints(maxWidth: isDesktop ? 900 : 500),
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundCard,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppTheme.borderSubtle),
                    boxShadow: AppTheme.cardShadow,
                  ),
                  child: isDesktop
                      ? Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(32),
                                child: _buildForm(),
                              ),
                            ),
                            _buildWelcomePanel(),
                          ],
                        )
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _buildMobileHeader(),
                            Padding(
                              padding: EdgeInsets.all(24),
                              child: _buildForm(),
                            ),
                          ],
                        ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileHeader() {
    return Container(
      padding: EdgeInsets.all(24),
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: AppTheme.accentGradient,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          Icon(Icons.school_rounded, size: 40, color: Colors.white),
          SizedBox(height: 8),
          Text(
            'Pengingat Jadwal Kuliah',
            style: AppTheme.bodyLarge.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Login', style: AppTheme.heading1),
        SizedBox(height: 8),
        Text(
          'Selamat datang kembali!',
          style: AppTheme.bodyMedium.copyWith(color: AppTheme.textSecondary),
        ),
        SizedBox(height: 24),

        TextField(
          controller: _usernameController,
          decoration: InputDecoration(
            labelText: 'Username',
            prefixIcon: Icon(Icons.person_outline),
          ),
        ),
        SizedBox(height: 16),

        TextField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          decoration: InputDecoration(
            labelText: 'Password',
            prefixIcon: Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                color: AppTheme.textSecondary,
              ),
              onPressed: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
            ),
          ),
        ),
        SizedBox(height: 8),

        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ForgotPasswordPage()),
            ),
            child: Text(
              'Lupa Password?',
              style: AppTheme.bodySmall.copyWith(color: AppTheme.accentBlue),
            ),
          ),
        ),
        SizedBox(height: 16),

        SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _login,
            child: _isLoading
                ? SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  )
                : Text('Login', style: AppTheme.button),
          ),
        ),
        SizedBox(height: 16),

        Center(
          child: Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                'Belum punya akun? ',
                style: AppTheme.bodySmall.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => RegisterPage()),
                ),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 0),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Daftar',
                  style: AppTheme.bodySmall.copyWith(
                    color: AppTheme.accentBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomePanel() {
    return Container(
      width: 320,
      decoration: BoxDecoration(
        gradient: AppTheme.accentGradient,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      padding: EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.calendar_today_rounded, size: 56, color: Colors.white),
          SizedBox(height: 20),
          Text(
            'Pengingat Jadwal Kuliah',
            style: AppTheme.heading3.copyWith(color: Colors.white),
          ),
          SizedBox(height: 8),
          Text(
            'Kelola jadwal dan tugas kuliah Anda dengan mudah',
            style: AppTheme.bodyMedium.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          SizedBox(height: 24),
          Divider(color: Colors.white.withOpacity(0.3)),
          SizedBox(height: 24),
          Text(
            'Belum Punya Akun?',
            style: AppTheme.bodyMedium.copyWith(
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 45,
            child: OutlinedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => RegisterPage()),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: BorderSide(
                  color: Colors.white.withOpacity(0.7),
                  width: 2,
                ),
              ),
              child: Text(
                'Daftar Sekarang',
                style: AppTheme.button.copyWith(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
