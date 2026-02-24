USE obdelov
CREATE TABLE konplan(
  idplan int NOT NULL IDENTITY(1,1),
  idsar  smallint,
  tip  integer,
  pozicija char(4),
  naziv char(40),
  predpis float, 
  spmeja  float,
  zgmeja float,
  kanal char(8),
  stvz tinyint,
  stkan tinyint, 
  com tinyint, 
  oznaka char(1)
 