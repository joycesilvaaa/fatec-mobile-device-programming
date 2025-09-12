# 📋 Lista de Prioridades

Um aplicativo Flutter para gerenciar tarefas com níveis de prioridade (Alta, Média, Baixa) utilizando SQLite como banco de dados.

## 🎯 Funcionalidades

- ✅ **Adicionar Tarefas**: Criar novas tarefas com nome e nível de prioridade
- 📝 **Editar Tarefas**: Modificar tarefas existentes
- 🗑️ **Deletar Tarefas**: Remover tarefas com confirmação
- 🎨 **Filtros por Prioridade**: Visualizar tarefas por nível de prioridade
- 📊 **Contadores**: Ver quantas tarefas existem em cada categoria
- 🔄 **Ordenação Automática**: Tarefas são ordenadas por prioridade (Alta → Média → Baixa)

## 🏗️ Estrutura do Projeto

```
lib/
├── main.dart                           # Ponto de entrada da aplicação
├── models/
│   └── tarefa.dart                     # Modelo de dados da Tarefa
├── services/
│   └── database_helper.dart            # Gerenciador do banco SQLite
└── screens/
    ├── task_list_screen.dart           # Tela principal (lista de tarefas)
    └── adicionar_tarefa_screen.dart     # Tela para adicionar/editar tarefas
```

## 🎨 Interface

### Níveis de Prioridade
- 🔴 **Alta**: Cor vermelha com ícone `priority_high`
- 🟠 **Média**: Cor laranja com ícone `remove`
- 🟢 **Baixa**: Cor verde com ícone `keyboard_arrow_down`

### Funcionalidades da Interface
- **Chips de Filtro**: Filtrar tarefas por prioridade com contadores
- **Cards Organizados**: Cada tarefa em um card com visual hierárquico
- **Ações Rápidas**: Botões para editar e deletar tarefas
- **Formulário Intuitivo**: Interface amigável para adicionar/editar tarefas

## 💾 Banco de Dados

### Tabela: `tarefas`
```sql
CREATE TABLE tarefas(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  nome TEXT NOT NULL,
  prioridade TEXT NOT NULL
)
```

## 🚀 Como Executar

1. **Clone/Acesse o projeto**:
   ```bash
   cd /Users/pedromartinsdeoliveira/Fatec/Flutter/priority_list
   ```

2. **Instale as dependências**:
   ```bash
   flutter pub get
   ```

3. **Execute o aplicativo**:
   ```bash
   flutter run
   ```

## 📦 Dependências

- `flutter`: SDK principal
- `sqflite: ^2.3.3+1`: Banco de dados SQLite
- `path: ^1.9.0`: Manipulação de caminhos de arquivos

---

**Desenvolvido com ❤️ em Flutter**
