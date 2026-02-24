USE SAPKontrola
CREATE TABLE Prijava(
  ident int NOT NULL IDENTITY(1,1),
  uporab char(12),
  sistem char(8), 
  client char(3),
  streznik char(30),
  sysnnum smallint,
  pass char(12),
  jezik char(2),
  glavni char(1))
 