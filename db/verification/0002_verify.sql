-- Consulta somente de diagnóstico após executar 0002.
-- Deve listar 10 tabelas com RLS ativo e as políticas instaladas.
SELECT t.tablename, t.rowsecurity,
       COALESCE(string_agg(p.policyname, ', ' ORDER BY p.policyname), 'SEM POLÍTICA') AS policies
FROM pg_tables t
LEFT JOIN pg_policies p ON p.schemaname=t.schemaname AND p.tablename=t.tablename
WHERE t.schemaname='public'
GROUP BY t.tablename,t.rowsecurity
ORDER BY t.tablename;
