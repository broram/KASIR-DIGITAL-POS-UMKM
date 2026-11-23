# Deskripsi Lengkap Projek UTS

## Identitas Projek

| Keterangan          | Isi                                                                                                                           |
| ------------------- | ----------------------------------------------------------------------------------------------------------------------------- |
| Nama aplikasi       | Kasir Digital & POS UMKM                                                                                                      |
| Jenis aplikasi      | Prototipe aplikasi kasir berbasis Flutter                                                                                     |
| Mata kuliah         | Pemrograman Berbasis Platform / Pemrograman Mobile                                                                            |
| Nama mahasiswa      | Muhammad Ilham Ramadhan                                                                                                       |
| NIM                 | 24343101                                                                                                                      |
| Versi aplikasi      | `1.0.0+1`                                                                                                                   |
| Bahasa pengembangan | Dart                                                                                                                          |
| Framework           | Flutter                                                                                                                       |
| Tujuan akademik     | Menyelesaikan UTS dengan menerapkan UI, state, model, asynchronous, JSON, penyimpanan lokal, autentikasi dasar, dan pengujian |

## Ringkasan

Repositori ini berisi prototipe **Kasir Digital & POS UMKM**, yaitu aplikasi untuk membantu pemilik atau pegawai UMKM mencatat penjualan secara digital. Aplikasi tidak merupakan sistem POS produksi, melainkan implementasi pembelajaran yang dapat menjalankan alur kasir dari login sampai penyimpanan riwayat transaksi.

Alur utama aplikasi adalah:

```text
Pembukaan aplikasi
  -> profil kasir dibuat pada penggunaan pertama
  -> atau kasir login pada penggunaan berikutnya
  -> katalog produk dimuat dari JSON lokal
  -> kasir menambah atau mengurangi produk
  -> keranjang menampilkan subtotal dan total
  -> kasir memasukkan pembayaran tunai
  -> nominal divalidasi dan kembalian dihitung
  -> transaksi dikonfirmasi
  -> transaksi disimpan ke SQLite
  -> struk ditampilkan
  -> transaksi dapat dibuka kembali dari riwayat
```

## Isi Repositori

Folder dan berkas utama berada di root `/home/ramduy/RAMDAN/kuliah/tugasssss/semester 5/pemograman berbasis platfrom/uts`.

### Berkas pendukung di root

- `proposal_uts_kasir_digital_revisi.md` — rancangan proposal dalam format Markdown.
- `RevisiEntri4_Proposal_UTS_Kasir_Digital_POS_UMKM.docx` — proposal revisi versi Word.
- `Proposal_Project_UTS_Kasir_Digital_POS_UMKM.pdf` — proposal UTS dalam format PDF.
- `Logbook_Minggu9_MuhammadIlhamRamadhan24343101_PBP.docx` — logbook Minggu 9.
- `Logbook_Minggu11_MuhammadIlhamRamadhan24343101_PBP.pdf` — logbook Minggu 11.
- `Logbook_Minggu12_MuhammadIlhamRamadhan24343101_PBP.pdf` — logbook Minggu 12, yang tercatat sebagai perubahan belum komit pada saat dokumen ini dibuat.
- `saran.txt` — catatan evaluasi dosen dan tanggapan/kondisi implementasi setelah pengembangan.
- `6a4e5a2d-c2eb-45dc-8bd1-d38aa4997ad7.jpeg` — berkas gambar pendukung.
- `dd576b11-cb3b-476f-828f-f211cca54476.jpeg` — berkas gambar pendukung.
- `deskripsi.md` — ringkasan lengkap seluruh isi projek ini.

### Projek aplikasi Flutter

Seluruh kode aplikasi utama berada di folder `utsprojeck/`. Folder ini merupakan proyek Flutter lintas platform dengan konfigurasi untuk Android, iOS, web, Windows, macOS, dan Linux.

