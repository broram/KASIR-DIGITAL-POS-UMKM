# Kasir Digital UMKM

Prototipe aplikasi kasir sederhana berbasis **Flutter** untuk membantu usaha kecil mencatat pilihan barang dan menghitung total belanja.

> **Status:** prototipe alur transaksi inti (`v1.0.0+1`). Katalog, keranjang, pembayaran tunai, konfirmasi, dan struk tersedia. Transaksi belum disimpan setelah aplikasi ditutup, sehingga aplikasi belum siap untuk operasional produksi.

## Daftar isi

- [Fitur](#fitur)
- [Tangkapan layar](#tangkapan-layar)
- [Teknologi](#teknologi)
- [Struktur proyek](#struktur-proyek)
- [Memulai](#memulai)
- [Pengujian](#pengujian)
- [Status pengembangan dan roadmap](#status-pengembangan-dan-roadmap)
- [Keterbatasan](#keterbatasan)
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
- Struk transaksi berisi ID, waktu, item, kuantitas, harga, total, pembayaran, dan kembalian.
- Model `Product`, `CartItem`, dan `SaleTransaction` dengan validasi dasar (nama kosong, harga negatif, kuantitas < 1, transaksi kosong, pembayaran kurang) dan serialisasi JSON.
- Tampilan Material 3 dengan warna dan komponen konsisten, katalog responsif, serta batas lebar konten pada layar besar.
- Nama produk panjang dibatasi dengan elipsis; daftar keranjang tetap dapat digulir saat berisi banyak produk.

**Belum tersedia**

- Penyimpanan serta riwayat transaksi.
- Pengelolaan produk, stok, autentikasi, dan pembayaran elektronik.

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
| State management | `ChangeNotifier` + `AnimatedBuilder` (`CartController`) |
| Data             | JSON lokal sebagai aset                                       |
| Pengujian        | `flutter_test` (tes unit dan widget)                        |

## Struktur proyek

```text
lib/
  controllers/   State dan operasi keranjang
  models/        Product, CartItem, SaleTransaction
  screens/       Layar katalog, keranjang, pembayaran, dan struk
  services/      Pemuatan katalog lokal
  theme/         Tema aplikasi
  utils/         Format Rupiah
assets/data/     Data contoh produk
test/            Tes model dan widget
```

Pembacaan JSON berada di *service*, parsing di *model*, dan state keranjang di *controller*, sehingga logika terpisah dari widget.

## Memulai

Prasyarat: Flutter SDK terpasang dan memenuhi batas SDK pada `pubspec.yaml`.

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

Hasil terakhir: `flutter analyze` tanpa masalah dan `flutter test` lulus 13 tes.

## Status pengembangan dan roadmap

| Tahap                                | Status        |
| ------------------------------------ | ------------- |
| Model data                           | Selesai       |
| Katalog produk                       | Selesai       |
| Keranjang                            | Selesai       |
| Pembayaran (input nominal, validasi) | Selesai       |
| Penyelesaian transaksi dan struk     | Selesai       |
| Persistensi dan riwayat              | Belum dimulai |

Alur saat ini:

```text
Katalog JSON → pilih produk → keranjang → pembayaran → konfirmasi → struk
```

Alur target:

```text
Keranjang → input pembayaran → validasi → konfirmasi → (simpan) → struk
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

**Prioritas 2 — opsional**

- [ ] Penyimpanan lokal dan riwayat transaksi
- [ ] CRUD produk, pencarian/kategori, stok, gambar produk
- [ ] Ikon, nama aplikasi, dan konfigurasi build untuk platform distribusi

## Keterbatasan

- Data produk berupa contoh statis.
- Keranjang dan transaksi tidak disimpan setelah aplikasi ditutup.
- Belum ada bukti build dan uji pada setiap platform target; keberadaan folder platform tidak otomatis menjamin kompatibilitas.
- Belum ada pengujian pada perangkat nyata yang tercatat.

## Logbook

Catatan kegiatan pengembangan: [LOGBOOK_UTS.md](./LOGBOOK_UTS.md).
