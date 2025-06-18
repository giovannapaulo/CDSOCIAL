

-- CAMILA PEREIRA VILHENA  - BP3052311 --
-- GIOVANNA BRANDÂO PAULO - BP3052401 --
-- PEDRO GUEDES DE AZEVEDO - BP305165X --



-- ===============================
-- VIEW: Resume a quantidade e frequência de reservas feitas em cada área comum do condomínio, identificando as áreas de maior demanda.
-- ===============================

CREATE OR REPLACE VIEW View_ReservasPorArea AS
SELECT
    ac.IdAreaComum,
    ac.nomeArea AS NomeAreaComum,
    COUNT(r.IdReserva) AS TotalReservas,
    MAX(r.dataReserva) AS UltimaReserva,
    ROUND(
        COUNT(r.IdReserva) / 
        GREATEST(1, TIMESTAMPDIFF(MONTH, MIN(r.dataReserva), MAX(r.dataReserva)))
    , 2) AS MediaReservasPorMes
FROM
    AreaComum ac
LEFT JOIN
    Reserva r ON r.AreaComum_IdAreaComum = ac.IdAreaComum
GROUP BY
    ac.IdAreaComum, ac.nomeArea;


-- Teste da View:
SELECT * FROM View_ReservasPorArea;


-- ===============================
-- FUNCTION: Calcula o total de ocorrências registradas por um morador em um intervalo de datas específico.
-- ===============================

DELIMITER //

CREATE FUNCTION TotalOcorrenciasPorMoradorPeriodo(idMorador INT, dataInicio DATE, dataFim DATE)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total INT;

    SELECT COUNT(*) INTO total
    FROM EnvolvimentoOcorrencia eo
    JOIN Ocorrencia o ON o.IdOcorrencia = eo.Ocorrencia_IdOcorrencia
    JOIN Morador m ON m.Pessoa_idPessoa = eo.Pessoa_IdPessoa
    WHERE m.IdMorador = idMorador
      AND o.dataOcorrencia BETWEEN dataInicio AND dataFim;

    RETURN total;
END //

DELIMITER ;


-- Teste da Function:
SELECT TotalOcorrenciasPorMoradorPeriodo(1, '2025-05-01', '2025-05-31') AS TotalOcorrencias;

-- ===============================
-- PROCEDURE: Lista moradores que registraram ocorrências no período informado, mostrando o total,
-- percentual do total geral e média mensal, ajudando a identificar moradores mais participativos ou com insatisfações recorrentes.
-- ===============================

DELIMITER //

CREATE PROCEDURE RelatorioOcorrenciasMoradoresComplexo(
    IN p_dataInicio DATE,
    IN p_dataFim DATE
)
BEGIN
    DECLARE totalCond INT;
    SELECT COUNT(*) INTO totalCond
    FROM Ocorrencia
    WHERE dataOcorrencia BETWEEN p_dataInicio AND p_dataFim;

    SELECT
        m.IdMorador,
        p.nome AS NomeMorador,
        TotalOcorrenciasPorMoradorPeriodo(m.IdMorador, p_dataInicio, p_dataFim) AS TotalOcorrencias,
        ROUND(
            100 * TotalOcorrenciasPorMoradorPeriodo(m.IdMorador, p_dataInicio, p_dataFim) / NULLIF(totalCond, 0),
            2
        ) AS PercentualOcorrenciasCondominio,
        ROUND(
            TotalOcorrenciasPorMoradorPeriodo(m.IdMorador, p_dataInicio, p_dataFim) /
            NULLIF(TIMESTAMPDIFF(MONTH, p_dataInicio, p_dataFim) + 1, 0),
            2
        ) AS MediaMensalOcorrencias
    FROM
        Morador m
    JOIN
        Pessoa p ON m.Pessoa_idPessoa = p.IdPessoa
    WHERE
        TotalOcorrenciasPorMoradorPeriodo(m.IdMorador, p_dataInicio, p_dataFim) > 0
    ORDER BY
        TotalOcorrencias DESC;
END //

DELIMITER ;

-- Teste da Procedure:
CALL RelatorioOcorrenciasMoradoresComplexo('2025-05-01', '2025-05-31');
CALL RelatorioOcorrenciasMoradoresComplexo('2025-05-01', '2025-05-05');


-- ===============================
-- PROCEDURE: Registra a posse de um novo síndico e encerra automaticamente o mandato do síndico anterior, 
-- garantindo que nunca haja dois síndicos ativos ao mesmo tempo.
-- ===============================

