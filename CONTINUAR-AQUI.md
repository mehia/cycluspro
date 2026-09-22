# myhabits — estado do projeto (handoff)

Arquivo de passagem de contexto. Abra este projeto no Claude do computador e
peça: "leia o CONTINUAR-AQUI.md e siga daqui".

---

## O que é

Aplicativo web instalável (PWA) de rastreamento diário de hábitos, em grade:
hábitos nas linhas, dias do mês nas colunas. Nasceu de um HTML único chamado
"Desafio 30 Dias Capivara", renomeado para **myhabits**.

## Onde estão as coisas

```
myhabits/
├── index.html              app completo (HTML + CSS + JS em arquivo único)
├── manifest.webmanifest    nome, ícone, cor, modo janela
├── sw.js                   service worker (cache-first do app shell)
├── icons/                  192, 512, maskable 512, apple-touch 180, favicon 32, .ico
├── INSTALAR-NO-WINDOWS.bat instalador do atalho (chama instalar.ps1)
├── instalar.ps1            cria atalhos em modo aplicativo, perfil isolado
├── electron/               projeto Electron para gerar .exe nativo
├── LEIAME.md               instruções de instalação e hospedagem
└── CONTINUAR-AQUI.md       este arquivo
```

Existe também uma versão publicada como artifact na conta claude.ai
(gallery: claude.ai/code/artifacts, título "myhabits"). Ela usa o mesmo código,
sem o `<head>` próprio — o artifact injeta o dele.

## Decisões já tomadas

| Tema | Decisão |
|---|---|
| Formato | PWA instalável, não Electron |
| Plataformas | Windows + celular |
| Dados | Só no aparelho (localStorage), sem sincronização |
| Design | Mantido igual ao HTML original: roxo escuro, Fraunces + Sora, ícone de capivara |
| Idioma | Português do Brasil |

## Como funciona por dentro

- **Estado**: objeto único em `localStorage`, chave `capivara-habit-tracker-v1`.
  Formato: `{ habits: [{id, name}], marks: { "AAAA-MM": { habitId: { dia: "done"|"miss" } } }, currentMonth }`
- **Dias do mês**: `new Date(y, m+1, 0).getDate()` — já trata 30, 31 e fevereiro bissexto.
- **Ciclo do clique**: vazio → `done` → `miss` → vazio.
- **`render()`** redesenha a grade inteira; **`paintTotals(nd)`** recalcula só os
  contadores e os cartões, e é chamada a cada clique para o progresso reagir na hora.
- **PWA**: `beforeinstallprompt` alimenta o botão "Instalar aplicativo" no topo;
  o service worker é registrado no `load`.

## Correções já aplicadas

1. Renomeado de "Desafio 30 Dias Capivara" para "myhabits" (título, H1, rodapé e
   dois nomes de hábitos que citavam o desafio).
2. Os cartões de progresso não atualizavam ao marcar um dia — só ao trocar de mês.
   Corrigido com `paintTotals()`.

## Uso no desktop (sem navegador)

Três caminhos, do mais simples ao mais definitivo:

1. **Atalho em modo aplicativo** (`INSTALAR-NO-WINDOWS.bat`) — implementado e é o
   padrão recomendado. Usa o motor do Chrome/Edge já instalado, com
   `--app=file:///...`, `--user-data-dir=%LOCALAPPDATA%\myhabits\perfil`,
   `--no-first-run`. Nenhum elemento de navegador aparece. Confirmado em teste:
   `localStorage` em `file://` grava e persiste entre reinícios do app.
   Limitação: o atalho aponta para o caminho absoluto da pasta — mover a pasta quebra.
2. **Electron** (`electron/`) — projeto pronto, ainda **não compilado**. Gera
   `.exe` com instalador NSIS. Exige Node.js na máquina do usuário.
   Os dados ficam em `%APPDATA%\myhabits` e são independentes dos outros caminhos.
3. **PWA hospedado** — exige endereço https. Não hospedado ainda.

Os três guardam dados em locais diferentes: são históricos separados, não se conversam.

