INSERT INTO `AreaComum` (`nomeArea`, `descArea`, `regra`, `capacidadePessoas`, `aceitaAnimais`) VALUES
('Salão de Festas Principal', 'Amplo salão para eventos, com cozinha e banheiros.', 'Obrigatório realizar a limpeza pós-uso', 150, 0),
('Churrasqueira do Jardim', 'Espaço coberto com vista para o jardim, churrasqueira com pia e uma mesa grande de oito cadeiras.', 'Obrigatório realizar a limpeza pós-uso', 20, 0),
('Churrasqueira da Piscina', 'Espaço coberto ao lado da piscina, com três mesas pequenas de quatro cadeiras cada.', 'Obrigatório realizar a limpeza pós-uso', 25, 0),
('Piscina Adulto', 'Piscina para adultos, com profundidade de 1.8m.', 'Evitar consumir alimentos próximo da piscina', 50, 0),
('Piscina Infantil', 'Piscina rasa para crianças de até 12 anos.', 'Necessita acompanhamento de um adulto.', 15, 0),
('Spa', 'Espaço relaxante', 'Atendimento somente mediante reserva.', 30, 1),
('Quadra Poliesportiva', 'Quadra para futebol, basquete e vôlei.', 'Reserva de 1h', 40, 0),
('Sala de Jogos', 'Mesa de bilhar, pebolim e jogos de tabuleiro.', 'Proibido bebidas alcoólicas neste ambiente.', 10, 0),
('Brinquedoteca', 'Espaço lúdico para crianças pequenas.', 'Necessita acompanhamento de um adulto.', 8, 0),
('Espaço Coworking', 'Área com mesas e internet para trabalho.', 'Silêncio obrigatório', 12, 1);
-- 0 para sim e 1 para nao --


INSERT INTO `Pessoa` (`nome`, `CPF`, `dataNascimento`, `telefone`, `email`) VALUES
('Yolanda Costa', '111.222.333-01', '1985-03-15', '11987654321', 'costa.nanda@email.com'),
('Bruno Santos', '222.333.444-02', '1970-11-22', '11998765432', 'bruno.s@email.com'),
('Kate Lima', '333.444.555-03', '1992-07-01', '11976543210', 'kate.kt@email.com'),
('Luan Tavares', '444.555.666-04', '1965-01-10', '11965432109', 'luan.0609@email.com'),
('Eduarda Alves', '555.666.777-05', '2000-05-20', '11954321098', 'eduarda.a@email.com'),
('Fernando Dias', '666.777.888-06', '1980-09-03', '11943210987', 'fernando.g@email.com'),
('Celine Mendes', '777.888.999-07', '2005-12-12', '11932109876', 'celine.m@email.com'),
('Hugo Castro', '888.999.000-08', '1978-02-28', '11921098765', 'hugo.c@email.com'),
('Bella Dantas', '999.000.111-09', '1995-06-07', '11910987654', 'bel.f@email.com'),
('Juliana Vaz', '000.111.222-10', '1988-04-25', '11909876543', 'ju.vaz444@email.com');


INSERT INTO `Morador` (`Pessoa_idPessoa`, `tipoVinculo`, `dataInicio`, `dataFim`) VALUES
(1, 'Proprietário', '2020-01-01', NULL), -- Yolanda - Proprietária atual
(2, 'Inquilino', '2023-03-01', NULL), -- Bruno - Inquilino atual
(3, 'Proprietário', '2018-05-10', NULL), -- Kate - Proprietária atual
(4, 'Inquilino', '2015-02-15', '2020-12-31'), -- Luan - Foi Inquilino
(4, 'Proprietário', '2021-01-01', NULL), -- Luan - Agora é Proprietário em outro apartamento
(5, 'Dependente', '2022-08-01', NULL), -- Eduarda - Dependente (filha de Yolanda)
(6, 'Proprietário', '2019-11-20', NULL), -- Fernando - Proprietário atual
(7, 'Dependente', '2024-01-01', NULL), -- Celine - Dependente (filha de Bruno)
(8, 'Inquilino', '2024-02-01', NULL), -- Hugo - Inquilino atual
(9, 'Outro', '2023-06-01', NULL); -- Bella - Residente temporária
-- Obs: Juliana Vaz não foi designada como morador aqui. Ela foi síndica contratada anteriormente. --


