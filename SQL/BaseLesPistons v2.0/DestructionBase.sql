
USE LesPistonsMSDK
GO

DROP FUNCTION [dbo].nbPiecesRestantes
GO
DROP VIEW PRESSE
GO
DROP VIEW production
GO
DROP VIEW stockPlanif
GO
DROP TRIGGER tgCumul
GO
DROP PROC majStats
GO
drop function fnStatsReduites
GO
drop proc statReduites
GO
drop function fnStatsCat
GO
drop proc statCat
GO
drop proc modifierSeuil
GO
drop proc supprModele
GO
drop trigger  addModeleStock 
GO
drop trigger supprModeleStock 
GO
drop proc ajouterMachine
GO
drop proc supprimerMachine
GO
drop proc changerEtatLot
GO
drop proc planifierLot
GO
drop proc demarrerLot
GO
drop proc suspendreLot
GO
drop function prodPrecedente
GO
drop proc trouverCat
GO
drop proc enregistrerPiece
GO
drop proc entreeCaisse
GO
drop proc sortieCaisse
go
drop proc arreterLot
GO
drop proc ajoutModele
GO

drop table PIECE
GO
drop TABLE CUMUL
GO
drop table LOT
GO
drop table STOCK
GO
drop table MODELE
GO
drop TABLE CATEGORIE
GO
drop table ETAT
GO
drop table MACHINE
GO
drop type TypeCommentaire
GO
drop type TypeQuantite
GO
drop type TypeNumPiece
GO
drop type TypeNumLot
GO
drop type TypeCote
GO
drop type TypeDate
GO
drop type TypeNom
GO
drop type TypeNumPresse
GO


USE master
GO
DROP DATABASE LesPistonsMSDK
GO