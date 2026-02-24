USE strojna	
 SELECT COUNT(glavmer.datum) AS 'Število meritev v danem časovnem obdobju' FROM glavmer
	JOIN karmer
	ON glavmer.idmer = karmer.idmer
	WHERE glavmer.koda = '12.141.00/00'  and karakt = '0010' 
	AND YEAR(datum) = 2021
	AND MONTH(datum) = 01
	AND DAY(datum) = 19