import 'package:hive_flutter/hive_flutter.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

/// DatabaseService - Central database management untuk aplikasi
/// Menggunakan Hive (NoSQL database) yang support Web + Mobile
///
/// Hive menggunakan konsep "Box" - seperti table di SQL
/// Setiap Box menyimpan data dalam format key-value pairs
class DatabaseService {
  // Singleton pattern - hanya ada 1 instance DatabaseService di seluruh app
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  // Nama-nama Box (seperti nama table di SQL)
  static const String _usersBox = 'users'; // Box untuk user accounts
  static const String _profilBox = 'profil'; // Box untuk data profil mahasiswa
  static const String _mataKuliahBox =
      'mata_kuliah'; // Box untuk daftar mata kuliah
  static const String _jadwalBox = 'jadwal'; // Box untuk jadwal kuliah
  static const String _tugasBox = 'tugas'; // Box untuk pengingat tugas

  // Variable untuk menyimpan current user yang sedang login
  String? _currentUserId;

  /// Getter untuk mengecek apakah ada user yang sedang login
  bool get isLoggedIn => _currentUserId != null;

  /// Getter untuk mendapatkan user ID yang sedang login
  String? get currentUserId => _currentUserId;

  /// Initialize Hive database
  /// Method ini harus dipanggil pertama kali sebelum menggunakan database
  /// Biasanya dipanggil di main() sebelum runApp()
  Future<void> init() async {
    // Initialize Hive untuk Flutter
    // Ini akan setup path untuk menyimpan database file
    await Hive.initFlutter();

    // Buka semua Box yang dibutuhkan
    // openBox() akan membuat Box baru jika belum ada
    // atau membuka Box yang sudah ada jika sudah pernah dibuat
    await Hive.openBox(_usersBox);
    await Hive.openBox(_profilBox);
    await Hive.openBox(_mataKuliahBox);
    await Hive.openBox(_jadwalBox);
    await Hive.openBox(_tugasBox);
  }

  // ============================================================================
  // USER AUTHENTICATION
  // ============================================================================

  /// Hash password menggunakan SHA-256
  /// Password tidak pernah disimpan dalam bentuk plain text untuk keamanan
  ///
  /// Contoh: password "admin123" akan di-hash menjadi string panjang seperti:
  /// "240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9"
  String _hashPassword(String password) {
    var bytes = utf8.encode(password); // Convert password ke bytes
    var digest = sha256.convert(bytes); // Hash menggunakan SHA-256
    return digest.toString();
  }

  /// Register user baru
  /// Returns true jika berhasil, false jika username sudah ada
  ///
  /// Data yang disimpan:
  /// - username: untuk login
  /// - password: dalam bentuk hash (aman)
  /// - email: untuk recovery/forgot password
  Future<bool> registerUser({
    required String username,
    required String password,
    required String email,
  }) async {
    var usersBox = Hive.box(_usersBox);

    // Cek apakah username sudah dipakai
    if (usersBox.containsKey(username)) {
      return false; // Username sudah ada, registrasi gagal
    }

    // Simpan user data dengan username sebagai key
    await usersBox.put(username, {
      'password': _hashPassword(password), // Password di-hash untuk security
      'email': email,
      'createdAt': DateTime.now().toIso8601String(), // Waktu registrasi
    });

    return true; // Registrasi berhasil
  }

  /// Login user
  /// Returns true jika berhasil login (username & password benar)
  /// Returns false jika gagal (username tidak ada atau password salah)
  Future<bool> loginUser(String username, String password) async {
    var usersBox = Hive.box(_usersBox);

    // Cek apakah username ada di database
    if (!usersBox.containsKey(username)) {
      return false; // Username tidak ditemukan
    }

    // Ambil data user dari database
    var userData = usersBox.get(username);
    var storedPasswordHash = userData['password'];

    // Compare password yang diinput dengan password di database
    // Keduanya harus di-hash untuk dibandingkan
    if (_hashPassword(password) == storedPasswordHash) {
      // Password benar, set current user
      _currentUserId = username;
      return true; // Login berhasil
    }

    return false; // Password salah
  }

  /// Logout user
  /// Clear current user session
  void logout() {
    _currentUserId = null;
  }

  /// Get user email (untuk fitur forgot password)
  String? getUserEmail(String username) {
    var usersBox = Hive.box(_usersBox);
    if (usersBox.containsKey(username)) {
      var userData = usersBox.get(username);
      return userData['email'];
    }
    return null;
  }

