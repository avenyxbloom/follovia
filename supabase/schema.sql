-- Follovia initial Supabase schema (apply only after creating a Supabase project)
-- This schema is a starting point. Review policies and test with separate accounts before production.

create extension if not exists pgcrypto;

create table if not exists public.workspaces (
  id uuid primary key default gen_random_uuid(),
  name text not null default 'My Business',
  owner_id uuid not null references auth.users(id) on delete cascade,
  created_at timestamptz not null default now()
);

create table if not exists public.workspace_members (
  workspace_id uuid not null references public.workspaces(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  role text not null default 'owner' check (role in ('owner','admin','member')),
  created_at timestamptz not null default now(),
  primary key (workspace_id, user_id)
);

create table if not exists public.customers (
  id uuid primary key default gen_random_uuid(),
  workspace_id uuid not null references public.workspaces(id) on delete cascade,
  name text not null,
  email text,
  phone text,
  company text,
  source text,
  status text not null default 'New' check (status in ('New','Replied','Interested','Quoted','Won','Lost')),
  estimated_value numeric(12,2) not null default 0 check (estimated_value >= 0),
  currency_code char(3) not null default 'USD',
  follow_up_at date,
  notes text,
  created_by uuid references auth.users(id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists customers_workspace_created_idx on public.customers(workspace_id, created_at desc);
create index if not exists customers_workspace_followup_idx on public.customers(workspace_id, follow_up_at);

alter table public.workspaces enable row level security;
alter table public.workspace_members enable row level security;
alter table public.customers enable row level security;

-- A signed-in user can read their own membership rows.
create policy "members can view workspace membership"
on public.workspace_members for select
to authenticated
using (user_id = auth.uid());

-- A user can read a workspace only if they are a member.
create policy "members can view workspaces"
on public.workspaces for select
to authenticated
using (exists (
  select 1 from public.workspace_members m
  where m.workspace_id = workspaces.id and m.user_id = auth.uid()
));

-- Customer access is restricted to workspaces where the user is a member.
create policy "members can read customers"
on public.customers for select
to authenticated
using (exists (
  select 1 from public.workspace_members m
  where m.workspace_id = customers.workspace_id and m.user_id = auth.uid()
));

create policy "members can insert customers"
on public.customers for insert
to authenticated
with check (exists (
  select 1 from public.workspace_members m
  where m.workspace_id = customers.workspace_id and m.user_id = auth.uid()
));

create policy "members can update customers"
on public.customers for update
to authenticated
using (exists (
  select 1 from public.workspace_members m
  where m.workspace_id = customers.workspace_id and m.user_id = auth.uid()
))
with check (exists (
  select 1 from public.workspace_members m
  where m.workspace_id = customers.workspace_id and m.user_id = auth.uid()
));

create policy "members can delete customers"
on public.customers for delete
to authenticated
using (exists (
  select 1 from public.workspace_members m
  where m.workspace_id = customers.workspace_id and m.user_id = auth.uid()
));
