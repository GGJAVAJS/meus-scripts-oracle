-- -----------------------------------------------------------------------------------
-- Nome do Script: sql_check_backup_status.sql
-- Proposito: Verifica o status dos ultimos jobs de backup RMAN registrados no
--            repositorio do controlfile.
-- SGBD: Oracle Database
-- Autor: Gustavo/GGJAVAJS
-- Data: 20/05/2025
--
-- IMPORTANTE:
-- 1. Requer acesso as views V$RMAN_BACKUP_JOB_DETAILS.
-- 2. Mostra informacoes dos backups executados via RMAN.
--
-- Historico de Alteracoes:
-- Data       | Autor          | Descricao
-- -----------------------------------------------------------------------------------
-- 20/05/2025 | Gutsdata       | Versao inicial do script
-- -----------------------------------------------------------------------------------

-- Configura o formato da saída SQL*Plus (opcional, para melhor visualização)
SET PAGESIZE 200
SET LINESIZE 200
COLUMN SESSION_KEY FORMAT 9999999
COLUMN INPUT_TYPE FORMAT A15
COLUMN STATUS FORMAT A20
COLUMN START_TIME FORMAT A20
COLUMN END_TIME FORMAT A20
COLUMN ELAPSED_MINUTES FORMAT 9999.99 HEADING 'ELAPSED|MINUTES'
COLUMN OUTPUT_MB FORMAT 999,999,999 HEADING 'OUTPUT|MB'
COLUMN COMPRESSION_RATIO FORMAT 99.99 HEADING 'COMP|RATIO'

PROMPT ======================================================
PROMPT Status dos Últimos Jobs de Backup RMAN
PROMPT ======================================================

SELECT
    SESSION_KEY,          -- Chave da sessão RMAN
    INPUT_TYPE,           -- Tipo de backup (DB FULL, ARCHIVELOG, CONTROLFILE, etc.)
    STATUS,               -- Status do job (COMPLETED, FAILED, COMPLETED WITH WARNINGS)
    TO_CHAR(START_TIME, 'DD-MON-YYYY HH24:MI:SS') AS START_TIME, -- Início do job
    TO_CHAR(END_TIME, 'DD-MON-YYYY HH24:MI:SS') AS END_TIME,     -- Fim do job
    ROUND(ELAPSED_SECONDS / 60, 2) AS ELAPSED_MINUTES, -- Duração em minutos
    ROUND(OUTPUT_BYTES / 1024 / 1024, 2) AS OUTPUT_MB, -- Tamanho do output em MB
    COMPRESSION_RATIO     -- Taxa de compressão (se aplicável)
FROM
    V$RMAN_BACKUP_JOB_DETAILS
ORDER BY
    START_TIME DESC; -- Ordena pelos mais recentes primeiro

PROMPT
PROMPT Para mais detalhes de um backup específico, use o comando RMAN:
PROMPT RMAN> LIST BACKUP OF DATABASE SUMMARY;
PROMPT RMAN> LIST BACKUP OF ARCHIVELOG ALL SUMMARY;
PROMPT RMAN> LIST BACKUP OF CONTROLFILE SUMMARY;
PROMPT
