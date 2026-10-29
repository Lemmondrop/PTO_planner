-- 월차 관리: Supabase SQL Editor 에 통째로 붙여넣고 Run 하세요.
-- 본인 계정(auth.uid())의 데이터만 읽고 쓸 수 있도록 RLS 를 켭니다.

-- 1) 설정 (사용자당 1행)
create table if not exists public.leave_settings (
  user_id          uuid primary key default auth.uid() references auth.users(id) on delete cascade,
  join_date        date        not null,
  probation_months int         not null default 3 check (probation_months between 0 and 24),
  carry_over       boolean     not null default false,
  holiday_add      jsonb       not null default '{}'::jsonb,   -- {"2026-04-10": "창립기념일"}
  holiday_off      jsonb       not null default '[]'::jsonb,   -- ["2026-05-01"]
  updated_at       timestamptz not null default now()
);

-- 2) 월차 기록 (하루 1행, 연휴는 grp 로 묶음)
create table if not exists public.leaves (
  id          text        not null,
  user_id     uuid        not null default auth.uid() references auth.users(id) on delete cascade,
  date        date        not null,
  kind        text        not null check (kind in ('full','am','pm')),
  reason      text        not null default '',
  grp         text,
  range_start date,
  range_end   date,
  created_at  timestamptz not null default now(),
  primary key (user_id, id)
);
create index if not exists leaves_user_date_idx on public.leaves (user_id, date);

-- 3) RLS: 본인 데이터만
alter table public.leave_settings enable row level security;
alter table public.leaves         enable row level security;

drop policy if exists "own settings" on public.leave_settings;
create policy "own settings" on public.leave_settings
  for all to authenticated
  using (user_id = (select auth.uid()))
  with check (user_id = (select auth.uid()));

drop policy if exists "own leaves" on public.leaves;
create policy "own leaves" on public.leaves
  for all to authenticated
  using (user_id = (select auth.uid()))
  with check (user_id = (select auth.uid()));