```text
utsprojeck/
├── lib/                    Kode Dart aplikasi
├── assets/data/            Data katalog JSON
├── test/                   Tes unit, service, dan widget
├── android/                Konfigurasi dan sumber native Android
├── ios/                    Konfigurasi dan sumber native iOS
├── macos/                  Konfigurasi dan sumber native macOS
├── windows/                Konfigurasi dan sumber native Windows
├── linux/                  Konfigurasi dan sumber native Linux
├── web/                    Konfigurasi aplikasi web
├── pubspec.yaml            Nama, versi, SDK, dependensi, dan aset
├── pubspec.lock            Versi dependensi yang terkunci
├── analysis_options.yaml   Konfigurasi lint Dart/Flutter
├── README.md               Petunjuk singkat dan status pengembangan
└── LOGBOOK_UTS.md          Catatan tahapan pengembangan
```

## Teknologi dan Dependensi

Teknologi utama yang digunakan:

- Flutter dan Material 3 untuk UI lintas platform.
- Dart dengan batas SDK `^3.13.2`.
- `ChangeNotifier` dan `AnimatedBuilder` untuk state keranjang serta autentikasi.
- JSON lokal untuk katalog produk.
- SQLite melalui `sqflite` untuk riwayat transaksi.
- `sqflite_common_ffi` untuk SQLite pada platform desktop.
- `flutter_secure_storage` untuk menyimpan data profil kasir.
- `cryptography` untuk hashing PIN PBKDF2 dengan salt.
- `path` untuk membentuk lokasi database.
- `flutter_test` untuk pengujian unit dan widget.
- `flutter_lints` untuk aturan kualitas kode.
- `cupertino_icons` sebagai paket ikon bawaan Flutter.

Batas SDK dan daftar dependensi lengkap tercatat pada `utsprojeck/pubspec.yaml`, sedangkan versi pasti hasil resolusi `flutter pub get` tercatat pada `pubspec.lock`.

## Struktur dan Tanggung Jawab Kode

### Titik masuk aplikasi

`lib/main.dart` berisi:

- Inisialisasi `sqflite` FFI pada Linux, Windows, dan macOS.
- Pembuatan `CartController`, `CashierAuthController`, dan `TransactionHistoryService`.
- Penerapan tema aplikasi.
- Pengecekan status login saat aplikasi dimulai.
- Menampilkan indikator pemuatan atau pesan error saat data login gagal dimuat.
- Menampilkan `LoginScreen` bila belum login atau `CatalogScreen` bila sudah login.
- Mengosongkan keranjang dan mengakhiri sesi kasir pada aksi logout.

### Model data

`lib/models/product.dart`

- Mendefinisikan model `Product` dengan `id`, `name`, `price`, dan `imageUrl` opsional.
- Melakukan validasi ID tidak negatif, nama tidak kosong, dan harga tidak negatif.
- Menyediakan `fromJson()` untuk membaca katalog dan `toJson()` untuk serialisasi.
- Memvalidasi tipe dan format integer saat parsing JSON.

`lib/models/cart_item.dart`

- Mendefinisikan satu baris produk dalam keranjang.
- Menyimpan objek `Product` dan kuantitas.
- Membatasi kuantitas minimal menjadi satu.
- Menghitung `subtotal` sebagai harga produk dikali kuantitas.

`lib/models/sale_transaction.dart`

- Mendefinisikan transaksi penjualan yang berisi ID, waktu, nama kasir, daftar item, dan nominal pembayaran.
- Mencegah nama kasir kosong, transaksi tanpa item, dan pembayaran yang kurang dari total.
- Menghitung total belanja dari seluruh subtotal item.
- Menghitung kembalian sebagai pembayaran dikurangi total.
- Menyediakan representasi JSON untuk keperluan data.

### Controller state

`lib/controllers/cart_controller.dart`

- Menyimpan item keranjang dalam `Map` berdasarkan ID produk.
- Menambah kuantitas produk yang sudah ada.
- Mengurangi kuantitas atau menghapus item saat kuantitas mencapai nol.
- Menghapus satu produk tertentu.
- Mengosongkan seluruh keranjang.
- Menghitung jumlah item dan total belanja.
- Memberi pemberitahuan kepada widget melalui `notifyListeners()`.

`lib/controllers/cashier_auth_controller.dart`

