CREATE EXTENSION IF NOT EXISTS "pgcrypto";

CREATE TABLE IF NOT EXISTS users (
    user_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    first_name VARCHAR(255),
    middle_name VARCHAR(255),
    last_name VARCHAR(255),
    second_last_name VARCHAR(255),
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    identity_document BIGINT,
    birthdate DATE,
    address VARCHAR(255),
    number_phone BIGINT,
    base_salary BIGINT,
    rol_id BIGINT
);

CREATE TABLE IF NOT EXISTS roles (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) UNIQUE NOT NULL,
    description VARCHAR(255)
);

INSERT INTO roles (name, description) VALUES ('ADMIN', 'Administrator role') ON CONFLICT (name) DO NOTHING;
INSERT INTO roles (name, description) VALUES ('USER', 'Regular user role') ON CONFLICT (name) DO NOTHING;
INSERT INTO roles (name, description) VALUES ('ADVISOR', 'Adviser role') ON CONFLICT (name) DO NOTHING;

INSERT INTO users (first_name, last_name, email, password, identity_document, birthdate, address, number_phone, base_salary, rol_id) VALUES
('Roberto', 'Londoño', 'roberto.admin@gmail.com', '$2a$10$079Qo5YY1hTTU8h1S2lUHOVUINmeYrvpToNf3oZMHJ9nSUF74K/wi', 123456789, '1990-01-15', 'Calle Falsa 123', 3101234567, 50000, 1),
('Roberto', 'Londoño', 'roberto.user@gmail.com', '$2a$10$079Qo5YY1hTTU8h1S2lUHOVUINmeYrvpToNf3oZMHJ9nSUF74K/wi', 987654321, '1995-08-20', 'Avenida Siempre Viva 742', 3209876543, 25000, 2),
('Roberto', 'Londoño', 'roberto.advisor@gmail.com', '$2a$10$079Qo5YY1hTTU8h1S2lUHOVUINmeYrvpToNf3oZMHJ9nSUF74K/wi', 9667654321, '1995-08-20', 'Avenida Siempre Viva 742', 3209876543, 25000, 3)
ON CONFLICT (email) DO NOTHING;