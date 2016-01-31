
--TESTS DE LA PROCEDURE enregistrerPiece
UPDATE LOT
SET etatDuLot = 'Démarré'
WHERE numLot = 1 OR numLot = 3
USE ProjetD
GO

DECLARE @lot TypeNumLot;
DECLARE @cat TypeNom;
DECLARE @numPiece TypeNumPiece;
DECLARE @commentaire TypeNom;
DECLARE @message varchar(100);
DECLARE @codeR int;
SET @lot = 3;
SET @commentaire = 'Cassé';
SET @cat = '';
SET @message = '';
SET @numPiece = 0;

-- Test enregistrement standard
PRINT 'Test enregistrement standard'
EXEC @codeR = enregistrerPiece @lot, 30.03, 30.02, 30.02, 30.02, @cat OUTPUT, @numPiece OUTPUT, @commentaire, @message OUTPUT
SELECT @message, @codeR, @cat, @numPiece
SELECT *, @cat AS CATSOURCE, @commentaire AS COMMENTAIRESOURCE, @numPiece AS IDPIECE, @message AS Message, @codeR AS CODE FROM PIECE WHERE numLot = @lot



INSERT INTO PIECE (numLot, nomCategorie, diametreHL, diametreHT, diametreBL, diametreBT)
						VALUES (1, 'Petit',30, 30 , 30, 30)

						SELECT * FROM LOT WHERE numLot = 2 
													AND nbPiecesDemandees = (SELECT COUNT(*)
																			 FROM PIECE
																			 WHERE numLot = 1
																			 )

DECLARE @codeR int;
DECLARE @message varchar(100);
EXEC @codeR = arreterLot  1, @message OUTPUT
SELECT @codeR, @message

--Test Paramètres manquants
PRINT 'Test Paramètres manquants'
EXEC @codeR = enregistrerPiece NULL, 30.05, 30.08, 30.02, 30.02, @cat OUTPUT, @numPiece OUTPUT, @commentaire, @message OUTPUT
SELECT *, @cat AS CATSOURCE, @commentaire AS COMMENTAIRESOURCE, @numPiece AS IDPIECE, @message AS Message, @codeR AS CODE FROM PIECE WHERE numLot = @lot

EXEC @codeR = enregistrerPiece @lot, NULL, 30.02, 30.02, 30.02, @cat OUTPUT, @numPiece OUTPUT, @commentaire, @message OUTPUT
SELECT *, @cat AS CATSOURCE, @commentaire AS COMMENTAIRESOURCE, @numPiece AS IDPIECE, @message AS Message, @codeR AS CODE FROM PIECE WHERE numLot = @lot

EXEC @codeR = enregistrerPiece @lot, 30.02, NULL, 30.02, 30.02, @cat OUTPUT, @numPiece OUTPUT, @commentaire, @message OUTPUT
SELECT *, @cat AS CATSOURCE, @commentaire AS COMMENTAIRESOURCE, @numPiece AS IDPIECE, @message AS Message, @codeR AS CODE FROM PIECE WHERE numLot = @lot

EXEC @codeR = enregistrerPiece @lot, 30.02, 30.02, NULL, 30.02, @cat OUTPUT, @numPiece OUTPUT, @commentaire, @message OUTPUT
SELECT *, @cat AS CATSOURCE, @commentaire AS COMMENTAIRESOURCE, @numPiece AS IDPIECE, @message AS Message, @codeR AS CODE FROM PIECE WHERE numLot = @lot

EXEC @codeR = enregistrerPiece @lot, 30.02, 30.02, 30.02, NULL, @cat OUTPUT, @numPiece OUTPUT, @commentaire, @message OUTPUT
SELECT *, @cat AS CATSOURCE, @commentaire AS COMMENTAIRESOURCE, @numPiece AS IDPIECE, @message AS Message, @codeR AS CODE FROM PIECE WHERE numLot = @lot

EXEC @codeR = enregistrerPiece @lot, 30.02, 30.02, 30.02, 30.02, NULL, @numPiece OUTPUT, @commentaire, @message OUTPUT
SELECT *, @cat AS CATSOURCE, @commentaire AS COMMENTAIRESOURCE, @numPiece AS IDPIECE, @message AS Message, @codeR AS CODE FROM PIECE WHERE numLot = @lot

