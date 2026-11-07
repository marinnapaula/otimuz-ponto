-- 0002: Isolamento multiempresa (RLS) — Ótimuz Ponto
-- Executar após 0001, exclusivamente no banco de desenvolvimento.
-- IMPORTANTE: a aplicação deve usar role sem BYPASSRLS, sem propriedade das tabelas,
-- e definir app.user_id somente depois de autenticar o usuário no servidor.
BEGIN;

-- Contexto autenticado fornecido pela API, nunca pelo navegador.
CREATE SCHEMA IF NOT EXISTS app_private;

CREATE OR REPLACE FUNCTION app_private.current_user_id()
RETURNS uuid LANGUAGE plpgsql STABLE SET search_path = pg_catalog AS $$
DECLARE raw_id text;
BEGIN
  raw_id := current_setting('app.user_id', true);
  IF raw_id IS NULL OR raw_id = '' THEN RETURN NULL; END IF;
  RETURN raw_id::uuid;
EXCEPTION WHEN invalid_text_representation THEN RETURN NULL;
END $$;

-- SECURITY DEFINER evita recursão da política em memberships.
-- Proprietário da função deve ser o proprietário confiável do esquema.
CREATE OR REPLACE FUNCTION app_private.has_membership(p_tenant uuid, p_roles text[] DEFAULT NULL)
RETURNS boolean LANGUAGE sql STABLE SECURITY DEFINER
SET search_path = pg_catalog, public
AS $$
 SELECT EXISTS (
   SELECT 1 FROM public.memberships m
   WHERE m.tenant_id = p_tenant
     AND m.user_id = app_private.current_user_id()
     AND m.active = true
     AND (p_roles IS NULL OR m.role = ANY(p_roles))
 )
$$;

REVOKE ALL ON SCHEMA app_private FROM PUBLIC;
REVOKE ALL ON FUNCTION app_private.current_user_id() FROM PUBLIC;
REVOKE ALL ON FUNCTION app_private.has_membership(uuid,text[]) FROM PUBLIC;

-- A role de aplicação é criada sem LOGIN e sem privilégios de owner.
-- A credencial de LOGIN que a API utilizará poderá receber esta role depois.
DO $$
BEGIN
 IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'otimuz_app') THEN
   CREATE ROLE otimuz_app NOLOGIN NOBYPASSRLS;
 END IF;
END $$;
GRANT USAGE ON SCHEMA public TO otimuz_app;
GRANT USAGE ON SCHEMA app_private TO otimuz_app;
GRANT EXECUTE ON FUNCTION app_private.current_user_id() TO otimuz_app;
GRANT EXECUTE ON FUNCTION app_private.has_membership(uuid,text[]) TO otimuz_app;
GRANT SELECT ON public.memberships TO otimuz_app;

-- Uma política SELECT por tabela, sempre verificando tenant no servidor.
DROP POLICY IF EXISTS tenant_read ON public.tenants;
CREATE POLICY tenant_read ON public.tenants FOR SELECT TO otimuz_app
 USING (app_private.has_membership(id));

DROP POLICY IF EXISTS membership_read ON public.memberships;
CREATE POLICY membership_read ON public.memberships FOR SELECT TO otimuz_app
 USING (app_private.has_membership(tenant_id));

DROP POLICY IF EXISTS establishment_read ON public.establishments;
CREATE POLICY establishment_read ON public.establishments FOR SELECT TO otimuz_app
 USING (app_private.has_membership(tenant_id));

DROP POLICY IF EXISTS team_read ON public.teams;
CREATE POLICY team_read ON public.teams FOR SELECT TO otimuz_app
 USING (app_private.has_membership(tenant_id));

DROP POLICY IF EXISTS worksite_read ON public.worksites;
CREATE POLICY worksite_read ON public.worksites FOR SELECT TO otimuz_app
 USING (app_private.has_membership(tenant_id));

DROP POLICY IF EXISTS worker_read ON public.workers;
CREATE POLICY worker_read ON public.workers FOR SELECT TO otimuz_app
 USING (app_private.has_membership(tenant_id));

DROP POLICY IF EXISTS schedule_read ON public.work_schedules;
CREATE POLICY schedule_read ON public.work_schedules FOR SELECT TO otimuz_app
 USING (app_private.has_membership(tenant_id));

DROP POLICY IF EXISTS worker_schedule_read ON public.worker_schedules;
CREATE POLICY worker_schedule_read ON public.worker_schedules FOR SELECT TO otimuz_app
 USING (app_private.has_membership(tenant_id));

DROP POLICY IF EXISTS team_assignment_read ON public.team_worksite_assignments;
CREATE POLICY team_assignment_read ON public.team_worksite_assignments FOR SELECT TO otimuz_app
 USING (app_private.has_membership(tenant_id));

-- app_users não possui tenant_id: acesso limitado à própria identidade.
ALTER TABLE public.app_users ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS self_user_read ON public.app_users;
CREATE POLICY self_user_read ON public.app_users FOR SELECT TO otimuz_app
 USING (id = app_private.current_user_id());

GRANT SELECT ON public.tenants, public.establishments, public.teams,
 public.worksites, public.workers, public.work_schedules,
 public.worker_schedules, public.team_worksite_assignments,
 public.app_users TO otimuz_app;

-- Sem INSERT/UPDATE/DELETE para a role da aplicação neste estágio.
-- Políticas de escrita exigirão validação por papel e testes dedicados.
COMMIT;
