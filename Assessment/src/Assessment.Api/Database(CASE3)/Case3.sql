-- ============================================================
-- SOFTWARE ENGINEER CODING ASSESSMENT
-- CASE 3
-- DATABASE, INTEGRITY, AND ADVANCED REASONING
--
-- Database : SQLite
-- Candidate Token : RAFIF
--
-- ============================================================


PRAGMA foreign_keys = ON;


-- ============================================================
-- TASK 1
-- SCHEMA DAN CONSTRAINTS
-- ============================================================

CREATE TABLE IF NOT EXISTS Planning
(
    PlanningId INTEGER PRIMARY KEY AUTOINCREMENT,

    RequestCode TEXT NOT NULL UNIQUE,

    CandidateToken TEXT NOT NULL,

    CreatedAt TEXT NOT NULL,

    Status TEXT NOT NULL
);


CREATE TABLE IF NOT EXISTS PlanningSlot
(
    PlanningId INTEGER NOT NULL,

    SlotOrder INTEGER NOT NULL,

    SlotName TEXT NOT NULL,

    OriginalQuantity INTEGER NOT NULL,

    BalancedQuantity INTEGER NOT NULL,

    IsActive INTEGER NOT NULL,

    PRIMARY KEY (PlanningId, SlotOrder),

    FOREIGN KEY (PlanningId)
        REFERENCES Planning(PlanningId)
        ON DELETE CASCADE,

    CHECK (OriginalQuantity >= 0),

    CHECK (BalancedQuantity >= 0),

    CHECK (IsActive IN (0, 1))
);


-- ============================================================
-- TASK 2
-- SEED DATA
-- ============================================================

-- ============================================================
-- DATA 1
-- Kasus normal sesuai contoh soal
-- Total = 27
-- Hasil = 4,5,4,5,5,4,0
-- ============================================================

INSERT INTO Planning
(
    RequestCode,
    CandidateToken,
    CreatedAt,
    Status
)
VALUES
(
    'SEED-001',
    'RAFIF',
    '2026-08-01T08:00:00',
    'PROCESSED'
);

INSERT INTO PlanningSlot
VALUES
((SELECT PlanningId FROM Planning WHERE RequestCode = 'SEED-001'),
 1, 'Senin', 4, 4, 1);

INSERT INTO PlanningSlot
VALUES
((SELECT PlanningId FROM Planning WHERE RequestCode = 'SEED-001'),
 2, 'Selasa', 5, 5, 1);

INSERT INTO PlanningSlot
VALUES
((SELECT PlanningId FROM Planning WHERE RequestCode = 'SEED-001'),
 3, 'Rabu', 1, 4, 1);

INSERT INTO PlanningSlot
VALUES
((SELECT PlanningId FROM Planning WHERE RequestCode = 'SEED-001'),
 4, 'Kamis', 7, 5, 1);

INSERT INTO PlanningSlot
VALUES
((SELECT PlanningId FROM Planning WHERE RequestCode = 'SEED-001'),
 5, 'Jumat', 6, 5, 1);

INSERT INTO PlanningSlot
VALUES
((SELECT PlanningId FROM Planning WHERE RequestCode = 'SEED-001'),
 6, 'Sabtu', 4, 4, 1);

INSERT INTO PlanningSlot
VALUES
((SELECT PlanningId FROM Planning WHERE RequestCode = 'SEED-001'),
 7, 'Minggu', 0, 0, 0);


-- ============================================================
-- DATA 2
-- Total habis dibagi
-- ============================================================

INSERT INTO Planning
(
    RequestCode,
    CandidateToken,
    CreatedAt,
    Status
)
VALUES
(
    'SEED-002',
    'RAFIF',
    '2026-08-02T08:00:00',
    'PROCESSED'
);

INSERT INTO PlanningSlot
VALUES
((SELECT PlanningId FROM Planning WHERE RequestCode = 'SEED-002'),
 1, 'Senin', 2, 2, 1),
((SELECT PlanningId FROM Planning WHERE RequestCode = 'SEED-002'),
 2, 'Selasa', 2, 2, 1),
((SELECT PlanningId FROM Planning WHERE RequestCode = 'SEED-002'),
 3, 'Rabu', 2, 2, 1),
((SELECT PlanningId FROM Planning WHERE RequestCode = 'SEED-002'),
 4, 'Kamis', 2, 2, 1),
((SELECT PlanningId FROM Planning WHERE RequestCode = 'SEED-002'),
 5, 'Jumat', 2, 2, 1),
