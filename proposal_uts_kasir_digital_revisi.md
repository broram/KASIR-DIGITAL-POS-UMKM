# Proposal UTS Project: Kasir Digital & POS UMKM

**Aplikasi Pencatatan Transaksi Penjualan Berbasis Flutter**

| | |
|---|---|
| Mata kuliah | Pemrograman Mobile (UTS, cakupan Modul 1–4) |
| Dosen pengampu | Dr. Resmi Darni, S.Kom., M.Kom. |
| Kelompok | Kelompok Kasir: Muhammad Ilham Ramadhan (24343101), _[tambahkan anggota lain]_ |
| Institusi | Program Studi Teknik Informatika, Departemen Teknik Elektronika, Fakultas Teknik, Universitas Negeri Padang |
| Tahun | 2026 |

---

## 1. Ringkasan Proyek

**Kasir Digital & POS UMKM** adalah aplikasi Flutter sederhana untuk membantu pemilik atau pegawai UMKM mencatat transaksi penjualan. Kasir membuat profil lokal saat pertama kali menggunakan aplikasi, lalu masuk dengan nama dan PIN. Kasir dapat memilih barang, mengelola keranjang, menerima pembayaran tunai, mengonfirmasi transaksi, dan melihat struk. Transaksi yang dikonfirmasi disimpan di SQLite dan dapat dibuka kembali melalui riwayat.

Proses kasir dipilih karena merupakan masalah nyata yang mudah diamati dan didemonstrasikan. Ruang lingkupnya sederhana untuk UTS, tetapi tetap menerapkan materi Flutter dan Dart dari praktikum T1–T7.

## 2. Latar Belakang

Sebagian UMKM masih mencatat penjualan secara manual. Cara ini rentan salah hitung total atau kembalian, menyulitkan pemilik mengetahui barang yang terjual, dan membuat riwayat transaksi sulit ditelusuri. Aplikasi POS sederhana dapat mempercepat pencatatan tanpa membangun sistem bisnis yang kompleks.

Agar realistis untuk UTS, aplikasi berfokus pada **pencatatan transaksi**, bukan sistem POS komersial penuh. Integrasi pembayaran sungguhan, multi-kasir berbasis server, dan backend produksi tidak menjadi syarat versi awal.

## 3. Rumusan Masalah

1. Bagaimana menampilkan katalog barang dengan harga dan informasi yang mudah dibaca?
2. Bagaimana membantu kasir memilih barang dan menghitung subtotal, total belanja, serta kembalian secara benar?
3. Bagaimana menampilkan perubahan data transaksi pada antarmuka Flutter?
4. Bagaimana mengelola kondisi data: katalog dimuat, keranjang kosong, input tidak valid, atau pemuatan data gagal?
5. Bagaimana menyediakan pintu masuk aplikasi (login awal) yang sederhana tanpa menyimpan data sensitif sebagai teks biasa?

## 4. Tujuan

- Membuat aplikasi Flutter yang membantu pencatatan penjualan sederhana.
- Menerapkan widget, form, navigasi, dan pengelolaan state pada alur kasir.
- Menggunakan model Dart agar data barang dan transaksi terstruktur.
- Menghitung harga dan kembalian secara dinamis serta memvalidasi input.
- Memuat data katalog secara asynchronous dengan status loading dan error yang ditangani.
- Menyusun kode dalam beberapa file berdasarkan tanggung jawabnya.
- Menerapkan desain antarmuka yang konsisten (Modern Minimalist Editorial) pada seluruh halaman.

## 5. Pengguna dan Skenario

**Pengguna:** pemilik atau pegawai UMKM yang melakukan transaksi penjualan.

**Skenario utama:** pada pemakaian pertama, kasir membuat profil lokal dengan nama dan PIN; pada pemakaian berikutnya kasir masuk menggunakan profil tersebut. Kasir memilih barang, menentukan jumlah, meninjau keranjang, memasukkan nominal pembayaran, lalu mengonfirmasi transaksi. Aplikasi menyimpan transaksi dan menampilkan struk berisi nama kasir, barang, jumlah, subtotal, total, pembayaran, dan kembalian.

