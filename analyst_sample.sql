-- Demonstrasi SQL dasar SQLite. Seluruh data simulasi, bukan data perusahaan.
-- Mulai pada database kosong. Tidak menghapus tabel pengguna yang sudah ada.
CREATE TABLE work_items(
 po_id TEXT PRIMARY KEY NOT NULL CHECK(trim(po_id)<>''),
 pic TEXT NOT NULL CHECK(trim(pic)<>''),
 age_days INTEGER NOT NULL CHECK(typeof(age_days)='integer' AND age_days>=0),
 sla_days INTEGER NOT NULL CHECK(typeof(sla_days)='integer' AND sla_days>0),
 status TEXT NOT NULL CHECK(status IN ('open','closed'))
);
INSERT INTO work_items VALUES
('DEMO-001','PIC A',23,14,'open'),
('DEMO-002','PIC B',10,14,'open'),
('DEMO-003','PIC C',36,21,'open'),
('DEMO-004','PIC A',7,14,'open');
-- Baseline 4 backlog, 2 overdue, 50%. Penyebut kosong menghasilkan NULL (tidak berlaku).
CREATE VIEW sla_summary AS
SELECT COUNT(*) AS open_backlog,
COALESCE(SUM(CASE WHEN age_days>sla_days THEN 1 ELSE 0 END),0) AS overdue_count,
ROUND(100.0*COALESCE(SUM(CASE WHEN age_days>sla_days THEN 1 ELSE 0 END),0)/NULLIF(COUNT(*),0),1) AS overdue_pct
FROM work_items WHERE status='open';
SELECT * FROM sla_summary;
CREATE VIEW overdue_priority AS
SELECT po_id,pic,age_days,sla_days,age_days-sla_days AS overdue_days
FROM work_items WHERE status='open' AND age_days>sla_days
ORDER BY overdue_days DESC,po_id;
SELECT * FROM overdue_priority;
-- Field wajib, ID unik, status, dan nilai numerik dijaga constraint.
