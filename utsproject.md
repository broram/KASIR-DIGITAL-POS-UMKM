# Proposal UTS Project: Kasir Digital & POS UMKM

## 1. Ringkasan Proyek

**Kasir Digital & POS UMKM** adalah aplikasi Flutter sederhana untuk membantu pemilik atau pegawai usaha mikro, kecil, dan menengah mencatat transaksi penjualan. Pengguna dapat melihat katalog barang, memasukkan barang ke keranjang, mengubah jumlah pembelian, menghitung total belanja dan kembalian, lalu menyimpan transaksi serta melihat ringkasan struk.

Proyek ini dipilih karena proses kasir merupakan masalah nyata yang mudah diamati dan didemonstrasikan. Ruang lingkupnya dapat dibuat sederhana untuk UTS, tetapi tetap memberi kesempatan menerapkan materi Flutter dan Dart yang muncul pada laporan praktikum T1–T7.

## 2. Latar Belakang

Sebagian UMKM masih mencatat penjualan secara manual. Cara tersebut dapat membuat perhitungan total atau kembalian keliru, menyulitkan pemilik mengetahui barang yang terjual, dan membuat riwayat transaksi sulit ditelusuri. Aplikasi POS sederhana dapat membantu mempercepat pencatatan tanpa perlu langsung membangun sistem bisnis yang kompleks.

Untuk menjaga proyek tetap realistis dikerjakan sebagai project UTS, aplikasi ini berfokus pada **pencatatan transaksi**, bukan sistem POS komersial penuh. Integrasi pembayaran sungguhan, akun multi-kasir, dan backend produksi tidak menjadi syarat versi awal.

## 3. Rumusan Masalah

1. Bagaimana menampilkan katalog barang dengan harga dan informasi yang mudah dibaca?
2. Bagaimana membantu kasir memilih barang dan menghitung subtotal, total belanja, serta kembalian secara benar?
3. Bagaimana menampilkan perubahan data transaksi pada UI Flutter?
4. Bagaimana mengelola kondisi data, seperti katalog sedang dimuat, keranjang kosong, input tidak valid, atau permintaan API gagal?

## 4. Tujuan

- Membuat aplikasi Flutter yang membantu proses pencatatan penjualan sederhana.
- Menerapkan widget, form, navigasi, dan pengelolaan state pada alur kasir.
- Menggunakan model Dart agar data barang dan transaksi lebih terstruktur.
- Menghitung harga dan kembalian secara dinamis serta memvalidasi input.
- Menerapkan pengambilan data katalog secara asynchronous; bila memakai API, aplikasi menampilkan status loading dan error dengan baik.
- Menyusun kode dalam beberapa file berdasarkan tanggung jawabnya.

## 5. Pengguna dan Skenario

**Pengguna:** pemilik atau pegawai UMKM yang melakukan transaksi penjualan.

**Skenario utama:** kasir membuka katalog, memilih barang, menentukan jumlah, meninjau keranjang, memasukkan nominal pembayaran, lalu menyelesaikan transaksi. Aplikasi menampilkan struk berisi barang, jumlah, subtotal, total, pembayaran, dan kembalian.

## 6. Fitur yang Diusulkan

### Fitur inti untuk versi UTS

1. **Katalog barang**
   - Menampilkan nama barang, harga, dan gambar/ikon opsional.
   - Menggunakan `ListView.builder` atau `GridView.builder`.
   - Data dapat berasal dari endpoint produk publik yang sesuai atau data JSON contoh. Jika memakai endpoint, tampilkan indikator loading, pesan error, dan tombol coba lagi.
2. **Keranjang transaksi**
   - Menambahkan barang ke keranjang.
   - Menambah atau mengurangi jumlah barang dan menghapus barang.
   - Menampilkan subtotal per barang dan total transaksi.
3. **Form pembayaran**
   - Memasukkan nama pelanggan secara opsional dan nominal pembayaran.
   - Memvalidasi jumlah barang dan pembayaran agar tidak kosong atau bernilai negatif.
   - Menghitung kembalian secara otomatis; pembayaran yang kurang tidak dapat diselesaikan.
4. **Konfirmasi dan struk**
   - Menampilkan ringkasan transaksi sebelum dikonfirmasi.
   - Menampilkan struk setelah transaksi berhasil dicatat.
5. **Navigasi halaman**
   - Berpindah dari katalog ke halaman keranjang/form transaksi.
   - Mengirim data pilihan barang ke halaman transaksi dan, bila diperlukan, mengembalikan hasil transaksi ke halaman sebelumnya.

### Pengembangan lanjutan (opsional)

- Riwayat transaksi dan penyimpanan lokal dengan SQLite (`sqflite`).
- Menyimpan pengaturan sederhana, misalnya nama toko, menggunakan `SharedPreferences`.
- Fitur pencarian/filter barang dan stok dasar.
- Unit test untuk fungsi perhitungan serta widget test untuk form dan struk.
- Menyiapkan build APK untuk demonstrasi.

## 7. Pemetaan ke Materi Praktikum

