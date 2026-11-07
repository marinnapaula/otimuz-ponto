# Arquitetura SaaS multiempresa — fundação

## Regras
- Todo dado de empresa deve carregar tenant_id, inclusive pessoas, jornadas, locais, marcações, comprovantes, anexos e auditoria.
- Estabelecimento pertence a uma empresa; usuário pode pertencer a várias empresas por membership com papel explícito.
- Isolamento de tenant no backend e PostgreSQL Row Level Security (RLS); não confiar em tenant_id fornecido pelo navegador.
- IDs UUID; chaves estrangeiras compostas quando necessário; testes automáticos de isolamento.
- Ações administrativas exigem autorização por empresa e trilha de auditoria.
- Ponto original imutável, com fluxo de apuração separado.
- Configuração de plano e limites por empresa, com piloto gratuito.
- Segredos exclusivamente no servidor; SSL obrigatório para PostgreSQL remoto.
- Exportação por empresa e portabilidade de dados.

## Entidades de fundação
tenants, establishments, users, memberships, workers, contracts, teams, worksites, schedules, assignments, punch_records, punch_receipts, occurrences, decisions, audit_events, subscription_plans, tenant_subscriptions.

## Primeira entrega de backend
1. PostgreSQL cloud e migrações.
2. Autenticação e memberships.
3. CRUD de equipes, locais, trabalhadores e jornadas com isolamento.
4. Testes de autorização e isolamento entre empresas.
5. Conexão da DEMO em ambiente preview, sem tocar na main.
6. Só então serviço REP-P separado e conformidade fiscal.