INSERT INTO `Reserva` (`AreaComum_IdAreaComum`, `Morador_IdMorador`, `dataReserva`, `motivoReserva`, `horaInicio`, `horaTermino`) VALUES
(1, 1, '2025-06-20', 'Aniversário Filho', '18:00:00', '23:00:00'), -- Yolanda reserva Salão de Festas
(2, 2, '2025-06-21', 'Churrasco com Amigos', '10:00:00', '14:00:00'), -- Bruno reserva Churrasqueira Jardim
(3, 3, '2025-06-21', 'Festa de confraternização', '15:00:00', '19:00:00'), -- Kate reserva Churrasqueira Piscina
(4, 4, '2025-06-22', 'Dia de Lazer em Família', '09:00:00', '17:00:00'), -- Luan reserva Piscina Adulto
(6, 5, '2025-06-23', 'Sessão de massagem', '14:00:00', '15:30:00'), -- Eduarda reserva Spa
(7, 6, '2025-06-24', 'Partida de Futebol', '19:00:00', '21:00:00'), -- Fernando reserva Quadra
(1, 7, '2025-07-05', 'Reunião Familiar', '19:00:00', '01:00:00'), -- Celine reserva Salão de Festas
(2, 8, '2025-07-06', 'Churrasco de Aniversário', '11:00:00', '15:00:00'), -- Hugo reserva Churrasqueira Jardim
(8, 9, '2025-07-07', 'Noite de Jogos de Tabuleiro', '20:00:00', '23:00:00'), -- Bella reserva Sala de Jogos
(10, 1, '2025-07-08', 'Trabalho Concentrado', '14:00:00', '17:00:00'); -- Yolanda reserva Coworking


INSERT INTO `Sindico` (`Pessoa_idPessoa`, `dataPosse`, `dataFim`) VALUES
(1, '2025-01-01', NULL), -- Yolanda síndica atual
(1, '2023-01-01', '2024-12-31'), -- Mandato anterior de Yolanda 
(3, '2020-01-01', '2022-12-31'), -- Kate - Síndica anterior
(2, '2018-01-01', '2019-12-31'), -- Bruno - Síndico antes da Kate
(6, '2016-01-01', '2017-12-31'), -- Fernando - Síndico antes do Bruno
(10, '2014-01-01', '2015-12-31'), -- Juliana - Síndica anterior
(1, '2012-01-01', '2013-12-31'), -- Mandato anterior de Yolanda 
(10, '2010-01-01', '2011-12-31'), -- Juliana - Síndica anterior
(10, '2008-01-01', '2009-12-31'); -- Juliana - Síndica anterior


INSERT INTO `Ocorrencia` (`tituloOcorrencia`, `descOcorrencia`, `dataOcorrencia`) VALUES
('Vazamento no Bloco A', 'Vazamento de água no apartamento 101, afetando o andar de baixo.', '2025-05-01'),
('Barulho Excessivo', 'Som alto vindo da unidade 305 durante a madrugada.', '2025-05-03'),
('Portão da Garagem Quebrado', 'O portão automático da garagem não está funcionando corretamente.', '2025-05-05'),
('Lixo Descartado Incorretamente', 'Morador descartou lixo fora do horário e local adequado.', '2025-05-07'),
('Piscina Suja', 'Água da piscina com coloração estranha e sujeira na superfície.', '2025-05-09'),
('Dano à Área Comum', 'Arranhões e marcas de pneu na parede da academia.', '2025-05-11'),
('Falta de Água', 'Problema no abastecimento de água do condomínio por 4 horas.', '2025-05-15'),
('Problema na Iluminação', 'Lâmpadas queimadas nos corredores do bloco B.', '2025-05-17'),
('Obra Fora do Horário', 'Obra no apartamento 202 causando barulho excessivo fora do horário permitido.', '2025-05-19');


INSERT INTO `EnvolvimentoOcorrencia` (`Ocorrencia_IdOcorrencia`, `Pessoa_IdPessoa`, `descEnvolvimento`) VALUES
(1, 1, 'Reportou o vazamento inicial.'),
(1, 2, 'Responsável pelo apartamento com problema de vazamento.'),
(2, 3, 'Responsável pela reclamação de barulho.'),
(2, 4, 'Causador do barulho excessivo'),
(3, 1, 'Síndica, acionou a manutenção.'),
(4, 5, 'Morador que descartou o lixo incorretamente.'),
(4, 1, 'Síndica, adivertou morador pelo descarte inadequado de lixo.'),
(5, 6, 'Morador que notificou a sujeira na piscina.'),
(6, 7, 'Pessoa que testemunhou o dano na academia.'),
(7, 9, 'Morador que reclamou da falta de água.'),
(8, 1, 'Síndica, reportou necessidade de troca em assembléia.'),
(9, 5, 'Morador que reclamou da obra fora de horário.');


