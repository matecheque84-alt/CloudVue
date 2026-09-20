# Repositório GitHub — SPE Castro Alves/Sapeaçu

## Objetivo
Este repositório privado versiona os documentos de desenvolvimento (Greenfield → RTB) e funciona como base comum de trabalho entre ChatGPT (pesquisa) e Claude (revisão crítica, modelagem e materiais institucionais).

## Estrutura padrão
- `01_premissas/` (`log_premissas.csv`)
- `02_modelo_financeiro/`
- `03_regulatorio/` (`registro_regulatorio.csv`)
- `04_conexao/`
- `05_fundiario/`
- `06_ambiental/`
- `07_riscos/` (`matriz_riscos.csv`)
- `08_data_room_index/` (`indice_data_room.csv`)
- `09_materiais_investidor/`
- `README.md`
- `CHANGELOG.md`
- `SECURITY.md`
- `.gitignore`

## Fluxo operacional
1. **Verificar acesso disponível**
   - Se houver computador vinculado, operar em pasta local clonada usando shell do dispositivo para Git.
   - Se houver navegador disponível, conduzir criação/ajustes do repositório com login/OAuth executados pelo usuário.
   - Sem os dois recursos, gerar versão em `.zip` para entrega manual.
2. **Criar/atualizar repositório**
   - Sempre manter o repositório como **Private**.
   - Não criar README diretamente no GitHub quando o pacote já contém `README.md`.
   - Registrar mudanças relevantes no `CHANGELOG.md`.
3. **Conectar ChatGPT**
   - Usar somente o conector oficial do GitHub nas configurações do ChatGPT.
   - Em permissões GitHub, selecionar **Only select repositories** e incluir apenas este repositório.
   - Evitar links de terceiros para conexão, salvo confirmação explícita do usuário.
   - Teste de conexão: pedir ao ChatGPT o resumo deste `README.md`.

## Regras de conteúdo
- Toda informação deve ser classificada com uma das tags:
  - `[FATO CONFIRMADO]`
  - `[PREMISSA]`
  - `[ESTIMATIVA]`
  - `[HIPÓTESE]`
  - `[PONTO A CONFIRMAR]`
  - `[RISCO CRÍTICO]`
- Dado regulatório deve registrar: órgão, número, data, vigência, link e implicação.
- Não inventar números, normas, CAPEX, preços ou aprovações para preencher templates.
- Materiais vindos do ChatGPT devem passar por revisão crítica e inconsistências devem ser registradas no `CHANGELOG.md`.

## Responsáveis
- Luigi — Incorporador Líder e Diretor Geral
- Dan — Diretor de Estruturação Financeira e Intermediação
- Diego — Diretor de Originação Territorial e Relações Públicas
- Gabriela — Diretora de Comunicação Estratégica, Documentação e Prompt Engineering
- João — Diretor de Controladoria, Arrecadação e Compliance Finanças
