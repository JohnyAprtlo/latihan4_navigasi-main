import 'package:flutter/material.dart';

class MataKuliah {
  String nama;

  MataKuliah({required this.nama});

  Map<String, dynamic> toJson() => {'nama': nama};

  factory MataKuliah.fromJson(Map<String, dynamic> json) {
    return MataKuliah(nama: json['nama']);
  }
}

class Jadwal {
  String mataKuliah;
  String tanggal;
  String waktu;

  Jadwal({
    required this.mataKuliah,
    required this.tanggal,
    required this.waktu,
  });

  Map<String, dynamic> toJson() => {
    'mataKuliah': mataKuliah,
    'tanggal': tanggal,
    'waktu': waktu,
  };

  factory Jadwal.fromJson(Map<String, dynamic> json) {
    return Jadwal(
      mataKuliah: json['mataKuliah'] ?? '',
      tanggal: json['tanggal'] ?? '',
      waktu: json['waktu'] ?? '',
    );
  }
}

class Tugas {
  String deskripsi;
  String? mataKuliah; // Tambahkan field ini
  DateTime? tanggal;
  TimeOfDay? waktu;
  bool selesai;

  Tugas({
    required this.deskripsi,
    this.mataKuliah,
    this.tanggal,
    this.waktu,
    this.selesai = false,
  });

  Map<String, dynamic> toJson() => {
    'deskripsi': deskripsi,
    'mataKuliah': mataKuliah,
    'tanggal': tanggal?.toIso8601String(),
    'waktu': waktu != null ? '${waktu!.hour}:${waktu!.minute}' : null,
    'selesai': selesai,
  };

  factory Tugas.fromJson(Map<String, dynamic> json) {
    TimeOfDay? waktu;
    if (json['waktu'] != null) {
      final parts = json['waktu'].split(':');
      waktu = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    }
    return Tugas(
      deskripsi: json['deskripsi'],
      mataKuliah: json['mataKuliah'],
      tanggal: json['tanggal'] != null ? DateTime.parse(json['tanggal']) : null,
      waktu: waktu,
      selesai: json['selesai'] ?? false,
    );
  }
}

class Profil {
  String nama;
  String nim;
  String jurusan;
  String semester;
  String? imagePath; // Add profile image path

  Profil({
    required this.nama,
    required this.nim,
    required this.jurusan,
    required this.semester,
    this.imagePath,
  });

  Map<String, dynamic> toJson() => {
    'nama': nama,
    'nim': nim,
    'jurusan': jurusan,
    'semester': semester,
    'imagePath': imagePath,
  };

  factory Profil.fromJson(Map<String, dynamic> json) {
    return Profil(
      nama: json['nama'] ?? 'John Doe',
      nim: json['nim'] ?? '123456789',
      jurusan: json['jurusan'] ?? 'Teknik Informatika',
      semester: json['semester'] ?? '4',
      imagePath: json['imagePath'],
    );
  }
}
