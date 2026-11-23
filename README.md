# MyPortfolio Mobile

Aplikasi mobile Flutter untuk portofolio pribadi **Razan Muhammad Fathin Lesmana** (NPM 2506603646, PBP B). Aplikasi ini adalah perluasan dari website portofolio Django ke ranah mobile, dan dikembangkan bertahap mengikuti Tutorial dan Individual Assignment PBP (Pemrograman Berbasis Platform) Semester Gasal 2026/2027.

## Cara Menjalankan (Setup)

1. Pastikan Flutter SDK sudah terpasang (`flutter doctor` tidak menampilkan error kritis).
2. Clone repositori ini, lalu masuk ke folder proyek:
   ```bash
   git clone <url-repo-ini>
   cd myportofolio_mobile
   ```
3. Unduh dependensi:
   ```bash
   flutter pub get
   ```
4. Jalankan aplikasi (emulator, perangkat, atau Chrome):
   ```bash
   flutter run
   ```
5. Cek kualitas kode:
   ```bash
   flutter analyze
   ```

## Struktur Proyek

```
lib/
├── main.dart   # Bootstrap aplikasi: MyApp (MaterialApp + tema)
├── screens/
│   ├── menu.dart            # Halaman utama dan daftar kartu aksi
│   ├── project_form.dart    # Formulir proyek
│   └── education_form.dart  # Formulir edukasi
└── widgets/
    ├── left_drawer.dart     # Menu navigasi bersama
    └── project_card.dart    # Kartu aksi halaman utama
```

## Progres Mingguan

| Minggu | Tugas | Yang dikerjakan |
|---|---|---|
| 8 | Tutorial 08 | Setup Flutter, pisah `menu.dart` dari `main.dart`, `MyHomePage` jadi `StatelessWidget`, `InfoCard` & `ItemCard` |
| 8 | Tugas 7 | Data profil sendiri di `InfoCard`, 3 tombol aksi dengan warna berbeda lewat atribut `color` di `ItemHomepage`, SnackBar per tombol, `flutter analyze` bersih |
| 9 | Tugas 8 | Form Tambah Edukasi, validasi isian, dialog ringkasan, dan navigasi melalui kartu maupun drawer |

---

## Pertanyaan Reflektif

### Tugas 7

1. **Widget tree dan hubungan parent-child.**
   Di Flutter, seluruh tampilan disusun dari widget yang saling bersarang membentuk struktur pohon (widget tree). Widget paling atas (root) di aplikasi ini adalah `MaterialApp`, yang punya anak `MyHomePage`, yang punya anak `Scaffold`, dan seterusnya sampai ke widget daun seperti `Text` dan `Icon`. Hubungan parent-child bekerja seperti ini:
   - **Parent menentukan batasan (constraints) ke anak**, misalnya `Padding` memberi ruang lebih sempit ke anaknya, `Row` menyusun anak-anaknya secara horizontal.
   - **Anak menentukan ukurannya sendiri di dalam batasan itu**, lalu parent menentukan posisi anak.
   - **Data mengalir dari atas ke bawah**, lewat parameter konstruktor (misalnya `InfoCard(title: 'NPM', content: npm)`) atau lewat lookup ke ancestor (misalnya `Theme.of(context)` mencari `Theme` di atasnya).
   - Parent bisa punya satu anak (`child`, contoh: `Padding`, `Center`) atau banyak anak (`children`, contoh: `Row`, `Column`, `GridView`).

