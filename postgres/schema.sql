-- =========================
-- Seção de Criação de Tabelas
-- =========================

CREATE TABLE IF NOT EXISTS "Student" (
    "id" SERIAL PRIMARY KEY,                  -- Identificador único para cada estudante (chave primária).
    "name" VARCHAR(255) NOT NULL,             -- Nome completo do estudante. O campo não pode ser nulo.
    "phone" VARCHAR(20),                      -- Número de telefone do estudante.
    "birthDate" DATE,                         -- Data de nascimento do estudante.
    "createdAt" TIMESTAMP DEFAULT now(),      -- Timestamp de quando o registro do estudante foi criado.
    "updatedAt" TIMESTAMP DEFAULT now()       -- Timestamp da última atualização do registro do estudante.
);

-- Tabela `Enrollment`
-- Armazena as informações de matrícula de um estudante em um curso.
-- Cada registro representa uma matrícula única, ligando um estudante a um curso específico.
CREATE TABLE IF NOT EXISTS "Enrollment" (
    "id" SERIAL PRIMARY KEY,                  -- Identificador único para cada matrícula (chave primária).
    "enrollmentCode" VARCHAR(50) NOT NULL,    -- Código único da matrícula.
    "courseName" VARCHAR(255) NOT NULL,       -- Nome do curso ao qual o estudante está matriculado.
    "startDate" DATE,                         -- Data de início do curso.
    "createdAt" TIMESTAMP DEFAULT now(),      -- Timestamp de quando a matrícula foi criada.
    "updatedAt" TIMESTAMP DEFAULT now(),      -- Timestamp da última atualização da matrícula.
    "studentId" INT NOT NULL,                 -- Chave estrangeira que referencia o `id` na tabela `Student`.
    CONSTRAINT "fk_student" FOREIGN KEY("studentId") REFERENCES "Student"("id") -- Garante a integridade referencial com a tabela `Student`.
);

-- =========================
-- Seção de Funções e Triggers
-- =========================

-- Função `update_updated_at_column`
-- Esta função é projetada para ser usada por triggers. Sua finalidade é atualizar
-- o campo `updatedAt` de um registro para o timestamp atual sempre que o registro for modificado.
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    -- A variável `NEW` representa a nova linha de dados que será inserida ou que substituirá a antiga.
    -- Aqui, estamos definindo o campo `updatedAt` dessa nova linha para o tempo atual.
    NEW."updatedAt" = now();
    RETURN NEW; -- Retorna a linha modificada para que a operação de UPDATE possa continuar.
END;
$$ LANGUAGE plpgsql;

-- Trigger `trigger_update_student_updated_at` na tabela `Student`
-- Este trigger é acionado automaticamente pelo banco de dados sempre que um
-- registro na tabela `Student` está prestes a ser atualizado (BEFORE UPDATE).
-- Ele chama a função `update_updated_at_column` para cada linha que será atualizada.
CREATE TRIGGER trigger_update_student_updated_at
BEFORE UPDATE ON "Student"
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();

-- Trigger `trigger_update_enrollment_updated_at` na tabela `Enrollment`
-- Similar ao trigger acima, mas para a tabela `Enrollment`.
-- Garante que o campo `updatedAt` da tabela `Enrollment` seja atualizado
-- sempre que uma matrícula for modificada.
CREATE TRIGGER trigger_update_enrollment_updated_at
BEFORE UPDATE ON "Enrollment"
FOR EACH ROW
EXECUTE FUNCTION update_updated_at_column();