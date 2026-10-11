-- MISSÃO 9 — V10.0.1 | Hotfix do RESET
-- Corrige o erro: DELETE requires a WHERE clause.
-- Não altera a chave de controle do professor.

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