2. **Widget yang digunakan dan fungsinya.**
   - `MaterialApp`: root aplikasi; menyediakan tema, navigasi, dan gaya Material Design.
   - `Scaffold`: kerangka halaman (tempat `AppBar`, `body`, dan tempat munculnya `SnackBar`).
   - `AppBar`: bar judul di atas halaman.
   - `Text`: menampilkan teks.
   - `Padding`: memberi jarak di sekeliling widget anak.
   - `Column`: menyusun anak secara vertikal.
   - `Row`: menyusun anak secara horizontal (dipakai untuk 3 `InfoCard`).
   - `SizedBox`: memberi jarak kosong dengan ukuran tetap.
   - `Center`: menaruh anak di tengah.
   - `GridView.count`: menampilkan tombol dalam kisi dengan jumlah kolom tetap (3 kolom).
   - `Card`: kotak dengan bayangan (elevation) untuk `InfoCard`.
   - `Container`: mengatur lebar dan padding isi `InfoCard` dan `ItemCard`.
   - `Material`: memberi warna latar dan sudut membulat pada `ItemCard`, sekaligus permukaan untuk efek ripple.
   - `InkWell`: membuat area bisa ditekan (`onTap`) dengan efek ripple.
   - `Icon`: menampilkan ikon di tiap tombol.
   - `SnackBar`: pesan singkat di bawah layar saat tombol ditekan.
   - `ScaffoldMessenger`: pengelola yang menampilkan/menyembunyikan `SnackBar`.
   - `MyHomePage`, `InfoCard`, `ItemCard`: widget buatan sendiri (custom `StatelessWidget`) yang menyusun widget-widget di atas.
   - Pendukung (bukan widget yang tampil): `ThemeData`/`ColorScheme` untuk tema, `MediaQuery` untuk membaca lebar layar, `Theme.of(context)` untuk mengambil warna tema.

3. **Fungsi `MaterialApp` dan alasan dipakai sebagai root.**
   `MaterialApp` membungkus aplikasi dengan semua hal yang dibutuhkan widget Material: tema global (`theme`), halaman awal (`home`), sistem navigasi (`Navigator`/routes), lokalisasi, arah teks, dan `ScaffoldMessenger`. Widget Material seperti `Scaffold`, `AppBar`, dan `SnackBar` mencari hal-hal itu di ancestor-nya lewat `BuildContext`. Karena itu `MaterialApp` ditaruh paling atas, supaya semua widget di bawahnya bisa menemukan tema dan navigasi yang sama. Tanpanya, widget Material bisa error atau tampil tanpa gaya.

4. **`StatelessWidget` vs `StatefulWidget`.**
   - `StatelessWidget` tidak punya state yang berubah. Tampilannya hanya bergantung pada data yang diberikan lewat konstruktor dan dibangun ulang hanya kalau parent-nya membangun ulang dengan data baru. Contoh di proyek ini: `MyHomePage`, `InfoCard`, `ItemCard`, karena NPM, nama, kelas, dan daftar tombol tidak berubah selama aplikasi berjalan.
   - `StatefulWidget` punya objek `State` terpisah yang menyimpan data yang bisa berubah. Saat data berubah, kita memanggil `setState()` dan Flutter membangun ulang widget itu.
   - **Pilih `StatelessWidget`** kalau tampilan hanya menampilkan data tetap atau data dari parent (lebih sederhana dan ringan).
   - **Pilih `StatefulWidget`** kalau widget itu sendiri harus mengingat dan mengubah data selama berjalan, misalnya counter, input form, checkbox, animasi, atau data hasil fetch dari server.

5. **`BuildContext`.**
   `BuildContext` adalah "alamat" sebuah widget di dalam widget tree. Setiap metode `build(BuildContext context)` menerima context miliknya, dan lewat context itu widget bisa mencari widget lain di atasnya (ancestor). Ini penting karena banyak fitur Flutter diambil dari ancestor, bukan dioper manual. Contoh penggunaan di proyek ini:
   - `Theme.of(context).colorScheme.primary` untuk mengambil warna tema dari `MaterialApp`.
   - `MediaQuery.of(context).size.width` untuk membaca lebar layar di `InfoCard`.
   - `ScaffoldMessenger.of(context).showSnackBar(...)` untuk menampilkan SnackBar di `ItemCard`.
   Karena pencarian berjalan ke atas dari posisi context, context yang dipakai harus berada di bawah widget yang dicari (misalnya harus di bawah `MaterialApp` supaya `ScaffoldMessenger` ketemu).

6. **Hot reload vs hot restart.**
   - **Hot reload** menyuntikkan kode yang diubah ke aplikasi yang sedang berjalan, lalu menjalankan ulang `build()`. State yang ada (misalnya nilai counter) tetap dipertahankan. Cocok untuk mengubah UI, warna, teks, atau layout.
   - **Hot restart** memuat ulang seluruh kode Dart dan menjalankan ulang aplikasi dari `main()`, sehingga semua state kembali ke awal. Lebih lambat dari hot reload tetapi lebih cepat dari build ulang penuh.
   - **Kapan hot reload tidak cukup (perlu hot restart):** mengubah isi `main()` atau `initState()`, mengubah nilai awal variabel global/static, mengubah widget dari `StatelessWidget` ke `StatefulWidget` (atau sebaliknya), mengubah enum atau tipe generic.
   - **Kapan perlu full restart (stop lalu `flutter run` lagi):** mengubah kode native (Android/iOS), menambah dependensi/plugin di `pubspec.yaml`, atau mengubah konfigurasi platform.

