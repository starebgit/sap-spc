USE strojna
CREATE TABLE Merila(
  idmerila int NOT NULL IDENTITY(1,1),
  red tinyint,
  idpost tinyint, 
  stevilka char(6),
  naziv char(50),
  opis char(50))
 