((SELECT PlanningId FROM Planning WHERE RequestCode = 'SEED-002'),
 6, 'Sabtu', 2, 2, 1),
((SELECT PlanningId FROM Planning WHERE RequestCode = 'SEED-002'),
 7, 'Minggu', 0, 0, 0);


-- ============================================================
-- DATA 3
-- Semua slot 0
-- ============================================================

INSERT INTO Planning
(
    RequestCode,
    CandidateToken,
    CreatedAt,
    Status
)
VALUES
(
    'SEED-003',
    'RAFIF',
    '2026-08-03T08:00:00',
    'PROCESSED'
);

INSERT INTO PlanningSlot
VALUES
((SELECT PlanningId FROM Planning WHERE RequestCode = 'SEED-003'),
 1, 'Senin', 0, 0, 0),
((SELECT PlanningId FROM Planning WHERE RequestCode = 'SEED-003'),
 2, 'Selasa', 0, 0, 0),
((SELECT PlanningId FROM Planning WHERE RequestCode = 'SEED-003'),
 3, 'Rabu', 0, 0, 0),
((SELECT PlanningId FROM Planning WHERE RequestCode = 'SEED-003'),
 4, 'Kamis', 0, 0, 0),
((SELECT PlanningId FROM Planning WHERE RequestCode = 'SEED-003'),
 5, 'Jumat', 0, 0, 0),
((SELECT PlanningId FROM Planning WHERE RequestCode = 'SEED-003'),
 6, 'Sabtu', 0, 0, 0),
((SELECT PlanningId FROM Planning WHERE RequestCode = 'SEED-003'),
 7, 'Minggu', 0, 0, 0);


-- ============================================================
-- DATA 4
-- Hanya satu slot aktif
-- ============================================================

INSERT INTO Planning
(
    RequestCode,
    CandidateToken,
    CreatedAt,
    Status
)
VALUES
(
    'SEED-004',
    'RAFIF',
    '2026-08-04T08:00:00',
    'PROCESSED'
);

INSERT INTO PlanningSlot
VALUES
((SELECT PlanningId FROM Planning WHERE RequestCode = 'SEED-004'),
 1, 'Senin', 15, 15, 1),
((SELECT PlanningId FROM Planning WHERE RequestCode = 'SEED-004'),
 2, 'Selasa', 0, 0, 0),
((SELECT PlanningId FROM Planning WHERE RequestCode = 'SEED-004'),
 3, 'Rabu', 0, 0, 0),
((SELECT PlanningId FROM Planning WHERE RequestCode = 'SEED-004'),
 4, 'Kamis', 0, 0, 0),
((SELECT PlanningId FROM Planning WHERE RequestCode = 'SEED-004'),
 5, 'Jumat', 0, 0, 0),
((SELECT PlanningId FROM Planning WHERE RequestCode = 'SEED-004'),
 6, 'Sabtu', 0, 0, 0),
((SELECT PlanningId FROM Planning WHERE RequestCode = 'SEED-004'),
 7, 'Minggu', 0, 0, 0);


-- ============================================================
-- DATA 5
-- Kasus tie
-- ============================================================

INSERT INTO Planning
(
    RequestCode,
    CandidateToken,
    CreatedAt,
    Status
)
VALUES
(
    'SEED-005',
    'RAFIF',
    '2026-08-05T08:00:00',
    'PROCESSED'
);

INSERT INTO PlanningSlot
VALUES
((SELECT PlanningId FROM Planning WHERE RequestCode = 'SEED-005'),
 1, 'Senin', 5, 5, 1),
((SELECT PlanningId FROM Planning WHERE RequestCode = 'SEED-005'),
 2, 'Selasa', 5, 5, 1),
((SELECT PlanningId FROM Planning WHERE RequestCode = 'SEED-005'),
 3, 'Rabu', 5, 5, 1),
((SELECT PlanningId FROM Planning WHERE RequestCode = 'SEED-005'),
 4, 'Kamis', 0, 0, 0),
((SELECT PlanningId FROM Planning WHERE RequestCode = 'SEED-005'),
 5, 'Jumat', 0, 0, 0),
((SELECT PlanningId FROM Planning WHERE RequestCode = 'SEED-005'),
 6, 'Sabtu', 0, 0, 0),
((SELECT PlanningId FROM Planning WHERE RequestCode = 'SEED-005'),
 7, 'Minggu', 0, 0, 0);


