USE strojna
CREATE TABLE metode(
  idmet int NOT NULL IDENTITY(1,1),
  idpost int,
  metoda char(5),
  kanal tinyint) 
 