INSERT INTO `Comunicado` (`tituloComunicado`, `descComunicado`, `Sindico_IdSindico`) VALUES
('Manutenção da Piscina', 'Informamos que a piscina ficará fechada para manutenção nos dias 10 e 11 de Junho.', 1),
('Reunião de Assembleia Extraordinária', 'Convocamos todos os moradores para assembleia extraordinária no dia 25/06 às 19h.', 1),
('Nova Regra de Descarte de Lixo', 'A partir de 01/07, o descarte de lixo deverá ser feito das 18h às 20h.', 1),
('Aviso de Desinsetização', 'Será realizada desinsetização nas áreas comuns no dia 15/07.', 1),
('Atualização de Contatos', 'Solicitamos que todos os moradores atualizem seus dados de contato na portaria.', 1),
('Horário de Uso da Academia', 'Novo horário de funcionamento da academia: das 6h às 22h.', 1),
('Convocação para Eleição de Conselho Fiscal', 'Eleição do conselho fiscal no dia 30/07. Candidatos devem se inscrever até 20/07.', 1),
('Revisão das Câmeras de Segurança', 'Informamos que o sistema de câmeras passará por revisão nos próximos dias.', 1),
('Promoção de Descontos em Áreas Comuns', 'Desconto de 20% em reservas do salão de festas durante o mês de agosto.', 1),
('Corte de Água Programado', 'Corte de água para manutenção programada no dia 20/07, das 9h às 12h.', 1),
('Corte de Água Programado', 'Corte de água para manutenção programada no dia 12/02, das 10h às 20h.', 3),
('Aviso de Desinsetização', 'Será realizada desinsetização nas áreas comuns no dia 15/07.', 3);




INSERT INTO `AtaAssembleia` (`titulo`, `descAta`, `dataAssembleia`, `Sindico_IdSindico`) VALUES
('Ata Assembleia Geral Ordinária 2025', 'Discussão e aprovação das contas de 2024, eleição de síndico e conselho.', '2025-04-10', 1),
('Ata Assembleia Extraordinária - Obras', 'Discussão sobre reforma da fachada do condomínio e aprovação de orçamento.', '2025-03-20', 1),
('Ata Assembleia Geral Ordinária 2024', 'Apresentação de balancete, aprovação de verbas, revisão de regimento interno.', '2024-04-15', 1),
('Ata Assembleia Extraordinária - Segurança', 'Discussão sobre implantação de novo sistema de segurança e biometria.', '2024-01-25', 1),
('Ata Assembleia Geral Ordinária 2023', 'Aprovação de contas 2022, novas regras de uso do salão de festas.', '2023-04-20', 1),
('Ata Assembleia Geral Ordinária 2022', 'Discussão sobre valor do condomínio, reajuste de salários dos funcionários.', '2022-04-18', 3),
('Ata Assembleia Extraordinária - Piscina', 'Deliberação sobre reforma e aquecimento da piscina.', '2022-02-10', 3),
('Ata Assembleia Geral Ordinária 2021', 'Aprovação de contas 2020, eleição de síndico.', '2021-04-22', 3),
('Ata Assembleia Extraordinária - Garagem', 'Discussão e aprovação de demarcação de vagas de garagem.', '2021-01-30', 3),
('Ata Assembleia Geral Ordinária 2020', 'Primeira assembleia do ano, planejamento de eventos.', '2020-03-05', 3);