-- ============================================================
-- DATA 6
-- Total bersisa
-- Total = 16
-- Slot aktif = 3
-- Hasil = 6,5,5
-- Tambahan diberikan kepada rencana awal terbesar
-- ============================================================

INSERT INTO Planning
(
    RequestCode,
    CandidateToken,
    CreatedAt,
    Status
)
VALUES
(
    'SEED-006',
    'RAFIF',
    '2026-08-06T08:00:00',
    'PROCESSED'
);

INSERT INTO PlanningSlot
VALUES
((SELECT PlanningId FROM Planning WHERE RequestCode = 'SEED-006'),
 1, 'Senin', 8, 6, 1),
((SELECT PlanningId FROM Planning WHERE RequestCode = 'SEED-006'),
 2, 'Selasa', 4, 5, 1),
((SELECT PlanningId FROM Planning WHERE RequestCode = 'SEED-006'),
 3, 'Rabu', 4, 5, 1),
((SELECT PlanningId FROM Planning WHERE RequestCode = 'SEED-006'),
 4, 'Kamis', 0, 0, 0),
((SELECT PlanningId FROM Planning WHERE RequestCode = 'SEED-006'),
 5, 'Jumat', 0, 0, 0),
((SELECT PlanningId FROM Planning WHERE RequestCode = 'SEED-006'),
 6, 'Sabtu', 0, 0, 0),
((SELECT PlanningId FROM Planning WHERE RequestCode = 'SEED-006'),
 7, 'Minggu', 0, 0, 0);


-- ============================================================
-- DATA 7
-- Nilai besar
-- ============================================================

INSERT INTO Planning
(
    RequestCode,
    CandidateToken,
    CreatedAt,
    Status
)
VALUES
(
    'SEED-007',
    'RAFIF',
    '2026-08-07T08:00:00',
    'PROCESSED'
);

INSERT INTO PlanningSlot
VALUES
((SELECT PlanningId FROM Planning WHERE RequestCode = 'SEED-007'),
 1, 'Senin', 1000000, 800000, 1),
((SELECT PlanningId FROM Planning WHERE RequestCode = 'SEED-007'),
 2, 'Selasa', 900000, 800000, 1),
((SELECT PlanningId FROM Planning WHERE RequestCode = 'SEED-007'),
 3, 'Rabu', 800000, 800000, 1),
((SELECT PlanningId FROM Planning WHERE RequestCode = 'SEED-007'),
 4, 'Kamis', 700000, 800000, 1),
((SELECT PlanningId FROM Planning WHERE RequestCode = 'SEED-007'),
 5, 'Jumat', 600000, 800000, 1),
((SELECT PlanningId FROM Planning WHERE RequestCode = 'SEED-007'),
 6, 'Sabtu', 0, 0, 0),
((SELECT PlanningId FROM Planning WHERE RequestCode = 'SEED-007'),
 7, 'Minggu', 0, 0, 0);


-- ============================================================
-- DATA 8
-- Tie dengan total bersisa
-- Total = 10
-- Slot aktif = 3
-- Hasil = 4,3,3
-- ============================================================

INSERT INTO Planning
(
    RequestCode,
    CandidateToken,
    CreatedAt,
    Status
)
VALUES
(
    'SEED-008',
    'RAFIF',
    '2026-08-08T08:00:00',
    'PROCESSED'
);

INSERT INTO PlanningSlot
VALUES
((SELECT PlanningId FROM Planning WHERE RequestCode = 'SEED-008'),
 1, 'Senin', 4, 4, 1),
((SELECT PlanningId FROM Planning WHERE RequestCode = 'SEED-008'),
 2, 'Selasa', 3, 3, 1),
((SELECT PlanningId FROM Planning WHERE RequestCode = 'SEED-008'),
 3, 'Rabu', 3, 3, 1),
((SELECT PlanningId FROM Planning WHERE RequestCode = 'SEED-008'),
 4, 'Kamis', 0, 0, 0),
((SELECT PlanningId FROM Planning WHERE RequestCode = 'SEED-008'),
 5, 'Jumat', 0, 0, 0),
((SELECT PlanningId FROM Planning WHERE RequestCode = 'SEED-008'),
 6, 'Sabtu', 0, 0, 0),
((SELECT PlanningId FROM Planning WHERE RequestCode = 'SEED-008'),
 7, 'Minggu', 0, 0, 0);


-- ============================================================
-- DATA 9
-- Beberapa slot aktif
-- ============================================================

