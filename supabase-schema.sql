-- Supabase schema para The 3rd Semester Awards
create extension if not exists pgcrypto;
create table if not exists public.participants (
 id uuid primary key default gen_random_uuid(),
 display_name text not null,
 active boolean not null default true,
 created_at timestamptz not null default now()
);
create table if not exists public.categories (
 id uuid primary key default gen_random_uuid(),
 title text not null,
 description text,
 sort_order integer not null default 0,
 is_open boolean not null default false,
 created_at timestamptz not null default now()
);
create table if not exists public.voter_tokens (
 id uuid primary key default gen_random_uuid(),
 token_hash text not null unique,
 active boolean not null default true,
 created_at timestamptz not null default now()
);
create table if not exists public.votes (
 id uuid primary key default gen_random_uuid(),
 category_id uuid not null references public.categories(id) on delete cascade,
 participant_id uuid not null references public.participants(id),
 voter_token_id uuid not null references public.voter_tokens(id),
 created_at timestamptz not null default now(),
 unique(category_id,voter_token_id)
);
alter table public.participants enable row level security;
alter table public.categories enable row level security;
alter table public.voter_tokens enable row level security;
alter table public.votes enable row level security;
create policy "public can read active participants" on public.participants for select using(active=true);
create policy "public can read categories" on public.categories for select using(true);
-- Segurança: NÃO permitir INSERT público direto em votes nem SELECT público de votos/tokens.
-- A versão de produção deve registrar votos por Edge Function/RPC que:
-- 1) valida o token (hash), 2) verifica categoria aberta, 3) verifica participante ativo,
-- 4) insere voto em transação e respeita UNIQUE(category_id,voter_token_id).
-- Painel administrativo protegido por autenticação e políticas específicas.
