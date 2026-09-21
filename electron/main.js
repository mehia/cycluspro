// myhabits - aplicativo desktop (Electron)
// Janela nativa, sem navegador. Os dados continuam no armazenamento local,
// agora dentro da pasta de dados do proprio aplicativo.

const { app, BrowserWindow, Menu, shell } = require('electron');
const path = require('node:path');

let janela = null;

function criarJanela() {
  janela = new BrowserWindow({
    width: 1280,
    height: 860,
    minWidth: 380,
    minHeight: 520,
    backgroundColor: '#050505',
    title: 'cyclus',
    icon: path.join(__dirname, 'app', 'icons', 'fav-icon.png'),
    autoHideMenuBar: true,
    show: false,
    webPreferences: {
      contextIsolation: true,
      nodeIntegration: false,
      sandbox: true
    }
  });

  janela.loadFile(path.join(__dirname, 'app', 'index.html'));

  janela.once('ready-to-show', () => janela.show());

  // Links externos abrem no navegador padrao, nunca dentro do app.
  janela.webContents.setWindowOpenHandler(({ url }) => {
    shell.openExternal(url);
    return { action: 'deny' };
  });

  janela.on('closed', () => { janela = null; });
}

// Menu enxuto, so com o essencial.
const menu = Menu.buildFromTemplate([
  {
    label: 'cyclus',
    submenu: [
      { label: 'Recarregar', accelerator: 'CmdOrCtrl+R', role: 'reload' },
      { type: 'separator' },
      { label: 'Aumentar zoom', role: 'zoomIn' },
      { label: 'Diminuir zoom', role: 'zoomOut' },
      { label: 'Zoom normal', role: 'resetZoom' },
      { type: 'separator' },
      { label: 'Tela cheia', role: 'togglefullscreen' },
      { type: 'separator' },
      { label: 'Sair', accelerator: 'CmdOrCtrl+Q', role: 'quit' }
    ]
  }
]);
Menu.setApplicationMenu(menu);

// Uma instancia so: clicar no icone de novo traz a janela existente.
if (!app.requestSingleInstanceLock()) {
  app.quit();
} else {
  app.on('second-instance', () => {
    if (janela) {
      if (janela.isMinimized()) janela.restore();
      janela.focus();
    }
  });

  app.whenReady().then(() => {
    criarJanela();
    app.on('activate', () => {
      if (BrowserWindow.getAllWindows().length === 0) criarJanela();
    });
  });

  app.on('window-all-closed', () => {
    if (process.platform !== 'darwin') app.quit();
  });
}
