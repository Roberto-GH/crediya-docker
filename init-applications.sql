-- Habilita la extensión pgcrypto si no está activa, para usar gen_random_uuid()
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Table: public.status
-- DROP TABLE IF EXISTS public.status;
CREATE TABLE IF NOT EXISTS public.status
(
    status_id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    name character varying(255) COLLATE pg_catalog."default" NOT NULL,
    description text COLLATE pg_catalog."default",
    CONSTRAINT status_pkey PRIMARY KEY (status_id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS public.status OWNER to postgres;
-- Insert initial data
INSERT INTO public.status (name, description) 
VALUES
    ('Pendiente de revisión', 'Solicitud pendiente de ser revisada por un asesor.'),
    ('Aprobada', 'La solicitud de crédito ha sido aprobada.'),
    ('Rechazada', 'La solicitud de crédito ha sido rechazada.'),
    ('En proceso', 'La solicitud está siendo procesada.'),
    ('En revisión manual', 'La solicitud está siendo revisada manualmente por un asesor.');

-- Table: public.type_of_loan                                                                                                
-- DROP TABLE IF EXISTS public.type_of_loan;     
CREATE TABLE IF NOT EXISTS public.type_of_loan                                                                               
(                                                                                                                            
    loan_type_id bigint NOT NULL GENERATED ALWAYS AS IDENTITY ( INCREMENT 1 START 1 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1 ),
    name character varying(255) COLLATE pg_catalog."default" NOT NULL,                                                       
    minimum_amount numeric(19,2) NOT NULL,                                                                                   
    maximum_amount numeric(19,2) NOT NULL,                                                                                   
    interest_rate numeric(5,4) NOT NULL,                                                                                     
    automatic_validation boolean NOT NULL,                                                                                   
    CONSTRAINT loan_type_pkey PRIMARY KEY (loan_type_id)                                                                  
)                                                                                                                            
     
TABLESPACE pg_default;                                                                                                       
     
ALTER TABLE IF EXISTS public.type_of_loan OWNER to postgres;                                                                                                       
                                                                                                                                   
-- Insert initial data
INSERT INTO public.type_of_loan 
(name, minimum_amount, maximum_amount, interest_rate, automatic_validation) 
VALUES           
    ('Personal', 500.00, 50000.00, 0.1250, true),                                                                            
    ('Hipotecario', 20000.00, 500000.00, 0.0575, false),                                                                     
    ('Automotriz', 5000.00, 100000.00, 0.0725, true),                                                                        
    ('Estudiantil', 1000.00, 150000.00, 0.0450, false),                                                                      
    ('Negocios', 10000.00, 1000000.00, 0.0950, false);

-- Creación de la tabla applications
CREATE TABLE IF NOT EXISTS applications (
    application_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    amount NUMERIC(19, 2) NOT NULL,
    term INTEGER NOT NULL,
    email VARCHAR(255) NOT NULL,
    identity_document BIGINT NOT NULL,
    status_id BIGINT NOT NULL,
    loan_type_id BIGINT NOT NULL,
    CONSTRAINT fk_status FOREIGN KEY (status_id) REFERENCES status(status_id),
    CONSTRAINT fk_loan_type FOREIGN KEY (loan_type_id) REFERENCES type_of_loan(loan_type_id)
);

 -- Índice compuesto para la tabla applications
 -- Optimiza las búsquedas que filtran por status_id y loan_type_id
CREATE INDEX idx_applications_status_loan_type ON applications (status_id, loan_type_id);