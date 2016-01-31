
USE LesPistonsMSDK
GO
--Population Table MACHINE

insert into MACHINE(libelle)
values
('ASTERIX'),
('OBELIX'),
('JUMBO')
go


--Population Table ETAT

insert into ETAT
values
('Lancé'),
('Démarré'),
('Suspendu'),
('Libéré'),
('Arrêté')
GO


--Population Table CATEGORIE

INSERT INTO CATEGORIE
VALUES
('Petit','-0.1','-0.01'),
('Moyen','-0.05','+0.05'),
('Gros','+0.01','+0.1'),
('Rebut', NULL, NULL)
GO



--Population Table MODELE

insert MODELE (modele, diametre, seuilMini)
values ('R4',30, 20.0);
insert MODELE (modele, diametre, seuilMini)
values ('R8',35, 25.0);
insert MODELE (modele, diametre, seuilMini)
values ('R12',40, 30.0);
insert MODELE (modele, diametre, seuilMini)
values ('Mégane',45.5, 60.0);
GO

-- Table STOCK remplie par le trigger
/*
--Population Table STOCK

insert STOCK
values('R4', 'moyen',3)
insert STOCK
values('R4', 'petit',1)
insert STOCK
values('R4', 'gros',2)
insert STOCK
values('R8', 'moyen',1)
insert STOCK
values('R8', 'petit',1)
insert STOCK
values('R8', 'gros',2)
insert STOCK
values('R12', 'moyen',6)
insert STOCK
values('R12', 'petit',2)
insert STOCK
values('R12', 'gros',2)
insert STOCK
values('Mégane', 'moyen', 7)
insert STOCK
values('Mégane', 'petit',0)
insert STOCK
values('Mégane', 'gros',1)

*/
--Population Table LOT

insert into LOT (nbPiecesDemandees, numPresse, modele)						
values
(20, 1 ,'R4'),
(100, 2 , 'R12'),
(50, 3, 'Mégane')
go

--Population Table PIECE
-- LOT 1 
insert into PIECE (numLot, nomCategorie, commentaireRebut)
values (1, 'Rebut', 'Cassé') , (1, 'Rebut', 'Rayé');
GO
insert into PIECE (numLot, nomCategorie, diametreHL, diametreHT, diametreBL, diametreBT)
values (1,'Moyen', 30,30,30,30), 
(1,'Moyen', 30.015,30.02,30.025,30.03), 
(1, 'Gros', 30.015,30.02,30.06,30.07), 
(1, 'Rebut', 30.005, 30.015, 30.055,30.05), 
(1, 'Rebut', 30.04,30.06,30.08,30.11), 
(1, 'Moyen', 30.045,30.01,30.015,30.02), 
(1, 'Moyen', 29.96,29.97,30.01,30.02)
GO
insert into PIECE (numLot, nomCategorie, commentaireRebut)
values(1, 'Rebut', 'Cassé')
GO
insert into PIECE (numLot, nomCategorie, diametreHL, diametreHT, diametreBL, diametreBT)
values (1,'Petit',29.91,29.92,29.96,29.98),
(1,'Rebut', 29.897,29.9,29.91,29.92),
(1,'Moyen', 29.953,29.955,29.96,29.97),
(1,'Rebut', 29.91,29.96,29.97,29.993),
(1,'Moyen', 29.96,29.99,30.01,30.04),
(1,'Rebut', 29.94,30,30,30.06),
(1,'Petit', 29.91,29.96,29.98,29.987),
(1,'Moyen', 29.953,29.999,30.01,30.047),
(1,'Moyen', 29.995,29.997,30.001,30.002),
(1,'Moyen', 29.953,29.99,30.01,30.047)
GO

-- LOT 2 
/*
insert PIECE (numLot, diametreHL, diametreHT, diametreBL, diametreBT)
values (2,30.05,30.05,30,30);
insert PIECE (numLot, diametreHL, diametreHT, diametreBL, diametreBT)
values(2,30.01,30.01,30.1,30.1);
insert PIECE (numLot, diametreHL, diametreHT, diametreBL, diametreBT)
values(2,29.95,29.95,30.05,30.05);
insert PIECE (numLot, diametreHL, diametreHT, diametreBL, diametreBT)
values(2,29.99,29.99,29.9,29.9);
insert PIECE (numLot, diametreHL, diametreHT, diametreBL, diametreBT)
values(2,29.993,29.993,29.91,29.91);
insert PIECE (numLot, diametreHL, diametreHT, diametreBL, diametreBT)
values(2,29.94,29.94,29.897,29.897);
insert PIECE (numLot, diametreHL, diametreHT, diametreBL, diametreBT)
values(2,30,30.01,29.98,29.99);
insert into PIECE (numLot, nomCategorie, commentaireRebut)
values(2, 'Rebut', 'Cassé') , (2, 'Rebut', 'Rayé');
GO
insert PIECE (numLot, diametreHL, diametreHT, diametreBL, diametreBT)
values(2,29.9,29.91,29.92,29.93);
insert PIECE (numLot, diametreHL, diametreHT, diametreBL, diametreBT)
values(2,29.97,29.96,30.01,30.053);
insert PIECE (numLot, diametreHL, diametreHT, diametreBL, diametreBT)
values(2,29.99,29.99,30.01,30);
*/