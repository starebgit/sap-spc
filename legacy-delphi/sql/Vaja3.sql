USE strojna	
 SELECT glavmer.idmer, karmer.vrednost FROM glavmer
	JOIN karmer ON glavmer.idmer = karmer.idmer
                  JOIN konsar ON glavmer.koda = konsar.koda 
                  JOIN konplan ON konplan.pozicija = karmer.karakt 
	WHERE glavmer.koda = '55.712.00/00'  and karmer.karakt = '0012' 
	AND YEAR(datum) = 2021
	AND MONTH(datum) = 03
	AND DAY(datum) = 6
                  AND karmer.vrednost >(select konplan.zgmeja from konsar inner join konplan on konsar.ident = konplan.idsar WHERE konsar.koda = '55.712.00/00' and konplan.pozicija = '0012')