## 6. Kebutuhan

### 6.1 Kebutuhan fungsional

| Kode | Kebutuhan | Keterangan |
|---|---|---|
| F-00 | Login awal | Pada pemakaian pertama, buat profil dengan nama kasir dan PIN 4–6 digit; pada pemakaian berikutnya, validasi nama dan PIN sebelum membuka katalog. Bersifat lokal (tanpa server). |
| F-01 | Katalog barang | Menampilkan nama, harga, dan gambar/ikon opsional memakai `ListView.builder` atau `GridView.builder`. Data dari JSON lokal (endpoint publik opsional). |
| F-02 | Keranjang transaksi | Tambah barang, ubah jumlah, hapus barang, tampilkan subtotal dan total. |
| F-03 | Form pembayaran | Nominal bayar; validasi tidak kosong dan tidak negatif; kembalian dihitung otomatis; pembayaran kurang tidak dapat diselesaikan. |
| F-04 | Konfirmasi dan struk | Ringkasan sebelum konfirmasi; setelah transaksi tersimpan, struk menampilkan nama kasir dan rincian transaksi. |
| F-05 | Navigasi halaman | Login → katalog → keranjang → pembayaran → struk/riwayat, dengan pengiriman data transaksi. |
| F-06 | Riwayat transaksi | Transaksi terkonfirmasi disimpan secara lokal dan daftar riwayat dapat dibuka kembali. |
| F-07 | Penanganan status data | Loading, pesan error, tombol coba lagi, serta empty state katalog dan keranjang. |

### 6.2 Kebutuhan nonfungsional

| Kode | Kebutuhan | Keterangan |
|---|---|---|
| NF-01 | Kemudahan penggunaan | Tampilan jelas dan alur singkat bagi kasir. |
| NF-02 | Keandalan | Aplikasi tidak crash saat input tidak valid atau pemuatan data gagal. |
| NF-03 | Keakuratan | Total dan kembalian dihitung dari data keranjang, bukan input manual. |
| NF-04 | Modularitas | Kode dipisah menjadi model, service, controller, screen, dan utilitas. |
| NF-05 | Keamanan dasar | PIN tidak disimpan sebagai teks biasa; hash PIN bersalt disimpan melalui penyimpanan aman perangkat. Login lokal bukan autentikasi produksi. |
| NF-06 | Konsistensi desain | Seluruh halaman mengikuti pedoman desain pada Bagian 9. |

## 7. Alur Aplikasi

```text
Login awal
    -> validasi nama kasir dan PIN
Katalog barang
    -> pilih/tambah barang
Keranjang
    -> ubah jumlah atau hapus barang
Form pembayaran
    -> validasi nominal dan hitung kembalian
Konfirmasi
    -> simpan transaksi di SQLite
Struk / riwayat transaksi
    -> buka struk sebelumnya atau kembali ke katalog
```

## 8. Rancangan Teknis

### 8.1 Model data

| Model | Atribut | Keterangan |
|---|---|---|
| `Product` | `id`, `name`, `price`, `imageUrl` (opsional) | Data barang pada katalog. |
| `CartItem` | `product`, `quantity`, `subtotal` | Satu baris barang dalam keranjang. |
| `SaleTransaction` | `id`, `createdAt`, `cashierName`, `items`, `total`, `amountPaid`, `change` | Satu transaksi yang selesai. |

Rumus utama (nilai uang disimpan sebagai bilangan bulat, diformat Rupiah hanya saat ditampilkan):

```text
subtotal barang = harga barang x jumlah
total transaksi = jumlah seluruh subtotal barang
kembalian       = pembayaran - total transaksi
```

### 8.2 Autentikasi lokal (login awal)

