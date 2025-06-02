-- -----------------------------------------------------------------------------------
-- Nome do Script: sql_list_active_sessions.sql
-- Proposito: Lista as sessoes ativas no banco de dados, incluindo informacoes
--            como usuario, maquina, programa, SQL_ID e consumo de CPU.
-- SGBD: Oracle Database
-- Autor: Gustavo/GGJAVAJS
-- Data: 16/05/2025
--
-- IMPORTANTE:
-- 1. Requer acesso as views V$SESSION, V$PROCESS, V$SQL (opcional), V$SESS_TIME_MODEL.
-- 2. Filtra por sessoes com STATUS='ACTIVE' e TYPE='USER'.
--
-- Historico de Alteracoes:
-- Data       | Autor          | Descricao
-- -----------------------------------------------------------------------------------
-- 16/05/2025 | Gutsdata       | Versao inicial do script
-- -----------------------------------------------------------------------------------

-- Configura o formato da saída SQL*Plus (opcional, para melhor visualização)
SET PAGESIZE 200
SET LINESIZE 250
COLUMN SID_SERIAL FORMAT A12 HEADING 'SID,SERIAL#'
COLUMN USERNAME FORMAT A20
COLUMN OSUSER FORMAT A15
COLUMN MACHINE FORMAT A30
COLUMN PROGRAM FORMAT A30
COLUMN STATUS FORMAT A10
COLUMN SQL_ID FORMAT A15
COLUMN LOGON_TIME FORMAT A20
COLUMN EVENT FORMAT A30
COLUMN DB_CPU_SECONDS FORMAT 999,990.99 HEADING 'DB CPU|(Secs)'

PROMPT ======================================================
PROMPT Sessões Ativas e Consumo de Recursos
PROMPT ======================================================

SELECT
    s.sid || ',' || s.serial# AS sid_serial, -- SID e Serial# da sessão
    s.username,                -- Usuário do banco de dados
    s.osuser,                  -- Usuário do sistema operacional cliente
    s.machine,                 -- Máquina cliente
    SUBSTR(s.program, 1, 30) AS program, -- Programa/aplicação cliente
    s.status,                  -- Status da sessão (ACTIVE, INACTIVE)
    s.sql_id,                  -- SQL_ID da query atualmente em execução (se houver)
    TO_CHAR(s.logon_time, 'DD-MON-YYYY HH24:MI:SS') AS logon_time, -- Hora do logon
    SUBSTR(s.event, 1, 30) AS event, -- Evento de espera atual (se estiver esperando)
    NVL(stm.value / 1000000, 0) AS db_cpu_seconds -- Tempo de CPU consumido pela sessão (em segundos)
FROM
    v$session s
LEFT JOIN
    v$sess_time_model stm ON s.sid = stm.sid AND stm.stat_name = 'DB CPU'
WHERE
    s.type = 'USER'            -- Exclui processos de background (ex: PMON, SMON)
    AND s.status = 'ACTIVE'    -- Mostra apenas sessões ativas
ORDER BY
    db_cpu_seconds DESC NULLS LAST, s.logon_time;

PROMPT
PROMPT Para ver o texto do SQL de uma sessão específica, use (substitua <SQL_ID>):
PROMPT SELECT sql_text FROM v$sql WHERE sql_id = '<SQL_ID>';
PROMPT
PROMPT Para matar uma sessão (USE COM EXTREMO CUIDADO e apenas se necessário):
PROMPT ALTER SYSTEM KILL SESSION 'sid,serial#' IMMEDIATE;
PROMPT Exemplo: ALTER SYSTEM KILL SESSION '123,4567' IMMEDIATE;
PROMPT
