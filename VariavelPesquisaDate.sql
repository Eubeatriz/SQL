DECLARE @DataInicio DATETIME
DECLARE @DataFinal DATETIME

SET @DataInicio = '2024-06-05 00:00:00.000'
SET @DataFinal = '2024-06-14 00:00:00.000'


SELECT S.Codigo, C.Nome AS Filme, LC.Numeracao AS Sala, aeEst.CodigoExterno AS TheaterId, AE.CodigoExterno AS MovieId, LC.Numeracao, S.DataHoraSessao, TL.Nome AS TipoLegenda
FROM Sessao S
INNER JOIN SessaoCopia SC ON S.Codigo = SC.Sessao_Codigo
INNER JOIN Copia C ON SC.Copia_Codigo = C.Codigo

INNER JOIN TipoLegenda TL ON C.TipoLegenda_Codigo = TL.Codigo
INNER JOIN Evento EV ON C.Evento_Codigo = EV.Codigo
INNER JOIN LayoutVigencia LV ON S.LayoutVigencia_Codigo = LV.Codigo
INNER JOIN Layout L ON LV.Layout_Codigo = L.Codigo
INNER JOIN [Local] LC ON L.Local_Codigo = LC.Codigo
INNER JOIN Estabelecimento E ON LC.Estabelecimento_Codigo = E.Codigo
INNER JOIN AtributoExterno AE ON C.Codigo = AE.CodigoOrigem
AND ae.ObjetoBD_Codigo = 6
AND ae.EntidadeExterna_Codigo = 2
INNER JOIN AtributoExterno AEEst ON E.Codigo = CAST(aeEst.CodigoOrigem AS INT)
AND AEEst.ObjetoBD_Codigo = 2
AND AEEst.EntidadeExterna_Codigo = 2
WHERE S.SessaoSituacao_Codigo = 2
AND E.codigo = 1
AND S.DataHoraSessao BETWEEN @DataInicio AND @DataFinal;
