# Fatec Mobile Device Programming - Apps

Este repositório contém exemplos de aplicativos desenvolvidos para a disciplina de Programação para Dispositivos Móveis, utilizando Node.js (API) e Flutter (aplicativo mobile).

---

## 1. Gerenciador de Tarefas

**Descrição:**
Aplicativo para gerenciar tarefas, permitindo adicionar, editar, marcar como concluída e excluir tarefas.

### Backend (Node.js)
- Local: `task_manager/task-manager-api`
- Como rodar:
  1. Instale as dependências: `npm install`
  2. Inicie o servidor: `node index.js`
  3. API disponível em: `http://localhost:3000`

### Frontend (Flutter)
- Local: `task_manager/task_manager_app`
- Como rodar:
  1. Instale as dependências: `flutter pub get`
  2. Execute o app: `flutter run`
  3. Configure o IP da API se necessário (emulador/dispositivo físico)

---

## 2. Catálogo de Produtos

**Descrição:**
Aplicativo para visualizar produtos, com dados offline e sincronização inicial com a API.

### Backend (Node.js)
- Local: `product_catalog/product-catalog-api`
- Como rodar:
  1. Instale as dependências: `npm install`
  2. Inicie o servidor: `node index.js`
  3. API disponível em: `http://localhost:3001`

### Frontend (Flutter)
- Local: `product_catalog/product_catalog_app`
- Como rodar:
  1. Instale as dependências: `flutter pub get`
  2. Execute o app: `flutter run`
  3. Configure o IP da API se necessário

---

## 3. Gerenciador de Contatos

**Descrição:**
Aplicativo para gerenciar contatos, sincronizando dados entre API e banco local SQLite.

### Backend (Node.js)
- Local: `contact_manager/contact-manager-api`
- Como rodar:
  1. Instale as dependências: `npm install`
  2. Inicie o servidor: `node index.js`
  3. API disponível em: `http://localhost:3002`

### Frontend (Flutter)
- Local: `contact_manager/contact_manager_app`
- Como rodar:
  1. Instale as dependências: `flutter pub get`
  2. Execute o app: `flutter run`
  3. Configure o IP da API se necessário

---

## 4. Aplicativo de Notícias

**Descrição:**
Aplicativo para exibir notícias e salvar favoritos offline no SQLite.

### Backend (Node.js)
- Local: `news-app/news-app-api`
- Como rodar:
  1. Instale as dependências: `npm install`
  2. Inicie o servidor: `node index.js`
  3. API disponível em: `http://localhost:3003`

### Frontend (Flutter)
- Local: `news-app/news_app`
- Como rodar:
  1. Instale as dependências: `flutter pub get`
  2. Execute o app: `flutter run`
  3. Configure o IP da API se necessário

---

## Observações Gerais
- Para rodar o backend, é necessário ter o Node.js instalado.
- Para rodar o frontend, é necessário ter o Flutter instalado.
- Se for testar em dispositivo físico, troque `localhost` pelo IP da máquina onde está rodando a API.
- Os bancos SQLite dos apps Flutter ficam salvos localmente no dispositivo/emulador.