INSERT INTO `Enquete` (`Sindico_IdSindico`, `questao`, `dataInicio`, `dataFim`) VALUES
(1, 'Qual cor pintar a fachada do Bloco C?', '2025-05-01 10:00:00', '2025-05-15 23:59:59'),
(1, 'Preferência de dia para feira de condomínio?', '2025-05-10 09:00:00', '2025-05-24 23:59:59'),
(1, 'Qual melhor dia para manutenção da piscina?', '2025-05-15 08:00:00', '2025-05-29 23:59:59'),
(1, 'Interesse em aulas de yoga no condomínio?', '2025-06-01 11:00:00', '2025-06-15 23:59:59'),
(1, 'Qual tipo de evento social devemos organizar?', '2025-06-05 14:00:00', '2025-06-19 23:59:59'),
(1, 'Deseja implementar coleta seletiva de lixo?', '2025-06-10 10:00:00', '2025-06-24 23:59:59'),
(1, 'Qual esporte priorizar na quadra?', '2025-06-12 10:00:00', '2025-06-26 23:59:59'),
(1, 'Sugestões para melhoria da segurança?', '2025-06-15 09:00:00', '2025-06-29 23:59:59'),
(1, 'Qual tipo de serviço de lavanderia preferiria?', '2025-06-18 10:00:00', '2025-07-02 23:59:59'),
(1, 'Quais você gostaria na Noite das Massas?', '2025-06-20 10:00:00', '2025-07-04 23:59:59');

-- Enquete 1: Qual cor pintar a fachada do Bloco C?
INSERT INTO `Opcao` (`Enquete_IdEnquete`, `tituloOpcao`) VALUES
(1, 'Azul Céu'),
(1, 'Branco Gelo'),
(1, 'Areia Clara'),
(1, 'Amarelo Suave'),
(1, 'Coral'),
(1, 'Rosa queimado'),
(1, 'Duas cores (seleciona esta opção + duas cores');

-- Enquete 2: Preferência de dia para feira de condomínio?
INSERT INTO `Opcao` (`Enquete_IdEnquete`, `tituloOpcao`) VALUES
(2, 'Quarta-feira de manhã'),
(2, 'Sábado de manhã'),
(2, 'Sábado a noite');

-- Enquete 3: Qual melhor dia para manutenção da piscina?
INSERT INTO `Opcao` (`Enquete_IdEnquete`, `tituloOpcao`) VALUES
(3, 'Segunda-feira'),
(3, 'Terça-feira'),
(3, 'Quarta-feira'),
(3, 'Quinta-feira');

-- Enquete 4: Interesse em aulas de yoga no condomínio?
INSERT INTO `Opcao` (`Enquete_IdEnquete`, `tituloOpcao`) VALUES
(4, 'Sim, tenho interesse'),
(4, 'Não, obrigado');

-- Enquete 5: Qual tipo de evento social devemos organizar?
INSERT INTO `Opcao` (`Enquete_IdEnquete`, `tituloOpcao`) VALUES
(5, 'Festa Junina'),
(5, 'Noite de Massas'),
(5, 'Dia do Circo'); 

-- Enquete 6: Deseja implementar coleta seletiva de lixo?
INSERT INTO `Opcao` (`Enquete_IdEnquete`, `tituloOpcao`) VALUES
(6, 'Sim, com urgência'),
(6, 'Não tenho interesse');

-- Enquete 7: Qual esporte priorizar na quadra?
INSERT INTO `Opcao` (`Enquete_IdEnquete`, `tituloOpcao`) VALUES
(7, 'Futsal'),
(7, 'Basquete'),
(7, 'Vôlei'),
(7, 'Handball'); 

-- Enquete 8: Sugestões para melhoria da segurança?
INSERT INTO `Opcao` (`Enquete_IdEnquete`, `tituloOpcao`) VALUES
(8, 'Instalar mais câmeras'),
(8, 'Contratar mais seguranças noturnos'),
(8, 'Gostaria de uma assembléia para ouvir argumentos');

-- Enquete 9: Qual tipo de serviço de lavanderia preferiria?
INSERT INTO `Opcao` (`Enquete_IdEnquete`, `tituloOpcao`) VALUES
(9, 'Autônomo, eu mesmo lavo e seco.'),
(9, 'Terceirizado, com coleta e entrega');

-- Enquete 10: Quais você gostaria na noite das massas?
INSERT INTO `Opcao` (`Enquete_IdEnquete`, `tituloOpcao`) VALUES
(10, 'Lasanha à Bolonhesa'),
(10, 'Cacio e Pepe'),
(10, 'Tagliatelle al Ragù'),
(10, 'Ravioli de Ricota e Espinafre'), 
(10, 'Gnocchi ao Molho de Tomate Fresco'),
(10, 'Carbonara'),
(10, 'Canelloni de Carne Seca e Abóbora'),
(10, 'Fettuccine Alfredo'),
(10, 'Tortellini in Brodo'),
(10, 'Penne All’Arrabbiata'),
(10, 'Agnolotti de Cordeiro');

