"""Pemeriksaan contoh kerja simulasi; jalankan python3 verify_analysis.py."""
from pathlib import Path
import sqlite3,json
r=Path(__file__).resolve().parent;c=sqlite3.connect(':memory:');c.executescript((r/'analyst_sample.sql').read_text());passed=[]
def check(name,actual,expected):
 assert actual==expected,(name,actual,expected)
 passed.append(name)
def summary():return c.execute('SELECT * FROM sla_summary').fetchone()
check('baseline',summary(),(4,2,50.0))
check('prioritas',c.execute('SELECT po_id FROM overdue_priority').fetchall(),[('DEMO-003',),('DEMO-001',)])
c.execute("INSERT INTO work_items VALUES('BOUNDARY','PIC D',14,14,'open')")
check('tepat batas SLA',summary(),(5,2,40.0))
c.execute("INSERT INTO work_items VALUES('CLOSED','PIC E',90,14,'closed')")
check('closed tidak masuk backlog',summary(),(5,2,40.0))
for name,row in [('ID duplikat',('DEMO-001','PIC A',1,14,'open')),('PIC kosong',('BAD1',' ',1,14,'open')),('umur negatif',('BAD2','PIC A',-1,14,'open')),('SLA nol',('BAD3','PIC A',1,0,'open')),('status tidak valid',('BAD4','PIC A',1,14,'other')),('umur pecahan',('BAD5','PIC A',1.5,14,'open'))]:
 try:c.execute('INSERT INTO work_items VALUES(?,?,?,?,?)',row)
 except sqlite3.IntegrityError:passed.append(name)
 else:raise AssertionError(name+' tidak ditolak')
c.execute('DELETE FROM work_items')
check('backlog kosong',summary(),(0,0,None))
print(json.dumps({'checks_passed':len(passed),'checks':passed,'scope':'SQLite simulated analysis only'},ensure_ascii=False,indent=2))
