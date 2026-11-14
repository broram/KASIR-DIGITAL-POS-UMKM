# Kasir Digital UMKM

Prototipe aplikasi kasir sederhana berbasis **Flutter** untuk membantu usaha kecil mencatat pilihan barang dan menghitung total belanja.

> **Status:** prototipe alur transaksi inti (`v1.0.0+1`). Login kasir, katalog, keranjang, pembayaran tunai, konfirmasi, struk, dan riwayat lokal tersedia. Data tersimpan di perangkat; belum ada sinkronisasi cloud atau dukungan multi-kasir.

## Daftar isi

- [Fitur](#fitur)
- [Tangkapan layar](#tangkapan-layar)
- [Teknologi](#teknologi)
- [Struktur proyek](#struktur-proyek)
- [Memulai](#memulai)
- [Pengujian](#pengujian)
- [Status pengembangan dan roadmap](#status-pengembangan-dan-roadmap)
- [Keterbatasan](#keterbatasan)
- [Proposal UTS](#proposal-uts)
- [Informasi proyek](#informasi-proyek)

## Fitur

**Sudah tersedia**

- Katalog 8 produk contoh yang dimuat dari JSON lokal (`assets/data/products.json`).
- Penanganan status memuat, gagal memuat (dengan tombol coba lagi), dan katalog kosong.
- Keranjang belanja: tambah, kurangi, dan hapus produk.
- Perhitungan jumlah barang, subtotal per produk, dan total belanja.
- Format nominal Rupiah.
- Form pembayaran tunai dengan validasi nominal dan perhitungan kembalian.
- Konfirmasi sebelum transaksi diselesaikan; keranjang hanya dikosongkan setelah konfirmasi.
- Struk transaksi berisi nama kasir, ID, waktu, item, kuantitas, harga, total, pembayaran, dan kembalian.
- Profil kasir lokal: nama dan PIN 4–6 digit dibuat saat pertama kali aplikasi dijalankan; login diminta pada pembukaan aplikasi berikutnya.
- PIN disimpan sebagai hash PBKDF2 dengan salt di penyimpanan aman perangkat.
- Transaksi dan snapshot item disimpan ke SQLite setelah konfirmasi; riwayat dapat dibuka kembali setelah aplikasi ditutup.
- Halaman riwayat menampilkan transaksi terbaru dan membuka kembali detail struk.
- Model `Product`, `CartItem`, dan `SaleTransaction` dengan validasi dasar (nama kosong, harga negatif, kuantitas < 1, transaksi kosong, pembayaran kurang) dan serialisasi JSON.
- Tampilan Material 3 dengan warna dan komponen konsisten, katalog responsif, serta batas lebar konten pada layar besar.
- Nama produk panjang dibatasi dengan elipsis; daftar keranjang tetap dapat digulir saat berisi banyak produk.

**Belum tersedia**

- Sinkronisasi transaksi ke server/cloud dan dukungan multi-kasir.
- Pengelolaan produk, stok, serta pembayaran elektronik.

## Tangkapan layar

<!-- Tambahkan screenshot setelah diambil, contoh:
| Katalog | Keranjang |
| --- | --- |
| ![Katalog](docs/screenshots/katalog.png) | ![Keranjang](docs/screenshots/keranjang.png) |
-->

_Belum ditambahkan._

## Teknologi

| Komponen         | Keterangan                                                    |
| ---------------- | ------------------------------------------------------------- |
| Framework        | Flutter                                                       |
| Bahasa           | Dart (`^3.13.2`, sesuai `pubspec.yaml`)                   |
| State management | `ChangeNotifier` + `AnimatedBuilder` (keranjang dan autentikasi) |
| Data             | Katalog JSON lokal; riwayat transaksi SQLite; profil lokal aman |
| Pengujian        | `flutter_test` (tes unit dan widget)                        |

## Struktur proyek

```text
lib/
  controllers/   State keranjang dan autentikasi kasir
  models/        Product, CartItem, SaleTransaction
  screens/       Login, katalog, keranjang, pembayaran, struk, riwayat
  services/      Katalog, autentikasi lokal, dan penyimpanan transaksi
  theme/         Tema aplikasi
  utils/         Format Rupiah
assets/data/     Data contoh produk
test/            Tes model dan widget
```

Pembacaan JSON berada di *service*, parsing di *model*, state keranjang/login di *controller*, dan penyimpanan transaksi di SQLite *service* agar logika terpisah dari widget.

## Memulai

Prasyarat: Flutter SDK terpasang dan memenuhi batas SDK pada `pubspec.yaml`. Build Linux juga membutuhkan paket pengembangan `libsecret` (Fedora: `libsecret-devel`; Debian/Ubuntu: `libsecret-1-dev`).

```bash
git clone <url-repositori>
cd <nama-folder-proyek>
flutter pub get
flutter run
```

## Pengujian

```bash
flutter analyze
flutter test
```

Hasil terakhir: `flutter analyze` tanpa masalah, `flutter test` lulus 21 tes, dan APK debug Android berhasil dibangun. Uji perangkat nyata masih perlu dilakukan.

## Status pengembangan dan roadmap

| Tahap                                | Status        |
| ------------------------------------ | ------------- |
| Model data                           | Selesai       |
| Katalog produk                       | Selesai       |
| Keranjang                            | Selesai       |
| Pembayaran (input nominal, validasi) | Selesai       |
| Penyelesaian transaksi dan struk     | Selesai       |
| Login dan nama kasir                 | Selesai       |
| Persistensi dan riwayat SQLite       | Selesai       |

Alur saat ini:

```text
Login → katalog JSON → pilih produk → keranjang → pembayaran → konfirmasi → simpan SQLite → struk
```

Alur target:

```text
Login → katalog → keranjang → input pembayaran → konfirmasi → simpan → struk/riwayat
```

**Prioritas 0 — melengkapi alur inti (selesai)**

- [x] Tombol checkout aktif hanya saat keranjang tidak kosong
- [x] Input pembayaran dengan validasi nominal kosong, format, dan pembayaran kurang
- [x] Tampilan total tagihan dan kembalian
- [x] Pembuatan `SaleTransaction` setelah pembayaran valid
- [x] Dialog konfirmasi; keranjang dikosongkan hanya setelah transaksi dikonfirmasi
- [x] Layar struk (ID, waktu, item, kuantitas, harga, total, bayar, kembalian)
- [x] Tes pembayaran, keranjang kosong, pembatalan konfirmasi, dan isi struk

**Prioritas 1 — kualitas**

- [x] Uji widget pada ukuran 360x800, 390x844, dan 1000x900; termasuk nama panjang dan keranjang 13 produk
- [ ] Skenario demo singkat dan screenshot/rekaman
- [ ] Sesuaikan fitur dengan rubrik tugas

**Prioritas 2 — pengembangan lanjutan**

- [ ] CRUD produk, pencarian/kategori, stok, gambar produk
- [ ] Sinkronisasi cloud dan dukungan multi-kasir
- [ ] Pembayaran digital
- [ ] Ikon, nama aplikasi, dan konfigurasi build untuk platform distribusi

## Keterbatasan

- Data produk berupa contoh statis.
- Profil kasir dan riwayat transaksi tersimpan lokal di perangkat; data tidak tersinkron ke perangkat lain atau cloud.
- Login lokal hanya pembatas akses sederhana, bukan autentikasi produksi atau dukungan multi-kasir.
- APK debug Android berhasil dibangun, tetapi belum diuji pada perangkat nyata; build Linux memerlukan paket `libsecret` dan platform lain belum diverifikasi.
- Belum ada pengujian pada perangkat nyata yang tercatat.

## Proposal UTS

Proposal telah direvisi agar status fitur, hasil pengujian, dan batasan prototipe selaras dengan implementasi login kasir dan riwayat transaksi lokal.

- [Proposal revisi — Entri 4](../RevisiEntri4_Proposal_UTS_Kasir_Digital_POS_UMKM.docx)
- [Draft proposal revisi](../proposal_uts_kasir_digital_revisi.md)
- Ringkasan perubahan proposal dan dokumentasi dicatat pada [Entri 4 logbook](./LOGBOOK_UTS.md#entri-4).

## Logbook

Catatan kegiatan pengembangan: [LOGBOOK_UTS.md](./LOGBOOK_UTS.md), termasuk revisi dokumentasi pada Entri 4.
