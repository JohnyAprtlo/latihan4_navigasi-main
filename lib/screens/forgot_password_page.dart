import 'package:flutter/material.dart';
import '../config/app_theme.dart';
import 'login_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;
  bool _emailSent = false;

  void _sendResetLink() async {
    // Validasi email
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Masukkan alamat email')));
      return;
    }

    if (!_emailController.text.contains('@')) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Format email tidak valid')));
      return;
    }

    // Simulate sending email
    setState(() => _isLoading = true);
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      _isLoading = false;
      _emailSent = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24),
            child: Container(
              constraints: BoxConstraints(maxWidth: 450),
              decoration: BoxDecoration(
                color: AppTheme.backgroundCard,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.borderSubtle),
                boxShadow: AppTheme.cardShadow,
              ),
              padding: EdgeInsets.all(32),
              child: _emailSent ? _buildSuccessView() : _buildFormView(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Icon
        Icon(Icons.lock_reset_rounded, size: 64, color: AppTheme.accentBlue),
        SizedBox(height: 16),

        // Title
        Text(
          'Lupa Password?',
          style: AppTheme.heading1.copyWith(fontSize: 28),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8),
        Text(
          'Masukkan email Anda untuk menerima link reset password',
          style: AppTheme.bodyMedium.copyWith(color: AppTheme.textSecondary),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 32),

        // Email Field
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Email',
            prefixIcon: Icon(Icons.email_outlined),
            hintText: 'contoh@email.com',
          ),
        ),
        SizedBox(height: 32),

        // Send Button
        SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _sendResetLink,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _isLoading
                ? SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text('Kirim Link Reset', style: AppTheme.button),
          ),
        ),
        SizedBox(height: 24),

        // Back to Login
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.arrow_back, size: 16, color: AppTheme.textSecondary),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
              child: Text(
                'Kembali ke Login',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.accentBlue,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSuccessView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Success Icon
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: AppTheme.successGreen.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check_circle_rounded,
            size: 50,
            color: AppTheme.successGreen,
          ),
        ),
        SizedBox(height: 24),

        // Success Title
        Text(
          'Email Terkirim!',
          style: AppTheme.heading2,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 12),

        // Success Message
        Text(
          'Kami telah mengirim link reset password ke ${_emailController.text}',
          style: AppTheme.bodyMedium.copyWith(color: AppTheme.textSecondary),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8),
        Text(
          'Silakan cek inbox atau folder spam Anda.',
          style: AppTheme.bodySmall.copyWith(color: AppTheme.textMuted),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 32),

        // Back to Login Button
        SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.accentBlue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text('Kembali ke Login', style: AppTheme.button),
          ),
        ),
      ],
    );
  }
}
