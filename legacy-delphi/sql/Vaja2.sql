USE strojna	
 SELECT COUNT(glavmer.datum) AS 'Število meritev v danem časovnem obdobju' FROM glavmer
	JOIN karmer ON glavmer.idmer = karmer.idmer
                  JOIN konsar ON glavmer.koda = konsar.koda 
                  JOIN konplan ON konplan.pozicija = karmer.karakt 
	WHERE glavmer.koda = '12.141.00/00'  and karmer.karakt = '0010' 
	AND YEAR(datum) = 2021
	AND MONTH(datum) = 01
	AND DAY(datum) = 19
                  AND karmer.vrednost < konplan.spmeja