INSERT INTO Planning
(
    RequestCode,
    CandidateToken,
    CreatedAt,
    Status
)
VALUES
(
    'SEED-009',
    'RAFIF',
    '2026-08-09T08:00:00',
    'PROCESSED'
);

INSERT INTO PlanningSlot
VALUES
((SELECT PlanningId FROM Planning WHERE RequestCode = 'SEED-009'),
 1, 'Senin', 3, 3, 1),
((SELECT PlanningId FROM Planning WHERE RequestCode = 'SEED-009'),
 2, 'Selasa', 3, 3, 1),
((SELECT PlanningId FROM Planning WHERE RequestCode = 'SEED-009'),
 3, 'Rabu', 3, 3, 1),
((SELECT PlanningId FROM Planning WHERE RequestCode = 'SEED-009'),
 4, 'Kamis', 3, 3, 1),
((SELECT PlanningId FROM Planning WHERE RequestCode = 'SEED-009'),
 5, 'Jumat', 0, 0, 0),
((SELECT PlanningId FROM Planning WHERE RequestCode = 'SEED-009'),
 6, 'Sabtu', 0, 0, 0),
((SELECT PlanningId FROM Planning WHERE RequestCode = 'SEED-009'),
 7, 'Minggu', 0, 0, 0);


-- ============================================================
-- DATA 10
-- Total bersisa
-- Total = 14
-- Slot aktif = 3
-- Hasil = 5,5,4
-- ============================================================

INSERT INTO Planning
(
    RequestCode,
    CandidateToken,
    CreatedAt,
    Status
)
VALUES
(
    'SEED-010',
    'RAFIF',
    '2026-08-10T08:00:00',
    'PROCESSED'
);

INSERT INTO PlanningSlot
VALUES
((SELECT PlanningId FROM Planning WHERE RequestCode = 'SEED-010'),
 1, 'Senin', 6, 5, 1),
((SELECT PlanningId FROM Planning WHERE RequestCode = 'SEED-010'),
 2, 'Selasa', 5, 5, 1),
((SELECT PlanningId FROM Planning WHERE RequestCode = 'SEED-010'),
 3, 'Rabu', 3, 4, 1),
((SELECT PlanningId FROM Planning WHERE RequestCode = 'SEED-010'),
 4, 'Kamis', 0, 0, 0),
((SELECT PlanningId FROM Planning WHERE RequestCode = 'SEED-010'),
 5, 'Jumat', 0, 0, 0),
((SELECT PlanningId FROM Planning WHERE RequestCode = 'SEED-010'),
 6, 'Sabtu', 0, 0, 0),
((SELECT PlanningId FROM Planning WHERE RequestCode = 'SEED-010'),
 7, 'Minggu', 0, 0, 0);


-- ============================================================
-- TASK 3
-- VALIDASI TOTAL
-- ============================================================

SELECT
    p.PlanningId,

    COALESCE(SUM(s.OriginalQuantity), 0)
        AS OriginalTotal,

    COALESCE(SUM(s.BalancedQuantity), 0)
        AS BalancedTotal,

    CASE
        WHEN COALESCE(SUM(s.OriginalQuantity), 0)
           =
             COALESCE(SUM(s.BalancedQuantity), 0)
        THEN 1
        ELSE 0
    END AS IsTotalValid

FROM Planning p

LEFT JOIN PlanningSlot s
    ON s.PlanningId = p.PlanningId

GROUP BY p.PlanningId

ORDER BY p.PlanningId;


-- ============================================================
-- TASK 4
-- HISTORY
-- ============================================================

SELECT
    p.RequestCode,

    p.CreatedAt,

    COUNT(
        CASE
            WHEN s.IsActive = 1 THEN 1
        END
    ) AS ActiveSlotCount,

    COALESCE(SUM(s.OriginalQuantity), 0)
        AS OriginalTotal,

    COALESCE(SUM(s.BalancedQuantity), 0)
        AS BalancedTotal,

    p.Status

FROM Planning p

LEFT JOIN PlanningSlot s
    ON s.PlanningId = p.PlanningId

GROUP BY
    p.PlanningId,
    p.RequestCode,
    p.CreatedAt,
    p.Status

ORDER BY p.CreatedAt DESC;


-- ============================================================
-- TASK 5
-- ANOMALY
--
-- Mencari:
-- 1. Slot nonaktif dengan BalancedQuantity > 0
-- 2. Total tidak sama
-- 3. Detail slot tidak lengkap
-- 4. RequestCode duplikat
-- ============================================================

