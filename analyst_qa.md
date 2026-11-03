# Contoh analisis operasional

Seluruh catatan di contoh ini merupakan simulasi untuk demonstrasi. Ini bukan data perusahaan atau sertifikasi kemampuan.

## Definisi metrik

| Metrik | Definisi | Hasil awal |
|---|---|---|
| Backlog terbuka | Jumlah item dengan status open | 4 |
| Overdue | Item open dengan umur > batas SLA | 2 |
| Overdue rate | Overdue / backlog terbuka × 100% | 50% |
| Deviasi maksimum | MAX(umur - SLA) untuk item open | 15 hari |

Umur = hari sejak pekerjaan dibuka sampai tanggal acuan yang sama. Umur persis sama dengan SLA masih dalam SLA. Contoh tidak membedakan hari kerja dan kalender; implementasi nyata harus menyepakati kalender, periode, dan definisi selesai bersama pemilik proses.

## Process map dan kontrol

Input PO → validasi field dan ID unik → perhitungan deviasi → prioritas overdue → konfirmasi hambatan ke PIC → rencana tindakan dan tenggat → bukti penyelesaian → penutupan serta review SLA.

Rekomendasi operasional: DEMO-003 lebih dahulu diperiksa karena terlambat 15 hari; DEMO-001 berikutnya karena terlambat 9 hari. Tindakan eskalasi mengikuti hasil konfirmasi hambatan, bukan hanya urutan angka.

## Kebutuhan dan kriteria penerimaan

| ID | Kebutuhan | Kriteria penerimaan |
|---|---|---|
| REQ-01 | Pantau backlog | Hanya item open masuk penyebut backlog |
| REQ-02 | Temukan deviasi | Umur > SLA menjadi overdue |
| REQ-03 | Prioritaskan tindak lanjut | Deviasi terbesar muncul paling atas |
| REQ-04 | Cari pekerjaan | Filter PO/PIC dan status diterapkan bersamaan |
| REQ-05 | Ekspor hasil | CSV hanya berisi baris hasil filter, beserta header |

## Skenario pemeriksaan

| ID | Skenario | Hasil yang diharapkan |
|---|---|---|
| UAT-01 | Buka tanpa filter | 4 item; 2 overdue; 50% overdue |
| UAT-02 | Pilih overdue | DEMO-003 lalu DEMO-001 |
| UAT-03 | Pilih dalam SLA | DEMO-002 dan DEMO-004 |
| UAT-04 | Cari DEMO-001 | 1 item, deviasi 9 hari |
| UAT-05 | Cari teks yang tidak tersedia | Pesan tanpa hasil, 0 item, 0% overdue |
| UAT-06 | Cari PIC A dan pilih overdue | Hanya DEMO-001 |
| UAT-07 | Jalankan analyst_sample.sql | 4 backlog, 2 overdue, 50% |
| UAT-08 | Umur sama dengan SLA | Dalam SLA; diuji sebagai aturan batas |
| UAT-09 | Item closed terlambat | Dikecualikan dari backlog terbuka pada query SQL |
| UAT-10 | PO duplikat atau umur negatif | Ditolak constraint SQL |

Skenario disusun sebagai contoh artefak analisis dan validasi, bukan klaim sertifikasi UAT atau metodologi tertentu.

## Pemeriksaan yang dijalankan

Jalankan `python3 verify_analysis.py` dengan Python 3 standar. Hasil: 11 pemeriksaan lulus. Lihat `analysis-checks.json` untuk daftar lengkap. Skenario UI di atas adalah kriteria penerimaan; hasil pemeriksaan otomatis hanya mencakup logika SQL.

Untuk penyebut kosong, query menghasilkan NULL (persentase tidak berlaku). Tampilan demo menggunakan 0% untuk hasil filter kosong dan menjelaskan konvensi tersebut. SQL menolak PIC kosong, status di luar open/closed, umur pecahan atau negatif, SLA nol, dan ID duplikat.

CSV adalah data awal yang sama dengan SQL; umur dihitung dalam hari kalender dan seluruh pekerjaan awal berstatus open. Tidak ada informasi mitra atau data pribadi perusahaan.