- Tanpa server dan tanpa akun multi-kasir; profil pertama kali dibuat di perangkat, lalu login diminta saat aplikasi dibuka.
- Aturan validasi: nama kasir tidak kosong; PIN wajib 4–6 digit angka dan harus cocok dengan profil lokal.
- PIN diproses dengan PBKDF2 bersalt; salt dan hash disimpan menggunakan `flutter_secure_storage`, bukan sebagai teks biasa.
- Nama kasir yang berhasil masuk diteruskan ke struk dan disimpan bersama transaksi.
- Login ini hanya pembatas akses sederhana pada prototipe lokal, bukan autentikasi yang aman untuk operasional produksi.

### 8.3 Struktur folder

```text
lib/
├── main.dart
├── controllers/
│   ├── cashier_auth_controller.dart # status login dan nama kasir
│   └── cart_controller.dart      # state keranjang, total, kembalian
├── models/
│   ├── product.dart
│   ├── cart_item.dart
│   └── sale_transaction.dart
├── services/
│   ├── cashier_auth_service.dart # profil kasir lokal dan verifikasi PIN
│   ├── product_catalog_service.dart # pemuatan katalog JSON lokal
│   └── transaction_history_service.dart # persistensi SQLite
├── screens/
│   ├── login_screen.dart         # pembuatan profil awal dan login kasir
│   ├── catalog_screen.dart
│   ├── cart_screen.dart
│   ├── payment_screen.dart
│   ├── receipt_screen.dart
│   └── transaction_history_screen.dart
├── theme/
│   └── app_theme.dart            # warna, tipografi, bentuk komponen
└── utils/
    ├── format_rupiah.dart
    └── format_date_time.dart
assets/data/products.json
test/
```

| Folder/File | Tanggung jawab |
|---|---|
| `controllers/` | State aplikasi (`ChangeNotifier`): login, keranjang, total, kembalian. |
| `models/` | Kelas data, validasi dasar, dan konversi JSON. |
| `services/` | Pemanggilan katalog, penyimpanan profil aman, dan penyimpanan riwayat SQLite. |
| `screens/` | Halaman login, katalog, transaksi, struk, riwayat, dan interaksi pengguna. |
| `theme/` | Satu sumber gaya agar desain konsisten. |
| `utils/` | Fungsi bantu, misalnya format Rupiah dan tanggal/waktu. |

State dikelola dengan `ChangeNotifier` + `AnimatedBuilder` secara konsisten; pendekatan ini dipilih agar mudah dijelaskan dan dipisahkan dari widget.

### 8.4 Rancangan halaman

| Halaman | Isi utama | Aksi pengguna |
|---|---|---|
| Login | Nama kasir dan PIN; pembuatan profil pada pemakaian pertama | Buat profil atau masuk |
| Katalog | Daftar/grid barang, indikator loading, pesan error | Tambah barang, buka keranjang |
| Keranjang | Daftar item, subtotal, total | Ubah jumlah, hapus, lanjut bayar |
| Pembayaran | Nominal bayar dan kembalian | Validasi, konfirmasi |
| Struk | Nama kasir, waktu, barang, jumlah, subtotal, total, bayar, kembalian | Kembali ke katalog |
| Riwayat | Daftar transaksi tersimpan dan total | Buka kembali struk |

## 9. Rancangan Antarmuka (Modern Minimalist Editorial)

Arah desain: sederhana, bersih, elegan, dan timeless, terinspirasi majalah perjalanan premium. Setiap elemen harus punya tujuan; prinsipnya _less is more_.

### 9.1 Pedoman visual

| Aspek | Ketentuan |
|---|---|
| Warna | Dominan putih; aksen soft gray, beige, dan charcoal. Hindari warna mencolok dan gradasi berlebihan. |
| Tipografi | Sans-serif modern (Inter). Heading tegas dan besar; teks isi ringan. |
| Layout | Whitespace luas, hierarki visual kuat, komposisi editorial asimetris. |
| Komponen | Border radius secukupnya, garis tipis, bayangan sangat halus. |
| Gerak | Tanpa animasi yang mengganggu. |
| Responsif | Mobile: susunan vertikal, navigasi ringkas, tipografi nyaman dibaca. |