| Materi yang dipelajari | Penerapan pada proyek |
|---|---|
| **T1 – Pengenalan Flutter dan persiapan lingkungan** | Membuat project Flutter, menggunakan Dart/Flutter SDK, menjalankan aplikasi, dan menguji pada target yang tersedia. |
| **T2 – Dasar Dart/Flutter dan asynchronous programming** | Menggunakan tipe data, class, function, collection, null safety, `Future`/`async`/`await`, serta menangani kesalahan input dan operasi asynchronous. |
| **T3 – UI dinamis dan pengelolaan data** | Menampilkan katalog/keranjang dengan `ListView.builder` atau `GridView.builder`; mengolah `List`/`Map`; menerapkan pencarian, penghapusan, dan empty state bila fitur tersebut dipilih. |
| **T4 – REST API, JSON, model, dan Provider** | Mengambil data produk dengan HTTP GET, mengubah JSON menjadi model melalui `fromJson`, serta mengelola katalog/keranjang dengan `Provider` atau `setState`. Struktur kode dipisahkan menjadi model, service, provider, dan screen. |
| **T5 – Penyimpanan lokal** | Pengembangan opsional untuk menyimpan produk atau riwayat transaksi agar tetap tersedia setelah aplikasi ditutup, menggunakan SQLite atau `SharedPreferences` sesuai jenis datanya. |
| **T6–T7 – Testing, keamanan, dan build release** | Pengembangan lanjutan: menguji fungsi hitung total/kembalian dan tampilan, menghindari penyimpanan rahasia di kode, serta membuat APK untuk demo. |

**Catatan cakupan:** dokumen UTS yang tersedia menyebut project praktikum mencakup **Modul 1–4**. Karena itu, fitur inti sebaiknya memprioritaskan materi T1–T4. Materi T5–T7 dapat disebut sebagai rencana pengembangan, bukan ketergantungan agar aplikasi inti bisa berjalan.

## 8. Rancangan Teknis

### Alur aplikasi

```text
Katalog barang
    -> pilih/tambah barang
Keranjang
    -> ubah jumlah atau hapus barang
Form pembayaran
    -> validasi nominal dan hitung kembalian
Konfirmasi
    -> catat transaksi
Struk transaksi
```

### Model data sederhana

- **Product**: `id`, `name`, `price`, `imageUrl` (opsional).
- **CartItem**: `product`, `quantity`, `subtotal`.
- **Transaction**: `id`, `createdAt`, `items`, `total`, `paid`, `change`.

Rumus utama:

```text
subtotal barang = harga barang x jumlah
total transaksi = jumlah seluruh subtotal barang
kembalian = pembayaran - total transaksi
```

Nilai total dan kembalian harus dihitung dari data keranjang, bukan dimasukkan manual. Gunakan tipe numerik yang sesuai dan format mata uang Rupiah hanya saat menampilkan nilai.

### Struktur folder yang disarankan

```text
lib/
├── main.dart
├── models/
│   ├── product.dart
│   ├── cart_item.dart
│   └── transaction.dart
├── services/
│   └── product_service.dart
├── providers/
│   └── cart_provider.dart
└── screens/
    ├── catalog_screen.dart
    ├── cart_screen.dart
    ├── payment_screen.dart
    └── receipt_screen.dart
```

Untuk implementasi paling sederhana, state keranjang dapat dikelola dengan `setState`. Jika ingin menunjukkan materi T4 secara lebih jelas, gunakan `Provider`/`ChangeNotifier` untuk state katalog dan keranjang. Pilih satu pendekatan yang dapat dijelaskan dan jangan mencampur pengelolaan state tanpa kebutuhan.

## 9. Batasan dan Asumsi

- Aplikasi merupakan prototipe pembelajaran, bukan sistem kasir siap produksi.
- Tidak memproses pembayaran digital atau terhubung ke rekening/QRIS sungguhan.
- Versi inti dapat menggunakan data contoh; jika memakai API publik, data katalog disesuaikan menjadi data produk yang memiliki nama dan harga. API publik hanya untuk demonstrasi dan tidak dianggap sebagai backend transaksi yang persisten.
- Penyimpanan riwayat transaksi, autentikasi, sinkronisasi antarperangkat, dan pengelolaan stok permanen merupakan pengembangan lanjutan.
- Tidak menyimpan kata sandi, token, atau data sensitif dalam teks biasa.

## 10. Kriteria Keberhasilan

1. Aplikasi dapat dibuka dan menampilkan katalog barang.
2. Kasir dapat menambahkan, mengubah jumlah, dan menghapus barang dari keranjang.
3. Subtotal, total, dan kembalian berubah sesuai data transaksi.
4. Input kosong, jumlah tidak valid, dan pembayaran kurang ditangani dengan pesan yang jelas.
5. Kasir dapat menyelesaikan transaksi dan melihat struk yang sesuai dengan keranjang.
6. Jika katalog diambil dari API, status loading dan kegagalan pemuatan ditampilkan tanpa membuat aplikasi crash.
7. Berkas kode tersusun modular dan alur pemilihan barang sampai struk dapat didemonstrasikan.

## 11. Deskripsi Singkat untuk Pengajuan

**Kasir Digital & POS UMKM** merupakan aplikasi berbasis Flutter yang dirancang untuk membantu pemilik atau pegawai UMKM mencatat transaksi penjualan secara sederhana. Aplikasi menyediakan katalog barang, keranjang belanja, form pembayaran, perhitungan total dan kembalian otomatis, serta tampilan struk transaksi. Pengembangan versi UTS menerapkan materi Flutter dan Dart yang telah dipelajari, meliputi widget dan navigasi, pengolahan data menggunakan collection dan model, form serta validasi input, pemrograman asynchronous, integrasi REST API dan JSON, dan pengelolaan state. Fitur penyimpanan riwayat, pengujian otomatis, dan build release dapat ditambahkan sebagai pengembangan lanjutan sesuai cakupan praktikum.
