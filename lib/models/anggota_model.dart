class AnggotaModel {
  final String id;
  final String nama;
  final String email;
  final String? noTelepon;
  final DateTime? tanggalBergabung;

  AnggotaModel({
    required this.id,
    required this.nama,
    required this.email,
    this.noTelepon,
    this.tanggalBergabung,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nama': nama,
      'email': email,
      'noTelepon': noTelepon,
      'tanggalBergabung': tanggalBergabung?.toIso8601String(),
    };
  }

  // Create from JSON
  factory AnggotaModel.fromJson(Map<String, dynamic> json) {
    return AnggotaModel(
      id: json['id'] as String,
      nama: json['nama'] as String,
      email: json['email'] as String,
      noTelepon: json['noTelepon'] as String?,
      tanggalBergabung: json['tanggalBergabung'] != null
          ? DateTime.parse(json['tanggalBergabung'] as String)
          : null,
    );
  }

  // Copy with method
  AnggotaModel copyWith({
    String? id,
    String? nama,
    String? email,
    String? noTelepon,
    DateTime? tanggalBergabung,
  }) {
    return AnggotaModel(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      email: email ?? this.email,
      noTelepon: noTelepon ?? this.noTelepon,
      tanggalBergabung: tanggalBergabung ?? this.tanggalBergabung,
    );
  }
}
