USE dia_stroji
CREATE TABLE zastoji(
  id  bigint NOT NULL IDENTITY(1,1),
  timestamp datetime DEFAULT (getdate()),
  ts_start datetime,
  ts_end datetime,
  nalog int,
  tip nvarchar(20), 
  stroj int,
  operater nvarchar(20), 
  vzrok text)
