CREATE DATABASE BTSQL;
USE [BTSQL];
--1
CREATE TABLE Khoa
(
	MaKhoa CHAR(8),
	TenKhoa CHAR(20) NOT NULL,
	NgayThanhLap DATE,
	NoiDungDaoTao CHAR(200),
	GhiChu VARCHAR(MAX),
	PRIMARY KEY (MaKhoa)
);

CREATE TABLE Lop
(
	Malop CHAR(8),
	TenLop char(20) NOT NULL,
	KhoaHoc char(4),
	GVCN char(50),
	MaKhoa char(8),
	GhiChu VARCHAR(MAX),
	PRIMARY KEY (MaLop),
	FOREIGN KEY (MaKhoa) REFERENCES Khoa(MaKhoa)
);

CREATE TABLE SinhVien
(
	MaSV char(10),
	HoSV char(50) NOT NULL,
	TenSV char(20) NOT NULL,
	GioiTinh char(4),
	NgaySinh DATE,
	QueQuan char(50),
	DiaChi char(100),
	MaLop char(8),
	GhiChu VARCHAR(MAX),
	PRIMARY KEY (MaSV),
	FOREIGN KEY (MaLop) REFERENCES Lop(Malop)
);

CREATE TABLE MonHoc
(
	MaMH INTEGER IDENTITY(1,1),
	TenMH char(20) NOT NULL,
	NoiDungMH char(200),
	MaKhoa char(8),
	SoTinChi SMALLINT,
	SoTiet SMALLINT,
	GhiChu VARCHAR(MAX),
	PRIMARY KEY (MaMH),
	FOREIGN KEY (MaKhoa) REFERENCES Khoa(MaKhoa)
);

CREATE TABLE Hoc
(
	MaSV char(10),
	MaMH INTEGER,
	NgayDangKy DATE,
	NgayThi	DATE,
	DiemTrungBinh DECIMAL,
	GhiChu VARCHAR(MAX),
	PRIMARY KEY (MaSV,MaMH,NgayDangKy),
	FOREIGN KEY (MaSV) REFERENCES SinhVien(MaSV),
	FOREIGN KEY (MaMH) REFERENCES MonHoc(MaMH)
);
--2

ALTER TABLE dbo.Hoc 
add CONSTRAINT CK_NgayDangKy CHECK (NgayDangKy<GETDATE());

--3
ALTER TABLE dbo.Hoc
ADD CONSTRAINT CK_DiemTrungBinh CHECK (DiemTrungBinh BETWEEN 0 AND 10);

--4
ALTER TABLE dbo.MonHoc
ADD CONSTRAINT UNI_TenMH UNIQUE (TenMH);

--5
CREATE VIEW Sinhvien_HocCSDL_tren2lan as
SELECT s.*
FROM dbo.SinhVien s,
					(SELECT h.MaSV
					FROM dbo.Hoc h 
					WHERE (h.MaMH =
									(SELECT mh.MaMH
									FROM dbo.MonHoc mh
									WHERE mh.TenMH='CSDL'))
					GROUP BY h.MaSV
					HAVING COUNT(h.MaMH)>2) r
WHERE r.MaSV=s.MaSV



