-- MISSÃO 9 — V10.0.2
-- PIN simples do professor + correção do RESET.
--
-- ANTES DE EXECUTAR:
-- substitua COLE_SEU_PIN_AQUI pelo PIN escolhido.
-- Não publique uma cópia deste arquivo depois de inserir o PIN.

insert into public.m9_control_secret(id,secret)
values ('main','COLE_SEU_PIN_AQUI')
on conflict (id) do update
set secret=excluded.secret;

create or replace function public.m9_validate_teacher_pin(p_secret text)
returns boolean
language sql
security definer
stable
set search_path=public
as $$
  select exists(
    select 1
    from public.m9_control_secret
    where id='main' and secret=p_secret
  );
$$;

revoke all on function public.m9_validate_teacher_pin(text) from public;
grant execute on function public.m9_validate_teacher_pin(text) to anon, authenticated;

create or replace function public.m9_reset_simulation(p_secret text)
returns public.experiment_state
language plpgsql
security definer
set search_path=public
as $$
declare
  outrow public.experiment_state;
begin
  if not exists(
    select 1
    from public.m9_control_secret
    where id='main' and secret=p_secret
  ) then
    raise exception 'Controle não autorizado';
  end if;

  delete from public.decision_answers where true;
  delete from public.investigation_answers where true;
  delete from public.feed_events where true;
  delete from public.attention where true;
  delete from public.reactions where true;
  delete from public.sessions where true;

  update public.experiment_state
  set status='waiting',
      reveal_stage=0,
      closing_stage=1,
      winning_theme=null,
      winning_group='ALL',
      run_id=gen_random_uuid()::text,
      updated_at=now()
  where id='main'
  returning * into outrow;

  return outrow;
end;
$$;

revoke all on function public.m9_reset_simulation(text) from public;
grant execute on function public.m9_reset_simulation(text) to anon, authenticated;
