USE strojna
CREATE TABLE Gencasovni(
  zapored int NOT NULL IDENTITY(1,1),
  stpost tinyint,
  ident int,
  stroj int,
  cas time(0)) 