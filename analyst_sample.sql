-- Contoh pendukung portofolio / seluruh data adalah simulasi.
-- SQLite; contoh query dasar, bukan klaim pengalaman produksi SQL.
CREATE TABLE work_items(po_id TEXT PRIMARY KEY, pic TEXT NOT NULL, age_days INTEGER NOT NULL CHECK(age_days>=0), sla_days INTEGER NOT NULL CHECK(sla_days>0), status TEXT NOT NULL);
INSERT INTO work_items VALUES
('DEMO-001','PIC A',23,14,'open'),
('DEMO-002','PIC B',10,14,'open'),
('DEMO-003','PIC C',36,21,'open'),
('DEMO-004','PIC A',7,14,'open');
-- Ringkasan backlog terbuka dan breach SLA: 4 item, 2 overdue, 50%.
SELECT COUNT(*) AS open_backlog,
SUM(CASE WHEN age_days > sla_days THEN 1 ELSE 0 END) AS overdue_count,
ROUND(100.0 * SUM(CASE WHEN age_days > sla_days THEN 1 ELSE 0 END)/NULLIF(COUNT(*),0),1) AS overdue_pct
FROM work_items WHERE status='open';
-- Prioritas: hanya pekerjaan terbuka; urutkan deviasi SLA terbesar.
SELECT po_id,pic,age_days,sla_days,age_days-sla_days AS overdue_days
FROM work_items WHERE status='open' AND age_days>sla_days
ORDER BY overdue_days DESC,po_id;
-- Validasi data sebelum pelaporan: hasil harus kosong.
SELECT po_id FROM work_items
WHERE pic IS NULL OR trim(pic)='' OR age_days<0 OR sla_days<=0;
