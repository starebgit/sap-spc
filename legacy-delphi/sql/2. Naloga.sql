USE strojna
SELECT count_big(konsar.ident) as 'Število slabih meritev' from konsar
	join konplan 
	on konsar.ident = konplan.idsar
	cross join karmer
	join glavmer
	on glavmer.idmer = karmer.idmer
	WHERE karmer.vrednost > konplan.zgmeja
	OR karmer.vrednost < konplan.spmeja