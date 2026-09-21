# myhabits — aplicativo de hábitos

Aplicativo web instalável (PWA). Abre em janela própria, com ícone no desktop e na
tela inicial do celular, e funciona **offline**. Os dados ficam salvos **só no aparelho**
onde você marca (nada vai para servidor, nada precisa de login).

---

## Conteúdo da pasta

```
INSTALAR-NO-WINDOWS.bat  <- comece por aqui no PC
instalar.ps1             script chamado pelo .bat (cria os atalhos)
index.html               o aplicativo
manifest.webmanifest     identidade do app (nome, ícone, cor, modo janela)
sw.js                    service worker: faz o app abrir offline quando hospedado
icons/                   ícones em todos os tamanhos (Windows, Android, iPhone)
electron/                projeto para gerar um .exe nativo (opcional)
LEIAME.md                este arquivo
CONTINUAR-AQUI.md        estado do projeto, para retomar com o Claude
```

---

## Instalar no Windows — sem navegador, sem internet, sem hospedagem

**Este é o caminho mais rápido. Dois cliques.**

1. Descompacte a pasta `myhabits` onde ela vai ficar em definitivo
   (sugestão: `Documentos\myhabits`).
2. Dê duplo clique em **`INSTALAR-NO-WINDOWS.bat`**.

Pronto. Você ganha um ícone **myhabits** na área de trabalho e no menu Iniciar.
Clicando nele, o app abre em janela própria: sem abas, sem barra de endereço, sem
nada de navegador na tela. Funciona sem internet.

Para fixar na barra de tarefas: menu Iniciar → botão direito em myhabits → Fixar.

> O instalador usa o motor do Chrome (ou do Edge) que já está no seu PC, em modo
> aplicativo e com perfil isolado. Na prática você nunca vê um navegador — e limpar
> dados de navegação **não** apaga seu histórico de hábitos.
>
> **Não mova nem renomeie a pasta depois de instalar.** O atalho aponta para dentro
> dela. Se precisar mover, mova e rode o `.bat` de novo.

Para desinstalar: apague os atalhos e a pasta. Os dados ficam em
`%LOCALAPPDATA%\myhabits`.

### Aplicativo nativo (.exe), sem depender do Chrome

Se quiser um executável independente de verdade, o projeto está em `electron/`
com o passo a passo em `electron/COMO-GERAR-O-EXE.md`. Exige instalar o Node.js
e rodar dois comandos. O resultado é um instalador `.exe` comum.

## Instalar como PWA (opcional, exige hospedagem)

## Instalar no celular

**Android (Chrome):** abra o link → menu `⋮` → **Adicionar à tela inicial** / **Instalar app**.

**iPhone (Safari):** abra o link → botão Compartilhar → **Adicionar à Tela de Início**.

Depois de instalado, o app abre sem a barra do navegador e funciona no modo avião.

---

## Hospedar você mesmo (opcional, mas recomendado)

Hospedar significa: o app fica em um endereço https só seu, independente de qualquer
conversa ou plataforma. Duas opções gratuitas:

**GitHub Pages**
1. Crie uma conta em github.com e um repositório novo, público, chamado `myhabits`.
2. Envie todos os arquivos desta pasta para o repositório (botão *Add file → Upload files*).
3. Vá em *Settings → Pages*, em **Source** escolha `main` / pasta `/ (root)` e salve.
4. Em cerca de um minuto o endereço `https://SEU-USUARIO.github.io/myhabits/` fica no ar.
   É esse link que você abre no PC e no celular para instalar.

**Netlify**
1. Crie uma conta em netlify.com.
2. Em *Sites*, arraste esta pasta inteira para a área de upload.
3. O endereço https sai pronto na hora.

> Importante: o app **precisa** estar em um endereço `http://` ou `https://` para ser
> instalável. Abrir o `index.html` com duplo clique (`file://`) mostra a página, mas o
> Windows não oferece a opção de instalar e o armazenamento local fica instável.

---

## Como usar

- **Clique em um dia** para alternar: vazio → verde (feito) → vermelho (não feito) → vazio.
- **Clique no nome** de um hábito para renomear.
- **×** no fim da linha remove o hábito.
- Campo de baixo adiciona hábitos novos.
- O seletor de mês guarda um histórico separado por mês, com o número correto de dias
  (30, 31 ou 28/29 em fevereiro).
- **Limpar mês** apaga só as marcações do mês aberto. Não tem desfazer.

## Onde ficam os dados

No armazenamento local do navegador/app, na chave `capivara-habit-tracker-v1`.
Consequências práticas:

- Marcações feitas no PC **não aparecem** no celular. São históricos independentes.
- Limpar dados de navegação com a opção "dados de sites" apaga o histórico do app.
- Desinstalar o app pode apagar os dados.

Se em algum momento quiser backup, sincronização entre aparelhos ou exportação para
planilha, dá para acrescentar — é uma mudança de arquitetura, não um ajuste de tela.