- Mengelola status initialization, login, logout, nama kasir terdaftar, dan nama kasir aktif.
- Memisahkan akses terhadap `CashierAuthService`.
- Memperbarui UI setelah profil dibuat atau login berhasil.

### Service

`lib/services/product_catalog_service.dart`

- Membaca `assets/data/products.json` menggunakan `rootBundle`.
- Mengurai JSON dengan `dart:convert`.
- Memastikan JSON adalah sebuah daftar.
- Mengubah setiap objek JSON menjadi model `Product`.
- Melempar `FormatException` bila struktur atau nilai data tidak valid.

`lib/services/cashier_auth_service.dart`

- Membuat atau membaca profil kasir lokal.
- Memvalidasi nama tidak kosong dan PIN berisi 4–6 digit angka.
- Membuat salt acak 16 byte dengan `Random.secure()`.
- Menghasilkan hash PIN dengan PBKDF2-HMAC-SHA256 sebanyak 100.000 iterasi dan 256 bit.
- Menyimpan nama kasir, salt, dan hash melalui penyimpanan aman perangkat.
- Membandingkan hash menggunakan pembanding yang memeriksa seluruh byte.
- Menangkap kesalahan platform dan mengubahnya menjadi `CashierAuthException`.
- Login lokal ini hanya pembatas akses prototipe dan bukan autentikasi server produksi.

`lib/services/transaction_history_service.dart`

- Membuka atau membuat database SQLite bernama `kasir_digital_transactions.db`.
- Membuat tabel `transactions` untuk data induk transaksi.
- Membuat tabel `transaction_items` untuk snapshot item beserta foreign key ke transaksi induk.
- Menyimpan transaksi dalam database transaction/SQL transaction agar data induk dan item konsisten.
- Memuat seluruh transaksi dengan urutan transaksi terbaru.
- Membaca snapshot nama, harga, gambar, dan kuantitas produk sebagai kondisi pada saat transaksi.
- Menutup database dan mengubah kesalahan SQLite/platform menjadi `TransactionPersistenceException`.

### Layar aplikasi

`lib/screens/login_screen.dart`

- Menentukan apakah aplikasi sedang membuat profil pertama kali atau melakukan login.
- Meminta nama kasir dan PIN.
- Menampilkan konfirmasi PIN pada proses pembuatan profil.
- Memvalidasi field kosong, format PIN, kecocokan konfirmasi PIN, dan hasil autentikasi.
- Menampilkan status proses dan mencegah submit ganda.

`lib/screens/catalog_screen.dart`

- Memuat data katalog secara asynchronous.
- Menampilkan status loading.
- Menampilkan pesan error beserta tombol coba lagi.
- Menangani katalog kosong.
- Menyajikan grid pada layar lebar dan susunan yang sesuai pada layar ponsel.
- Menambah produk ke keranjang.
- Menampilkan jumlah item keranjang.
- Membuka keranjang dan riwayat transaksi.
- Menampilkan tombol logout.

`lib/screens/cart_screen.dart`

- Menampilkan daftar produk dan kuantitas.
- Menyediakan aksi tambah, kurangi, dan hapus.
- Menampilkan subtotal setiap item.
- Menampilkan total belanja.
- Menampilkan empty state ketika keranjang kosong.
- Menyalurkan alur ke halaman pembayaran.
- Membuat daftar panjang tetap dapat digulir.

`lib/screens/payment_screen.dart`

- Menampilkan ringkasan total tagihan.
- Menerima input nominal pembayaran tunai.
- Memvalidasi input kosong, negatif, format tidak valid, dan nominal kurang dari total.
- Menghitung kembalian secara dinamis.
- Membuat objek `SaleTransaction`.
- Menampilkan dialog konfirmasi sebelum menyelesaikan transaksi.
- Membatalkan konfirmasi tidak mengubah isi keranjang.
- Menyimpan transaksi ke SQLite; kegagalan penyimpanan ditampilkan dan keranjang tidak dikosongkan.
- Menavigasikan ke struk setelah penyimpanan berhasil.

`lib/screens/receipt_screen.dart`

