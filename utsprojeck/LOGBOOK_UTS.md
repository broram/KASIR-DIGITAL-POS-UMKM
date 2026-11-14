
# Logbook Pengembangan UTS — Kasir Digital UMKM

## Entri 1

| Informasi | Keterangan                                                   |
| --------- | ------------------------------------------------------------ |
| Tanggal   | 6 November 2026                                              |
| Kegiatan  | Analisis README dan penyelesaian alur pembayaran serta struk |
| Status    | Selesai                                                      |

### Tujuan

Melanjutkan fitur inti yang pada README masih berstatus belum tersedia: checkout, input pembayaran tunai, konfirmasi transaksi, dan tampilan struk.

### Pekerjaan yang dilakukan

1. Meninjau README, struktur aplikasi Flutter, model transaksi, controller keranjang, dan tes yang sudah ada.
2. Memperbarui tampilan keranjang agar lebih rapi pada layar sempit, menampilkan subtotal dengan jelas, dan menonaktifkan checkout saat keranjang kosong.
3. Membuat halaman pembayaran dengan ringkasan total, input nominal tunai, validasi input kosong/tidak valid/kurang, dan perhitungan kembalian.
4. Menambahkan dialog konfirmasi. Transaksi hanya diselesaikan setelah pengguna menyetujui; membatalkan konfirmasi tidak mengubah keranjang.
5. Membuat struk dengan ID dan waktu transaksi, rincian produk, total belanja, uang diterima, serta kembalian.
6. Menambahkan operasi untuk mengosongkan keranjang setelah transaksi dikonfirmasi.
7. Menambahkan tes widget untuk checkout saat keranjang kosong, validasi pembayaran, penyelesaian transaksi, isi struk, dan pembatalan konfirmasi.
8. Memperbarui README, mencentang pekerjaan alur inti yang telah selesai, serta menghapus brief desain blog yang tidak sesuai dengan proyek Kasir Digital UMKM.

### Hasil dan verifikasi

- `flutter test`: lulus, 11 tes.
- `flutter analyze`: tidak menemukan masalah.
- Alur transaksi: katalog → keranjang → pembayaran → konfirmasi → struk.
- Transaksi masih hanya tersedia selama sesi aplikasi; penyimpanan lokal dan riwayat belum dibuat.

### Pekerjaan berikutnya

- Uji tampilan pada beberapa ukuran layar dan perangkat nyata.
- Siapkan skenario demo serta tangkapan layar.
- Pertimbangkan penyimpanan lokal dan riwayat transaksi setelah cakupan tugas dikonfirmasi.

## Entri 2

| Informasi | Keterangan                                     |
| --------- | ---------------------------------------------- |
| Tanggal   | 6 November 2026                                |
| Kegiatan  | Perapian desain dan pengujian responsivitas UI |
| Status    | Selesai                                        |

### Tujuan

Melanjutkan prioritas kualitas di README dengan memperbaiki tampilan aplikasi pada ponsel dan layar lebar, tanpa mengubah alur transaksi.

### Pekerjaan yang dilakukan

1. Membuat tema Material 3 terpusat dengan palet warna, bentuk kartu, input, dan tombol yang konsisten.
2. Menyusun ulang katalog dengan judul yang lebih jelas, tata letak satu kolom pada ponsel dan grid hingga tiga kolom pada layar lebar.
3. Membatasi lebar isi halaman keranjang dan struk untuk layar besar, memperbaiki batas tampilan nama produk, dan menjaga keranjang panjang tetap dapat digulir.
4. Menambahkan widget test untuk katalog pada ukuran 390x844 dan 1000x900, nama produk panjang pada layar 360x800, dan keranjang berisi 13 produk.
5. Memperbarui README serta mencentang pekerjaan responsivitas yang sudah diuji. Screenshot demo dan uji perangkat nyata tetap belum dilakukan.

### Hasil dan verifikasi

- `flutter analyze`: tidak menemukan masalah.
- `flutter test`: lulus, 13 tes.
- Alur katalog, keranjang, pembayaran, dan struk tetap lulus pengujian.

### Pekerjaan berikutnya

