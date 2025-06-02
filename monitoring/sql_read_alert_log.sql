-- -----------------------------------------------------------------------------------
-- Nome do Script: sql_read_alert_log.sql
-- Proposito: Consulta as entradas recentes do Alert Log do banco de dados,
--            filtrando por mensagens de erro (ORA-) ou palavras-chave.
-- SGBD: Oracle Database (11g em diante, com ADR)
-- Autor: Gustavo/GGJAVAJS
-- Data: 17/05/2025
--
-- IMPORTANTE:
-- 1. Requer acesso a view V$DIAG_ALERT_EXT (ou X$DBGALERTEXT).
-- 2. Esta view lê o alert.log XML. Se o log XML não estiver sendo populado
--    corretamente, a view pode não retornar dados ou dados desatualizados.
-- 3. O Alert Log pode ser extenso. Filtros são importantes.
--
-- Historico de Alteracoes:
-- Data       | Autor          | Descricao
-- -----------------------------------------------------------------------------------
-- [Data]     | [Seu Nome]     | Versao inicial
-- -----------------------------------------------------------------------------------

-- Configura o formato da saída SQL*Plus (opcional, para melhor visualização)
SET PAGESIZE 200
SET LINESIZE 200
SET LONG 100000    -- Permite que colunas LONG (como MESSAGE_TEXT) sejam exibidas
COLUMN EVENT_TIME FORMAT A25 HEADING 'Timestamp'
COLUMN MESSAGE_TEXT FORMAT A150 WORD_WRAPPED HEADING 'Mensagem do Alert Log'

PROMPT ==================================================================
PROMPT Consultando o Alert Log (Últimas 24 horas - Erros ORA- ou 'ERROR')
PROMPT ==================================================================
PROMPT (Pode demorar um pouco dependendo do tamanho do log e filtros)

SELECT
    TO_CHAR(ORIGINATING_TIMESTAMP, 'DD-MON-YYYY HH24:MI:SS.FF3 TZR') AS event_time,
    MESSAGE_TEXT
FROM
    V$DIAG_ALERT_EXT -- View externa padrão para o alert log
WHERE
    ORIGINATING_TIMESTAMP >= SYSTIMESTAMP - INTERVAL '1' DAY  -- Filtra pelas últimas 24 horas
    AND (
         UPPER(MESSAGE_TEXT) LIKE '%ORA-%' OR   -- Procura por erros Oracle
         UPPER(MESSAGE_TEXT) LIKE '%ERROR%' OR  -- Procura pela palavra 'ERROR'
         UPPER(MESSAGE_TEXT) LIKE '%WARNING%'   -- Procura pela palavra 'WARNING'
        )
    -- Adicione mais filtros se necessário, por exemplo:
    -- AND MESSAGE_TEXT NOT LIKE '%ORA-00000%' -- Para ignorar mensagens específicas
ORDER BY
    ORIGINATING_TIMESTAMP DESC; -- Mostra os mais recentes primeiro

PROMPT
PROMPT Para ver todas as mensagens das últimas X horas (ex: 1 hora):
PROMPT Altere: "SYSTIMESTAMP - INTERVAL '1' DAY" para "SYSTIMESTAMP - INTERVAL '1' HOUR"
PROMPT E remova ou ajuste a cláusula "AND (UPPER(MESSAGE_TEXT) LIKE ...)"
PROMPT
PROMPT Localização do Alert Log em texto (varia conforme a configuração):
PROMPT Execute: SELECT value FROM v$diag_info WHERE name = 'Diag Alert';
PROMPT (Isso mostrará o caminho para o alert_<SID>.xml, o .log estará no mesmo diretório)
PROMPT

-- Limpa as configurações de formatação (opcional)
-- CLEAR COLUMNS
-- CLEAR BREAKS
-- CLEAR COMPUTES
-- SET PAGESIZE 14
-- SET LINESIZE 80
-- SET LONG 80
