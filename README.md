# 📋todo-it

Este é um aplicativo em Flutter simples para gerenciamento de tarefas, com autenticação de usuários, cadastro, edição e exclusão de tarefas. Os dados são armazenados e sincronizados com um backend PHP e banco de dados em PostgreSQL

## ⚙️ Funcionalidades

- Autenticação de usuário (login/cadastro)
- Tela inicial com listagem de tarefas
- Cadastro de novas tarefas
- Edição e exclusão de tarefas
- Armazenamento de preferência de tema com SharedPreferences

## 🧪 Requisitos

- Flutter SDK
- Backend PHP com endpoints:
  - usuario.php
   - /acao=cadastrarUsuario
   - /acao=login
  - tarefa.php
   - /acao=listarTarefas
   - /acao=cadastrarTarefa
   - /acao=editarTarefa
   - /acao=excluirTarefa
   - /acao=buscarTarefaPorId
   - /acao=alterarStatus
   - /acao=buscarTarefa

## ▶️ Execução

1. Clone o repositório:
   ```bash
   git clone https://github.com/ccarolb/todoit-app.git
   cd todoit-app
   ```

2. Instale as dependências:
   ```bash
   flutter pub get
   ```

3. Execute o projeto:
   ```bash
   flutter run
   ```

4. Para rodar local, substitua o ip nos arquivos tarefa_service e usuario_service pelo ip da sua máquina.
