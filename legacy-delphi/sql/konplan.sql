USE strojna
CREATE TABLE konplan(
  idplan int NOT NULL IDENTITY(1,1),
  idsar  smallint,
  tip  integer,
  pozicija char(4),
  naziv char(40),
  spmeja  float,
  zgmeja float,
  kanal char(8),
  stvz tinyint,
  stkanal tinyint, 
  oznaka char(1)
 