import fs from "fs";
import path from "path";
import { fileURLToPath } from "url";
import { Client } from "pg";
import dotenv from "dotenv";

// --- LÓGICA PARA RESOLVER O CAMINHO ---
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

// Carrega as variáveis de ambiente do arquivo .env na raiz do projeto.
dotenv.config({ path: path.resolve(__dirname, "..", "..", ".env") });

const schemaPath = path.join(__dirname, "..", "schema.sql");
const seedsPath = path.join(__dirname, "..", "seeds.sql");
// --- FIM DA LÓGICA ---

/**
 * Instância do cliente PostgreSQL para executar os scripts.
 * @type {Client}
 */
const client: Client = new Client({
    connectionString: process.env.DATABASE_URL,
});

/**
 * Executa o script de migração do schema ou de inserção de seeds no banco de dados.
 * @param {boolean} [isSeed=false] - Se verdadeiro, executa o script de seeds. Caso contrário, executa o script do schema.
 * @returns {Promise<void>}
 */ async function runScript(isSeed: boolean = false): Promise<void> {
    try {
        await client.connect();
        console.log("✅ Conectado ao PostgreSQL!");

        if (isSeed) {
            console.log(`🔍 Procurando seeds em: ${seedsPath}`);
            if (fs.existsSync(seedsPath)) {
                const seeds = fs.readFileSync(seedsPath, "utf8");
                console.log("🌱 Rodando seeds...");
                await client.query(seeds);
                console.log("✅ Seeds aplicados com sucesso!");
            } else {
                console.log("🟡 Arquivo de seeds não encontrado. Pulando...");
            }
        } else {
            console.log(`🔍 Lendo schema de: ${schemaPath}`);
            const schema = fs.readFileSync(schemaPath, "utf8");
            console.log("📌 Aplicando schema...");
            await client.query(schema);
            console.log("✅ Migração do schema concluída!");
        }
    } catch (err) {
        console.error("❌ Erro ao executar o script:", err);
        process.exit(1);
    } finally {
        await client.end();
        console.log("🚪 Conexão com o banco de dados fechada.");
    }
}

// Verifica se o argumento 'seed' foi passado na linha de comando para determinar qual script rodar.
const arg = process.argv[2];
runScript(arg === "seed");