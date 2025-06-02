-- -----------------------------------------------------------------------------------
-- Nome do Script: sql_check_tablespace_usage.sql
-- Proposito: Verifica o espaco total, usado, livre e percentual de uso
--            para cada tablespace permanente no banco de dados.
-- SGBD: Oracle Database
-- Autor: Gustavo/GGJAVAJS
-- Data: 15/05/2025
--
-- IMPORTANTE:
-- 1. Requer acesso as views DBA_TABLESPACES, DBA_DATA_FILES, DBA_FREE_SPACE.
-- 2. Nao inclui tablespaces temporarios (use DBA_TEMP_FILES e V$TEMP_SPACE_HEADER para isso).
--
-- Historico de Alteracoes:
-- Data       | Autor          | Descricao
-- -----------------------------------------------------------------------------------
-- 15/05/2025 | Gutsdata       | Versao inicial do script
-- -----------------------------------------------------------------------------------

-- Configura o formato da saída SQL*Plus (opcional, para melhor visualização)
SET PAGESIZE 100
SET LINESIZE 200
COLUMN TABLESPACE_NAME FORMAT A30
COLUMN TOTAL_MB FORMAT 999,999,990.99 HEADING 'Total|(MB)'
COLUMN USED_MB FORMAT 999,999,990.99 HEADING 'Usado|(MB)'
COLUMN FREE_MB FORMAT 999,999,990.99 HEADING 'Livre|(MB)'
COLUMN PERC_USED FORMAT 990.99 HEADING 'Usado|(%)'
COLUMN STATUS FORMAT A10

PROMPT ======================================================
PROMPT Uso de Espaço por Tablespace (Permanente)
PROMPT ======================================================

SELECT
    df.tablespace_name,
    ts.status,
    ROUND(df.total_bytes / (1024 * 1024), 2) AS total_mb,
    ROUND((df.total_bytes - NVL(fs.free_bytes, 0)) / (1024 * 1024), 2) AS used_mb,
    ROUND(NVL(fs.free_bytes, 0) / (1024 * 1024), 2) AS free_mb,
    ROUND(((df.total_bytes - NVL(fs.free_bytes, 0)) / df.total_bytes) * 100, 2) AS perc_used
FROM
    ( -- Subquery para calcular o total de bytes por tablespace a partir dos datafiles
      SELECT
          tablespace_name,
          SUM(bytes) AS total_bytes
      FROM
          dba_data_files
      GROUP BY
          tablespace_name
    ) df
LEFT JOIN
    ( -- Subquery para calcular o total de bytes livres por tablespace
      SELECT
          tablespace_name,
          SUM(bytes) AS free_bytes
      FROM
          dba_free_space
      GROUP BY
          tablespace_name
    ) fs ON df.tablespace_name = fs.tablespace_name
JOIN
    dba_tablespaces ts ON df.tablespace_name = ts.tablespace_name
ORDER BY
    perc_used DESC, df.tablespace_name;

PROMPT
PROMPT Nota: Para tablespaces com autoextend nos datafiles, 'Total (MB)' pode aumentar.
PROMPT       'Livre (MB)' representa o espaço atualmente alocado e não utilizado.
PROMPT
