import 'package:flutter/material.dart';
import '../models/data_models.dart';
import '../models/data_manager.dart';
import '../config/app_theme.dart';

class InputMKPage extends StatefulWidget {
  const InputMKPage({super.key});

  @override
  _InputMKPageState createState() => _InputMKPageState();
}

class _InputMKPageState extends State<InputMKPage> {
  final TextEditingController _mkController = TextEditingController();
  List<MataKuliah> _mataKuliah = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final data = await DataManager.loadMataKuliah();
    setState(() {
      _mataKuliah = data;
    });
  }

  Future<void> _saveData() async {
    await DataManager.saveMataKuliah(_mataKuliah);
  }

  void _addMK() {
    if (_mkController.text.isNotEmpty) {
      setState(() {
        _mataKuliah.add(MataKuliah(nama: _mkController.text));
        _mkController.clear();
      });
      _saveData();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Mata kuliah ditambahkan')));
    }
  }

  void _editMK(int index) {
    _mkController.text = _mataKuliah[index].nama;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.backgroundCard,
        title: Text('Edit Mata Kuliah', style: AppTheme.heading3),
        content: TextField(
          controller: _mkController,
          decoration: InputDecoration(
            labelText: 'Nama Mata Kuliah',
            prefixIcon: Icon(Icons.book_rounded),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _mkController.clear();
            },
            child: Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _mataKuliah[index] = MataKuliah(nama: _mkController.text);
              });
              _saveData();
              Navigator.of(context).pop();
              _mkController.clear();
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Mata kuliah diperbarui')));
            },
            child: Text('Simpan'),
          ),
        ],
      ),
    );
  }

  void _deleteMK(int index) {
    final mkName = _mataKuliah[index].nama;
    setState(() {
      _mataKuliah.removeAt(index);
    });
    _saveData();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$mkName dihapus')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Input Mata Kuliah')),
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
                    Text('Tambah Mata Kuliah', style: AppTheme.heading3),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _mkController,
                            decoration: InputDecoration(
                              labelText: 'Nama Mata Kuliah',
                              hintText: 'Contoh: Pemrograman Mobile',
                              prefixIcon: Icon(Icons.book_rounded),
                            ),
                            onSubmitted: (_) => _addMK(),
                          ),
                        ),
                        SizedBox(width: 12),
                        ElevatedButton.icon(
                          onPressed: _addMK,
                          icon: Icon(Icons.add_rounded),
                          label: Text('Tambah'),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24),

              // List Header
              if (_mataKuliah.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Daftar Mata Kuliah', style: AppTheme.heading3),
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
                          '${_mataKuliah.length} MK',
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
                child: _mataKuliah.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.book_outlined,
                              size: 64,
                              color: AppTheme.textMuted,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Belum ada mata kuliah',
                              style: AppTheme.bodyLarge.copyWith(
                                color: AppTheme.textSecondary,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Tambahkan mata kuliah baru di atas',
                              style: AppTheme.bodySmall,
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: _mataKuliah.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: AppTheme.backgroundCard,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppTheme.borderSubtle),
                              boxShadow: AppTheme.subtleShadow,
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 8,
                              ),
                              leading: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: AppTheme.accentBlue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(
                                  Icons.book_rounded,
                                  color: AppTheme.accentBlue,
                                ),
                              ),
                              title: Text(
                                _mataKuliah[index].nama,
                                style: AppTheme.bodyLarge,
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit_rounded),
                                    color: AppTheme.accentBlue,
                                    onPressed: () => _editMK(index),
                                    tooltip: 'Edit',
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete_rounded),
                                    color: AppTheme.warningRed,
                                    onPressed: () => _deleteMK(index),
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
