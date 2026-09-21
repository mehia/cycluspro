# myhabits - cria o atalho do aplicativo no Windows
# Abre o app em janela propria (modo aplicativo), sem barra de navegador,
# com perfil isolado - limpar dados de navegacao NAO apaga o historico de habitos.

$ErrorActionPreference = 'Stop'

function Escrever($texto, $cor = 'Gray') { Write-Host "  $texto" -ForegroundColor $cor }

$base  = Split-Path -Parent $MyInvocation.MyCommand.Path
$html  = Join-Path $base 'index.html'
$icone = Join-Path $base 'icons\myhabits.ico'

if (-not (Test-Path $html)) {
    Escrever "ERRO: index.html nao foi encontrado nesta pasta." 'Red'
    Escrever "Mantenha o instalador dentro da pasta myhabits e tente de novo." 'Red'
    exit 1
}

# ---- 1. Localizar o navegador (Chrome ou Edge) ----
$candidatos = @(
    "$env:ProgramFiles\Google\Chrome\Application\chrome.exe",
    "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe",
    "$env:LOCALAPPDATA\Google\Chrome\Application\chrome.exe",
    "$env:ProgramFiles\Microsoft\Edge\Application\msedge.exe",
    "${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe"
)

$navegador = $candidatos | Where-Object { Test-Path $_ } | Select-Object -First 1

if (-not $navegador) {
    Escrever "ERRO: nao encontrei o Google Chrome nem o Microsoft Edge." 'Red'
    Escrever "Instale um dos dois e rode este instalador de novo." 'Red'
    exit 1
}

$nomeNav = if ($navegador -like '*chrome.exe') { 'Google Chrome' } else { 'Microsoft Edge' }
Escrever "Motor encontrado: $nomeNav" 'DarkGray'

# ---- 2. Montar os argumentos ----
$perfil = Join-Path $env:LOCALAPPDATA 'myhabits\perfil'
New-Item -ItemType Directory -Force -Path $perfil | Out-Null

$url = 'file:///' + (($html -replace '\\', '/') -replace ' ', '%20')

$argumentos = @(
    "--app=`"$url`"",
    "--user-data-dir=`"$perfil`"",
    '--no-first-run',
    '--no-default-browser-check',
    '--disable-features=Translate,MediaRouter',
    '--window-size=1280,860'
) -join ' '

# ---- 3. Criar os atalhos ----
$shell = New-Object -ComObject WScript.Shell

$destinos = @(
    (Join-Path ([Environment]::GetFolderPath('Desktop')) 'myhabits.lnk'),
    (Join-Path $env:APPDATA 'Microsoft\Windows\Start Menu\Programs\myhabits.lnk')
)

foreach ($destino in $destinos) {
    $pasta = Split-Path -Parent $destino
    if (-not (Test-Path $pasta)) { New-Item -ItemType Directory -Force -Path $pasta | Out-Null }

    $atalho = $shell.CreateShortcut($destino)
    $atalho.TargetPath       = $navegador
    $atalho.Arguments        = $argumentos
    $atalho.WorkingDirectory = $base
    $atalho.Description      = 'myhabits - rastreador de habitos'
    if (Test-Path $icone) { $atalho.IconLocation = "$icone,0" }
    $atalho.Save()
}

Escrever ""
Escrever "PRONTO." 'Green'
Escrever ""
Escrever "Atalho criado na Area de Trabalho e no menu Iniciar."   'White'
Escrever "Procure por 'myhabits' no menu Iniciar e clique com o"  'DarkGray'
Escrever "botao direito para fixar na barra de tarefas."          'DarkGray'
Escrever ""
Escrever "IMPORTANTE: nao mova nem renomeie esta pasta."          'Yellow'
Escrever "O atalho aponta para o arquivo dentro dela."            'Yellow'
Escrever ""

# ---- 4. Abrir o app agora ----
$abrir = Read-Host "  Abrir o myhabits agora? (S/N)"
if ($abrir -match '^[SsYy]') {
    Start-Process -FilePath $navegador -ArgumentList $argumentos
}