EXEC @codeR = enregistrerPiece @lot, 30.02, 30.02, 30.02, 30.02, @cat OUTPUT, NULL, @commentaire, @message OUTPUT
SELECT *, @cat AS CATSOURCE, @commentaire AS COMMENTAIRESOURCE, @numPiece AS IDPIECE, @message AS Message, @codeR AS CODE FROM PIECE WHERE numLot = @lot

EXEC @codeR = enregistrerPiece @lot, 30.02, 30.02, 30.02, 30.02, @cat OUTPUT, @numPiece OUTPUT, NULL, @message OUTPUT
SELECT *, @cat AS CATSOURCE, @commentaire AS COMMENTAIRESOURCE, @numPiece AS IDPIECE, @message AS Message, @codeR AS CODE FROM PIECE WHERE numLot = @lot

EXEC @codeR = enregistrerPiece @lot, 30.02, 30.02, 30.02, 30.02, @cat OUTPUT, @numPiece OUTPUT, @commentaire, NULL
SELECT *, @cat AS CATSOURCE, @commentaire AS COMMENTAIRESOURCE, @numPiece AS IDPIECE, @message AS Message, @codeR AS CODE FROM PIECE WHERE numLot = @lot

-- Test lot inexistant
PRINT 'Test lot inexistant'
EXEC @codeR = enregistrerPiece 1000, 30.02, 30.02, 30.02, 30.02, @cat OUTPUT, @numPiece OUTPUT, @commentaire, @message OUTPUT
SELECT *, @cat AS CATSOURCE, @commentaire AS COMMENTAIRESOURCE, @numPiece AS IDPIECE, @message AS Message, @codeR AS CODE FROM PIECE WHERE numLot = @lot


-- Test enregistrement standard
PRINT 'Test enregistrement standard'
EXEC @codeR = enregistrerPiece @lot, 30.03, 30.02, 30.02, 30.02, @cat OUTPUT, @numPiece OUTPUT, @commentaire, @message OUTPUT
SELECT *, @cat AS CATSOURCE, @commentaire AS COMMENTAIRESOURCE, @numPiece AS IDPIECE, @message AS Message, @codeR AS CODE FROM PIECE WHERE numLot = @lot



-- Tests Procédure statReduites @numLot typeNumLot, @message varchar(255) OUTPUT

DECLARE @message varchar(255)
DECLARE @code int;

-- Test appel procédure normal

EXEC @code =statReduites 1, @message
SELECT @message, @code;

-- Tests Paramètres manquants

@code = EXEC statReduites NULL, @message
SELECT @message, @codeRet;

@code = EXEC statReduites -1, @message
SELECT @message, @codeRet;



-- Tests Procédure statCat @numLot typeNumLot, @message varchar(255) OUTPUT

-- Tests Paramètres manquants

@code = EXEC statCat NULL, @message
SELECT @message, @codeRet;

DECLARE @message varchar(100);
DECLARE @code INT;
EXEC @code = statCat 2, @message output
SELECT @message, @code;
-- Test appel procédure normal
DECLARE @numLot INT = 2;
SELECT nomCategorie AS CATEGORIE, SUM (nombreDePieces) AS QUANTITE
				FROM CUMUL 
				WHERE numLot = @numLot
				GROUP BY nomCategorie, numLot

				UNION

				SELECT 'Total' AS CATEGORIE, SUM (nombreDePieces) AS QUANTITE
				FROM CUMUL 
				WHERE numLot = @numLot
				

EXEC statCat 1, @message
SELECT @message, @codeRet;
-- Tests Paramètres manquants


--TESTS PROCEDURE trouverCat

EXEC trouverCat @modele TypeNom, @cote1 TypeCote, @cote2 TypeCote, 
			@cote3 TypeCote, @cote4 TypeCote, @nomCat TypeNom OUTPUT, 
			@message varchar(255) OUTPUT
DECLARE @cat TypeNom;
DECLARE @message varchar(255);
EXEC trouverCat 'Mégane', 45.5,45.5,45.5,45.5, @cat OUTPUT,@message;
select @cat, @message
