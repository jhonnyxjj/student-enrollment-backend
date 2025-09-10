import { Client } from "pg";
import dotenv from "dotenv";

dotenv.config();

/**
 * Instância do cliente PostgreSQL.
 * Utiliza a string de conexão da variável de ambiente DATABASE_URL.
 * @type {Client}
 */
const client = new Client({
    connectionString: process.env.DATABASE_URL,
});

/**
 * Conecta-se ao banco de dados PostgreSQL.
 * A função encerra o processo em caso de falha na conexão.
 * @returns {Promise<void>}
 */
export async function connectDb() {
    try {
        await client.connect();
        console.log("✅ Conectado ao PostgreSQL!");
    } catch (err) {
        console.error("❌ Erro ao conectar ao PostgreSQL:", err);
        process.exit(1);
    }
}

export default client;