import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/data_models.dart';
import '../models/data_manager.dart';
import '../config/app_theme.dart';

class AturJadwalPage extends StatefulWidget {
  const AturJadwalPage({super.key});

  @override
  _AturJadwalPageState createState() => _AturJadwalPageState();
}

class _AturJadwalPageState extends State<AturJadwalPage> {
  List<Jadwal> _jadwal = [];
  List<MataKuliah> _mataKuliah = [];
  String? _selectedMK;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final jadwalData = await DataManager.loadJadwal();
    final mkData = await DataManager.loadMataKuliah();
    setState(() {
      _jadwal = jadwalData;
      _mataKuliah = mkData;
    });
  }

  Future<void> _saveData() async {
    await DataManager.saveJadwal(_jadwal);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppTheme.accentBlue,
              onPrimary: Colors.white,
              surface: AppTheme.backgroundCard,
              onSurface: AppTheme.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: ColorScheme.dark(
              primary: AppTheme.accentBlue,
              onPrimary: Colors.white,
              surface: AppTheme.backgroundCard,
              onSurface: AppTheme.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _addJadwal() async {
    if (_selectedMK != null && _selectedDate != null && _selectedTime != null) {
      final jadwal = Jadwal(
        mataKuliah: _selectedMK!,
        tanggal: DateFormat('yyyy-MM-dd').format(_selectedDate!),
        waktu: _selectedTime!.format(context),
      );
      setState(() {
        _jadwal.add(jadwal);
        _resetForm();
      });
      await _saveData();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Jadwal ditambahkan')));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Isi semua field')));
    }
  }

  void _resetForm() {
    setState(() {
      _selectedMK = null;
      _selectedDate = null;
      _selectedTime = null;
    });
  }

  void _deleteJadwal(int index) async {
    final jadwalName = _jadwal[index].mataKuliah;
    setState(() {
      _jadwal.removeAt(index);
    });
    await _saveData();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Jadwal $jadwalName dihapus')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Atur Jadwal')),
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Input Card
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.backgroundCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.borderSubtle),
                  boxShadow: AppTheme.cardShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Tambah Jadwal Kuliah', style: AppTheme.heading3),
                    SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedMK,
                      decoration: InputDecoration(
                        labelText: 'Mata Kuliah',
                        prefixIcon: Icon(Icons.book_rounded),
                      ),
                      dropdownColor: AppTheme.backgroundCard,
                      items: _mataKuliah.map((mk) {
                        return DropdownMenuItem(
                          value: mk.nama,
                          child: Text(mk.nama),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedMK = value;
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _selectDate(context),
                            icon: Icon(Icons.calendar_today_rounded),
                            label: Text(
                              _selectedDate == null
                                  ? 'Pilih Tanggal'
                                  : DateFormat(
                                      'dd MMM yyyy',
                                    ).format(_selectedDate!),
                            ),
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => _selectTime(context),
                            icon: Icon(Icons.access_time_rounded),
                            label: Text(
                              _selectedTime == null
                                  ? 'Pilih Waktu'
                                  : _selectedTime!.format(context),
                            ),
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _addJadwal,
                        icon: Icon(Icons.add_rounded),
                        label: Text('Tambah Jadwal'),
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),

              // List Header
              if (_jadwal.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Daftar Jadwal', style: AppTheme.heading3),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.accentBlue.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${_jadwal.length} jadwal',
                          style: AppTheme.bodySmall.copyWith(
                            color: AppTheme.accentBlue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // List
              Expanded(
                child: _jadwal.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.event_note_outlined,
                              size: 64,
                              color: AppTheme.textMuted,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Belum ada jadwal',
                              style: AppTheme.bodyLarge.copyWith(
                                color: AppTheme.textSecondary,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Tambahkan jadwal kuliah di atas',
                              style: AppTheme.bodySmall,
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: _jadwal.length,
                        itemBuilder: (context, index) {
                          final jadwal = _jadwal[index];
                          return Container(
                            margin: EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: AppTheme.backgroundCard,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppTheme.borderSubtle),
                              boxShadow: AppTheme.subtleShadow,
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.all(16),
                              leading: Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  gradient: AppTheme.accentGradient,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.schedule_rounded,
                                  color: Colors.white,
                                ),
                              ),
                              title: Text(
                                jadwal.mataKuliah,
                                style: AppTheme.bodyLarge.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.calendar_today_rounded,
                                        size: 14,
                                        color: AppTheme.textSecondary,
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        jadwal.tanggal,
                                        style: AppTheme.bodySmall,
                                      ),
                                      SizedBox(width: 16),
                                      Icon(
                                        Icons.access_time_rounded,
                                        size: 14,
                                        color: AppTheme.textSecondary,
                                      ),
                                      SizedBox(width: 6),
                                      Text(
                                        jadwal.waktu,
                                        style: AppTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.delete_rounded),
                                color: AppTheme.warningRed,
                                onPressed: () => _deleteJadwal(index),
                                tooltip: 'Hapus',
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
}