-- Votos 
-- Enquete 1
INSERT INTO `Voto` (`Morador_IdMorador`, `Opcao_IdOpcao`) VALUES
(1, 1), (1, 2), (1, 3), -- Yolanda
(2, 2), (2, 4), -- Bruno
(3, 3), (3, 5), (3, 7), -- Kate
(4, 4), (4, 6), (4, 1), -- Luan
(5, 5), (5, 7), (5, 2), -- Eduarda
(6, 6), (6, 1), (6, 3), -- Fernando
(7, 7), (7, 4), -- Celine
(8, 1), (8, 5), (8, 6), -- Hugo
(9, 2), (9, 3); -- Bella

-- Enquete 2
INSERT INTO `Voto` (`Morador_IdMorador`, `Opcao_IdOpcao`) VALUES
(1, 8), (1, 9), -- Yolanda
(2, 9), (2, 10), -- Bruno
(3, 8), (3, 10), -- Kate
(4, 10), (4, 8), -- Luan
(5, 9), (5, 8), -- Eduarda
(6, 8), (6, 9), -- Fernando
(7, 9), (7, 10), -- Celine
(8, 10), (8, 9), -- Hugo
(9, 8), (9, 9); -- Bella

-- Enquete 3
INSERT INTO `Voto` (`Morador_IdMorador`, `Opcao_IdOpcao`) VALUES
(1, 11), (1, 12), -- Yolanda
(2, 12), (2, 13), -- Bruno
(3, 11), (3, 14), -- Kate
(4, 13), (4, 11), -- Luan
(5, 14), (5, 12), -- Eduarda
(6, 11), (6, 13), -- Fernando
(7, 12), (7, 14), -- Celine
(8, 13), (8, 11), -- Hugo
(9, 14), (9, 12); -- Bella

-- Enquete 4
INSERT INTO `Voto` (`Morador_IdMorador`, `Opcao_IdOpcao`) VALUES
(1, 15), 
(2, 16), 
(3, 15), 
(4, 15), 
(5, 16),
(6, 15), 
(7, 15), 
(8, 16), 
(9, 15);

-- Enquete 5
INSERT INTO `Voto` (`Morador_IdMorador`, `Opcao_IdOpcao`) VALUES
(1, 17), (1, 18), -- Yolanda
(2, 18), (2, 19), -- Bruno
(3, 17), (3, 19), -- Kate
(4, 19), (4, 17), -- Luan
(5, 18), (5, 17), -- Eduarda
(6, 17), (6, 18), -- Fernando
(7, 19), (7, 18), -- Celine
(8, 18), (8, 19), -- Hugo
(9, 17), (9, 18); -- Bella

-- Enquete 6
INSERT INTO `Voto` (`Morador_IdMorador`, `Opcao_IdOpcao`) VALUES
(1, 20), 
(2, 20), 
(3, 21), 
(4, 20), 
(5, 20),
(6, 21), 
(7, 20), 
(8, 20), 
(9, 21);

-- Enquete 7
INSERT INTO `Voto` (`Morador_IdMorador`, `Opcao_IdOpcao`) VALUES
(1, 22), (1, 23), -- Yolanda
(2, 23), (2, 24), -- Bruno
(3, 22), (3, 25), -- Kate
(4, 24), (4, 22), -- Luan
(5, 25), (5, 23), -- Eduarda
(6, 22), (6, 24), -- Fernando
(7, 23), (7, 25), -- Celine
(8, 24), (8, 22), -- Hugo
(9, 25), (9, 23); -- Bella

-- Enquete 8
INSERT INTO `Voto` (`Morador_IdMorador`, `Opcao_IdOpcao`) VALUES
(1, 26), (1, 27), -- Yolanda
(2, 27), (2, 28), -- Bruno
(3, 28), (3, 26), -- Kate
(4, 26), (4, 27), -- Luan
(5, 27), (5, 28), -- Eduarda
(6, 28), (6, 26), -- Fernando
(7, 26), (7, 27), -- Celine
(8, 27), (8, 28), -- Hugo
(9, 28), (9, 26); -- Bella