WITH PlanningSummary AS
(
    SELECT
        p.PlanningId,

        p.RequestCode,

        COUNT(s.SlotOrder) AS SlotCount,

        SUM(
            CASE
                WHEN s.IsActive = 0
                     AND s.BalancedQuantity > 0
                THEN 1
                ELSE 0
            END
        ) AS InvalidInactiveSlots,

        COALESCE(SUM(s.OriginalQuantity), 0)
            AS OriginalTotal,

        COALESCE(SUM(s.BalancedQuantity), 0)
            AS BalancedTotal

    FROM Planning p

    LEFT JOIN PlanningSlot s
        ON s.PlanningId = p.PlanningId

    GROUP BY
        p.PlanningId,
        p.RequestCode
),

DuplicateRequestCodes AS
(
    SELECT
        RequestCode

    FROM Planning

    GROUP BY RequestCode

    HAVING COUNT(*) > 1
)

SELECT
    ps.PlanningId,

    ps.RequestCode,

    CASE

        WHEN ps.InvalidInactiveSlots > 0
        THEN 'SLOT_NONAKTIF_MEMILIKI_BALANCED_QUANTITY'

        WHEN ps.OriginalTotal <> ps.BalancedTotal
        THEN 'TOTAL_TIDAK_SAMA'

        WHEN ps.SlotCount <> 7
        THEN 'DETAIL_SLOT_TIDAK_LENGKAP'

        WHEN dr.RequestCode IS NOT NULL
        THEN 'REQUEST_CODE_DUPLIKAT'

        ELSE 'TIDAK_ADA_ANOMALI'

    END AS AnomalyType

FROM PlanningSummary ps

LEFT JOIN DuplicateRequestCodes dr
    ON dr.RequestCode = ps.RequestCode

WHERE
       ps.InvalidInactiveSlots > 0
    OR ps.OriginalTotal <> ps.BalancedTotal
    OR ps.SlotCount <> 7
    OR dr.RequestCode IS NOT NULL;


-- ============================================================
-- TASK 6
-- 3 PERUBAHAN TERBESAR
-- ============================================================

SELECT
    p.RequestCode,

    s.SlotOrder,

    s.SlotName,

    s.OriginalQuantity,

    s.BalancedQuantity,

    ABS(
        s.BalancedQuantity
        - s.OriginalQuantity
    ) AS AbsoluteAdjustment

FROM PlanningSlot s

INNER JOIN Planning p
    ON p.PlanningId = s.PlanningId

ORDER BY
    AbsoluteAdjustment DESC,
    s.SlotOrder ASC

LIMIT 3;


-- ============================================================
-- TASK 7
-- ATOMIC SAVE
-- ============================================================

-- Prinsip atomic save:
--
-- 1. Insert Planning
-- 2. Insert seluruh PlanningSlot
-- 3. Jika semuanya berhasil -> COMMIT
-- 4. Jika satu saja gagal -> ROLLBACK
--
-- Dengan demikian tidak ada data Planning tanpa detail
-- atau detail yang tersimpan sebagian.

BEGIN TRANSACTION;

INSERT INTO Planning
(
    RequestCode,
    CandidateToken,
    CreatedAt,
    Status
)
VALUES
(
    'ATOMIC-TEST',
    'RAFIF',
    '2026-08-12T10:00:00',
    'PROCESSED'
);

INSERT INTO PlanningSlot
(
    PlanningId,
    SlotOrder,
    SlotName,
    OriginalQuantity,
    BalancedQuantity,
    IsActive
)
VALUES
(
    last_insert_rowid(),
    1,
    'Senin',
    4,
    4,
    1
);

-- Jika seluruh insert berhasil:
-- COMMIT;

-- Jika salah satu proses gagal:
-- ROLLBACK;

ROLLBACK;


-- ============================================================
-- TASK 8
-- LATEST PROCESSING VERSION
-- ============================================================

CREATE TABLE IF NOT EXISTS RebalanceRun
(
    RebalanceRunId INTEGER PRIMARY KEY AUTOINCREMENT,

    PlanningId INTEGER NOT NULL,

    Version INTEGER NOT NULL,

    ProcessedAt TEXT NOT NULL,

    FOREIGN KEY (PlanningId)
        REFERENCES Planning(PlanningId)
        ON DELETE CASCADE,

    UNIQUE (PlanningId, Version)
);


-- Contoh dua kali proses pada planning yang sama.

INSERT INTO RebalanceRun
(
    PlanningId,
    Version,
    ProcessedAt
)
SELECT
    PlanningId,
    1,
    '2026-08-12T09:00:00'
