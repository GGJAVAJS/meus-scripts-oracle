# Meus Scripts Oracle para DBA

Bem-vindo ao meu repositório de scripts Oracle! Esta é uma coleção de scripts que desenvolvi e utilizo para tarefas comuns de administração de banco de dados Oracle.

## Propósito

O objetivo deste repositório é:
*   Servir como um portfólio pessoal de scripts DBA.
*   Compartilhar conhecimento com a comunidade.
*   Manter um local centralizado para meus scripts utilitários.

## Estrutura do Repositório

Os scripts estão organizados nas seguintes pastas (ou estarão em breve):

*   `/backup`: Scripts relacionados a backup e recovery (RMAN).
*   `/monitoring`: Scripts para monitoramento de performance, sessões, etc.
*   `/space_management`: Scripts para gerenciamento de espaço (tablespaces, datafiles).
*   `/maintenance`: Scripts para tarefas de manutenção (índices, estatísticas).
*   `/security`: Scripts relacionados a usuários, roles e permissões.
*   `/utils`: Scripts utilitários diversos.

## Como Usar

1.  Navegue até a pasta desejada.
2.  Clique no script `.sql` ou `.rman` para visualizar seu conteúdo.
3.  Você pode copiar o conteúdo ou fazer o download do arquivo.
4.  **Leia atentamente os comentários no início de cada script** para entender seu propósito, pré-requisitos e como executá-lo.

## Pré-requisitos Gerais

*   A maioria dos scripts requer privilégios de DBA ou acesso a views de dicionário de dados específicas (ex: `V$`, `DBA_`).
*   Testados primariamente em Oracle Database [Sua Versão Principal, ex: 19c], mas muitos devem funcionar em outras versões com pequenas ou nenhuma adaptação.

## ⚠️ Disclaimer ⚠️

**Use estes scripts por sua conta e risco!**
Sempre teste qualquer script em um ambiente de **DESENVOLVIMENTO ou TESTE** antes de executá-lo em um ambiente de **PRODUÇÃO**. Não me responsabilizo por quaisquer perdas de dados ou problemas causados pelo uso indevido destes scripts.

## Contato

*   GitHub: GGJAVAJS
*   LinkedIn: linkedin.com/in/gustavo-ferreira-de-souza-a58608198 

---
*Última atualização: 02/06/2025*