- Menampilkan ID transaksi.
- Menampilkan nama kasir.
- Menampilkan waktu transaksi.
- Menampilkan nama, kuantitas, harga, dan subtotal setiap produk.
- Menampilkan total, nominal pembayaran, dan kembalian.
- Memungkinkan kembali ke katalog.

`lib/screens/transaction_history_screen.dart`

- Memuat transaksi dari SQLite secara asynchronous.
- Menampilkan loading dan pesan kegagalan.
- Menampilkan empty state bila belum ada transaksi.
- Menyajikan daftar transaksi terbaru beserta ringkasan kasir dan total.
- Membuka struk transaksi lama dengan data snapshot.

### Tema dan utilitas

`lib/theme/app_theme.dart`

- Menyediakan tema Material 3 terpusat.
- Mengimplementasikan desain **Modern Minimalist Editorial** dengan latar putih, aksen beige, garis tipis, teks charcoal, dan teks sekunder abu-abu.
- Mengatur input bergaris bawah, kartu radius 6, tombol utama 52 px, AppBar transparan, dan komponen lain agar konsisten.
- Mengatur CardTheme, input field, tombol, AppBar, dan border.
- Menjadi satu sumber gaya agar antarmuka antarhalaman konsisten.

`lib/utils/format_rupiah.dart`

- Memformat bilangan integer menjadi teks mata uang Rupiah.
- Contoh bentuk hasil: `Rp 15.000`.

`lib/utils/format_date_time.dart`

- Memformat waktu transaksi menjadi teks tanggal dan waktu yang mudah dibaca.

## Katalog Produk

Data katalog terletak pada `assets/data/products.json` dan memuat delapan produk:

| ID | Nama produk   |     Harga |
| -- | ------------- | --------: |
| 1  | Kopi Susu     | Rp 15.000 |
| 2  | Teh Manis     |  Rp 8.000 |
| 3  | Roti Bakar    | Rp 18.000 |
| 4  | Pisang Goreng | Rp 12.000 |
| 5  | Nasi Goreng   | Rp 25.000 |
| 6  | Mie Goreng    | Rp 22.000 |
| 7  | Air Mineral   |  Rp 5.000 |
| 8  | Jus Jeruk     | Rp 14.000 |

Katalog saat ini bersifat statis. Data dapat diperbarui dengan mengedit JSON, tetapi aplikasi belum menyediakan CRUD produk melalui antarmuka.

## Penyimpanan dan Keamanan

### Riwayat transaksi

SQLite menyimpan data transaksi permanen pada perangkat. Setiap item disalin sebagai snapshot pada saat transaksi, sehingga struk lama tetap dapat menampilkan nama dan harga produk meskipun data katalog berubah.

Database berisi:

```text
transactions
  id
  created_at
  cashier_name
  amount_paid
  total

transaction_items
  id
  transaction_id
  product_id
  product_name
  product_price
  product_image_url
  quantity
```

Penghapusan aplikasi atau penghapusan data aplikasi dapat menghapus riwayat dan profil kasir.

### Profil kasir

Pada penggunaan pertama, pengguna memasukkan nama kasir dan PIN 4–6 digit. PIN:

- tidak ditulis sebagai plaintext pada source code;
- menggunakan salt acak;
- diproses menggunakan PBKDF2-HMAC-SHA256;
- disimpan beserta nama kasir dan salt pada penyimpanan aman perangkat.

Pada penggunaan berikutnya, nama dan PIN dibandingkan dengan profil yang tersimpan. Fitur ini adalah pembatas akses lokal untuk prototipe, bukan sistem autentikasi produksi atau perlindungan akun multi-kasir.

## Perhitungan Bisnis

Nilai uang disimpan sebagai bilangan integer agar tidak bergantung pada representasi desimal floating point.

```text
Subtotal produk = harga produk × kuantitas
Total transaksi = jumlah seluruh subtotal produk
Kembalian       = nominal pembayaran - total transaksi
```

Contoh:

```text
Kopi Susu × 2 = Rp 30.000
Teh Manis × 1 = Rp 8.000
Total         = Rp 38.000
Pembayaran    = Rp 50.000
Kembalian     = Rp 12.000
```

