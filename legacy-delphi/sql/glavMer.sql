USE strojna
CREATE TABLE Glavmer(
  idmer  int NOT NULL IDENTITY(1,1),
  idpost int,
  datum DateTime,
  koda  char(18),
  sarza char(12),
  dodatno char(10))