-- Enquete 9
INSERT INTO `Voto` (`Morador_IdMorador`, `Opcao_IdOpcao`) VALUES
(1, 29), 
(2, 30), 
(3, 29), 
(4, 30), 
(5, 29),
(6, 30), 
(7, 29), 
(8, 30), 
(9, 29);

-- Enquete 10
INSERT INTO `Voto` (`Morador_IdMorador`, `Opcao_IdOpcao`) VALUES
(1, 31), (1, 32), (1, 33),  -- Yolanda
(2, 32), (2, 34), (2, 35),  -- Bruno
(3, 33), (3, 36), (3, 37),  -- Kate
(4, 34), (4, 38), (4, 39),  -- Luan
(5, 35), (5, 39), (5, 40),  -- Eduarda
(6, 36), (6, 41), (6, 31),  -- Fernando
(7, 37), (7, 32), (7, 33),  -- Celine
(8, 38), (8, 34), (8, 35),  -- Hugo
(9, 39), (9, 36), (9, 37);  -- Bella


INSERT INTO `Taxa` (`titulo`, `vencimento`, `valorCobrado`, `descricao`) VALUES
('Taxa Condominial Jun/2025', '2025-06-10 23:59:59', 850.00, 'Mensalidade de condomínio referente a Junho.'),
('Fundo de Reserva', '2025-06-10 23:59:59', 85.00, 'Valor adicional para fundo de reserva.'),
('Multa por Barulho', '2025-06-15 23:59:59', 150.00, 'Multa por reclamação de barulho excessivo (Ref. Ocorrência ID 2).'),
('Taxa de Mudança', '2025-06-20 23:59:59', 100.00, 'Taxa para uso do elevador de serviço em dia de mudança.'),
('Consumo de Água Mai/2025', '2025-06-25 23:59:59', 75.20, 'Consumo individual de água referente a Maio.'),
('Extra - Reforma Fachada', '2025-07-01 23:59:59', 200.00, 'Rateio para custear a reforma da fachada do Bloco A.'),
('Multa por Lixo Incorreto', '2025-07-05 23:59:59', 50.00, 'Multa por descarte de lixo fora do horário (Ref. Ocorrência ID 4).'),
('Taxa de Gás Jun/2025', '2025-07-10 23:59:59', 45.80, 'Consumo individual de gás referente a Junho.'),
('IPTU (rateio)', '2025-07-15 23:59:59', 120.00, 'Parcela de IPTU rateada entre condôminos.'),
('Consumo de Energia Áreas Comuns', '2025-07-20 23:59:59', 30.00, 'Rateio do consumo de energia das áreas comuns.');


INSERT INTO `Transacao` (`valorPago`, `formaPagamento`, `Taxa_IdTaxa`, `Morador_IdMorador`) VALUES
(850.00, 'Pix', 1, 1),
(85.00, 'Crédito', 2, 1),
(150.00, 'Dinheiro em espécie', 3, 4), -- Luan pagou a multa da ocorrencia por barulho
(100.00, 'Debito', 4, 2),
(75.20, 'Pix', 5, 3),
(200.00, 'Crédito', 6, 6),
(50.00, 'Pix', 7, 5),
(45.80, 'Crédito', 8, 8),
(120.00, 'Pix', 9, 1),
(120.00, 'Crédito', 9, 2),
(120.00, 'Pix', 9, 3),
(120.00, 'Pix', 9, 4),
(120.00, 'Crédito', 9, 5),
(120.00, 'Pix', 9, 6),
(120.00, 'Crédito', 9, 7),
(100.00, 'Boleto', 9, 8), -- Hugo pagou R$ 100 do rateio IPTU, onde o valor cobrado era R$ 120.
(120.00, 'Pix', 9, 9),
(30.00, 'Debito', 10, 9);

SELECT * FROM AreaComum;
SELECT * FROM Pessoa;
SELECT * FROM Morador;
SELECT * FROM Reserva;
SELECT * FROM Sindico;
SELECT * FROM Ocorrencia;
SELECT * FROM EnvolvimentoOcorrencia;
SELECT * FROM Comunicado;
SELECT * FROM AtaAssembleia;
SELECT * FROM Enquete;
SELECT * FROM Opcao;
SELECT * FROM Voto;
SELECT * FROM Taxa;
SELECT * FROM TRansacao;