FROM Planning
WHERE RequestCode = 'SEED-001';


INSERT INTO RebalanceRun
(
    PlanningId,
    Version,
    ProcessedAt
)
SELECT
    PlanningId,
    2,
    '2026-08-12T10:00:00'
FROM Planning
WHERE RequestCode = 'SEED-001';


-- Menampilkan hanya versi terbaru
-- dari setiap Planning.

WITH LatestRun AS
(
    SELECT
        r.*,

        ROW_NUMBER() OVER
        (
            PARTITION BY r.PlanningId

            ORDER BY
                r.Version DESC,
                r.ProcessedAt DESC

        ) AS RowNumber

    FROM RebalanceRun r
)

SELECT
    RebalanceRunId,

    PlanningId,

    Version,

    ProcessedAt

FROM LatestRun

WHERE RowNumber = 1

ORDER BY PlanningId;


-- ============================================================
-- TASK 9
-- INDEX
-- ============================================================

-- RequestCode sudah memiliki UNIQUE constraint.
-- SQLite otomatis membuat unique index sehingga
-- tidak perlu membuat index RequestCode kedua.

CREATE INDEX IF NOT EXISTS IX_Planning_CreatedAt
ON Planning(CreatedAt);


CREATE INDEX IF NOT EXISTS IX_Planning_Status
ON Planning(Status);


-- Penjelasan:
--
-- IX_Planning_CreatedAt:
-- Mempercepat pencarian dan pengurutan berdasarkan waktu.
--
-- IX_Planning_Status:
-- Mempercepat pencarian berdasarkan status proses.
--
-- RequestCode:
-- Sudah memiliki unique index dari UNIQUE constraint.
--
-- Kekurangan index:
-- Setiap INSERT/UPDATE harus ikut memperbarui index.
-- Index juga menggunakan ruang penyimpanan tambahan.


-- ============================================================
-- TASK 10
-- SAFE MIGRATION
-- ============================================================

-- Model lama:
--
-- Planning
-- ----------------------------------
-- PlanningId
-- RequestCode
-- MondayQuantity
-- TuesdayQuantity
-- WednesdayQuantity
-- ThursdayQuantity
-- FridayQuantity
-- SaturdayQuantity
-- SundayQuantity
--
--
-- Model baru:
--
-- Planning
-- ----------------------------------
-- PlanningId
-- RequestCode
-- CandidateToken
-- CreatedAt
-- Status
--
-- PlanningSlot
-- ----------------------------------
-- PlanningId
-- SlotOrder
-- SlotName
-- OriginalQuantity
-- BalancedQuantity
-- IsActive
--
--
-- Langkah migrasi:
--
-- 1. Backup database lama.
--
-- 2. Membuat tabel PlanningSlot.
--
-- 3. Memastikan setiap Planning memiliki
--    RequestCode yang valid dan unik.
--
-- 4. Memeriksa agar tidak ada quantity negatif.
--
-- 5. Memindahkan setiap kolom hari menjadi satu row.
--
-- Mapping:
--
-- Monday    -> SlotOrder 1
-- Tuesday   -> SlotOrder 2
-- Wednesday -> SlotOrder 3
-- Thursday  -> SlotOrder 4
-- Friday    -> SlotOrder 5
-- Saturday  -> SlotOrder 6
-- Sunday    -> SlotOrder 7
--
-- 6. OriginalQuantity diambil dari nilai
--    quantity pada model lama.
--
-- 7. BalancedQuantity diambil dari hasil
--    balancing yang sudah tersimpan.
--
-- 8. IsActive ditentukan berdasarkan aturan
--    bisnis atau field aktif pada model lama.
--
-- 9. Setelah migrasi, lakukan validasi:
--
--    a. Setiap Planning memiliki 7 slot.
--
--    b. Tidak ada quantity negatif.
--
--    c. Semua PlanningSlot memiliki PlanningId
--       yang valid.
--
--    d. RequestCode tetap unik.
--
--    e. Total OriginalQuantity sebelum dan
--       sesudah migrasi harus sama.
--
-- 10. Jika seluruh validasi berhasil,
--     barulah kolom lama dapat dihapus.
--
-- 11. Jika validasi gagal, migrasi dihentikan
--     dan database dikembalikan dari backup.
--
-- Pendekatan ini mencegah kehilangan data
-- ketika mengubah model satu kolom per hari
-- menjadi model detail per baris.