USE strojna
CREATE TABLE stroji(
  zapored int NOT NULL IDENTITY(1,1),
  stPost int,
  idstroja char(15),
  sifstroja char(20),
  naziv char(50))