### 9.2 Token desain

| Token | Nilai | Pemakaian |
|---|---|---|
| `background` | `#FFFFFF` | Latar halaman |
| `surface-beige` | `#F3EFE7` | Label, panel pendukung |
| `line` | `#E4E1DA` | Garis tipis pemisah |
| `text-primary` (charcoal) | `#1F1F1D` | Heading, tombol utama |
| `text-secondary` | `#6B6A65` | Teks pendukung |
| Heading | Inter 700, 40 px (login), tracking −0.02em | Judul halaman |
| Body | Inter 400, 15–16 px, tinggi baris 1.6 | Isi dan input |
| Label | Inter 500, 12 px | Label field, keterangan kecil |
| Tombol utama | tinggi 52 px, radius 6 px | Aksi utama |

Rasio kontras teks terhadap latar minimal 4,5:1, dan target sentuh minimal 44 px.

### 9.3 Tampilan login awal

Mockup visual tersedia pada kanvas desain: <https://claude.ai/artifact/Pu3hpXJgosLLcMypHJVZCh>

```text
┌──────────────────────────────┐
│ KASIR DIGITAL        POS UMKM│  ← header, garis tipis di bawah
│──────────────────────────────│
│                              │
│                              │  ← whitespace luas
│                              │
│ (Edisi 01 · Prototipe)       │  ← label pil beige
│ Catat penjualan,             │
│ tanpa repot.                 │  ← headline besar
│ Masuk untuk memulai          │
│ transaksi hari ini.          │
│                              │
│ Nama kasir                   │
│ ____________________________ │  ← input bergaris bawah
│ PIN                          │
│ ____________________________ │
│                              │
│ [          Masuk           ] │  ← tombol charcoal
│                              │
│──────────────────────────────│
│ Prototipe UTS · Data lokal   │  ← footer
└──────────────────────────────┘
```

**Perilaku dan validasi layar login**

| Kondisi | Respons |
|---|---|
| Nama kasir kosong | Pesan "Nama kasir wajib diisi" di bawah field. |
| PIN bukan 4–6 digit angka | Pesan "PIN harus 4–6 digit angka". |
| PIN tidak cocok | Pesan "Nama kasir atau PIN tidak sesuai." ditampilkan. |
| Data valid | Navigasi ke katalog; nama kasir tersedia untuk struk. |

Pada pemakaian pertama, layar login meminta nama, PIN, dan konfirmasi PIN untuk membuat profil lokal. Halaman lain (katalog, keranjang, pembayaran, struk, dan riwayat) mengikuti token dan prinsip yang sama.

## 10. Pemetaan ke Materi Praktikum

| Materi | Penerapan pada proyek |
|---|---|
| **T1 – Pengenalan Flutter dan persiapan lingkungan** | Membuat project, menjalankan aplikasi, menguji pada target yang tersedia. |
| **T2 – Dasar Dart/Flutter dan asynchronous** | Tipe data, class, function, collection, null safety, `Future`/`async`/`await`, penanganan kesalahan input. |
| **T3 – UI dinamis dan pengelolaan data** | Katalog dan keranjang dengan `ListView.builder`/`GridView.builder`, pengolahan `List`/`Map`, empty state, form login dan pembayaran. |
| **T4 – REST API, JSON, model, dan state** | Pemuatan katalog dan `fromJson`; pemisahan model–service–controller–screen. HTTP GET opsional jika dosen mensyaratkan. |
| **T5 – Penyimpanan lokal** | Menyimpan riwayat transaksi dan snapshot item di SQLite; menyimpan hash PIN pada penyimpanan aman perangkat. |
| **T6–T7 – Testing, keamanan, build release** | Tes fungsi, widget, login, dan persistensi; PIN diproses dengan hash bersalt; build APK untuk demo. |

