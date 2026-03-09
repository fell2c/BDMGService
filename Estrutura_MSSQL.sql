CREATE TABLE StatusTarefas(
	ID INT IDENTITY(1,1) PRIMARY KEY,
	DESCRICAO NVARCHAR(25) NOT NULL
);

CREATE TABLE Tarefas (
    ID INT IDENTITY(1,1) PRIMARY KEY,
    Titulo NVARCHAR(100) NOT NULL,
    Descricao NVARCHAR(200) NULL,
    StatusId INT NOT NULL,       
    Prioridade INT NOT NULL CONSTRAINT CK_Prioridade CHECK (Prioridade BETWEEN 1 AND 3),
    DataCriacao DATETIME2 NOT NULL DEFAULT GETDATE(),
    DataConclusao DATETIME2 NULL
    
    CONSTRAINT FK_Tarefas_Status FOREIGN KEY (StatusId) REFERENCES StatusTarefas(ID)
);

INSERT INTO StatusTarefas (DESCRICAO) VALUES ('Pendente'), ('Em Andamento'), ('Concluída');

CREATE OR ALTER VIEW Vw_IndicadoresTarefas AS
  SELECT
    COUNT(*) AS TotalTarefas,
    CAST(
        ROUND(
            AVG(CASE 
	                WHEN t.statusID = 1                    
	                THEN t.Prioridade 
                END), 
        0) 
    AS INT) AS MediaPrioridadePendentes,
    COUNT(CASE 
            WHEN t.statusID = 3
             AND t.DataConclusao >= DATEADD(DAY, -7, CAST(GETDATE() AS DATE))
            THEN 1 
          END) AS ConcluidasUltimos7Dias
FROM Tarefas t;