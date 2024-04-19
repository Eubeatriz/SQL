-- Crie uma tabela temporária
DROP TABLE IF EXISTS #temp
GO
CREATE TABLE #temp (CodigoBusca VARCHAR (100)  COLLATE DATABASE_DEFAULT NOT NULL)
 
-- Insira os valores que você está procurando na tabela temporária
INSERT INTO #temp (CodigoBusca)
VALUES 
('34104C24E7'),	
('B8713CD295'),
('F0F69FF8E3')
SELECT
	[Chave]                                  =CONCAT (v.CodigoBusca,'|', LojaTEF,'|', imo.TipoItem) ,
    [CODIGO_VENDA]					         = v.codigo,       
	[TIPO_ITEM]								 = imo.TipoItem,
    [LOJA_FILIAL]							 = CASE WHEN COM.FechamentoPorEstabelecimento =  0 then COM.Nome else ET.Nome end,        
    [BANDEIRA]								 = fp.Nome,    
	[BANDEIRA_Origem]						 = fp2.Nome, 
    [OUTROMONTANTE]							 = OM.Nome,
	[OUTROMONTANTE_Origem]					 = OM2.Nome,
    [TIPO_TRANSACAO]						 = UPPER(ttef.Nome),        
    [VALOR]									 = SUM(CONVERT(DECIMAL(19,2),imo.ValorTotal)),        
    [QTD_VENDA]								 = SUM(CONVERT(INT,imo.Quantidade)),         
    [DATA_VENDA]							 = FORMAT(c.DataConsolidacao,'yyyy/MM/dd'),        
    [SEQUENCIA]								 = ROW_NUMBER() OVER (ORDER BY c.DataConsolidacao),        
    [NOTA_FISCAL]							 = v.CodigoBusca, 
	CodigoBuscaOrigem                        = v2.CodigoBusca,
    [LOJATEF]								 = ET.LojaTEF,        
    [NSU]									 = p.NSU,        
    [NSUHOST]								 = p.NSUHost,
	[NSUFEPAS]                               = p.NSUFepas,        
    [AUTORIZACAO]							 = p.CodAutorizacao,
	[NSU_Origem]							 = p2.NSU,        
    [NSUHOST_Origem]						 = p2.NSUHost,
	[NSUFEPAS_Origem]                        = p2.NSUFepas,        
    [AUTORIZACAO_Origem]					 = p2.CodAutorizacao,
 
	[CANAL_VENDA]							 = CV.Nome,
    [CANAL_RESGATE]						     = UPPER(cv2.Nome),        
    [DATACONSOLIDACAOVENDA]					 = c.DataConsolidacao,        
    [VALORVENDIDO]							 = SUM(CAST(ROUND(ISNULL(ip.Valor, imo.ValorTotal), 2, 1) AS DECIMAL(10,2))),        
    [QTDEVENDIDA]							 = SUM(CAST(ISNULL((CASE WHEN cvp.VendaPeso =  1 THEN 1 ELSE imo.Quantidade END), 0)         
												* (CASE WHEN ( ( ip.Valor IS NOT NULL ) AND ( ISNULL(imo.ValorTotal, .0) > 0 ) )        
													THEN CAST(ROUND(ip.Valor / imo.ValorTotal, 0) AS INT)ELSE 1   END)AS INT)),        
    [SITUACAOITEMMOVIMENTOOPER_SIGLA]        = simo.Sigla,        
    [CONTABILIZA]							 = imo.Contabiliza,  
	imo.TipoItem,
    [RESGATADA]                              = CAST(CASE WHEN v.CaixaCarrinho_Codigo IS NOT NULL THEN 1 WHEN imo.ItemMovOperResgatado_Codigo IS NOT NULL THEN 1 ELSE 0 END AS BIT),        
	[Produto_Nome] =pro.Nome,
	[ingresso_Nome] = i.Nome
 
FROM Caixa c         
	INNER JOIN Venda v							 ON c.Codigo =  v.Caixa_Codigo        
	INNER JOIN MovimentoOperacional mo			 ON v.Codigo =  mo.Venda_Codigo        
	INNER JOIN ItemMovimentoOperacional imo	     ON mo.Codigo =  imo.MovimentoOperacional_Codigo        
	INNER JOIN TipoMovimentoOperacional tmo	     ON tmo.Codigo =  mo.TpMovimentoOperacional_Codigo        
	INNER JOIN SituacaoItemMovimentoOper simo    ON imo.SituacaoItemMovOper_Codigo =  simo.Codigo         
	INNER JOIN EstacaoVenda ev					 ON c.EstacaoVenda_Codigo =  ev.Codigo        
	INNER JOIN CanalVenda CV					 ON CV.Codigo =  ev.CanalVenda_Codigo        
	INNER JOIN Estabelecimento ET				 ON ET.Codigo =  ev.Estabelecimento_Codigo        
	INNER JOIN Complexo COM						 ON COM.Codigo =  ET.Complexo_Codigo