DELIMITER //
CREATE PROCEDURE NovoSindico (
    IN p_Pessoa_idPessoa INT,
    IN p_dataPosse DATE
)
BEGIN
    DECLARE nomeSindico VARCHAR(100);
   UPDATE Sindico
   SET dataFim = p_dataPosse
   WHERE dataFim IS NULL
   ORDER BY IdSindico DESC
   LIMIT 1;

    
    INSERT INTO Sindico (Pessoa_idPessoa, dataPosse)
    VALUES (p_Pessoa_idPessoa, p_dataPosse);

    SELECT nome INTO nomeSindico
    FROM Pessoa
    WHERE idPessoa = p_Pessoa_idPessoa;

    SET @novoIdSindico = LAST_INSERT_ID();

    INSERT INTO Comunicado (tituloComunicado, descComunicado, Sindico_IdSindico)
    VALUES (
        CONCAT('Novo síndico: ', nomeSindico),
        'Informamos que um novo síndico assumiu a gestão.',
        @novoIdSindico
    );
END;
//
DELIMITER ;

-- Teste da Procedure:

SELECT * FROM Sindico ORDER BY dataPosse DESC;
SELECT * FROM Comunicado ORDER BY idComunicado DESC;

CALL NovoSindico(7, '2025-06-14');

SELECT * FROM Sindico ORDER BY dataPosse DESC;
SELECT * FROM Comunicado ORDER BY idComunicado DESC;

CALL NovoSindico(3, '2025-06-14');


-- ===============================
-- FUNCTION: Calcula quantos dias um morador demorou para pagar uma determinada taxa condominial.
-- ===============================

DELIMITER //

