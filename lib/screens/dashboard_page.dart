import 'package:flutter/material.dart';
import 'input_mk_page.dart';
import 'atur_jadwal_page.dart';
import 'pengingat_tugas_page.dart';
import 'laporan_tugas_page.dart';
import 'profil_page.dart';
import 'login_page.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/data_models.dart';
import '../models/data_manager.dart';
import '../config/app_theme.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<Tugas> _tugas = [];

  @override
  void initState() {
    super.initState();
    _loadTugas();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadTugas();
  }

  Future<void> _loadTugas() async {
    final tugasData = await DataManager.loadTugas();
    setState(() {
      _tugas = tugasData;
    });
  }

  int get _totalTugas => _tugas.length;
  int get _selesai => _tugas.where((t) => t.selesai).length;
  int get _belumSelesai => _totalTugas - _selesai;
  double get _progress => _totalTugas == 0 ? 0 : (_selesai / _totalTugas) * 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/logo_uniba.png', height: 32, width: 32),
            SizedBox(width: 12),
            Text('Dashboard'),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadTugas,
            tooltip: 'Refresh',
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Card
              _buildWelcomeCard(),
              SizedBox(height: 24),

              // Quick Actions
              Text('Menu Cepat', style: AppTheme.heading3),
              SizedBox(height: 16),
              _buildQuickActions(),
              SizedBox(height: 32),

              // Statistics Card
              Text('Ringkasan Tugas', style: AppTheme.heading3),
              SizedBox(height: 16),
              _buildStatisticsCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Container(
        color: AppTheme.backgroundCard,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(gradient: AppTheme.accentGradient),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Image.asset(
                          'assets/images/logo_uniba.png',
                          height: 40,
                          width: 40,
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'UNIBA',
                              style: AppTheme.heading3.copyWith(
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              'Pengingat Jadwal',
                              style: AppTheme.bodySmall.copyWith(
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            _buildDrawerItem(
              Icons.book_rounded,
              'Input MK',
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => InputMKPage()),
              ),
            ),
            _buildDrawerItem(
              Icons.schedule_rounded,
              'Atur Jadwal',
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AturJadwalPage()),
              ),
            ),
            _buildDrawerItem(
              Icons.notifications_rounded,
              'Pengingat Tugas',
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => PengingatTugasPage()),
              ),
            ),
            _buildDrawerItem(
              Icons.report_rounded,
              'Laporan Tugas',
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LaporanTugasPage()),
              ),
            ),
            Divider(color: AppTheme.borderSubtle),
            _buildDrawerItem(
              Icons.person_rounded,
              'Profil Mahasiswa',
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilPage()),
              ),
            ),
            Divider(color: AppTheme.borderSubtle),
            _buildDrawerItem(Icons.logout_rounded, 'Logout', _logout),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.accentBlue),
      title: Text(title, style: AppTheme.bodyMedium),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.backgroundCard,
        title: Row(
          children: [
            Icon(Icons.logout_rounded, color: AppTheme.warningRed),
            SizedBox(width: 12),
            Text('Konfirmasi Logout', style: AppTheme.heading3),
          ],
        ),
        content: Text(
          'Apakah Anda yakin ingin keluar dari aplikasi?',
          style: AppTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => LoginPage()),
                (route) => false, // Remove all previous routes
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.warningRed,
            ),
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppTheme.accentGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selamat Datang! 👋',
                  style: AppTheme.heading2.copyWith(color: Colors.white),
                ),
                SizedBox(height: 8),
                Text(
                  'Kelola jadwal kuliah dan tugas Anda dengan mudah',
                  style: AppTheme.bodyMedium.copyWith(
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.school_rounded,
            size: 64,
            color: Colors.white.withOpacity(0.3),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildQuickActionCard(
          'Input MK',
          Icons.book_rounded,
          AppTheme.accentBlue,
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => InputMKPage()),
          ),
        ),
        _buildQuickActionCard(
          'Atur Jadwal',
          Icons.schedule_rounded,
          Color(0xFF9D4EDD),
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AturJadwalPage()),
          ),
        ),
        _buildQuickActionCard(
          'Pengingat Tugas',
          Icons.notifications_active_rounded,
          Color(0xFFFFB703),
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PengingatTugasPage()),
          ),
        ),
        _buildQuickActionCard(
          'Laporan Tugas',
          Icons.assessment_rounded,
          AppTheme.successGreen,
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LaporanTugasPage()),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionCard(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.backgroundCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.borderSubtle),
          boxShadow: AppTheme.subtleShadow,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 32, color: color),
            ),
            SizedBox(height: 12),
            Text(
              title,
              style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.backgroundCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.borderSubtle),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        children: [
          // Progress Text
          Text(
            _totalTugas == 0
                ? 'Belum ada tugas'
                : '${_progress.toStringAsFixed(0)}% Selesai',
            style: AppTheme.heading2,
          ),
          SizedBox(height: 24),

          // Pie Chart
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sections: _totalTugas == 0
                    ? [
                        PieChartSectionData(
                          value: 1,
                          title: '',
                          color: AppTheme.textMuted.withOpacity(0.3),
                          radius: 65,
                        ),
                      ]
                    : [
                        PieChartSectionData(
                          value: _selesai.toDouble(),
                          title: '',
                          color: AppTheme.successGreen,
                          radius: 65,
                        ),
                        PieChartSectionData(
                          value: _belumSelesai.toDouble(),
                          title: '',
                          color: AppTheme.accentBlue,
                          radius: 65,
                        ),
                      ],
                sectionsSpace: 4,
                centerSpaceRadius: 58,
                centerSpaceColor: AppTheme.backgroundDark,
              ),
            ),
          ),
          SizedBox(height: 28),

          // Stats Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStatItem(
                'Total',
                _totalTugas.toString(),
                AppTheme.textSecondary,
              ),
              Container(height: 40, width: 1, color: AppTheme.borderSubtle),
              _buildStatItem(
                'Selesai',
                _selesai.toString(),
                AppTheme.successGreen,
              ),
              Container(height: 40, width: 1, color: AppTheme.borderSubtle),
              _buildStatItem(
                'Belum',
                _belumSelesai.toString(),
                AppTheme.accentBlue,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    final icons = {
      'Total': Icons.format_list_bulleted_rounded,
      'Selesai': Icons.check_circle_rounded,
      'Belum': Icons.pending_rounded,
    };

    return Column(
      children: [
        Icon(icons[label] ?? Icons.circle, size: 22, color: color),
        SizedBox(height: 8),
        Text(
          value,
          style: AppTheme.heading2.copyWith(
            color: color,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: AppTheme.bodySmall.copyWith(color: AppTheme.textSecondary),
        ),
      ],
    );
  }
}