**Catatan cakupan:** katalog dan parsing JSON menerapkan materi T1–T4; penyimpanan transaksi lokal menerapkan T5 sebagai penguatan fitur, bukan backend produksi.

## 11. Status Implementasi (per 15 November 2026)

| Kode | Status | Catatan |
|---|---|---|
| F-00 Login awal | Selesai | Profil awal nama + PIN; PIN hash bersalt di penyimpanan aman |
| F-01 Katalog | Selesai | JSON lokal, 8 produk |
| F-02 Keranjang | Selesai | Tambah, kurangi, hapus, total |
| F-03 Pembayaran | Selesai | Tunai, validasi nominal, dan perhitungan kembalian |
| F-04 Konfirmasi dan struk | Selesai | Simpan sebelum menampilkan struk; nama kasir disertakan |
| F-05 Navigasi | Selesai | Login → katalog → keranjang → pembayaran → struk |
| F-06 Riwayat transaksi | Selesai | SQLite lokal; data item tersimpan sebagai snapshot |
| F-07 Status data | Selesai | Loading, error/retry, katalog kosong, dan keranjang kosong |
| Pengujian | Sebagian | `flutter analyze` tanpa masalah, 21 tes lulus, APK debug Android berhasil dibangun; uji perangkat nyata masih perlu dilakukan |

## 12. Tahapan dan Jadwal Pengerjaan

| Tahap | Kegiatan | Waktu |
|---|---|---|
| 1 | Persiapan lingkungan, project, struktur folder | _[isi]_ |
| 2 | Model data dan data contoh/service | _[isi]_ |
| 3 | Halaman katalog dengan status loading dan error | _[isi]_ |
| 4 | Keranjang dan perhitungan subtotal/total | _[isi]_ |
| 5 | Tema desain dan halaman login awal | _[isi]_ |
| 6 | Form pembayaran, validasi, dan kembalian | _[isi]_ |
| 7 | Konfirmasi dan struk transaksi | _[isi]_ |
| 8 | Pengujian, perbaikan, dan penyusunan laporan | _[isi]_ |
| 9 | Pengembangan lanjutan (bila waktu cukup) | _[isi]_ |

## 13. Rencana Pengujian

| No | Skenario uji | Hasil yang diharapkan |
|---|---|---|
| 1 | Buka aplikasi pertama kali | Form pembuatan profil kasir tampil. |
| 2 | Login dengan nama kosong | Pesan validasi tampil. |
| 3 | Login dengan PIN tidak valid atau salah | Pesan validasi tampil; tidak masuk. |
| 4 | Buat profil atau login dengan data valid | Katalog barang tampil. |
| 5 | Tambah barang ke keranjang | Barang muncul dengan subtotal benar. |
| 6 | Ubah jumlah barang | Subtotal dan total ikut berubah. |
| 7 | Hapus barang | Barang hilang dan total diperbarui. |
| 8 | Buka keranjang kosong | Pesan keranjang kosong tampil. |
| 9 | Pembayaran kosong atau negatif | Pesan validasi tampil. |
| 10 | Pembayaran kurang dari total | Transaksi tidak dapat diselesaikan. |
| 11 | Pembayaran lebih dari total | Kembalian dihitung benar. |
| 12 | Selesaikan transaksi | Struk sesuai isi keranjang dan memuat nama kasir. |
| 13 | Pemuatan katalog gagal | Pesan error dan tombol coba lagi tampil tanpa crash. |
| 14 | Aplikasi dibuka kembali setelah transaksi | Transaksi tetap muncul pada riwayat dan struk dapat dibuka kembali. |
| 15 | Penyimpanan transaksi gagal | Pesan kegagalan tampil dan keranjang tidak dikosongkan. |
| 16 | PIN saat pembuatan profil tidak sama dengan konfirmasi | Profil tidak dibuat dan pesan kesalahan tampil. |
| 17 | Login dengan PIN salah | Katalog tidak terbuka dan pesan kesalahan tampil. |

