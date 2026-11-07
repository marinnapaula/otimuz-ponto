# Migração 0002 — RLS multiempresa

**Status:** políticas iniciais de leitura, não prontas para acesso público.

## O que faz
- Cria a role `otimuz_app` sem login, sem BYPASSRLS.
- Usa `app.user_id` para associar consultas a um usuário autenticado.
- Aplica políticas de leitura com `tenant_id` a todas as tabelas de empresa.
- Protege `app_users` para leitura apenas da própria identidade.
- Não concede escrita, não cria usuários reais, nem conecta a DEMO.

## Modelo de confiança (crítico)
A variável `app.user_id` pode ser alterada por qualquer sessão SQL com acesso direto. Portanto, **não é um mecanismo de autenticação**. Somente uma API confiável deve definir o contexto, após verificar a sessão de login; nunca permitir SQL arbitrário de clientes, nem expor credenciais do PostgreSQL no navegador. Usar transações com `SET LOCAL` / `set_config(..., true)`, evitando vazamento de contexto entre conexões de pool.

A função `SECURITY DEFINER` precisa pertencer a uma role confiável e ter `search_path` fixo. Antes da produção, executar testes de invasão e isolamento cruzado, inclusive tentativas de alteração de contexto, permissões e funções.

## Execução
1. No Neon > SQL Editor, selecionar o projeto `otimuz-ponto-dev`.
2. Copiar o arquivo `0002_rls_multitenant.sql` e executar.
3. Rodar `0002_verify.sql`; devem aparecer 10 tabelas com RLS ativo.
4. Não criar contas reais ou inserir dados pessoais ainda.

## Próximo passo
- Implementar login, sessão e API confiável.
- Criar role de LOGIN dedicada e políticas de escrita por papel.
- Testar isolamento entre duas empresas fictícias antes de permitir cadastros.