## Penanganan Kondisi dan Error

Aplikasi menangani kondisi berikut:

- profil login belum ada dan perlu dibuat;
- nama kasir kosong;
- PIN kosong, bukan angka, atau panjangnya di luar 4–6 digit;
- PIN dan konfirmasi PIN tidak cocok;
- PIN salah;
- katalog sedang dimuat;
- katalog gagal dimuat;
- katalog kosong;
- keranjang kosong;
- nominal pembayaran kosong atau bukan angka;
- nominal pembayaran negatif;
- nominal pembayaran kurang dari total;
- pembatalan dialog konfirmasi;
- kegagalan menyimpan transaksi ke SQLite;
- kegagalan membaca riwayat;
- nama produk terlalu panjang;
- layar sempit dan layar lebar.

Saat penyimpanan transaksi gagal, keranjang tidak dikosongkan agar kasir dapat mencoba kembali dan tidak kehilangan daftar belanja.

## Pengujian

Folder `test/` memuat pengujian untuk model, controller, service, dan layar. Cakupan pengujian meliputi:

- validasi dan serialisasi model produk;
- subtotal, total, dan kembalian transaksi;
- penolakan transaksi kosong atau pembayaran tidak cukup;
- validasi nilai negatif pada model;
- operasi tambah, kurangi, hapus, dan clear pada keranjang;
- pembuatan profil, login, logout, dan penolakan PIN salah;
- penyimpanan dan verifikasi hash PIN bersalt;
- pemuatan katalog JSON;
- status loading, error, retry, dan katalog lokal;
- layout katalog pada layar 360×800, 390×844, dan 1000×900;
- nama produk panjang;
- keranjang berisi banyak produk;
- checkout pada keranjang kosong;
- validasi pembayaran;
- penyelesaian transaksi dan isi struk;
- pembatalan konfirmasi;
- penyimpanan dan pembacaan ulang riwayat SQLite;
- kegagalan duplikat penyimpanan tanpa menyimpan transaksi parsial;
- daftar riwayat dan pembukaan struk lama.

Berdasarkan dokumentasi proyek:

- `flutter analyze` dinyatakan tanpa masalah.
- `flutter test` dinyatakan lulus 21 tes.
- APK debug Android dinyatakan berhasil dibangun.
- Pengujian pada perangkat nyata dan pengujian di semua platform belum tercatat sebagai hasil final.

## Dukungan Platform

Konfigurasi native tersedia untuk:

| Platform | Lokasi konfigurasi | Catatan                                                                                            |
| -------- | ------------------ | -------------------------------------------------------------------------------------------------- |
| Android  | `android/`       | Sudah berhasil membuat APK debug dalam catatan proyek                                              |
| iOS      | `ios/`           | Konfigurasi dan runner tersedia; belum ada bukti pengujian fisik                                   |
| macOS    | `macos/`         | Konfigurasi desktop tersedia                                                                       |
| Windows  | `windows/`       | Konfigurasi desktop tersedia                                                                       |
| Linux    | `linux/`         | Konfigurasi desktop tersedia; SQLite menggunakan FFI dan penyimpanan aman memerlukan `libsecret` |
| Web      | `web/`           | Shell Flutter web tersedia; perilaku penyimpanan aman dan SQLite perlu dipastikan pada target web  |

Untuk build Linux, lingkungan pengembangan membutuhkan paket pengembangan `libsecret`, misalnya `libsecret-devel` pada Fedora atau `libsecret-1-dev` pada Debian/Ubuntu.

## Dokumentasi Pengembangan

`LOGBOOK_UTS.md` mencatat tahapan pengembangan, meliputi:

- penyelesaian alur pembayaran dan struk;
- validasi pembayaran serta dialog konfirmasi;
- perapian tema dan responsivitas UI;
- pengujian ukuran layar;
- revisi proposal UTS;
- penambahan login kasir;
- penambahan SQLite dan riwayat transaksi;
- hasil analisis, pengujian, dan build APK.

`README.md` berisi daftar fitur, teknologi, struktur, cara menjalankan, pengujian, roadmap, keterbatasan, serta tautan dokumentasi lain.

