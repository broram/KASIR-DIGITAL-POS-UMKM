/// Mengubah tanggal menjadi teks dengan format hari, tanggal, dan waktu.
String formatDateTime(DateTime dateTime) {
  final localTime = dateTime.toLocal();
  final date =
      '${localTime.day.toString().padLeft(2, '0')}/'
      '${localTime.month.toString().padLeft(2, '0')}/${localTime.year}';
  final time =
      '${localTime.hour.toString().padLeft(2, '0')}:'
      '${localTime.minute.toString().padLeft(2, '0')}';
  return '$date $time';
}
