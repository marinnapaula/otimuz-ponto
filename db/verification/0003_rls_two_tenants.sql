-- ÓTIMUZ PONTO — Teste isolado de RLS com duas empresas fictícias.
-- Executar no Neon SQL Editor (banco de desenvolvimento), após migrações 0001 e 0002.
-- Usa transação e ROLLBACK: nenhum dado de teste permanece gravado.
-- Resultado esperado: quatro consultas SELECT com resultado PASS (cada uma em sua aba).
BEGIN;

-- IDs determinísticos apenas para este teste transacional.
INSERT INTO public.tenants (id,legal_name,display_name)
VALUES
 ('10000000-0000-4000-8000-000000000001','Empresa Piloto Fictícia','Ótimuz Piloto'),
 ('10000000-0000-4000-8000-000000000002','Empresa Externa Fictícia','Empresa Teste');
INSERT INTO public.app_users (id,auth_subject,display_name)
VALUES
 ('20000000-0000-4000-8000-000000000001','rls-test-user-a','Usuário fictício A'),
 ('20000000-0000-4000-8000-000000000002','rls-test-user-b','Usuário fictício B'),
 ('20000000-0000-4000-8000-000000000003','rls-test-user-none','Usuário fictício sem empresa');
INSERT INTO public.memberships (tenant_id,user_id,role)
VALUES
 ('10000000-0000-4000-8000-000000000001','20000000-0000-4000-8000-000000000001','admin'),
 ('10000000-0000-4000-8000-000000000002','20000000-0000-4000-8000-000000000002','admin');

-- A role do banco precisa ser diferente da role proprietária.
SET LOCAL ROLE otimuz_app;
SELECT set_config('app.user_id','20000000-0000-4000-8000-000000000001',true);
SELECT 'A vê somente sua empresa' AS teste, 1 AS esperado, count(*)::integer AS encontrado,
 CASE WHEN count(*)=1 THEN 'PASS' ELSE 'FAIL' END AS resultado FROM public.tenants;

SELECT 'A não vê empresa B' AS teste, 0 AS esperado, count(*)::integer AS encontrado,
 CASE WHEN count(*)=0 THEN 'PASS' ELSE 'FAIL' END AS resultado FROM public.tenants WHERE id='10000000-0000-4000-8000-000000000002';

SELECT set_config('app.user_id','20000000-0000-4000-8000-000000000002',true);
SELECT 'B vê somente sua empresa' AS teste, 1 AS esperado, count(*)::integer AS encontrado,
 CASE WHEN count(*)=1 THEN 'PASS' ELSE 'FAIL' END AS resultado FROM public.tenants;

SELECT set_config('app.user_id','20000000-0000-4000-8000-000000000003',true);
SELECT 'Sem vínculo não vê empresas' AS teste, 0 AS esperado, count(*)::integer AS encontrado,
 CASE WHEN count(*)=0 THEN 'PASS' ELSE 'FAIL' END AS resultado FROM public.tenants;

ROLLBACK;
