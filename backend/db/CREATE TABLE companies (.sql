CREATE TABLE companies (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(200) NOT NULL,
    join_code NVARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE users (
    id INT IDENTITY(1,1) PRIMARY KEY,
    company_id INT NOT NULL REFERENCES companies(id),
    display_name NVARCHAR(100) NOT NULL,
    token NVARCHAR(100) NOT NULL UNIQUE,
    points INT NOT NULL DEFAULT 0,
    created_at DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
);

CREATE TABLE jargon (
    id INT IDENTITY(1,1) PRIMARY KEY,
    company_id INT NOT NULL REFERENCES companies(id),
    term NVARCHAR(200) NOT NULL,
    term_normalized NVARCHAR(200) NOT NULL,
    meaning NVARCHAR(MAX) NOT NULL,
    example_sentence NVARCHAR(MAX) NULL,
    first_heard_at DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT UQ_jargon_company_term UNIQUE (company_id, term_normalized)
);

CREATE TABLE user_jargon (
    user_id INT NOT NULL REFERENCES users(id),
    jargon_id INT NOT NULL REFERENCES jargon(id),
    times_heard INT NOT NULL DEFAULT 1,
    mastery INT NOT NULL DEFAULT 0,
    times_correct INT NOT NULL DEFAULT 0,
    times_wrong INT NOT NULL DEFAULT 0,
    last_quizzed_at DATETIME2 NULL,
    PRIMARY KEY (user_id, jargon_id)
);

CREATE TABLE meeting_sessions (
    id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(id),
    started_at DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    rolling_tail NVARCHAR(MAX) NULL
);