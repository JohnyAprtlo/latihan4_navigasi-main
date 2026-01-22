import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/data_models.dart';
import '../models/data_manager.dart';
import '../config/app_theme.dart';

class LaporanTugasPage extends StatefulWidget {
  const LaporanTugasPage({super.key});

  @override
  _LaporanTugasPageState createState() => _LaporanTugasPageState();
}

class _LaporanTugasPageState extends State<LaporanTugasPage> {
  List<Tugas> _tugas = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await DataManager.loadTugas();
    setState(() {
      _tugas = data;
    });
  }

  Future<void> _saveData() async {
    await DataManager.saveTugas(_tugas);
  }

  void _toggleSelesai(int index) async {
    setState(() {
      _tugas[index].selesai = !_tugas[index].selesai;
    });
    await _saveData();
  }

  int get _totalTugas => _tugas.length;
  int get _selesai => _tugas.where((t) => t.selesai).length;
  int get _belumSelesai => _totalTugas - _selesai;
  double get _progress => _totalTugas == 0 ? 0 : (_selesai / _totalTugas) * 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Laporan Tugas'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh_rounded),
            onPressed: _loadData,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Statistics Card
              Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: AppTheme.accentGradient,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: AppTheme.cardShadow,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.assessment_rounded,
                          size: 48,
                          color: Colors.white,
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Ringkasan Tugas',
                                style: AppTheme.heading3.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                _totalTugas == 0
                                    ? 'Belum ada tugas'
                                    : '${_progress.toStringAsFixed(0)}% Selesai',
                                style: AppTheme.bodyMedium.copyWith(
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            'Total',
                            _totalTugas.toString(),
                            Icons.format_list_numbered_rounded,
                            Colors.white.withOpacity(0.2),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            'Selesai',
                            _selesai.toString(),
                            Icons.check_circle_rounded,
                            Colors.white.withOpacity(0.2),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: _buildStatCard(
                            'Belum',
                            _belumSelesai.toString(),
                            Icons.pending_rounded,
                            Colors.white.withOpacity(0.2),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),

              // Task List Header
              Text('Daftar Tugas', style: AppTheme.heading3),
              SizedBox(height: 16),

              // Task List
              Expanded(
                child: _tugas.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.assignment_outlined,
                              size: 64,
                              color: AppTheme.textMuted,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Belum ada tugas',
                              style: AppTheme.bodyLarge.copyWith(
                                color: AppTheme.textSecondary,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Tambahkan tugas dari menu Pengingat Tugas',
                              style: AppTheme.bodySmall,
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: _tugas.length,
                        itemBuilder: (context, index) {
                          final tugas = _tugas[index];
                          return Container(
                            margin: EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: tugas.selesai
                                  ? AppTheme.successGreen.withOpacity(0.1)
                                  : AppTheme.backgroundCard,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: tugas.selesai
                                    ? AppTheme.successGreen.withOpacity(0.3)
                                    : AppTheme.borderSubtle,
                              ),
                              boxShadow: AppTheme.subtleShadow,
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.all(16),
                              leading: Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: tugas.selesai
                                      ? AppTheme.successGreen.withOpacity(0.2)
                                      : AppTheme.accentBlue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  tugas.selesai
                                      ? Icons.check_circle_rounded
                                      : Icons.pending_rounded,
                                  color: tugas.selesai
                                      ? AppTheme.successGreen
                                      : AppTheme.accentBlue,
                                ),
                              ),
                              title: Text(
                                tugas.deskripsi,
                                style: AppTheme.bodyLarge.copyWith(
                                  fontWeight: FontWeight.w600,
                                  decoration: tugas.selesai
                                      ? TextDecoration.lineThrough
                                      : null,
                                  color: tugas.selesai
                                      ? AppTheme.textSecondary
                                      : AppTheme.textPrimary,
                                ),
                              ),
                              subtitle:
                                  tugas.mataKuliah != null ||
                                      tugas.tanggal != null
                                  ? Padding(
                                      padding: EdgeInsets.only(top: 8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (tugas.mataKuliah != null)
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.book_rounded,
                                                  size: 14,
                                                  color: AppTheme.textSecondary,
                                                ),
                                                SizedBox(width: 6),
                                                Text(
                                                  tugas.mataKuliah!,
                                                  style: AppTheme.bodySmall,
                                                ),
                                              ],
                                            ),
                                          if (tugas.tanggal != null)
                                            SizedBox(height: 4),
                                          if (tugas.tanggal != null)
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.calendar_today_rounded,
                                                  size: 14,
                                                  color: AppTheme.textSecondary,
                                                ),
                                                SizedBox(width: 6),
                                                Text(
                                                  DateFormat(
                                                    'dd MMM yyyy',
                                                  ).format(tugas.tanggal!),
                                                  style: AppTheme.bodySmall,
                                                ),
                                                if (tugas.waktu != null)
                                                  SizedBox(width: 12),
                                                if (tugas.waktu != null)
                                                  Icon(
                                                    Icons.access_time_rounded,
                                                    size: 14,
                                                    color:
                                                        AppTheme.textSecondary,
                                                  ),
                                                if (tugas.waktu != null)
                                                  SizedBox(width: 6),
                                                if (tugas.waktu != null)
                                                  Text(
                                                    tugas.waktu!.format(
                                                      context,
                                                    ),
                                                    style: AppTheme.bodySmall,
                                                  ),
                                              ],
                                            ),
                                        ],
                                      ),
                                    )
                                  : null,
                              trailing: Checkbox(
                                value: tugas.selesai,
                                onChanged: (value) => _toggleSelesai(index),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color bgColor,
  ) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 28),
          SizedBox(height: 8),
          Text(value, style: AppTheme.heading2.copyWith(color: Colors.white)),
          SizedBox(height: 4),
          Text(label, style: AppTheme.bodySmall.copyWith(color: Colors.white)),
        ],
      ),
    );
  }
}