  /// Reset password user
  /// Untuk fitur forgot password
  Future<bool> resetPassword(String username, String newPassword) async {
    var usersBox = Hive.box(_usersBox);

    if (!usersBox.containsKey(username)) {
      return false; // User tidak ditemukan
    }

    var userData = usersBox.get(username);
    userData['password'] = _hashPassword(newPassword);
    await usersBox.put(username, userData);

    return true;
  }

  // ============================================================================
  // PROFIL MAHASISWA
  // ============================================================================

  /// Simpan data profil mahasiswa
  /// Data disimpan per user (setiap user punya profil sendiri)
  Future<void> saveProfil({
    required String nama,
    required String nim,
    required String jurusan,
    required String semester,
    String? imagePath,
  }) async {
    if (!isLoggedIn) return; // Harus login dulu

    var profilBox = Hive.box(_profilBox);

    // Key = userId, Value = data profil
    // Jadi setiap user punya profil sendiri-sendiri
    await profilBox.put(_currentUserId!, {
      'nama': nama,
      'nim': nim,
      'jurusan': jurusan,
      'semester': semester,
      'imagePath': imagePath,
    });
  }

  /// Load data profil mahasiswa
  /// Returns Map berisi data profil, atau null jika belum ada
  Map<String, dynamic>? getProfil() {
    if (!isLoggedIn) return null;

    var profilBox = Hive.box(_profilBox);
    return profilBox.get(_currentUserId);
  }

  // ============================================================================
  // MATA KULIAH
  // ============================================================================

  /// Simpan daftar mata kuliah
  /// Input: List of mata kuliah names
  Future<void> saveMataKuliah(List<String> mataKuliahList) async {
    if (!isLoggedIn) return;

    var mkBox = Hive.box(_mataKuliahBox);
    await mkBox.put(_currentUserId!, mataKuliahList);
  }

  /// Load daftar mata kuliah
  /// Returns List of mata kuliah names
  List<String> getMataKuliah() {
    if (!isLoggedIn) return [];

    var mkBox = Hive.box(_mataKuliahBox);
    var data = mkBox.get(_currentUserId);

    if (data == null) return [];

    // Convert dynamic list to List<String>
    return List<String>.from(data);
  }

  // ============================================================================
  // JADWAL KULIAH
  // ============================================================================

  /// Simpan daftar jadwal kuliah
  /// Input: List of jadwal Maps
  Future<void> saveJadwal(List<Map<String, dynamic>> jadwalList) async {
    if (!isLoggedIn) return;

    var jadwalBox = Hive.box(_jadwalBox);
    await jadwalBox.put(_currentUserId!, jadwalList);
  }

  /// Load daftar jadwal kuliah
  /// Returns List of jadwal Maps
  List<Map<String, dynamic>> getJadwal() {
    if (!isLoggedIn) return [];

    var jadwalBox = Hive.box(_jadwalBox);
    var data = jadwalBox.get(_currentUserId);

    if (data == null) return [];

    // Convert dynamic list to List<Map>
    return List<Map<String, dynamic>>.from(data);
  }

  // ============================================================================
  // TUGAS / PENGINGAT
  // ============================================================================

  /// Simpan daftar tugas
  /// Input: List of tugas Maps
  Future<void> saveTugas(List<Map<String, dynamic>> tugasList) async {
    if (!isLoggedIn) return;

    var tugasBox = Hive.box(_tugasBox);
    await tugasBox.put(_currentUserId!, tugasList);
  }

  /// Load daftar tugas
  /// Returns List of tugas Maps
  List<Map<String, dynamic>> getTugas() {
    if (!isLoggedIn) return [];

    var tugasBox = Hive.box(_tugasBox);
    var data = tugasBox.get(_currentUserId);

    if (data == null) return [];

    // Convert dynamic list to List<Map>
    return List<Map<String, dynamic>>.from(data);
  }

  // ============================================================================
  // UTILITY METHODS
  // ============================================================================

  /// Clear semua data user tertentu
  /// Berguna untuk fitur delete account
  Future<void> clearUserData(String userId) async {
    await Hive.box(_profilBox).delete(userId);
    await Hive.box(_mataKuliahBox).delete(userId);
    await Hive.box(_jadwalBox).delete(userId);
    await Hive.box(_tugasBox).delete(userId);
    await Hive.box(_usersBox).delete(userId);
  }

  /// Clear semua database (untuk development/testing)
  Future<void> clearAll() async {
    await Hive.box(_usersBox).clear();
    await Hive.box(_profilBox).clear();
    await Hive.box(_mataKuliahBox).clear();
    await Hive.box(_jadwalBox).clear();
    await Hive.box(_tugasBox).clear();
  }
}
