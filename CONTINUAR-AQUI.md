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
