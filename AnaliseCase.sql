--ALTER VIEW vw_DW_CIS_Clientes_RecurrentPaymentHistory AS

SELECT 
UserId,
CreateDate,
StartDate,
CancelDate,
RecurrentPaymentHistoryId,
CASE 
WHEN CinemarkClubCategoryType = 1 
THEN 'Red'
ELSE 'Black'
END as CinemarkCategoryType,

    CASE 
        WHEN StartDate = (SELECT MIN(StartDate) FROM DW_CIS_Clientes_RecurrentPaymentHistory A WHERE A.UserId = PH.UserId) 
        THEN 'Sim' 
        ELSE 'Não' 
    END as PrimeiraAdesao,
[Status],
    CASE 
        WHEN Status = 1 THEN 'Ativo'
        WHEN Status = 2 THEN 'Finalizado'
        WHEN Status = 3 THEN 'Desativado'
        WHEN Status = 4 THEN 'Desativado'
        WHEN Status = 5 THEN 'Desativado'
        WHEN Status = 97 THEN 'Cancelado'
        WHEN Status = 98 THEN 'Estornado'
        WHEN Status = 99 THEN 'Cancelado'
        ELSE 'Status Desconhecido'
    END AS [StatusName],
    CASE 
        WHEN Status = 1 THEN 'Ativo'
        WHEN Status = 2 THEN 'Finalizado'
        WHEN Status = 3 THEN 'Desativado Pelo Usuário'
        WHEN Status = 4 THEN 'Desativado Número Máximo Tentativas'
        WHEN Status = 5 THEN 'Desativado Cartão Expirado'
        WHEN Status = 97 THEN 'Cancelamento Total'
        WHEN Status = 98 THEN 'Estornado'
        WHEN Status = 99 THEN 'Cancelamento Pelo Usuário'
        ELSE 'Detalhe Status Desconhecido'
    END AS DetalheStatus,


    CASE 
        WHEN StartDate = (SELECT MIN(StartDate) FROM DW_CIS_Clientes_RecurrentPaymentHistory A WHERE A.UserId = PH.UserId) 
        THEN NULL
        ELSE  LEAD(Status) OVER(ORDER BY UserId,StartDate DESC)
    END as StatusUltimoCancelamento

FROM DW_CIS_Clientes_RecurrentPaymentHistory PH

--WHERE [Status] = '5'
--WHERE UserId = '1241239'
--WHERE StartDate = (SELECT MIN(StartDate) FROM DW_CIS_Clientes_RecurrentPaymentHistory WHERE UserId = DW_CIS_Clientes_RecurrentPaymentHistory.UserId)

--ORDER BY UserId
