import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/data_models.dart';
import '../models/data_manager.dart';
import '../config/app_theme.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  _ProfilPageState createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  late Profil _profil;
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _nimController = TextEditingController();
  final TextEditingController _jurusanController = TextEditingController();
  final TextEditingController _semesterController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _imageFile;
  String? _webImagePath; // For web platform

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await DataManager.loadProfil();
    setState(() {
      _profil = data;
      _namaController.text = _profil.nama;
      _nimController.text = _profil.nim;
      _jurusanController.text = _profil.jurusan;
      _semesterController.text = _profil.semester;

      // Load existing image if available
      if (_profil.imagePath != null && _profil.imagePath!.isNotEmpty) {
        if (!kIsWeb) {
          _imageFile = File(_profil.imagePath!);
        }
        _webImagePath = _profil.imagePath;
      }
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 75,
      );

      if (pickedFile != null) {
        setState(() {
          _webImagePath = pickedFile.path;
          if (!kIsWeb) {
            _imageFile = File(pickedFile.path);
          }
        });
        // Auto save after picking image
        _saveData();
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error memilih gambar: $e')));
    }
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.backgroundCard,
        title: Text('Pilih Sumber Foto', style: AppTheme.heading3),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.photo_library, color: AppTheme.accentBlue),
              title: Text('Galeri', style: AppTheme.bodyMedium),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: Icon(Icons.camera_alt, color: AppTheme.accentBlue),
              title: Text('Kamera', style: AppTheme.bodyMedium),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveData() async {
    _profil = Profil(
      nama: _namaController.text,
      nim: _nimController.text,
      jurusan: _jurusanController.text,
      semester: _semesterController.text,
      imagePath: _webImagePath ?? _imageFile?.path,
    );
    await DataManager.saveProfil(_profil);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Profil berhasil disimpan')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profil Mahasiswa'),
        actions: [
          IconButton(
            icon: Icon(Icons.save_rounded),
            onPressed: _saveData,
            tooltip: 'Simpan',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              // Profile Header Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: AppTheme.accentGradient,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: AppTheme.cardShadow,
                ),
                child: Column(
                  children: [
                    // Profile Photo with Upload Button
                    Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                          ),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.white,
                            backgroundImage: kIsWeb
                                ? (_webImagePath != null
                                      ? NetworkImage(_webImagePath!)
                                      : null)
                                : (_imageFile != null
                                      ? FileImage(_imageFile!) as ImageProvider
                                      : null),
                            child: (_webImagePath == null && _imageFile == null)
                                ? Icon(
                                    Icons.person,
                                    size: 50,
                                    color: AppTheme.accentBlue,
                                  )
                                : null,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: InkWell(
                            onTap: _showImageSourceDialog,
                            child: Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppTheme.successGreen,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                Icons.camera_alt,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text(
                      _namaController.text.isEmpty
                          ? 'Nama Mahasiswa'
                          : _namaController.text,
                      style: AppTheme.heading2.copyWith(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 4),
                    Text(
                      _nimController.text.isEmpty ? 'NIM' : _nimController.text,
                      style: AppTheme.bodyMedium.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),

              // Form Card
              Container(
                padding: EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppTheme.backgroundCard,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.borderSubtle),
                  boxShadow: AppTheme.cardShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Informasi Mahasiswa', style: AppTheme.heading3),
                    SizedBox(height: 20),

                    TextField(
                      controller: _namaController,
                      decoration: InputDecoration(
                        labelText: 'Nama Lengkap',
                        prefixIcon: Icon(Icons.person_rounded),
                      ),
                      onChanged: (value) => setState(() {}), // Update real-time
                    ),
                    SizedBox(height: 16),

                    TextField(
                      controller: _nimController,
                      decoration: InputDecoration(
                        labelText: 'NIM',
                        prefixIcon: Icon(Icons.badge_rounded),
                      ),
                      onChanged: (value) => setState(() {}), // Update real-time
                    ),
                    SizedBox(height: 16),

                    TextField(
                      controller: _jurusanController,
                      decoration: InputDecoration(
                        labelText: 'Jurusan',
                        prefixIcon: Icon(Icons.school_rounded),
                      ),
                    ),
                    SizedBox(height: 16),

                    TextField(
                      controller: _semesterController,
                      decoration: InputDecoration(
                        labelText: 'Semester',
                        prefixIcon: Icon(Icons.calendar_today_rounded),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 24),

                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: _saveData,
                        icon: Icon(Icons.save_rounded),
                        label: Text('Simpan Profil'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.accentBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
