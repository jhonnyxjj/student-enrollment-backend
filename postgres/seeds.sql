-- =========================
-- Seção de Inserção de Dados (Seeds)
-- =========================
-- Limpa as tabelas antes de inserir novos dados para evitar duplicatas e conflitos.
-- A ordem é importante para respeitar as chaves estrangeiras (Enrollment depende de Student).
DELETE FROM "Enrollment";

DELETE FROM "Student";

-- Reinicia as sequências dos IDs para que os novos registros comecem do 1.
-- O uso de `ALTER SEQUENCE ... RESTART WITH 1;` é mais limpo que `TRUNCATE ... RESTART IDENTITY;` 
-- quando se quer apenas reiniciar a contagem.
ALTER SEQUENCE "Student_id_seq" RESTART WITH 1;

ALTER SEQUENCE "Enrollment_id_seq" RESTART WITH 1;

-- Inserção de dados na tabela `Student`
-- Inserindo 5 estudantes de exemplo.
INSERT INTO
    "Student" ("name", "phone", "birthDate")
VALUES
    ('Ana Silva', '11987654321', '1995-03-15'),
    ('Bruno Costa', '21998877665', '1998-07-22'),
    ('Carla Dias', '31988889999', '1997-01-30'),
    ('Daniel Farias', '41977776666', '2000-11-05'),
    ('Elena Martins', '51966665555', '1999-09-10');

-- Inserção de dados na tabela `Enrollment`
-- Adicionando matrículas para os estudantes criados acima.
INSERT INTO
    "Enrollment" (
        "enrollmentCode",
        "courseName",
        "startDate",
        "studentId"
    )
VALUES
    -- Matrículas para Ana Silva (studentId = 1)
    (
        'ENRL-001',
        'Introdução à Programação',
        '2023-01-20',
        1
    ),
    ('ENRL-002', 'Banco de Dados SQL', '2023-03-10', 1),
    -- Matrículas para Bruno Costa (studentId = 2)
    (
        'ENRL-003',
        'Desenvolvimento Web Avançado',
        '2023-02-15',
        2
    ),
    -- Matrículas para Carla Dias (studentId = 3)
    (
        'ENRL-004',
        'Introdução à Programação',
        '2023-01-20',
        3
    ),
    ('ENRL-005', 'Estrutura de Dados', '2023-04-01', 3),
    -- Daniel Farias (studentId = 4) não possui matrículas.
    -- Matrículas para Elena Martins (studentId = 5)
    (
        'ENRL-006',
        'Desenvolvimento Web Avançado',
        '2023-02-15',
        5
    );