--TEF                        
    LEFT JOIN (Pagamento p                
    LEFT JOIN ItemPagamento ip					 ON ip.Pagamento_Codigo =  p.Codigo        
    LEFT JOIN PagamentoLog pl					 ON p.Codigo =  pl.Pagamento_Codigo        
    LEFT JOIN FormaPagamento FP				 ON fp.Codigo =  p.FormaPagamento_Codigo        
    LEFT JOIN OutroMontante OM					 ON OM.Codigo =  fp.OutroMontante_Codigo        
    LEFT JOIN TipoTef TTEF						 ON  TTEF.Codigo  =  FP.TipoTef_Codigo )			 
												 ON p.Venda_Codigo =  v.Codigo AND ip.ItemMovOperacional_Codigo =  imo.Codigo        
-- Ingressos                    
    LEFT JOIN (IngressoMovimentoOperacional igmo         
    INNER JOIN Sessao s							 ON igmo.Sessao_Codigo =  s.Codigo        
    INNER JOIN SessaoCopia sc					 ON sc.Sessao_Codigo =  s.Codigo        
    INNER JOIN LayoutVigencia lv				 ON s.LayoutVigencia_Codigo =  lv.Codigo        
    INNER JOIN Layout l							 ON lv.Layout_Codigo =  l.Codigo        
    INNER JOIN Local lo							 ON l.Local_Codigo =  lo.Codigo        
    INNER JOIN Elemento e						 ON igmo.Elemento_Codigo =  e.Codigo        
    INNER JOIN Ingresso i						 ON igmo.Ingresso_Codigo =  i.Codigo)			  
												 ON imo.Codigo =  igmo.Codigo        
-- Produtos        
    LEFT JOIN (ProdutoMovimentoOperacional pmo          
    INNER JOIN Produto pro						 ON pmo.Produto_Codigo =  pro.Codigo        
    LEFT JOIN ConfiguracaoVendaProduto cvp	     ON cvp.Produto_Codigo =  pro.Codigo)  ON imo.Codigo =  pmo.Codigo  

 
-- Venda Externa
     LEFT JOIN (Pagamento p2                
     LEFT JOIN ItemPagamento ip2			    ON ip2.Pagamento_Codigo =  p2.Codigo
	 LEFT JOIN ItemMovimentoOperacional IMO2    ON IMO2.Codigo =IP2.ItemMovOperacional_Codigo
	 LEFT JOIN MovimentoOperacional MO2         ON mo2.Codigo = imo2.MovimentoOperacional_Codigo
	 LEFT JOIN Venda V2                         ON v2.Codigo = mo2.Venda_Codigo
	 LEFT JOIN Caixa C2                         ON C2.Codigo = v2.Caixa_Codigo
	 LEFT JOIN EstacaoVenda EV2                 ON EV2.Codigo =C2.EstacaoVenda_Codigo
	 LEFT JOIN CanalVenda CV2                   ON CV2.Codigo = EV2.CanalVenda_Codigo
     LEFT JOIN PagamentoLog pl2					ON p2.Codigo =  pl2.Pagamento_Codigo        
     LEFT JOIN FormaPagamento FP2				ON fp2.Codigo =  p2.FormaPagamento_Codigo        
     LEFT JOIN OutroMontante OM2				ON OM2.Codigo =  fp2.OutroMontante_Codigo        
     LEFT JOIN TipoTef TTEF2					ON  TTEF2.Codigo  =  FP2.TipoTef_Codigo )	ON  imo2.Codigo =  imo.ItemMovOperResgatado_Codigo     
WHERE 1=1
--c.DataConsolidacao >='20240201'
AND
--v.CodigoBusca
v.CodigoBusca IN (SELECT CodigoBusca FROM #temp)
GROUP BY 
		v.codigo, mo.DataHoraConsolidacao,c.DataConsolidacao, fp.Nome, simo.Sigla,        
		imo.Contabiliza, v.CaixaCarrinho_Codigo, imo.ItemMovOperResgatado_Codigo, p.NSU,p.NSUHost, p.CodAutorizacao, OM.Nome, et.LojaTEF, cv.Codigo, cv.TipoSistemaVenda_Codigo,        
		TTEF.Nome,  CASE WHEN COM.FechamentoPorEstabelecimento =  0 THEN COM.Nome ELSE ET.Nome END, v.CodigoBusca, cv.Nome,p.NSUFepas,imo.TipoItem,
		pro.Nome,	 i.Nome		,v2.CodigoBusca, cv2.Nome, fp2.Nome, OM2.Nome,p2.NSU, p2.NSUHost,p2.NSUFepas,   p2.CodAutorizacao
