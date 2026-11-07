# Migração 0001 — Fundação multiempresa

Arquivo: `0001_multitenant_foundation.sql`

## Execução
1. Abra Neon > SQL Editor no projeto de desenvolvimento.
2. Execute a migração somente no banco de desenvolvimento, após revisar o SQL.
3. Confira a criação das tabelas em Tables.

## Segurança
- Não execute em banco de produção sem revisão e plano de rollback.
- Não contém dados de clientes ou senhas.
- A migração ativa RLS em tabelas por empresa, mas ainda **não cria políticas de acesso**.
- O usuário proprietário do banco pode contornar RLS. A aplicação deve usar role separada, sem BYPASSRLS e sem privilégios de proprietário.
- Não conectar a interface diretamente a estas tabelas; autenticação, autorização e políticas RLS são a próxima etapa.
- Não há ainda marcação de ponto REP-P oficial.

## Próximas migrações
- 0002: políticas de isolamento multiempresa, roles e testes.
- 0003: API autenticada de cadastros.
- 0004+: núcleo de registro, comprovantes e apuração, conforme conformidade legal.