- Jalankan aplikasi pada perangkat nyata dan ambil screenshot untuk README.
- Siapkan skenario demo singkat dan cocokkan dengan rubrik tugas.
- Pertimbangkan penyimpanan lokal dan riwayat transaksi setelah cakupan tugas dikonfirmasi.

## Entri 4

| Informasi | Keterangan                                              |
| --------- | ------------------------------------------------------- |
| Tanggal   | 15 November 2026                                        |
| Kegiatan  | Revisi proposal UTS dan pemutakhiran dokumentasi proyek |
| Status    | Selesai                                                 |

### Tujuan

Menyelaraskan proposal UTS dengan fitur yang sudah tersedia, status implementasi terbaru, serta dokumentasi proyek tanpa mengubah kode aplikasi.

### Pekerjaan yang dilakukan

1. Menyusun proposal revisi dalam format Word dengan nama `RevisiEntri4_Proposal_UTS_Kasir_Digital_POS_UMKM.docx`.
2. Memperbarui ringkasan status implementasi agar pembayaran tunai, konfirmasi transaksi, dan struk tercatat selesai sesuai README dan pekerjaan pada entri sebelumnya.
3. Memperbarui catatan pengujian proposal agar sesuai dengan hasil terakhir yang tercatat, yaitu 13 tes lulus dan `flutter analyze` tanpa masalah.
4. Memperjelas bahwa login awal masih berupa rancangan dan belum tersedia pada prototipe saat ini.
5. Memutakhirkan README dengan tautan ke proposal revisi dan mencatat pekerjaan dokumentasi ini.

### Hasil

- Proposal revisi tersedia dalam format `.docx`.
- README dan logbook mencatat perubahan dokumen serta status prototipe yang konsisten.
- Tidak ada perubahan pada kode aplikasi.

### Pekerjaan berikutnya

- Lengkapi bagian anggota kelompok dan jadwal yang masih berupa placeholder pada proposal.
- Cocokkan cakupan proposal dengan rubrik/dosen sebelum pengumpulan.
- Lanjutkan dokumentasi demo dan pengujian perangkat nyata sesuai prioritas proyek.

## Entri 5

| Informasi | Keterangan                                              |
| --------- | ------------------------------------------------------- |
| Tanggal   | 15 November 2026                                        |
| Kegiatan  | Menambahkan login kasir dan riwayat transaksi persisten |
| Status    | Selesai                                                 |

### Tujuan

Menyimpan transaksi yang sudah dikonfirmasi agar dapat ditelusuri kembali, serta menampilkan nama kasir pada struk.

### Pekerjaan yang dilakukan

1. Menambahkan pembuatan profil lokal pada pemakaian pertama dan login kasir pada pemakaian berikutnya.
2. Menyimpan hash PIN bersalt melalui penyimpanan aman perangkat; PIN tidak ditanam sebagai teks di source code.
3. Menyertakan nama kasir pada model transaksi dan struk.
4. Menambahkan penyimpanan transaksi beserta snapshot item ke SQLite setelah konfirmasi.
5. Menambahkan layar riwayat untuk melihat transaksi tersimpan dan membuka kembali struk.
6. Menangani kegagalan simpan agar pesan tampil dan keranjang tidak dikosongkan.
7. Memperbarui README serta proposal revisi mengikuti implementasi terbaru.

### Hasil dan verifikasi

- `flutter test`: lulus, 21 tes.
- `flutter analyze`: tidak menemukan masalah.
- `flutter build apk --debug`: berhasil.
- Build Linux belum dapat diverifikasi karena lingkungan belum memiliki paket pengembangan `libsecret`.
- Tes persistensi memastikan transaksi dan rincian produk tetap tersedia setelah database ditutup dan dibuka kembali.
- Tes widget mencakup setup/login, nama kasir pada struk, dan kegagalan penyimpanan.

### Batasan dan pekerjaan berikutnya

- Profil kasir dan riwayat berlaku lokal pada perangkat; belum ada sinkronisasi cloud atau dukungan multi-kasir.
- Uji APK pada perangkat nyata dan siapkan screenshot/demo sebelum pengumpulan.
- Login lokal adalah pembatas akses prototipe, bukan autentikasi produksi.
