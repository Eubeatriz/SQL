SELECT 
VI.Ingresso_Codigo,
V.IngressoEspecial_Codigo,
Ingresso_Nome,
SUM(QuantidadeVendida) as QuantidadeVendida

FROM [dbo].[DW_Arena_Vendas_Ingressos] VI
INNER JOIN DW_Arena_Ingresso I
ON VI.Ingresso_Codigo = I.Ingresso_Codigo

INNER JOIN Arena.dbo.IngressoEspecialValidacao V
ON V.IngressoEspecial_Codigo = VI.Ingresso_Codigo

WHERE VI.Ingresso_Codigo IN
(523, 790, 795, 824, 862, 907, 949, 969, 993, 994, 1001, 1002, 1187, 1215, 1237, 1239, 1240, 1241, 1253, 1262, 1267, 1268, 1273, 1313, 1315, 1317, 1319, 
1321, 1323, 1353, 1404, 2461)

GROUP BY VI.Ingresso_Codigo, Ingresso_Nome, V.IngressoEspecial_Codigo

ORDER BY  QuantidadeVendida DESC
