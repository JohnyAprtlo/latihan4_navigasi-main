import '../database/database_service.dart';
import 'data_models.dart';

class DataManager {
  // Instance database service
  static final DatabaseService _db = DatabaseService();

  // Mata Kuliah
  static Future<List<MataKuliah>> loadMataKuliah() async {
    // Ambil data dari Hive database (returns List<String>)
    List<String> mkList = _db.getMataKuliah();

    // Convert List<String> ke List<MataKuliah>
    return mkList.map((nama) => MataKuliah(nama: nama)).toList();
  }

  static Future<void> saveMataKuliah(List<MataKuliah> mk) async {
    // Convert List<MataKuliah> ke List<String> untuk disimpan di Hive
    List<String> mkListStrings = mk.map((e) => e.nama).toList();
    await _db.saveMataKuliah(mkListStrings);
  }

  // Jadwal
  static Future<List<Jadwal>> loadJadwal() async {
    // Ambil data dari Hive (returns List<Map>)
    final data = _db.getJadwal();

    // Convert List<Map> ke List<Jadwal>
    return data.map((e) => Jadwal.fromJson(e)).toList();
  }

  static Future<void> saveJadwal(List<Jadwal> jadwal) async {
    // Convert List<Jadwal> ke List<Map>
    final jadwalList = jadwal.map((e) => e.toJson()).toList();
    await _db.saveJadwal(jadwalList);
  }

  // Tugas
  static Future<List<Tugas>> loadTugas() async {
    // Ambil data dari Hive (returns List<Map>)
    final data = _db.getTugas();

    // Convert List<Map> ke List<Tugas>
    return data.map((e) => Tugas.fromJson(e)).toList();
  }

  static Future<void> saveTugas(List<Tugas> tugas) async {
    // Convert List<Tugas> ke List<Map>
    final tugasList = tugas.map((e) => e.toJson()).toList();
    await _db.saveTugas(tugasList);
  }

  // Profil
  static Future<Profil> loadProfil() async {
    // Ambil data profil dari Hive
    final data = _db.getProfil();

    // Jika ada data, convert ke object Profil
    if (data != null) {
      return Profil.fromJson(data);
    }

    // Default value jika belum ada data profil
    return Profil(
      nama: 'Mahasiswa',
      nim: '-',
      jurusan: 'Sistem Informasi',
      semester: '1',
    );
  }

  static Future<void> saveProfil(Profil profil) async {
    // Save ke Hive
    await _db.saveProfil(
      nama: profil.nama,
      nim: profil.nim,
      jurusan: profil.jurusan,
      semester: profil.semester,
      imagePath: profil.imagePath,
    );
  }
}
