# Gerenciamento de Banco de Dados: Migrations e Seeds

Este documento explica como o sistema de migração e "seeding" (popular o banco) funciona neste projeto.

## Como Usar

Certifique-se de que seu arquivo `.env` na raiz do projeto está configurado com as credenciais corretas do banco de dados.

### Para Aplicar o Schema (Migrations)

Este comando irá ler o arquivo `schema.sql` e aplicar a estrutura de tabelas, funções e triggers ao seu banco de dados.

```bash
bun run db:migrate
```

### Para Popular o Banco de Dados (Seeds)

Este comando irá executar o arquivo `seeds.sql` para inserir dados iniciais no seu banco. Execute-o apenas **depois** de rodar a migração.

```bash
bun run db:seed
```

---

## Explicação Técnica do Script (`migrate.ts`)

O sistema utiliza um único script (`postgres/migrations/migrate.ts`) para realizar as duas tarefas (migrate e seed). Abaixo, uma explicação de como ele funciona.

### O Desafio: Encontrar o Caminho Correto

Um script Node.js, quando executado, não sabe onde seus próprios arquivos "irmãos" estão. Ele é executado a partir do diretório onde o comando `bun run` foi chamado (a raiz do projeto). Portanto, não podemos usar caminhos relativos simples como `../schema.sql` de forma confiável.

A solução é fazer com que o script descubra sua própria localização no sistema de arquivos e, a partir daí, construa um caminho seguro até os arquivos `schema.sql` e `seeds.sql`.

Isso é feito com o seguinte código:

```typescript
import path from 'path';
import { fileURLToPath } from 'url';

// 1. `import.meta.url`: Pega a URL completa do arquivo atual (migrate.ts).
const __filename = fileURLToPath(import.meta.url);

// 2. `path.dirname`: Extrai apenas o caminho do diretório onde o script está.
const __dirname = path.dirname(__filename);

// 3. `path.join`: Cria um caminho completo e seguro, não importa de onde o script seja chamado.
// '..' significa "subir um nível de diretório".
const schemaPath = path.join(__dirname, '..', 'schema.sql');
const seedsPath = path.join(__dirname, '..', 'seeds.sql');
```

### Um Script, Duas Tarefas

Para evitar duplicação de código, o script `migrate.ts` foi projetado para executar tanto a migração quanto o seeding.

Ele verifica se um argumento extra foi passado na linha de comando:

- **`bun run db:migrate`**: Executa `migrate.ts` sem argumentos. O script entende que deve aplicar o `schema.sql`.
- **`bun run db:seed`**: Executa `migrate.ts` com o argumento `seed`. O script vê esse argumento e entende que deve aplicar o `seeds.sql`.

Essa abordagem centraliza a lógica de conexão e execução em um só lugar, tornando o sistema mais robusto e fácil de manter.