CREATE FUNCTION DiasAtrasoPagamento(idTaxa INT, idMorador INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE vencimento DATE;
    DECLARE pagamento DATE;
    DECLARE atraso INT;

    SELECT DATE(t.vencimento) INTO vencimento FROM Taxa t WHERE t.IdTaxa = idTaxa;

    SELECT MIN(DATE(tr.data)) INTO pagamento FROM Transacao tr 
    WHERE tr.Taxa_IdTaxa = idTaxa AND tr.Morador_IdMorador = idMorador;

    IF pagamento IS NULL THEN
        SET atraso = 0;
    ELSE
        SET atraso = DATEDIFF(pagamento, vencimento);
        IF atraso < 0 THEN SET atraso = 0; END IF;
    END IF;

    RETURN atraso;
END //

DELIMITER ;

-- Teste da Function:
SELECT nome, DiasAtrasoPagamento(2, IdMorador) AS DiasAtraso
FROM Morador
JOIN Pessoa ON Pessoa.IdPessoa = Morador.Pessoa_IdPessoa;



-- ===============================
-- VIEW: Mostra cada síndico com seu período de mandato, total de comunicados enviados e a média mensal de comunicados, 
-- permitindo avaliar a frequência e eficiência da comunicação deles com os moradores.
-- ===============================

CREATE OR REPLACE VIEW View_FrequenciaComunicadosSindico AS
SELECT
    p.IdPessoa AS IdSindico,
    p.nome AS NomeSindico,
    s.dataPosse,
    COALESCE(DATE_FORMAT(s.dataFim, '%d/%m/%Y'), 'Atualmente') AS DataFimFormatada,
    
    COUNT(c.idComunicado) AS TotalComunicados,
    
    PERIOD_DIFF(
        DATE_FORMAT(COALESCE(s.dataFim, CURDATE()), '%Y%m'),
        DATE_FORMAT(s.dataPosse, '%Y%m')
    ) + 1 AS MesesDeMandato,
    
    ROUND(
        COUNT(c.idComunicado) / 
        (PERIOD_DIFF(
            DATE_FORMAT(COALESCE(s.dataFim, CURDATE()), '%Y%m'),
            DATE_FORMAT(s.dataPosse, '%Y%m')
        ) + 1), 2
    ) AS ComunicadosPorMes
    
FROM
    Pessoa p
JOIN
    Sindico s ON p.IdPessoa = s.Pessoa_IdPessoa
LEFT JOIN
    Comunicado c ON s.IdSindico = c.Sindico_IdSindico
GROUP BY
    p.IdPessoa, p.nome, s.dataPosse, s.dataFim
HAVING
    TotalComunicados > 0
ORDER BY
    ComunicadosPorMes DESC, TotalComunicados DESC;

-- Teste da View:
SELECT * FROM View_FrequenciaComunicadosSindico;


-- ===============================
-- FUNCTION: Verifica se um morador tem pelo menos uma taxa vencida e não paga. 
-- Retorna 1 (verdadeiro) ou 0 (falso). 
-- ===============================

DELIMITER //

CREATE FUNCTION TemTaxaVencida(idMorador INT) RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE qtd INT;
    SELECT COUNT(*)
    INTO qtd
    FROM Taxa t
    LEFT JOIN Transacao tr ON tr.Taxa_IdTaxa = t.IdTaxa AND tr.Morador_IdMorador = idMorador
    WHERE t.vencimento < NOW() AND tr.IdTransacao IS NULL;
    
    RETURN (qtd > 0);
END //

DELIMITER ;
    
-- Teste da Function:
SELECT TemTaxaVencida(1) AS MoradorPossuiTaxa;
SELECT TemTaxaVencida(4) AS MoradorPossuiTaxa;
SELECT TemTaxaVencida(7) AS MoradorPossuiTaxa;


-- ===============================
-- PROCEDURE: Lista moradores que fizeram reservas em áreas comuns e 
-- têm taxas vencidas não pagas, mostrando detalhes da reserva e da taxa.
-- ===============================

DELIMITER //

CREATE PROCEDURE MoradoresComReservasETaxasVencidas()
BEGIN
    SELECT
        m.IdMorador,                
        p.nome AS NomeMorador,
        r.dataReserva AS DataReserva,
        a.nomeArea AS AreaReservada,
        t.titulo AS TaxaVencida,
        t.vencimento AS DataVencimento
    FROM
        Morador m
    JOIN Pessoa p ON p.IdPessoa = m.Pessoa_idPessoa
    JOIN Reserva r ON r.Morador_IdMorador = m.IdMorador
    JOIN AreaComum a ON a.IdAreaComum = r.AreaComum_IdAreaComum
    JOIN Taxa t
    LEFT JOIN Transacao tr ON tr.Taxa_IdTaxa = t.IdTaxa AND tr.Morador_IdMorador = m.IdMorador
    WHERE
        TemTaxaVencida(m.IdMorador) = 1  
        AND t.vencimento < NOW()
        AND tr.IdTransacao IS NULL;
END //

DELIMITER ;

-- Teste da Procedure:
CALL MoradoresComReservasETaxasVencidas();

-- ===============================
-- FUNCTION: Verifica se o morador já possui alguma reserva no mesmo dia e com horário que se sobrepõe ao novo pedido.
-- ===============================

DELIMITER //

CREATE FUNCTION verificaReservaAtiva(
    pidMorador INT,
    pdata DATE,
    phoraInicio TIME,
    phoraFim TIME
) RETURNS INT
DETERMINISTIC
READS SQL DATA
BEGIN
    DECLARE countReservas INT;

    SELECT COUNT(*)
    INTO countReservas
    FROM Reserva
    WHERE Morador_IdMorador = pidMorador
      AND dataReserva = pdata
      AND (
            horaInicio < phoraFim
            AND horaTermino > phoraInicio
          );

    RETURN countReservas;
END;
//

-- Teste da Function:
SELECT verificaReservaAtiva(1, '2025-06-20', '18:00:00', '20:00:00') AS qtdReservasAtivas;
SELECT verificaReservaAtiva(6, '2025-06-20', '18:00:00', '20:00:00') AS qtdReservasAtivas;


-- ===============================
-- TRIGGER: Impede que um morador faça uma nova reserva no mesmo dia e horário em que ele já tem uma reserva ativa.
-- ===============================

CREATE TRIGGER trg_BloqueiaReservaDuplicada
BEFORE INSERT ON Reserva
FOR EACH ROW
BEGIN
    IF verificaReservaAtiva(
        NEW.Morador_IdMorador,
        NEW.dataReserva,
        NEW.horaInicio,
        NEW.horaTermino
    ) > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Reserva duplicada: morador já tem reserva neste dia e horário.';
    END IF;
END;
//
DELIMITER ;

-- Teste Trigger:

-- Inserir reserva válida (sem conflito)
INSERT INTO Reserva (
    AreaComum_IdAreaComum,
    Morador_IdMorador,
    dataReserva,
    motivoReserva,
    horaInicio,
    horaTermino
) VALUES (
    1, 1, '2025-06-10', 'Festa de aniversário', '18:00:00', '20:00:00'
);
-- Deve inserir com sucesso

-- Teste: Inserir reserva que NÃO conflita em horário
INSERT INTO Reserva (
    AreaComum_IdAreaComum,
    Morador_IdMorador,
    dataReserva,
    motivoReserva,
    horaInicio,
    horaTermino
) VALUES (
    1, 1, '2025-06-10', 'Churrasco', '20:00:00', '22:00:00'
);
-- Deve inserir com sucesso

-- Teste: Inserir reserva que CONFLITA com a reserva do Teste 1
INSERT INTO Reserva (
    AreaComum_IdAreaComum,
    Morador_IdMorador,
    dataReserva,
    motivoReserva,
    horaInicio,
    horaTermino
) VALUES (
    1, 1, '2025-06-10', 'Evento duplicado', '19:30:00', '21:00:00'
);
-- Deve dar erro: 'Reserva duplicada: morador já tem reserva neste dia e horário.'

-- ===============================
-- FUNCTION: Calcula a porcentagem de votos de uma opção com base no total de participantes da enquete.
-- ===============================

DELIMITER //


CREATE FUNCTION CalcularPorcentagemOpcao(opcaoId INT) RETURNS DECIMAL(5,1)
READS SQL DATA
BEGIN
    DECLARE totalVotosOpcao INT;
    DECLARE totalParticipantesEnquete INT;
    DECLARE enqueteId INT;
    DECLARE porcentagem DECIMAL(5,1);

    SELECT Enquete_IdEnquete INTO enqueteId FROM Opcao WHERE IdOpcao = opcaoId;

    SELECT COUNT(*) INTO totalVotosOpcao FROM Voto WHERE Opcao_IdOpcao = opcaoId;

    SELECT totalParticipantes INTO totalParticipantesEnquete FROM Enquete WHERE IdEnquete = enqueteId;

    IF totalParticipantesEnquete > 0 THEN
        SET porcentagem = ROUND((totalVotosOpcao / totalParticipantesEnquete) * 100, 1);
    ELSE
        SET porcentagem = 0.0;
    END IF;

    RETURN porcentagem;
END //

DELIMITER ;


-- ===============================
-- TRIGGER: Atualiza automaticamente o atributo porcentResposta de todas as opções após cada voto.
-- ===============================

DELIMITER //

CREATE TRIGGER trg_porcentagem_opcao
AFTER INSERT ON Voto
FOR EACH ROW
BEGIN
    DECLARE v_enqueteId INT;

    SELECT Enquete_IdEnquete INTO v_enqueteId
    FROM Opcao
    WHERE IdOpcao = NEW.Opcao_IdOpcao;

    UPDATE Opcao
    SET porcentResposta = CalcularPorcentagemOpcao(IdOpcao)
    WHERE Enquete_IdEnquete = v_enqueteId;
END //

DELIMITER ;


-- ===============================
-- TRIGGER: Atualiza o campo totalParticipantes da enquete sempre que um novo voto é inserido.
-- ===============================

DELIMITER //

CREATE TRIGGER trg_total_participantes
AFTER INSERT ON Voto
FOR EACH ROW
BEGIN
    DECLARE v_enqueteId INT;
    DECLARE v_totalParticipantes INT;

    SELECT Enquete_IdEnquete INTO v_enqueteId
    FROM Opcao
    WHERE IdOpcao = NEW.Opcao_IdOpcao;

    SELECT COUNT(DISTINCT V.Morador_IdMorador)
    INTO v_totalParticipantes
    FROM Voto AS V
    JOIN Opcao AS O ON V.Opcao_IdOpcao = O.IdOpcao
    WHERE O.Enquete_IdEnquete = v_enqueteId;

    UPDATE Enquete
    SET totalParticipantes = v_totalParticipantes
    WHERE IdEnquete = v_enqueteId;
END //

DELIMITER ;

-- Teste Trigger:


-- Update para garantir a sincronização da porcentagem das opções de uma enquete
UPDATE Opcao o
SET porcentResposta = CalcularPorcentagemOpcao(o.IdOpcao)
WHERE o.Enquete_IdEnquete = 1;

 -- Update para garantir a sincronização da tabela.
 UPDATE Enquete e
SET totalParticipantes = (
  SELECT COUNT(DISTINCT v.Morador_IdMorador)
  FROM Voto v
  JOIN Opcao o ON v.Opcao_IdOpcao = o.IdOpcao
  WHERE o.Enquete_IdEnquete = e.IdEnquete
)
WHERE e.IdEnquete = 1;

-- Antes da inserção
SELECT * FROM Enquete WHERE IdEnquete = 1;
SELECT * FROM Opcao WHERE Enquete_IdEnquete = 1;

-- Inserção de registro
INSERT INTO Voto (Morador_IdMorador, Opcao_IdOpcao)
VALUES (10, 3);  -- 3 é IdOpcao pertencente à Enquete 1

-- Depois da inserção.
SELECT * FROM Enquete WHERE IdEnquete = 1;  
SELECT * FROM Opcao WHERE Enquete_IdEnquete = 1;  