## 14. Batasan dan Asumsi

- Aplikasi merupakan prototipe pembelajaran, bukan sistem kasir siap produksi.
- Tidak memproses pembayaran digital atau terhubung ke rekening/QRIS sungguhan.
- Data katalog berupa data contoh lokal; API publik hanya untuk demonstrasi dan bukan backend transaksi.
- Login dan penyimpanan riwayat bersifat lokal; autentikasi server, multi-kasir, sinkronisasi antarperangkat, dan stok permanen bukan cakupan prototipe.
- Riwayat tersimpan hanya pada perangkat dan dapat hilang jika data aplikasi dihapus.
- Login lokal adalah pembatas akses sederhana, bukan perlindungan untuk data produksi.
- PIN tidak disimpan dalam teks biasa; salt dan hash disimpan melalui penyimpanan aman perangkat.
- Build desktop Linux membutuhkan paket pengembangan `libsecret`; uji perangkat nyata masih diperlukan.

## 15. Pengembangan Lanjutan (Opsional)

- Sinkronisasi riwayat ke server/cloud setelah kebutuhan backend disetujui.
- Dukungan beberapa profil kasir dengan pengelolaan akun yang sesuai.
- Pengaturan nama toko, pencarian/filter produk, dan stok dasar.
- Uji pada perangkat nyata, screenshot, dan rekaman demo.
- Build APK release dengan konfigurasi penandatanganan yang sesuai.

## 16. Kriteria Keberhasilan

1. Aplikasi dapat membuat profil kasir pada pemakaian pertama dan menampilkan katalog setelah login berikutnya.
2. Login menolak input kosong atau tidak valid dengan pesan yang jelas.
3. Kasir dapat menambah, mengubah jumlah, dan menghapus barang dari keranjang.
4. Subtotal, total, dan kembalian berubah sesuai data transaksi.
5. Input kosong, jumlah tidak valid, dan pembayaran kurang ditangani dengan pesan yang jelas.
6. Kasir dapat menyelesaikan transaksi, melihat struk, dan menemukan transaksi itu kembali pada riwayat setelah aplikasi dibuka ulang.
7. Kegagalan menyimpan transaksi ditampilkan dan keranjang tidak dikosongkan.
8. Status loading dan kegagalan pemuatan ditampilkan tanpa membuat aplikasi crash.
9. Seluruh halaman konsisten dengan pedoman desain; kode modular dan alur login sampai riwayat dapat didemonstrasikan.

## 17. Deskripsi Singkat untuk Pengajuan

**Kasir Digital & POS UMKM** adalah aplikasi berbasis Flutter yang membantu pemilik atau pegawai UMKM mencatat transaksi penjualan secara sederhana. Aplikasi menyediakan login lokal nama kasir dan PIN, katalog barang, keranjang, pembayaran tunai, konfirmasi, struk, serta riwayat transaksi persisten di SQLite. PIN disimpan sebagai hash bersalt pada penyimpanan aman perangkat. Pengembangan menerapkan widget dan navigasi, model dan collection, form dan validasi, pemrograman asynchronous, JSON, SQLite, dan pengelolaan state. Sinkronisasi online, multi-kasir, stok, dan pembayaran digital menjadi pengembangan lanjutan.

## Daftar Pustaka

1. Dokumentasi resmi Flutter. https://docs.flutter.dev
2. Dokumentasi resmi Dart. https://dart.dev/guides
3. Dokumentasi paket `http`. https://pub.dev/packages/http (jika HTTP GET digunakan)
4. Modul praktikum T1–T7 mata kuliah Pemrograman Mobile. _[Lengkapi sesuai modul dari dosen]_
