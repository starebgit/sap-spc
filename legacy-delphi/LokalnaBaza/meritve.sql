USE obdelov
CREATE TABLE meritve(
  ident int NOT NULL IDENTITY(1,1),
  idmer int,
  tip  tinyint,
  poz char(4), 
  stv  smallint,
  vrednost decimal(8,3),
  slabi smallint,
  eval char(1),  
  opomba  char(60))
  

 