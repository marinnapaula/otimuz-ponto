-- Ótimuz Ponto: fundação multiempresa, PostgreSQL 18
-- Desenvolvimento com dados fictícios. Não constitui implementação REP-P certificada.
BEGIN;
CREATE EXTENSION IF NOT EXISTS pgcrypto;
CREATE TABLE IF NOT EXISTS tenants (
 id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
 legal_name text NOT NULL,
 display_name text NOT NULL,
 status text NOT NULL DEFAULT 'pilot' CHECK (status IN ('pilot','active','suspended')),
 created_at timestamptz NOT NULL DEFAULT now()
);
CREATE TABLE IF NOT EXISTS establishments (
 id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
 tenant_id uuid NOT NULL REFERENCES tenants(id),
 name text NOT NULL,
 created_at timestamptz NOT NULL DEFAULT now(),
 UNIQUE (tenant_id,id)
);
CREATE TABLE IF NOT EXISTS app_users (
 id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
 auth_subject text UNIQUE NOT NULL,
 display_name text NOT NULL,
 created_at timestamptz NOT NULL DEFAULT now()
);
CREATE TABLE IF NOT EXISTS memberships (
 tenant_id uuid NOT NULL REFERENCES tenants(id),
 user_id uuid NOT NULL REFERENCES app_users(id),
 role text NOT NULL CHECK(role IN ('owner','admin','leader','worker')),
 active boolean NOT NULL DEFAULT true,
 PRIMARY KEY(tenant_id,user_id)
);
CREATE TABLE IF NOT EXISTS teams (
 id uuid NOT NULL DEFAULT gen_random_uuid(),
 tenant_id uuid NOT NULL REFERENCES tenants(id),
 name text NOT NULL,
 leader_user_id uuid,
 created_at timestamptz NOT NULL DEFAULT now(),
 PRIMARY KEY(id),
 UNIQUE(tenant_id,id),
 FOREIGN KEY(tenant_id,leader_user_id) REFERENCES memberships(tenant_id,user_id)
);
CREATE TABLE IF NOT EXISTS worksites (
 id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
 tenant_id uuid NOT NULL REFERENCES tenants(id),
 name text NOT NULL,
 kind text NOT NULL DEFAULT 'worksite',
 latitude numeric(10,7) CHECK(latitude BETWEEN -90 AND 90),
 longitude numeric(10,7) CHECK(longitude BETWEEN -180 AND 180),
 radius_m integer NOT NULL DEFAULT 150 CHECK(radius_m BETWEEN 30 AND 1000),
 created_at timestamptz NOT NULL DEFAULT now(),
 UNIQUE(tenant_id,id),
 CHECK ((latitude IS NULL)=(longitude IS NULL))
);
CREATE TABLE IF NOT EXISTS workers (
 id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
 tenant_id uuid NOT NULL REFERENCES tenants(id),
 establishment_id uuid,
 team_id uuid,
 worksite_id uuid,
 display_name text NOT NULL,
 employment_type text NOT NULL DEFAULT 'CLT',
 status text NOT NULL DEFAULT 'active' CHECK(status IN ('active','leave','inactive')),
 created_at timestamptz NOT NULL DEFAULT now(),
 UNIQUE(tenant_id,id),
 FOREIGN KEY(tenant_id,establishment_id) REFERENCES establishments(tenant_id,id),
 FOREIGN KEY(tenant_id,team_id) REFERENCES teams(tenant_id,id),
 FOREIGN KEY(tenant_id,worksite_id) REFERENCES worksites(tenant_id,id)
);
CREATE TABLE IF NOT EXISTS work_schedules (
 id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
 tenant_id uuid NOT NULL REFERENCES tenants(id),
 name text NOT NULL,
 timezone text NOT NULL DEFAULT 'America/Sao_Paulo',
 definition jsonb NOT NULL DEFAULT '{}'::jsonb,
 created_at timestamptz NOT NULL DEFAULT now(),
 UNIQUE(tenant_id,id)
);
CREATE TABLE IF NOT EXISTS worker_schedules (
 tenant_id uuid NOT NULL REFERENCES tenants(id),
 worker_id uuid NOT NULL,
 schedule_id uuid NOT NULL,
 starts_on date NOT NULL,
 ends_on date,
 PRIMARY KEY(tenant_id,worker_id,starts_on),
 FOREIGN KEY(tenant_id,worker_id) REFERENCES workers(tenant_id,id),
 FOREIGN KEY(tenant_id,schedule_id) REFERENCES work_schedules(tenant_id,id),
 CHECK(ends_on IS NULL OR ends_on>=starts_on)
);
CREATE TABLE IF NOT EXISTS team_worksite_assignments (
 tenant_id uuid NOT NULL REFERENCES tenants(id),
 team_id uuid NOT NULL,
 worksite_id uuid NOT NULL,
 starts_on date NOT NULL,
 ends_on date,
 PRIMARY KEY(tenant_id,team_id,worksite_id,starts_on),
 FOREIGN KEY(tenant_id,team_id) REFERENCES teams(tenant_id,id),
 FOREIGN KEY(tenant_id,worksite_id) REFERENCES worksites(tenant_id,id),
 CHECK(ends_on IS NULL OR ends_on>=starts_on)
);
CREATE INDEX IF NOT EXISTS idx_workers_tenant_team ON workers(tenant_id,team_id);
CREATE INDEX IF NOT EXISTS idx_worksites_tenant ON worksites(tenant_id);
CREATE INDEX IF NOT EXISTS idx_memberships_user ON memberships(user_id);
-- RLS fail-closed: nenhuma role comum terá acesso sem políticas explícitas.
-- A API deverá usar usuário autenticado e contexto de tenant validado pelo servidor.
ALTER TABLE tenants ENABLE ROW LEVEL SECURITY;
ALTER TABLE establishments ENABLE ROW LEVEL SECURITY;
ALTER TABLE memberships ENABLE ROW LEVEL SECURITY;
ALTER TABLE teams ENABLE ROW LEVEL SECURITY;
ALTER TABLE worksites ENABLE ROW LEVEL SECURITY;
ALTER TABLE workers ENABLE ROW LEVEL SECURITY;
ALTER TABLE work_schedules ENABLE ROW LEVEL SECURITY;
ALTER TABLE worker_schedules ENABLE ROW LEVEL SECURITY;
ALTER TABLE team_worksite_assignments ENABLE ROW LEVEL SECURITY;
-- Não conceder privilégios ao usuário de aplicação até implementar políticas RLS e testes.
COMMIT;
