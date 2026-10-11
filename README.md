# Missão 9 — Data Driven

Experiência educacional interativa para o 9º ano, com três interfaces sincronizadas pelo Supabase:

- `professor.html` — painel de controle do professor
- `telao.html` — projeção da turma
- `aluno.html` — experiência individual do aluno
- `index.html` — página inicial

## Versão

V10.0.1 — piloto HTTPS/multidispositivo.

## Arquitetura

Professor, Telão e Alunos podem estar em dispositivos e redes diferentes. O estado da experiência é sincronizado pelo projeto Supabase.

## DECIDA

Fluxo protegido em duas etapas:

1. **APRESENTAR DECIDA** — desafio visível, interação do aluno bloqueada.
2. **LIBERAR DECISÃO** — estratégia e evidências são habilitadas.

A chave de controle do professor não fica gravada no HTML; é solicitada durante a sessão do painel.