Proposal Markdown menjelaskan latar belakang, rumusan masalah, tujuan, kebutuhan fungsional dan nonfungsional, model data, alur, antarmuka, rancangan pengujian, keterbatasan, serta pemetaan ke modul praktikum.

## Cara Menjalankan

Prasyarat:

- Flutter SDK sesuai dengan batas SDK pada `pubspec.yaml`.
- Android SDK, Chrome, atau toolchain desktop sesuai platform target.
- Paket `libsecret` untuk build Linux yang menggunakan penyimpanan aman.

Perintah umum:

```bash
cd utsprojeck
flutter pub get
flutter analyze
flutter test
flutter run
```

Untuk build Android debug:

```bash
cd utsprojeck
flutter build apk --debug
```

Hasil build desktop atau mobile akan berada pada folder `build/` yang dibuat oleh Flutter dan platform terkait. Folder build dan cache seperti `.dart_tool/`, Gradle cache, serta hasil native tidak seharusnya menjadi sumber dokumentasi fitur utama karena dapat berubah setiap kali aplikasi dikompilasi.

## Status Fitur

### Sudah tersedia

- Login/profil kasir lokal.
- PIN 4–6 digit dengan hash bersalt.
- Katalog delapan produk dari JSON lokal.
- Loading, error, retry, dan empty state katalog.
- Tambah, kurangi, hapus, dan clear keranjang.
- Subtotal dan total dinamis.
- Form pembayaran tunai.
- Validasi pembayaran kosong, format, negatif, dan kurang.
- Perhitungan kembalian.
- Dialog konfirmasi transaksi.
- Penyimpanan transaksi ke SQLite.
- Snapshot produk pada transaksi.
- Struk lengkap dengan kasir, waktu, item, total, pembayaran, dan kembalian.
- Riwayat transaksi dari SQLite.
- Pembukaan kembali struk lama.
- Tema Material 3 terpusat.
- Responsivitas pada ponsel dan layar lebar.
- Tes model, controller, service, dan widget.

### Belum tersedia

- Sinkronisasi cloud dan server.
- Dukungan multi-kasir berbasis server.
- CRUD produk melalui aplikasi.
- Pencarian dan kategori produk.
- Pengelolaan stok permanen.
- Gambar produk aktual pada kartu katalog.
- Pembayaran digital atau QRIS.
- Cetak fisik atau bagikan struk.
- Sinkronisasi antarperangkat.
- Pengujian perangkat nyata yang terdokumentasi.
- Screenshot atau rekaman demonstrasi final.
- Build rilis dengan penandatanganan produksi.
- Pengaturan nama toko, profil toko, atau pajak.

## Batasan

Aplikasi merupakan prototipe UTS, bukan sistem POS komersial.

Data katalog bersifat lokal dan statis.

Login adalah pembatas akses lokal, bukan keamanan produksi.

Riwayat dan profil hanya tersimpan pada perangkat.

* [ ] Keranjang dikelola dalam memori dan dikosongkan saat logout atau mulai ulang pada kondisi tertentu.

Tidak ada sinkronisasi atau pembayaran elektronik.

Pengujian nyata lintas perangkat belum sepenuhnya tercatat.

Desktop Linux memerlukan dependensi `libsecret`.

Target iOS, macOS, Windows, dan web memiliki konfigurasi proyek, tetapi perilaku final pada semua platform belum diverifikasi dalam dokumentasi.

## Kesimpulan

Repositori ini telah melampaui prototipe katalog sederhana dan menyediakan alur kasir yang dapat dijalankan. Kode dipisahkan ke model, controller, service, screen, tema, dan utilitas; katalog dimuat dari JSON; keranjang mengelola perubahan state; pembayaran tunai memvalidasi dan menghitung kembalian; transaksi dikonfirmasi lalu disimpan ke SQLite; serta struk dan riwayat dapat dibuka kembali.

Fitur yang tersisa untuk pengembangan lanjutan adalah sistem server/cloud, multi-kasir, pengelolaan stok dan produk, pencarian, pembayaran digital, cetak/bagikan struk, dan bukti pengujian pada perangkat nyata.
