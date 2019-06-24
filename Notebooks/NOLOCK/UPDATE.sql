USE tempdb
GO
SET NOCOUNT ON;
-- We're now going to randomly generate data for other agents
-- to cause more index fragmentation

INSERT INTO dbo.CallDetails (AGENTID, CALLTIME, CALLDETAILS)
SELECT AGENTID, CALLTIME, CALLDETAILS
FROM
(
SELECT CAST(RAND() * 1000 AS INT) AS AGENTID,
10 AS CALLTIME,
REPLICATE('CallGoesOn', 100) AS CALLDETAILS
) AS DETAILS
WHERE AGENTID <> 123
Go 500