---

### Tugas 8

1. **Navigasi halaman**

   - `push()` membuka halaman baru di atas halaman sekarang. Kartu **Tambah Edukasi** pakai cara ini supaya Home tetap ada di bawah form.
   - `pop()` menutup tampilan paling atas. Saat kita tekan **Back** dari form tadi, kita kembali ke Home.
   - `pushReplacement()` mengganti halaman yang sedang dibuka. Opsi **Add Education** di drawer pakai cara ini untuk membuka form.
   - Saat kita pilih **Home** di drawer, `pop()` menutup drawer dulu. Setelah itu, `pushReplacement()` mengganti form dengan `MyHomePage`.

2. **Struktur dan warna halaman**

   - `Scaffold` mengatur letak judul, isi halaman, dan menu samping.
   - `AppBar` menampilkan judul di bagian atas tiap halaman.
   - Home dan kedua form pakai `LeftDrawer` yang sama, jadi pilihan menunya konsisten.
   - Kartu **Tambah Edukasi** di Home dan `AppBar` di form edukasi sama-sama pakai `Colors.indigo`.

3. **Layout form di layar kecil**

   - Input disusun satu kolom supaya label dan isian mudah dibaca di ponsel.
   - Kalau kita pilih **Perguruan Tinggi**, kolom program studi muncul di bawah jenjang.
   - `SizedBox(height: 16)` memberi jarak antarkolom. Padding memberi jarak dari tepi layar.
   - `ListView` membuat form bisa digulir sampai tombol **Simpan**, termasuk saat keyboard terbuka.

4. **Validasi saat menekan Simpan**

   1. Tombol **Simpan** mengakses form lewat `GlobalKey<FormState>`, lalu memanggil `validate()`.
   2. Tiap `validator` mengecek isi kolomnya. Misalnya, nama institusi yang cuma berisi spasi jadi kosong setelah `trim()`, jadi muncul pesan di kolom itu.
   3. Tahun masuk boleh kosong. Kalau diisi, tahunnya harus empat digit dan diawali angka 1 sampai 9. Keyboard angka masih bisa dipakai untuk mengetik `25`, jadi formatnya tetap perlu dicek.
   4. Kalau semua isian valid, `save()` mengambil nilainya lewat `onSaved`. Lalu `showDialog()` menampilkan ringkasan di `AlertDialog`.
   5. Tombol **OK** menutup dialog dan kita kembali ke form.

---

## AI Disclosure

**Tools:** Claude (Anthropic).

**Strategi prompting:** Saya mengunggah file PDF soal Tugas 8 dan zip proyek hasil Tutorial 09, lalu meminta Claude menjelaskan isi tugas dan menunjukkan perubahan apa saja yang perlu dilakukan per file dan per tahap, dengan penjelasan konsepnya dulu sebelum kode.

**Bagian yang dibantu AI:**
- Membaca checklist Tugas 8 dan menentukan bagian yang perlu ditambahkan ke proyek hasil Tutorial 09.
- Membantu membuat form edukasi di `lib/screens/education_form.dart` berdasarkan field yang saya pilih, termasuk validasi input dan dialog ringkasan saat tombol Simpan ditekan.
- Membantu menghubungkan form ke kartu Tambah Edukasi di Home dan opsi Add Education di drawer, lalu menguji kedua jalur navigasi dengan widget test.
- Menyusun draf jawaban untuk empat pertanyaan reflektif di README sesuai implementasi aplikasi yang kemudian saya pelajari dan koreksi/sesuaikan.

**Keterbatasan AI dan perbaikan manual:**
- AI tidak bisa menjalankan `flutter analyze` maupun aplikasi di lingkungannya, jadi saya menjalankan dan memverifikasi sendiri di laptop.

**Log chat AI:** 
https://claude.ai/chat/7ce375eb-ddef-4996-8309-c07ec88a4af3