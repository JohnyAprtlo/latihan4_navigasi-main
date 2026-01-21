import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/data_models.dart';
import '../models/data_manager.dart';
import '../config/app_theme.dart';

class PengingatTugasPage extends StatefulWidget {
  const PengingatTugasPage({super.key});

  @override
  _PengingatTugasPageState createState() => _PengingatTugasPageState();
}

class _PengingatTugasPageState extends State<PengingatTugasPage> {
  final TextEditingController _tugasController = TextEditingController();
  List<Tugas> _tugas = [];
  List<MataKuliah> _mataKuliah = [];
  List<Jadwal> _jadwal = [];
  String? _selectedMK;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final tugasData = await DataManager.loadTugas();
    final mkData = await DataManager.loadMataKuliah();
    final jadwalData = await DataManager.loadJadwal();
    setState(() {
      _tugas = tugasData;
      _mataKuliah = mkData;
      _jadwal = jadwalData;
    });
  }

  Future<void> _saveData() async {
    await DataManager.saveTugas(_tugas);
  }

  void _addTugas() {
    if (_tugasController.text.isNotEmpty) {
      setState(() {
        _tugas.add(
          Tugas(
            deskripsi: _tugasController.text,
            mataKuliah: _selectedMK,
            tanggal: _selectedDate,
            waktu: _selectedTime,
          ),
        );
        _tugasController.clear();
        _selectedMK = null;
        _selectedDate = null;
        _selectedTime = null;
      });
      _saveData();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Tugas ditambahkan')));
    }
  }

  void _editTugas(int index) {
    _tugasController.text = _tugas[index].deskripsi;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.backgroundCard,
        title: Text('Edit Tugas', style: AppTheme.heading3),
        content: TextField(
          controller: _tugasController,
          decoration: InputDecoration(
            labelText: 'Deskripsi Tugas',
            prefixIcon: Icon(Icons.task_rounded),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _tugasController.clear();
            },
            child: Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _tugas[index] = Tugas(
                  deskripsi: _tugasController.text,
                  selesai: _tugas[index].selesai,
                );
              });
              _saveData();
              Navigator.of(context).pop();
              _tugasController.clear();
            },
            child: Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _deleteTugas(int index) {
    setState(() {
      _tugas.removeAt(index);
    });
    _saveData();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Tugas dihapus')));
  }

  void _toggleSelesai(int index) {
    setState(() {
      _tugas[index].selesai = !_tugas[index].selesai;
    });
    _saveData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pengingat Tugas')),
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
                    Text('Tambah Tugas', style: AppTheme.heading3),
                    SizedBox(height: 16),
                    TextField(
                      controller: _tugasController,
                      decoration: InputDecoration(
                        labelText: 'Deskripsi Tugas',
                        hintText: 'Contoh: Mengerjakan laporan...',
                        prefixIcon: Icon(Icons.task_rounded),
                      ),
                    ),
                    SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedMK,
                      decoration: InputDecoration(
                        labelText: 'Mata Kuliah (Opsional)',
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
                          if (value != null) {
                            final jadwal = _jadwal.firstWhere(
                              (j) => j.mataKuliah == value,
                              orElse: () => Jadwal(
                                mataKuliah: '',
                                tanggal: '',
                                waktu: '',
                              ),
                            );
                            if (jadwal.tanggal.isNotEmpty) {
                              _selectedDate = DateTime.parse(jadwal.tanggal);
                            }
                            if (jadwal.waktu.isNotEmpty) {
                              // Handle both 24-hour (HH:mm) and 12-hour (hh:mm AM/PM) formats
                              try {
                                if (jadwal.waktu.contains(':')) {
                                  final parts = jadwal.waktu.split(':');
                                  // Remove AM/PM if present
                                  final minutePart = parts[1].replaceAll(
                                    RegExp(r'[^\d]'),
                                    '',
                                  );
                                  int hour = int.parse(parts[0].trim());
                                  int minute = int.parse(minutePart);

                                  // Adjust for AM/PM if present
                                  if (jadwal.waktu.toUpperCase().contains(
                                        'PM',
                                      ) &&
                                      hour != 12) {
                                    hour += 12;
                                  } else if (jadwal.waktu
                                          .toUpperCase()
                                          .contains('AM') &&
                                      hour == 12) {
                                    hour = 0;
                                  }

                                  _selectedTime = TimeOfDay(
                                    hour: hour,
                                    minute: minute,
                                  );
                                }
                              } catch (e) {
                                // If parsing fails, ignore and leave _selectedTime null
                                print('Error parsing time: $e');
                              }
                            }
                          } else {
                            _selectedDate = null;
                            _selectedTime = null;
                          }
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: _addTugas,
                        icon: Icon(Icons.add_rounded),
                        label: Text('Tambah Tugas'),
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
              if (_tugas.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Daftar Tugas', style: AppTheme.heading3),
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
                          '${_tugas.where((t) => !t.selesai).length}/${_tugas.length}',
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
                child: _tugas.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.task_alt_outlined,
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
                              'Tambahkan tugas baru di atas',
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
                              leading: Checkbox(
                                value: tugas.selesai,
                                onChanged: (value) => _toggleSelesai(index),
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
                                                Expanded(
                                                  child: Text(
                                                    tugas.mataKuliah!,
                                                    style: AppTheme.bodySmall,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          if (tugas.mataKuliah != null &&
                                              tugas.tanggal != null)
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
                                                Flexible(
                                                  child: Text(
                                                    DateFormat(
                                                      'dd MMM yyyy',
                                                    ).format(tugas.tanggal!),
                                                    style: AppTheme.bodySmall,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                if (tugas.waktu != null)
                                                  SizedBox(width: 8),
                                                if (tugas.waktu != null)
                                                  Icon(
                                                    Icons.access_time_rounded,
                                                    size: 14,
                                                    color:
                                                        AppTheme.textSecondary,
                                                  ),
                                                if (tugas.waktu != null)
                                                  SizedBox(width: 4),
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
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit_rounded),
                                    color: AppTheme.accentBlue,
                                    onPressed: () => _editTugas(index),
                                    tooltip: 'Edit',
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete_rounded),
                                    color: AppTheme.warningRed,
                                    onPressed: () => _deleteTugas(index),
                                    tooltip: 'Hapus',
                                  ),
                                ],
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
