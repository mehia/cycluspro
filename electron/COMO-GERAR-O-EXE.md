# Gerar o myhabits.exe (aplicativo nativo)

Este caminho produz um instalador `.exe` de verdade — aplicativo próprio, sem nenhuma
relação visual ou funcional com navegador. Exige rodar dois comandos uma única vez.

## Pré-requisito

Instale o **Node.js LTS**: https://nodejs.org (botão "LTS", instalação padrão,
avançar até o fim). Reinicie o terminal depois.

## Passo a passo

1. Abra o **Prompt de Comando** ou o **PowerShell**.
2. Entre nesta pasta:

   ```
   cd "C:\caminho\ate\myhabits\electron"
   ```

   (atalho: abra a pasta no Explorer, clique na barra de endereço, digite `cmd` e Enter)

3. Instale as dependências — demora alguns minutos na primeira vez:

   ```
   npm install
   ```

4. Teste antes de empacotar:

   ```
   npm start
   ```

   A janela do myhabits deve abrir. Feche.

5. Gere o instalador:

   ```
   npm run dist
   ```

6. O arquivo sai em `electron\dist\myhabits Setup 1.0.0.exe`.
   Execute, escolha a pasta e pronto: ícone na área de trabalho e no menu Iniciar.

## Observações

- O SmartScreen do Windows vai avisar que o app é de "editor desconhecido" — é
  esperado em qualquer executável sem certificado de assinatura digital (que é pago).
  Clique em "Mais informações" → "Executar assim mesmo".
- Os dados ficam em `%APPDATA%\myhabits`. São **independentes** do histórico que você
  tenha criado na versão de navegador ou no atalho — começam zerados.
- Para atualizar o app depois de mexer no `index.html`: copie o arquivo alterado para
  `electron\app\index.html` e rode `npm run dist` de novo.

## Estrutura

```
electron/
├── package.json     configuração do build
├── main.js          janela nativa, menu, instância única
└── app/             o aplicativo em si (index.html + ícones)
```
