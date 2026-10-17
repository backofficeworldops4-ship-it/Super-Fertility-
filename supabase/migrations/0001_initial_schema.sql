-- SuperFertility Phase 1 schema foundation. Do not apply to production without client security/privacy review.
create extension if not exists pgcrypto;
create type public.app_role as enum ('patient','psychiatrist','gp','internal_qc','admin');
create type public.case_status as enum ('application','payment_pending','intake_consent','report_preparation','qc1','psychiatrist_consultation','psychiatrist_review','gp_consultation','gp_review','qc2','released','missed_appointment_hold');
create table public.profiles (
 id uuid primary key references auth.users(id) on delete cascade,
 display_name text not null,
 role public.app_role not null default 'patient',
 created_at timestamptz not null default now()
);
create table public.cases (
 id uuid primary key default gen_random_uuid(),
 case_number text unique not null,
 case_type text not null check (case_type in ('single','partner')),
 status public.case_status not null default 'application',
 payment_status text not null default 'pending',
 psychiatrist_id uuid references public.profiles(id),
 gp_id uuid references public.profiles(id),
 qc1_status text not null default 'pending', qc2_status text not null default 'pending',
 created_by uuid references public.profiles(id), created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
create table public.applicants (
 id uuid primary key default gen_random_uuid(), case_id uuid not null references public.cases(id) on delete cascade,
 profile_id uuid references public.profiles(id), display_name text not null, email text,
 consent_status text not null default 'pending', report_expiry date,
 created_at timestamptz not null default now()
);
create table public.reports (
 id uuid primary key default gen_random_uuid(), case_id uuid not null references public.cases(id) on delete cascade,
 applicant_id uuid not null references public.applicants(id) on delete cascade,
 report_type text not null check (report_type in ('psychiatrist','gp')),
 status text not null default 'draft', version integer not null default 1,
 storage_path text, signed_at timestamptz, released_at timestamptz,
 created_at timestamptz not null default now(), updated_at timestamptz not null default now()
);
create table public.audit_events (
 id uuid primary key default gen_random_uuid(), case_id uuid references public.cases(id) on delete set null,
 actor_id uuid references public.profiles(id), event_type text not null, details jsonb not null default '{}'::jsonb,
 created_at timestamptz not null default now()
);
create table public.integration_events (
 id uuid primary key default gen_random_uuid(), case_id uuid references public.cases(id) on delete set null,
 provider text not null, event_type text not null, status text not null default 'queued',
 external_reference text, safe_error text, created_at timestamptz not null default now()
);
-- RLS must be enabled and tested with explicit applicant/partner access policies before any production data is loaded.
alter table public.profiles enable row level security;
alter table public.cases enable row level security;
alter table public.applicants enable row level security;
alter table public.reports enable row level security;
alter table public.audit_events enable row level security;
alter table public.integration_events enable row level security;