## Pontos abertos / próximos passos possíveis

- **Hospedagem**: o app precisa de um endereço `https://` para ser instalável.
  Ainda não foi hospedado. Caminhos no `LEIAME.md` (GitHub Pages ou Netlify).
- **Sincronização entre aparelhos**: não existe. PC e celular têm históricos
  separados. Exige backend ou armazenamento compartilhado — mudança de arquitetura.
- **Backup**: não há exportar/importar. Limpar dados do navegador apaga o histórico.
- **Sem desfazer** no botão "Limpar mês".
- **Progresso do mês** conta todos os dias do mês como possíveis, inclusive os
  futuros — no dia 10 o teto é ~33%. Alternativa: calcular sobre os dias já
  decorridos. Não foi alterado porque não foi pedido.
- **Fontes**: carregadas do Google Fonts. Offline, caem para as fontes do sistema.
  Se quiser offline 100% fiel, empacotar os .woff2 localmente.

## Ao retomar

Peça o que quiser direto: "hospeda no GitHub Pages", "adiciona exportar backup",
"muda o cálculo do progresso para os dias decorridos", "coloca sequência/streak".

---

## Atualização — 2026-09-22

### O que mudou desde a versão acima

Este documento (a parte de cima) ficou desatualizado: o app **já tem login e
sincronização via Firebase** (Auth por e-mail/senha + Firestore), não é mais
"só localStorage". Isso foi feito antes desta sessão, no commit inicial do
repositório GitHub `mehia/cycluspro`.

### Estado atual

- **Repositório:** https://github.com/mehia/cycluspro (público)
- **Hospedado via GitHub Pages em:** https://mehia.github.io/cycluspro/
- **Projeto Firebase:** `cyclusz` (Auth + Firestore)
- Domínio `mehia.github.io` já foi adicionado em Authorized domains no Firebase.
- Objetivo do usuário: transformar o app em "app de celular" — decidido usar
  o caminho PWA (instalar direto do navegador), não Capacitor/nativo por ora.

### Bug encontrado e corrigido nesta sessão

`sw.js` cacheava (cache-first) **qualquer** requisição GET, inclusive chamadas
do SDK do Firebase para domínios do Google (`googleapis.com`,
`firebaseapp.com`, `gstatic.com`). Isso fazia o app usar respostas antigas
cacheadas mesmo depois de corrigir configurações no Firebase Console (ex:
autorizar o domínio), resultando em: login parece completar (sem erro, botão
volta ao normal) mas a tela de login nunca some.

**Correção aplicada e já enviada ao GitHub** (commit `31a0c40`):
chamadas para esses domínios agora pulam o cache do service worker
(`if (isFirebase) return;`), e o nome do cache mudou de `myhabits-v1` para
`myhabits-v2` para forçar a limpeza do cache antigo em quem já tinha
instalado o app.

### Pendente / não confirmado ainda

- **Não confirmamos se o login funciona agora** após a correção. O usuário
  ainda precisa: esperar o Pages atualizar (~1min), forçar reload
  (Ctrl+Shift+R) ou desregistrar o service worker antigo em
  DevTools → Application → Service Workers, e testar login/cadastro de novo.
- Se ainda falhar: pedir o texto exato de qualquer erro no Console (F12), e
  conferir se existe usuário duplicado/conflitante criado manualmente antes
  em Firebase Console → Authentication → Users (aconteceu nesta sessão: um
  e-mail foi cadastrado manualmente lá, o que pode conflitar com "criar
  conta" pelo próprio app pedindo o mesmo e-mail — nesse caso apagar o
  usuário manual e recriar pelo app, ou logar em vez de cadastrar).
- Teste de instalação como PWA no celular (Android/iPhone) ainda não foi
  confirmado pelo usuário — só a hospedagem foi validada.

### Ao retomar (sessão atual)

Peça: "confirma se o login/sync do Firebase já funciona" ou "testa a
instalação como PWA no celular" — ou, se o usuário disser que ainda não
funciona, peça o erro exato do Console (F12) antes de mexer em mais nada.
