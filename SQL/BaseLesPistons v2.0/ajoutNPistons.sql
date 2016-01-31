

alter PROC ajoutNPistons @nombrePistons int, @message varchar(255) OUTPUT

AS

DECLARE @nbPistLot int;
DECLARE @typePiston int;
DECLARE @compteur int;
DECLARE @compteurTotal int;
DECLARE @nomCateg TypeNom;
DECLARE @nbModele int;
DECLARE @modele TypeNom;
DECLARE @coteModele TypeCote;
DECLARE @numLot TypeNumLot;
DECLARE @numPiece TypeNumPiece;

DECLARE @diamHL TypeCote;
DECLARE @diamHT TypeCote;
DECLARE @diamBL TypeCote;
DECLARE @diamBT TypeCote;

DECLARE @erreur1 TypeCote;
DECLARE @erreur2 TypeCote;
DECLARE @erreur3 TypeCote;
DECLARE @erreur4 TypeCote;


DECLARE @codeRet int;

BEGIN
	BEGIN TRY
		SET @compteurTotal = 0;
		SET @nomCateg = '';
		set @codeRet = 0;
		WHILE (@codeRet = 0 AND @compteurTotal < @nombrePistons)
		BEGIN

			SET @nbPistLot = 1 + RAND() * 5;
			PRINT 'Nombre de Pièces pour ce lot : ' + CAST(@nbPistLot AS varchar(5));
			SET @nbModele = CEILING(RAND() * 4);

			SET @modele =
				CASE
				WHEN @nbModele = 1 THEN 'R4'
				WHEN @nbModele = 2 THEN 'R8'
				WHEN @nbModele = 3 THEN 'R12'
				ELSE 'Mégane'
			END
			PRINT 'modele : ' + CAST(@modele AS varchar(10));
			EXEC @codeRet = planifierLot @modele, @nbPistLot, @message output;
		
			--- récupération du numéro du lot 
			SELECT @numLot = MAX(numLot) FROM LOT
			-- Lancement du lot sur la presse 'JUMBO'
			EXEC @codeRet = demarrerLot @numLot, 'JUMBO', @message output;
			--- récupération de la côte de ce modèle
			SELECT @coteModele = diametre FROM MODELE WHERE modele = @modele;
	
			SET @compteur = 0;

			WHILE (@codeRet = 0 AND @compteur < @nbPistLot AND @compteurTotal + @compteur < @nombrePistons)
			BEGIN
				SET @typePiston = RAND() * 100 ;
				
				IF @typePiston < 3 
				BEGIN
					EXEC @codeRet = enregistrerPiece @numLot, 0, 0, 0, 0, 'Rebut', @numpiece OUTPUT,
						'Rayé', @message OUTPUT;
					--INSERT INTO PIECE (numLot, nomCategorie, commentaireRebut)
								--VALUES (@compteurLot, 'Rebut', 'Rayé');
				END
				ELSE IF @typePiston < 6
				BEGIN 
					EXEC @codeRet = enregistrerPiece @numLot, 0, 0, 0, 0, 'Rebut', @numpiece OUTPUT,
						'Cassé', @message OUTPUT;
					--INSERT INTO PIECE (numLot, nomCategorie, commentaireRebut)
							--VALUES (@compteurLot, 'Rebut', 'Cassé');
				END
				ELSE 
				BEGIN

					--Génération des erreurs
					SET @erreur1 = RAND()*0.12 - 0.06;
					SET @erreur2 = @erreur1 + RAND()*0.04 - 0.02;
					SET @erreur3 = @erreur1 + RAND()*0.04 - 0.02;
					SET @erreur4 = @erreur1 + RAND()*0.04 - 0.02;
					--Définitions des diamètres
					SET @diamHL = @coteModele + @erreur1;
					SET @diamHT = @coteModele + @erreur2;
					SET @diamBL = @coteModele + @erreur3;
					SET @diamBT = @coteModele + @erreur4;
					PRINT 'diam1 : ' + CAST(@diamHL AS varchar(50));
					PRINT 'diam2 : ' + CAST(@diamHT AS varchar(50));
					PRINT 'diam3 : ' + CAST(@diamBL AS varchar(50));
					PRINT 'diam4 : ' + CAST(@diamBT AS varchar(50));

					EXEC trouverCat @modele, @diamHL, @diamHT, @diamBL, @diamBT, @nomCateg OUTPUT, @message OUTPUT;
					PRINT 'Catégorie dans insérerPiston : ' + CAST(@nomCateg AS varchar(50));
			
					EXEC @codeRet = enregistrerPiece @numLot, @diamHL, @diamHT, @diamBL, @diamBT, @nomCateg, @numpiece OUTPUT,
						 '', @message OUTPUT;
				
				END
				SET @compteur += 1;
			END
			IF @compteur < @nbPistLot
			BEGIN 
				EXEC suspendreLot @numLot, @message OUTPUT;
			END
			SET @compteurTotal += @compteur;
		END
	PRINT 'Nombre de Pièces enregistrées : ' + CAST(@compteurTotal AS varchar(10));
	END TRY
	BEGIN CATCH
		-- erreur base de données
   		SET @message='Erreur base de données' + ERROR_MESSAGE();
   	END CATCH
END
RETURN @codeRet;

GO
delete Piece
GO
delete LOT
go

DECLARE @message varchar(255);
DECLARE @codeR int;
EXEC @codeR = ajoutNPistons 10, @message
SELECT @message , @codeR

