CREATE DATABASE LesPistonsMSDK
GO
USE LesPistonsMSDK

--Créations des droits


exec sp_adduser JavaUser1, responsablePlanif;
GO
exec sp_adduser JavaUser2, responsableProd;
GO
exec sp_adduser JavaUser3, responsableControle;
GO
exec sp_adduser JavaUser4, responsableQualite
GO
exec sp_adduser JavaUser5, responsableGestion
GO
exec sp_adduser JavaUser6, responsableMagasin
GO

exec sp_addrolemember 'db_owner', responsablePlanif;
GO
exec sp_addrolemember 'db_owner', responsableProd;
GO
exec sp_addrolemember 'db_owner', responsableControle;
GO
exec sp_addrolemember 'db_owner', responsableQualite;
GO
exec sp_addrolemember 'db_owner', responsableGestion;
GO
exec sp_addrolemember 'db_owner', responsableMagasin;
GO

--Création des types

CREATE type TypeDate
FROM DATETIME
GO
CREATE type TypeNumPresse
FROM SMALLINT

GO
CREATE type TypeNom
FROM VARCHAR(50)
Not NULL
GO
CREATE type TypeCote
FROM DECIMAL(6,4)
GO
CREATE type TypeNumLot
FROM INT
NOT NULL
GO
CREATE type TypeNumPiece
FROM INT
NOT NULL
GO
CREATE type TypeQuantite
FROM INT
NOT NULL
GO
CREATE type TypeCommentaire
FROM VARCHAR(50)
GO

--Création des tables
CREATE TABLE MACHINE
(
numPresse TypeNumPresse identity(1,1) primary key,
libelle TypeNom NOT NULL constraint nomPresseEmpty CHECK (libelle LIKE '[a-zA-Z0-9]%'),
etatPresse TypeNom NOT NULL constraint etatPresseEmpty CHECK (etatPresse LIKE '[a-zA-Z0-9]%') DEFAULT 'Libre'
)


CREATE TABLE ETAT
(
nomEtat TypeNom NOT NULL primary key  constraint nomEtatEmpty CHECK (nomEtat LIKE '[a-zA-Z0-9]%')
)
GO

--Population Table ETAT

INSERT INTO ETAT
VALUES
('Lancé'),
('Démarré'),
('Suspendu'),
('Libéré'),
('Arrêté')
GO

CREATE TABLE CATEGORIE
(
nomCategorie TypeNom  PRIMARY KEY NOT NULL constraint nomCategorieEmpty CHECK (nomCategorie LIKE '[a-zA-Z0-9]%'),
toleranceMini TypeCote,
toleranceMaxi TypeCote
)
GO

--Population Table CATEGORIE

INSERT INTO CATEGORIE
VALUES
('Petit','-0.1','-0.01'),
('Moyen','-0.05','+0.05'),
('Gros','+0.01','+0.1'),
('Rebut', NULL, NULL)
GO

CREATE TABLE MODELE
(
modele TypeNom  NOT NULL primary key constraint tableModeleEmpty CHECK (modele LIKE '[a-zA-Z0-9]%'),
diametre TypeCote NOT NULL,
seuilMini TypeQuantite NOT NULL CHECK (seuilMini >=0) DEFAULT 0,
)
GO

CREATE TABLE STOCK
(
modele TypeNom      	foreign key(modele)   references MODELE(modele),
nomCategorie TypeNom 	foreign key(nomCategorie) references CATEGORIE(nomCategorie) CHECK (nomCategorie <> 'Rebut'),
constraint cle_double_Stock primary key (modele,nomCategorie),
quantiteStock TypeQuantite NULL CHECK (quantiteStock >= 0)  Default  0,
)
GO

CREATE TABLE LOT
(
numLot TypeNumLot identity(1,1) primary key,
nbPiecesDemandees TypeQuantite NOT NULL CHECK (nbPiecesDemandees > 0),
dateDePlanification TypeDate,
dateDeFabrication TypeDate,
etatDuLot TypeNom NULL references ETAT (nomEtat) DEFAULT 'Lancé',
numPresse TypeNumPresse references MACHINE (numPresse),
modele TypeNom NOT NULL references MODELE (modele),
moyenneHL TypeCote CHECK (moyenneHL >=0),
moyenneHT TypeCote CHECK (moyenneHT >=0),
moyenneBL TypeCote CHECK (moyenneBL >=0),
moyenneBT TypeCote CHECK (moyenneBT >=0),
maximumHL TypeCote CHECK (maximumHL >=0),
maximumHT TypeCote CHECK (maximumHT >=0),
maximumBL TypeCote CHECK (maximumBL >=0),
maximumBT TypeCote CHECK (maximumBT >=0),
minimumBL TypeCote CHECK (minimumBL >=0),
minimumBT TypeCote CHECK (minimumBT >=0),
minimumHL TypeCote CHECK (minimumHL >=0),
minimumHT TypeCote CHECK (minimumHT >=0),
ecartTypeHL TypeCote CHECK (ecartTypeHL >=0),
ecartTypeHT TypeCote CHECK (ecartTypeHT >=0),
ecartTypeBL TypeCote CHECK (ecartTypeBL >=0),
ecartTypeBT TypeCote CHECK (ecartTypeBT >=0)
)
GO

CREATE TABLE CUMUL
(
numLot TypeNumLot  FOREIGN KEY(numLot) REFERENCES LOT(numLot),
nomCategorie TypeNom FOREIGN KEY (nomCategorie) REFERENCES CATEGORIE(nomCategorie),
Constraint cleDoubleCumul PRIMARY KEY(numLot,nomCategorie),
nombreDePieces TypeNumPiece CHECK (NombreDePieces >=0)
)
GO
CREATE TABLE PIECE
(
idPiece TypeNumPiece identity(1,1) Primary key,
numLot TypeNumLot foreign key(numLot) references LOT(numLot),
nomCategorie TypeNom foreign key(nomCategorie) references CATEGORIE(Nomcategorie),
diametreHL TypeCote DEFAULT 0 CHECK (DiametreHL >= 0), 
diametreHT TypeCote DEFAULT 0 CHECK (DiametreHT >= 0),
diametreBL TypeCote DEFAULT 0 CHECK (DiametreBL >= 0),
diametreBT TypeCote DEFAULT 0 CHECK (DiametreBT >= 0),
commentaireRebut TypeCommentaire
)
GO


--Procédures Stockées


/* 
1) trouverRole 
2) ajoutModele
3) modifierSeuil
4) supprModele
5) addModeleStock (Trigger)
6) supprModeleStock (Trigger)
7) ajouterMachine
8) supprimerMachine
9) changerEtatLot
10) planifierLot
11) demarrerLot
12) suspendreLot
13) prodPrecedente
14) trouverCat
15) enregistrementPiece
16) entreeCaisse
17) sortieCaisse
18) fnStatsReduites
19) statReduites
20) fnStatsCat
21) statCat
22) metteAjourStat
23) tgCumul (Trigger)
*/








/** 2) ajoutModele
======================================================================================================
*
* La PROC ajoutModele permet d'ajouter un modèle de piston
*
*
* @author  MSDK
* @version 1.0
* @since   2016-12-01
*
*
*@modele est le modele de piston
*
======================================================================================================
*/

CREATE PROC ajoutModele @modele TypeNom,@diametre TypeCote, @message VARCHAR(255) OUTPUT

--code retour
--   		 1: un parametre possede une valeur nulle
--   		 2: la modèle existe déja
--      	 3: erreur base de données( exception)
--   		 0:ok
-- sortie :@message: contient le message d'erreur

AS

DECLARE @coderet INT;
DECLARE @dummy CHAR;
----verification des parametres

IF @modele IS NULL OR  @modele NOT LIKE '[a-zA-Z0-9]%'
BEGIN
    SET @coderet=1;
    SET @message = 'Erreur : Nom de modèle invalide';
END
ELSE IF @diametre IS NULL OR  @diametre <= 0
BEGIN
	SET @coderet=1;
    SET @message = 'Erreur : Diamètre invalide';
END
ELSE
BEGIN
   	BEGIN TRY
		BEGIN TRANSACTION
		SELECT @dummy = ' '
		FROM	MODELE  WITH (HOLDLOCK, TABLOCK)
				--STOCK  WITH (HOLDLOCK, HOLDLOCK) -- trigger ???
		WHERE Modele.modele IS NULL; 
		--verifier l existence du modele de piston
   		IF EXISTS (SELECT modele 
					FROM MODELE
					WHERE modele = @modele)  
		BEGIN
   			SET @message ='Erreur : le modèle  ' + @modele + ' existe déjà';
   			SET @codeRet =2;
			ROLLBACK TRANSACTION;
   		END
   		ELSE
   		BEGIN		 
			INSERT INTO MODELE(modele,diametre,seuilMini)
			VALUES (@modele,@diametre,0)

			SET @codeRet = 0;
			SET @message = 'Le modèle ' + @modele + ' a été ajouté';
				 
			COMMIT TRANSACTION;		 					 
   		END
	END TRY
   	BEGIN CATCH
   		-- erreur base de données
		ROLLBACK TRANSACTION;

   		SET @message='Erreur base de données' + ERROR_MESSAGE();
   		SET @coderet=3;
		
   	END CATCH
END
RETURN (@coderet);
GO




/** /3
======================================================================================================
*
* La PROC modifierSeuil permet de modifier le Seuil d'alerte du stock pour chaque modèle de piston
*
*
* @author  MSDK
* @version 1.0
* @since   2016-12-01
*
*
*@modele est le modele de piston
*
*@SeuilMini est le seuil minimum pour lequel ON souhaite mettre une alerte
*
======================================================================================================
*/

CREATE PROC modifierSeuil @modele TypeNom, @SeuilMini TypeQuantite , @message VARCHAR(255) OUTPUT

--code retour
--   		 1: un parametre possede une valeur nulle
--   		 2: la presse existe déjà
--      	 3: erreur base de données( exception)
--   		 0: ok
-- sortie :@message: contient le message d'erreur

AS

DECLARE @coderet INT;

----verification des parametres

IF @modele IS NULL OR  @modele NOT LIKE '[a-zA-Z0-9]%'   --!! en remplacement de [A-Za-z]%
BEGIN
    SET @coderet=1;
    SET @message = 'Erreur : Nom de modèle invalide';
END
ELSE IF @seuilMini IS NULL OR  @seuilMini < 0 
BEGIN
	SET @coderet = 1;
	SET @message = 'Erreur : Seuil d''alerte non valide';
END
ELSE
BEGIN
   	BEGIN TRY
		 BEGIN TRANSACTION --verifier l existence du modele, dans la TRANSACTION
			IF NOT EXISTS (SELECT Modele FROM MODELE WITH (HOLDLOCK, TABLOCKX) WHERE modele = @modele)
   			 BEGIN
			 
				ROLLBACK TRANSACTION;

   				SET @message ='Erreur : le modèle ' + @modele + ' n''existe pas';
   				SET @codeRet =2;
				
   			 END
   			 ELSE
   			 BEGIN
   				 UPDATE Modele
				 SET seuilMini = @SeuilMini
				 WHERE modele = @modele
				 
				 COMMIT TRANSACTION;

				 SET @codeRet =0;
				 SET @message = 'Seuil d''alerte mis à jour' ;
				 				 		 					 
   			 END
	END TRY
   	BEGIN CATCH
   		-- erreur base de données
		ROLLBACK TRANSACTION;

   		SET @message='Erreur base de données' + ERROR_MESSAGE();
   		SET @coderet=3;
		
   	END CATCH
END
RETURN (@coderet);
GO




/**4/
======================================================================================================
* La PROC supprModele permet de supprimer un modèle de piston
*
* @author  MSDK
* @version 1.0
* @since   2016-12-01
*
*@modele est le modele de piston
======================================================================================================
*/

CREATE PROC supprModele @modele TypeNom, @message VARCHAR(255) OUTPUT

--code retour
--   		 1: un parametre possede une valeur nulle
--   		 2: le modele n'existe pas
--      	 3: erreur base de données( exception)
--   		 0:ok
-- sortie :@message: contient le message d'erreur

AS

BEGIN

	DECLARE @coderet INT;
	DECLARE @dummy CHAR;

	----verification des parametres

	IF @modele IS NULL OR  @modele NOT LIKE '[a-zA-Z0-9]%'
	BEGIN
		SET @coderet=1;
		SET @message = 'Erreur : modèle invalide';
	END
	ELSE
   	BEGIN TRY
		BEGIN TRANSACTION 
		
		SELECT @dummy = ' '
		FROM MODELE  WITH (HOLDLOCK, TABLOCKX) , 
			 LOT WITH (HOLDLOCK, TABLOCKX)
			--STOCK  WITH (HOLDLOCK, TABLOCKX) ? Trigger
		WHERE Modele.modele IS NULL ;
		
		IF NOT EXISTS (SELECT modele FROM MODELE  WHERE modele = @modele)  --verifier l existence du modele de piston
   		BEGIN
			ROLLBACK TRANSACTION;

   			SET @message ='Erreur : le modèle  ' + @modele + ' n''existe pas';
   			SET @codeRet =2;
				
   		END
   		ELSE IF EXISTS (SELECT modele FROM LOT  WHERE modele = @modele)
		BEGIN
			ROLLBACK TRANSACTION;

   			SET @message ='Erreur : le modèle  ' + @modele + ' ne peut etre supprimé car un lot a déjà été créé';
   			SET @codeRet =2;
				
		END
		ELSE 
   		--traitement de la suppression
		BEGIN			 
			DELETE FROM  LOT
			WHERE modele = @modele;
   				 
			--DELETE FROM  STOCK ?Trigger!
			--WHERE modele = @modele;
				 
			DELETE FROM  MODELE
			WHERE modele = @modele;

			COMMIT TRANSACTION;		 

			SET @codeRet =0;
			SET @message = 'Le modèle ' + @modele + ' a été supprimé';
				 				 
   		END
	END TRY
   	BEGIN CATCH
   		-- erreur base de données
		ROLLBACK TRANSACTION;

   		SET @message='Erreur base de données' + ERROR_MESSAGE();
   		SET @coderet=3;
			 
   	END CATCH
END
RETURN (@coderet);
GO


/**5/
======================================================================================================
* Le Trigger supprModeleStock  permet de supprimer un modèle de piston dans le stock
*
* @author  MSDK
* @version 1.0
* @since   2016-12-01
*
*lorsque l'on supprime un modèle celui ci sera également supprimé du stock avec ses catégories
======================================================================================================
*/

CREATE TRIGGER supprModeleStock 

ON MODELE

FOR DELETE

AS

BEGIN

	DELETE STOCK
	FROM deleted
	WHERE STOCK.modele = deleted.modele
END

GO


/**6/
======================================================================================================
* Le Trigger addModeleStock  permet d'ajouter un modèle de piston dans le stock
*
* @author  MSDK
* @version 1.0
* @since   2016-12-01
*
*lorsque l'ON va ajouter un modèle celui ci sera également ajouté au stock avec ses catégorie
======================================================================================================
*/
CREATE TRIGGER addModeleStock 

ON MODELE

FOR INSERT

AS

BEGIN
	
	INSERT INTO STOCK(modele,nomCategorie)
	SELECT i.modele,'Petit'
	FROM inserted i
	JOIN Modele mo
	ON i.modele = mo.modele 
	
	INSERT INTO STOCK(modele,nomCategorie)
	SELECT i.modele,'Moyen'
	FROM inserted i
	JOIN Modele mo
	ON i.modele = mo.modele 
	
	INSERT INTO STOCK(modele,nomCategorie)
	SELECT i.modele,'Gros'
	FROM inserted i
	JOIN Modele mo
	ON i.modele = mo.modele 

END
GO


/** /7 ajouterMachine
--=========================================================================================
--Auteur: MSDK
--Date : 11/01/16
--Fonction: --Cette procédure ajoute une machine
--parametres : @nomPresse est le nom de la presse concerné par la PROC.
--==========================================================================================
*/
CREATE PROC ajouterMachine @nomPresse TypeNom, @message VARCHAR(255) OUTPUT

--code retour
--   		 1: un parametre possede une valeur nulle
--   		 2: la presse existe déjà
--      	 3: erreur base de données( exception)
--   		 0:ok
-- sortie :@message: contient le message d'erreur

AS

DECLARE @coderet INT;

----verification des parametres
BEGIN
	IF @nomPresse IS NULL OR  @nomPresse NOT LIKE '[a-zA-Z0-9]%'
	BEGIN
		SET @coderet=1;
		SET @message = 'Erreur : Nom de la presse absent ou invalide';
	END
	ELSE
	BEGIN TRY
		--verifier l existence de la machine
		BEGIN TRANSACTION 
		 
   		IF EXISTS (SELECT numPresse FROM MACHINE WITH (HOLDLOCK, TABLOCKX) WHERE libelle = @nomPresse) 
   		BEGIN
			ROLLBACK TRANSACTION;

   			SET @message ='Erreur : La presse ' + @nomPresse + ' existe déjà';
   			SET @codeRet =2;				
   		END
   		ELSE
   		BEGIN
			-- creation d'une machine dans la TABLE MACHINE
   			INSERT MACHINE (libelle)
			VALUES (@nomPresse);

			COMMIT TRANSACTION;	

			SET @codeRet =0;
			SET @message = 'Presse ' + @nomPresse + ' créée';				 	 					 
   		END
	END TRY
   	BEGIN CATCH
   		-- erreur base de données
		ROLLBACK TRANSACTION;

   		SET @message='Erreur base de données' + ERROR_MESSAGE();
   		SET @coderet=3;
			 
   	END CATCH
END
RETURN (@coderet);
GO

/** /8 supprimerMachine
--=========================================================================================
--Auteur: MSDK
--Date : 12/01/16
--Fonction: --Cette procédure supprime une machine
--parametres : @nomPresse  est le nom de la presse concerné par la PROC.
--==========================================================================================
*/
CREATE PROC supprimerMachine @nomPresse TypeNom, @message VARCHAR(255) OUTPUT

--code retour
--   		 1: un parametre possede une valeur nulle
--   		 2: la presse existe déjà
--      	 3: erreur base de données( exception)
--   		 0:ok
-- sortie :@message: contient le message d'erreur

AS

DECLARE @coderet INT;

----verification des parametres

IF @nomPresse IS NULL OR  @nomPresse NOT LIKE '[a-zA-Z0-9]%'
BEGIN
    SET @coderet=1;
    SET @message = 'Erreur : nom de la presse absent ou invalide';
END
ELSE
BEGIN
	BEGIN TRY
	BEGIN TRANSACTION 

	--verifier l existence de la machine, dans la TRANSACTION
		 		
	IF NOT EXISTS (SELECT numPresse FROM MACHINE  WITH (HOLDLOCK, TABLOCKX) WHERE libelle = @nomPresse) 
	BEGIN
		ROLLBACK TRANSACTION;

		SET @message ='Erreur : La presse ' + @nomPresse + ' n''existe pas';
		SET @codeRet =2;
				
	END

	ELSE

	BEGIN
		--- verifie que la machine n a pas deja été utilisée
		IF NOT EXISTS(SELECT libelle 
				FROM MACHINE m JOIN LOT l ON m.numPresse = l.numPresse 
				WHERE libelle = @nomPresse )
		--On supprime la machine
		BEGIN
			DELETE MACHINE
			WHERE 	libelle = @nomPresse;
				 
			COMMIT TRANSACTION;	 	

			SET @codeRet =0;
			SET @message = 'Presse ' + @nomPresse + ' supprimée'
		END
				 
		ELSE
		--La machine passe à l'état inactif
		BEGIN
			UPDATE MACHINE	
			SET etatPresse ='Inactif'
			WHERE libelle = @nomPresse;
				
			COMMIT TRANSACTION;	 	

			SET @codeRet =0;
			SET @message = 'Presse ' + @nomPresse + ' inactivée';
		END				
	END
	END TRY
	BEGIN CATCH
		-- erreur base de données
		ROLLBACK TRANSACTION;

		SET @message='Erreur base de données' + ERROR_MESSAGE();
		SET @coderet=3;
			 
	END CATCH
END
RETURN (@coderet);
GO





/** /9 changerEtatLot
--=========================================================================================
--Auteur: MSDK
--Date : 11/01/16
--Fonction: --Cette procédure fait évoluer l'état du lot à l'état suivant 
--(Si l'état était à 'Lancé' =>'Démarré' , 'Suspendu'=>' Démarré'; 'Démarré'=> 'Libéré'; 'Libéré'=> 'Arrété')
--( Elle libere la presse état 'En Production=> 'Libre' lorsque l'état du Lot passe de 'Démarré'=> 'Libéré')
--Elle initialise à la date courante le champs dateDeFabrication
--parametres : @numLot  est le numéro du lot concerné par la PROC.
--==========================================================================================
*/

CREATE PROC changerEtatLot  @numLot TypeNumLot, @message VARCHAR(255) OUTPUT

--code retour
--   		 1: un parametre possede une valeur nulle  //etatDuLot
--   		 2: la presse existe déjà
--      	 3: erreur base de données( exception)
--   		 0:ok
-- sortie :@message: contient le message d'erreur

AS

DECLARE @coderet INT;
DECLARE @etatLot typeNom;

----verification des parametres

--verifie que la variable n'est pas nulle et superieur à 0
IF @numLot IS NULL OR @numLot < 0
BEGIN
    SET @coderet=1;
    SET @message = 'Erreur : nom du lot absent';
END
ELSE
BEGIN
	BEGIN TRY
		--verifier l existence du Lot, dans la TRANSACTION	
		BEGIN TRANSACTION 
		DECLARE @dummy CHAR;
		SELECT @dummy = ' '
		FROM MACHINE WITH (HOLDLOCK, TABLOCKX) , 
		LOT WITH (HOLDLOCK, TABLOCKX)  
		WHERE LOT.numLot IS NULL ;		 	
		
		IF NOT EXISTS (SELECT etatDuLot FROM LOT WHERE numLot = @numLot)  
		BEGIN
			ROLLBACK TRANSACTION;

			SET @message ='Erreur : Le lot '+ CAST(@numLot AS VARCHAR(50)) +' n''existe pas';
			SET @codeRet =2;
				
		END
		ELSE

		BEGIN

			SELECT @etatLot=etatDuLot 
			FROM LOT
			WHERE  numLot = @numLot;
			 

			IF @etatLot='lancé'
			BEGIN
				UPDATE LOT
				SET etatDuLot= 'Démarré' WHERE  numLot = @numLot;
			END
			
			ELSE IF @etatLot= 'Suspendu' 
			BEGIN
				UPDATE LOT
				SET etatDuLot= 'Démarré' WHERE  numLot = @numLot;
			END
			
			ELSE IF @etatLot='Démarré'
			BEGIN
				UPDATE LOT
				SET etatDuLot= 'Libéré' WHERE  numLot = @numLot ;

				--La machine utilisée par la production est libérée
				UPDATE MACHINE
				SET etatPresse='Libre' WHERE numPresse IN
				(SELECT m.numPresse FROM Machine m JOIN LOT l 
				ON m.numPresse=l.numPresse 
				WHERE numLot = @numLot);

				--la date de fabrication est initialisée
				UPDATE LOT
				SET dateDeFabrication = GETDATE()  WHERE  numLot = @numLot;
								
			END
			
			ELSE IF @etatLot='Libéré'
			BEGIN
				UPDATE LOT
				SET etatDuLot= 'Arrêté'
				WHERE  numLot = @numLot;
			END
							
			COMMIT TRANSACTION;

			SET @codeRet =0;
			SET @message = 'Etat du lot '+ CAST(@numLot AS VARCHAR(50)) +' modifié';
				 
				 		 					 
		END
	END TRY
	
	BEGIN CATCH
		-- erreur base de données
		ROLLBACK TRANSACTION;

		SET @message='Erreur base de données' + ERROR_MESSAGE();
		SET @coderet=3;
			 
	END CATCH
END
RETURN (@coderet);
GO

/** /10 planifierLot
--==========================================================================================================
--auteur :MSDK
--date:12/01/16
--fonction: Cette procédure permet de planifier un lot , initialise la date de planification à la date courante et la date de fabrication à NULL
--parametres:   @modele est le modèle concerne par la planification
--				@quantite est le nombre de pieces du modèle
--==========================================================================================================
*/
CREATE PROC planifierLot @modele TypeNom, @quantite TypeQuantite, @message VARCHAR(255) OUTPUT

--code retour
--   		 1: un parametre possede une valeur nulle  //etatDuLot
--   		 2: la presse existe déjà
--      	 3: erreur base de données( exception)
--   		 0:ok
-- sortie :@message: contient le message d'erreur

AS

DECLARE @coderet INT;
DECLARE @numLot INT;

----verification des parametres

--verifie que la variable  @modele n'est pas nulle et commence bien par une lettre ou chiffre
IF @modele IS NULL OR @modele NOT LIKE '[a-zA-Z0-9]%'																										
BEGIN
    SET @coderet=1;
    SET @message = 'Erreur : nom du modele absent ou non valide';
END

--verifie que le variable @quantite n'est pas nulle
ELSE IF @quantite IS NULL OR @quantite <=0																											
BEGIN
    SET @coderet=1;
    SET @message = 'Erreur : quantité absente ou non valide';
END
ELSE
BEGIN
   	BEGIN TRY
		 --verifier l existence du modèle, dans la TRANSACTION
		 BEGIN TRANSACTION 
		 	
		 		DECLARE @dummy CHAR = '';
				SELECT @dummy = ''
				FROM LOT  WITH (HOLDLOCK, TABLOCKX) , 
					 MODELE  WITH (HOLDLOCK, TABLOCKX)  				     
				WHERE MODELE.modele IS NULL ;				 				 		 		 	
			
   			IF NOT EXISTS (SELECT diametre FROM MODELE  WHERE modele = @modele)  
			 BEGIN
				ROLLBACK TRANSACTION;

   				SET @message ='Erreur : le modèle ' + @modele + ' n''existe pas';
   				SET @codeRet =2;
				
   			 END
   			 ELSE
			 
   			 BEGIN
				-- creation du lot
				-- remplit les champs nbPiecesDemandees, modele,dateDePlanification dans la TABLE LOT				
   				INSERT INTO LOT (nbPiecesDemandees, modele,dateDePlanification)
				VALUES	(@quantite, @modele,GETDATE());	

				--recuperation du numéro de Lot pour afficher dans le message				
				SELECT @numLot= MAX(numLot) 
				FROM LOT		
				COMMIT TRANSACTION;		 
				 							
				SET @codeRet = 0;
				SET @message = 'Nouveau lot ' + CAST(@numLot AS VARCHAR(50)) + ' planifié'; 
   			END	
		END TRY
   		 BEGIN CATCH
   			 -- erreur base de données
			 ROLLBACK TRANSACTION;

   			 SET @message='Erreur base de données' + ERROR_MESSAGE();
   			 SET @coderet=3;
			 
   		 END CATCH
	END
	RETURN (@coderet);
GO



/* 11*/
--==========================================================================================================
--auteur :MSDK
--date:13/01/16
--fonction: Cette procédure permet de démarrer un lot en production , l'etat du lot passe de Lancé=>Démarré
--			grace à la procédure changerEtatLot
--			l'etat de la presse passe à l'état 'En production'
--parametres:   @numLot est le nuémro de lot concerne par la production
--				@nomPresse est la presse choisie par l 'opérateur
--==========================================================================================================
CREATE PROC demarrerLot   @numLot TypeNumLot, @nomPresse TypeNom, @message VARCHAR(255) OUTPUT

--code retour
--   		 1: un parametre possede une valeur nulle
--   		 2: la presse est déjà utilisée
--      	 3: erreur base de données( exception)
--   		 0:ok
-- sortie :@message: contient le message d'erreur

AS
DECLARE @coderet INT;
DECLARE @numPresse TypeNumPresse;

----verification des parametres

IF @nomPresse IS NULL
	BEGIN
		SET @coderet=1;
		SET @message = ' Erreur : numéro de presse absent';
	END
ELSE
IF @numLot IS NULL OR @numLot < 0
	BEGIN 
		SET @coderet= 1;
		SET @message= 'Erreur: numéro de lot absent ou non valide';
	END
	ELSE
	BEGIN
   		BEGIN TRY 
			BEGIN TRANSACTION
					 DECLARE @dummy CHAR = '';

					 SELECT @dummy = ''
					 FROM MACHINE  WITH (HOLDLOCK, TABLOCKX) , 
						  LOT WITH (HOLDLOCK, TABLOCKX)  
			 			  WHERE LOT.numLot IS NULL ;
			 --verifier l existence de la machine	
   				IF NOT EXISTS (SELECT* FROM MACHINE 
								WHERE libelle = @nomPresse)
						BEGIN
							ROLLBACK TRANSACTION;

							SET @coderet=1;
							SET @message ='Erreur : la presse ' + @nomPresse + ' n''existe pas';
							
						END
				ELSE
				-- verifier l existence du numero du lot
				IF NOT EXISTS (SELECT numLot FROM LOT WHERE numLot = @numLot AND etatDuLot = 'Lancé')
						BEGIN
							ROLLBACK TRANSACTION;

							SET @coderet=1;
							SET @message ='Erreur : le lot n. ' + CAST(@numLot AS VARCHAR(50)) + ' n''existe pas ou est déjà lancé';
							
						END			

				ELSE-- verifier que la presse demandée est libre
				 IF NOT EXISTS ( SELECT* FROM MACHINE 
									WHERE libelle = @nomPresse
									AND EtatPresse= 'Libre')
					 BEGIN 
						ROLLBACK TRANSACTION;

						 SET @coderet = 2;
						 SET @message = 'Erreur : la presse ' + @nomPresse + ' n''est pas disponible';
						 
					 END 
				ELSE
   					 BEGIN 
						
						SELECT @numPresse= numPresse FROM MACHINE WHERE libelle =  @nomPresse;

   						 UPDATE LOT
						 SET numPresse = @numPresse
						 WHERE numLot =  @numLot;

						 UPDATE MACHINE 
						 SET etatPresse = 'En Production'
						 WHERE libelle =@nomPresse; 

						 execute @coderet = changerEtatLot @numLot , @message OUTPUT

						 
						 --Changement : rajout du test sur le coderet
						 IF @coderet = 0
						 BEGIN
							COMMIT TRANSACTION;
							SET @message = 'Le lot n. ' + CAST(@numLot AS VARCHAR(50)) + ' a démarré sur la presse ' 
							+ @nomPresse;
						 END

						 ELSE
						 BEGIN
							ROLLBACK TRANSACTION;
						 END
					END
				
		END TRY
   		 BEGIN CATCH
   			 -- erreur base de données
			 ROLLBACK TRANSACTION;

   			 SET @message='Erreur base de données ' + ERROR_MESSAGE();
   			 SET @coderet=3;
			 
   		 END CATCH
	END
	RETURN (@coderet);
GO
/** /12 / suspendreLot
--=========================================================================================
--Auteur: MSDK
--Date : 11/01/16
--Fonction: --Cette procédure fait évoluer l'état du lot Démarré'=> 'Suspendu'
--parametres : @numLot  est le numéro du lot concerné par la PROC.

--==========================================================================================
*/

/*test suspendreLot
DECLARE @message varchar(100);
DECLARE @code INT;
exec @code = suspendreLot 1, @message OUTPUT;
SELECT @message, @code
*/
CREATE PROC suspendreLot  @numLot TypeNumLot, @message VARCHAR(255) OUTPUT

--code retour
--   		 1: un parametre possede une valeur nulle  //etatDuLot
--   		 2: la presse existe déjà
--      	 3: erreur base de données( exception)
--   		 0:ok
-- sortie :@message: contient le message d'erreur

AS

DECLARE @coderet INT;

----verification des parametres

--verifie que la variable n'est pas nulle et superieur à 0
IF @numLot IS NULL OR @numLot < 0
BEGIN
    SET @coderet=1;
    SET @message = 'Erreur : paramètre nom du lot absent';
END
ELSE
BEGIN
   	BEGIN TRY
		--verifier l existence du Lot, dans la TRANSACTION	
		BEGIN TRANSACTION 	
		
		IF NOT EXISTS (SELECT etatDuLot 
							FROM LOT WITH (HOLDLOCK, TABLOCKX) 
							WHERE numLot = @numLot
							AND (etatDuLot = 'Démarré'
							OR etatDuLot = 'Libéré')) 
   		BEGIN
   			ROLLBACK TRANSACTION;
				
			SET @message ='Erreur : le lot '+ CAST(@numLot AS VARCHAR(50)) +' n''existe pas ou n''est pas en état d''être suspendu';
   			SET @codeRet =2;
				
   		END

		ELSE

		BEGIN
			 			 
			UPDATE LOT
			SET etatDuLot= 'Suspendu'  WHERE  numLot = @numLot;

			COMMIT TRANSACTION;

			SET @codeRet = 0;
			SET @message = 'Le lot n. '+ CAST(@numLot AS VARCHAR)+' a été suspendu';

		END
						
		
				 			 
	END TRY
   	BEGIN CATCH
		-- erreur base de données
		ROLLBACK TRANSACTION;

		SET @message='Erreur base de données' + ERROR_MESSAGE();
		SET @coderet=3;
			 
   	END CATCH
END
RETURN (@coderet);
GO

/** / / arreterLot
--=========================================================================================
--Auteur: MSDK
--Date : 11/01/16
--Fonction: --Cette procédure change l'état du lot à 'Arrêté'
--parametres : @numLot  est le numéro du lot concerné.

--==========================================================================================
*/
CREATE PROC arreterLot  @numLot TypeNumLot, @message VARCHAR(255) OUTPUT

--code retour
--   		 1: un parametre possede une valeur nulle  //etatDuLot
--   		 2: la presse existe déjà
--      	 3: erreur base de données( exception)
--   		 0:ok
-- sortie :@message: contient le message d'erreur

AS

DECLARE @coderet INT;
DECLARE @dummy CHAR;
----verification des parametres

--verifie que la variable n'est pas nulle et superieur à 0
IF @numLot IS NULL OR @numLot < 0
BEGIN
    SET @coderet=1;
    SET @message = 'Erreur : paramètre nom du lot absent ou invalide';
END
ELSE
BEGIN
   	BEGIN TRY
		 --verifier l existence du Lot, dans la TRANSACTION	
		 BEGIN TRANSACTION 	

			SELECT @dummy = ''
			FROM MACHINE  WITH (HOLDLOCK, TABLOCKX) , 
					LOT WITH (HOLDLOCK, TABLOCKX)  
			WHERE LOT.numLot IS NULL ;
   			
			IF NOT EXISTS (SELECT etatDuLot 
							FROM LOT
							WHERE numLot = @numLot
							AND (etatDuLot = 'Démarré'
							OR etatDuLot = 'Libéré'
							OR etatDuLot = 'Suspendu')) 
   			 BEGIN
   				ROLLBACK TRANSACTION;
				
				SET @message ='Erreur : le lot '+ CAST(@numLot AS VARCHAR(50)) +' n''existe pas ou n''est pas en état d''être arrêté';
   				SET @coderet =2;
				
   			 END
   			 ELSE
   			 BEGIN
				
				 --met l'état du lot à arrêté
			 
   				UPDATE LOT
				SET etatDuLot= 'Arrêté'  
				WHERE  numLot = @numLot;

				-- Libère la presse
				
				UPDATE MACHINE
				SET etatPresse = 'Libre'
				WHERE numPresse = (SELECT numPresse
									FROM LOT
									WHERE numLot = @numLot)
				
				 COMMIT TRANSACTION;	 					
				 SET @coderet =0;
				 SET @message = 'Le lot n. '+ CAST(@numLot AS VARCHAR)+' a été arrêté';
				 
					 					 
   			   END
		 END TRY
   		 BEGIN CATCH
   			 -- erreur base de données
   			 SET @message='Erreur base de données' + ERROR_MESSAGE();
   			 SET @coderet=3;
			 ROLLBACK TRANSACTION;
   		 END CATCH
	END
	RETURN (@coderet);
GO

/* /13 prodPrecedente
--=========================================================================================
--Auteur: MSDK
--Date : 11/01/16
--Fonction: --Cette fonction permet de connaitre la derniere production faite sur une machine
--parametres : @nomPresse  est le nom du machine concerné par la PROC.

--==========================================================================================
*/

CREATE FUNCTION [dbo].prodPrecedente
(@nomPresse TypeNom)

RETURNS typeNom

AS

BEGIN
	
	DECLARE @numLot typeNumLot;
	DECLARE @numPresse TypeNumPresse;
	DECLARE @retour typeNom;

	----verification du paramètre
	IF @nomPresse IS NOT NULL AND @nomPresse LIKE '[a-zA-Z0-9]%'
		AND EXISTS (SELECT numPresse FROM MACHINE WHERE libelle = @nomPresse) 
	
	BEGIN
		
		SELECT @numPresse=numPresse
		FROM MACHINE
		WHERE libelle = @nomPresse;

		SELECT @retour=modele
		FROM LOT 
		WHERE numLot = (SELECT MAX(numLot) FROM LOT WHERE numPresse = @numPresse);		 			 
				
		IF @retour IS NULL
			SET @retour= 0;			
				 
   	END
RETURN (@retour);
END

GO



/** /14 trouverCat
======================================================================================================
*
* La PROC trouverCat permet de trouver, partant des côtes d'une pièce et son modèle, 
* la catégorie à laquelle celle-ci appartient.
* Elle teste d'abord si les dimensions de la pièce traitée sont celles exigées 
* par la catégorie 'Moyen'.
* Sinon elle vérifie si elles respectent celles des catégories 'Petit' et 'Gros'.
* Finalement, toute pièce dont les mesures ne coïncident avec aucune de ces catégories 
* est considérée 'Rebut'.
* 
* @author  MSDK
* @version 1.0
* @since   2016-12-01
*
*
*
*@modele Nom du modèle de piston
*
*@cote1, @cote2, @cote3, @cote4
*
*@nomCat Nom de la catégorie
* 
*@message Message de sortie
======================================================================================================
*/

CREATE PROC trouverCat @modele TypeNom, 
						@cote1 TypeCote, @cote2 TypeCote, @cote3 TypeCote, @cote4 TypeCote, 
						@nomCat TypeNom OUTPUT, 
						@message VARCHAR(255) OUTPUT

AS

-- Déclaration de la borne inférieure de la catégorie courante
DECLARE @diamMin TypeCote;
-- Déclaration de la borne supérieure de la catégorie courante
DECLARE @diamMax TypeCote;

BEGIN
	SET NOCOUNT ON; -- le nombre de lignes affectées n'est pas renvoyé
	BEGIN TRY
	-- Initialisation des bornes, on priorise le traitement sur 'Moyen'
	SELECT @diamMin = diametre + (SELECT toleranceMini 
									FROM CATEGORIE
									WHERE nomCategorie = 'Moyen')									
						FROM MODELE	
						WHERE modele = @modele
	SELECT @diamMax = diametre + (SELECT toleranceMaxi 
									FROM CATEGORIE
									WHERE nomCategorie = 'Moyen')									
						FROM MODELE	
						WHERE modele = @modele
	
	--On commence par vérifier si la pièce peut être considérée 'standard' ('Moyen')
	IF (@cote1 > @diamMin AND @cote2 > @diamMin AND @cote3 > @diamMin AND @cote4 > @diamMin) AND
		(@cote1 < @diamMax AND @cote2 < @diamMax AND @cote3 < @diamMax AND @cote4 < @diamMax)
		BEGIN
			SET @nomCat = 'Moyen';
		END
	ELSE 
		-- Si non, on cherche si elle peut correspondre avec les dimensions de taille 'Petit'
		BEGIN
			SELECT @diamMin = diametre + (SELECT toleranceMini 
									FROM CATEGORIE
									WHERE nomCategorie = 'Petit')									
						FROM MODELE	
						WHERE modele = @modele
			SELECT @diamMax = diametre + (SELECT toleranceMaxi 
									FROM CATEGORIE
									WHERE nomCategorie = 'Petit')									
						FROM MODELE	
						WHERE modele = @modele

			
			--On vérifie si les côtes rentrent dans l'intervalle des pièces de catégorie 'Petit'
			IF (@cote1 > @diamMin AND @cote2 > @diamMin AND @cote3 > @diamMin AND @cote4 > @diamMin) AND
				(@cote1 < @diamMax AND @cote2 < @diamMax AND @cote3 < @diamMax AND @cote4 < @diamMax)
			BEGIN
				SET @nomCat = 'Petit';
			END

			ELSE 
				-- Si non, on essaye encore avec les dimensions de la catégorie 'Gros'
				BEGIN
					SELECT @diamMin = diametre + (SELECT toleranceMini 
											FROM CATEGORIE
											WHERE nomCategorie = 'Gros')									
								FROM MODELE	
								WHERE modele = @modele
					SELECT @diamMax = diametre + (SELECT toleranceMaxi 
											FROM CATEGORIE
											WHERE nomCategorie = 'Gros')									
								FROM MODELE	
								WHERE modele = @modele

					--On vérifie si les côtes rentrent dans l'intervalle des pièces de catégorie 'Gros'
					IF (@cote1 > @diamMin AND @cote2 > @diamMin AND @cote3 > @diamMin AND @cote4 > @diamMin) AND
						(@cote1 < @diamMax AND @cote2 < @diamMax AND @cote3 < @diamMax AND @cote4 < @diamMax)
					BEGIN
						SET @nomCat = 'Gros';
					END

					ELSE
						-- Si toujours pas, alors c'est un rebut
						BEGIN
							SET @nomCat = 'Rebut';
						END
				END
			END
	END TRY

	BEGIN CATCH
   			-- erreur base de données
   			SET @message='Erreur base de données' + ERROR_MESSAGE();
   			--SET @codeRet=3;
   	END CATCH
END
GO

/** /15 enregistrerPiece
======================================================================================================
*
* La PROC enregistrerPiece enregistre une nouvelle pièce et donne la catégorie 
* et le numéro de la pièce créée.
* Si la pièce courante est la dernière du lot, la procédure arreterLot est appelée pour
* faire passer l'état du lot à 'Arrêté'
* 
* @author  MSDK
* @version 1.0
* @since   2016-12-01
*
*
*
*@modele est le modele de voiture
*
*@SeuilMini est le seuil minimum pour lequel ON souhaite mettre une alerte
*
*
======================================================================================================
*/

CREATE PROC enregistrerPiece @lot TypeNumLot, 
								@hl TypeCote, @ht TypeCote , @bl TypeCote, @bt TypeCote, 
								@categorie TypeNom OUTPUT, 
							    @numpiece TypeNumPiece OUTPUT, 
							    @commentaireRebut TypeNom, 
							    @message VARCHAR(100) OUTPUT

-- Code Retour
--			1 : Un parametre possede une valeur nulle
--			2 : Le lot n'existe pas ou n'est pas à 'Démarré'
--			3 : Erreur base de données( exception)
--			0 : Ok
-- Sortie : @message: contient le message d'erreur

AS
DECLARE @codeRet INT;
DECLARE @modelePiece TypeNom;
DECLARE @dummy CHAR;

BEGIN
	BEGIN TRY
	SET NOCOUNT ON; -- le nombre de lignes affectées n'est pas renvoyé
		--Vérifications des paramètres

		IF @lot IS NULL
		BEGIN
			SET @codeRet = 1;
			SET @message = 'Erreur : Paramètre @lot absent';
		END

		ELSE
		BEGIN
			IF @hl IS NULL OR @ht IS NULL OR @bl IS NULL OR @bt IS NULL
				OR @hl < 0 OR @ht < 0 OR @bl < 0 OR @bt < 0
			BEGIN
				SET @codeRet = 1;
				SET @message = 'Erreur : Paramètres Côtes manquants ou invalides';
			END -- Fin de la vérification des paramètres

			ELSE -- Si les paramètres sont corrects, on poursuit le traitement
			BEGIN
				BEGIN TRANSACTION 
				SELECT @dummy = ' ' -- Blockage des tables
								FROM LOT  WITH (HOLDLOCK, TABLOCKX) , 
									MODELE  WITH (HOLDLOCK, TABLOCKX) , 
									CATEGORIE  WITH (HOLDLOCK, TABLOCKX) 
								WHERE numLot IS NULL ;

				-- Vérification de l'existence du lot donné en paramètre
				IF NOT EXISTS (SELECT numLot
									FROM LOT 
									WHERE numLot = @lot)
				BEGIN
					ROLLBACK TRANSACTION;
					SET @codeRet = 2;
					SET @message = 'Erreur : Le lot n. ' + CAST(@lot AS VARCHAR(50)) + ' n''existe pas';
				END
				
				ELSE
				BEGIN
				--Vérification de l'état du lot donné en paramètre
					IF NOT EXISTS (SELECT numLot
									FROM LOT
									WHERE numLot = @lot
										AND (etatDuLot LIKE 'Démarré'
										OR etatDuLot LIKE 'Libéré'))
					BEGIN
						ROLLBACK TRANSACTION;
						SET @codeRet = 2;
						SET @message = 'Erreur : Le lot n. ' + CAST(@lot AS VARCHAR(50)) + ' n''est pas en état d''être contrôlé';
					END 
						
					ELSE --Si l'état du lot est correct, début du traitement
					BEGIN
						-- Récupération du modèle du lot donné
						SELECT @modelePiece = MODELE.modele
								FROM MODELE JOIN LOT ON LOT.modele = MODELE.modele
								WHERE LOT.numLot = @lot
		
						-- Appel de la procédure trouverCat pour connaître la catégorie de la pièce courante
						EXEC trouverCat @modelePiece, @hl, @ht , @bl, @bt, @categorie OUTPUT, @message OUTPUT;
				
						--Insertion de la pièce dans la TABLE PIECE
				
						INSERT INTO PIECE (numLot, nomCategorie, diametreHL, diametreHT, diametreBL, diametreBT, commentaireRebut)
						VALUES (@lot, @categorie, @hl, @ht , @bl, @bt, @commentaireRebut)
		
						--On récupère le numéro de pièce de ce dernier enregistrement 
						SELECT @numPiece = MAX(idPiece) 
						FROM PIECE 
						WHERE numLot = @lot
						
						-- Mise à jour du @message et du code Retour
						SET @codeRet = 0;
						SET @message = 'La pièce n.' + CAST(@numPiece AS VARCHAR(50)) + ' a été enregistrée';
						

						--Si ON a atteint le nombre de pièces demandées pour ce lot (donc fin de lot)
				
						IF EXISTS (SELECT * FROM LOT WHERE numLot = @lot 
													AND nbPiecesDemandees = (SELECT COUNT(*)
																			 FROM PIECE
																			 WHERE numLot = @lot
																			 )
								  )
				
						--On fait passer l'état du lot à Arrêté
						BEGIN
							EXEC @codeRet = arreterLot  @lot, @message OUTPUT
						
							IF @codeRet = 0
							BEGIN
								-- On peut valider la TRANSACTION et libérer les tables
								COMMIT TRANSACTION;
							END
							ELSE
							BEGIN 
								ROLLBACK TRANSACTION;
							END
						END
						
						ELSE
						BEGIN
							COMMIT TRANSACTION;
						END
					END
				END
			END
		END
	END TRY
	BEGIN CATCH
		-- erreur base de données
   		SET @message='Erreur base de données' + ERROR_MESSAGE();
   		SET @codeRet = 3;
		ROLLBACK TRANSACTION;
   	END CATCH
END
RETURN @codeRet;
GO



/** 16/
======================================================================================================
* @author  MSDK
* @version 1.0
* @since   2016-12-01
*
* La PROC entreeCaisse permet de modifier le Stock en y ajoutant des caisses de piston
*
*@modele est le modele de voiture
*
*@nameCategorie est la categorie dans laquelle le piston est classé
*
*@nbcaisse est le nombre de caisse que l'ON souhaite ajouter au stock
======================================================================================================
*/


CREATE PROC entreeCaisse @modele TypeNom, @nameCategorie TypeNom, @nbCaisse Typequantite , @message VARCHAR(255) OUTPUT

--code retour
--   		 1: un parametre possede une valeur NULL
--   		 2: le modele pour lequel ON souhaite stocker le piston n 'existe pas
--      	 3: erreur base de données( exception)
--   		 0:la saisie à bien été prise en compte
-- sortie :@message: contient le message d'erreur

AS

DECLARE @coderet INT;

----verification des parametres

IF @modele IS NULL OR  @modele NOT LIKE '[a-zA-Z0-9]%'
BEGIN
    SET @coderet=1;
    SET @message = 'Erreur : nom du modèle absent ou non valide';
END
ELSE IF	@nameCategorie IS NULL OR @nameCategorie NOT LIKE '[A-Za-z]%'
BEGIN
    SET @coderet=1;
    SET @message = 'Erreur : nom de catégorie absent ou non valide';
END
ELSE IF @nbCaisse IS NULL  OR @nbCaisse < 0
BEGIN
    SET @coderet=1;
    SET @message = 'Erreur : quantité absente ou non valide';
END
ELSE
BEGIN
   	BEGIN TRY
		 BEGIN TRANSACTION 
   			IF NOT EXISTS (SELECT modele 
							FROM STOCK WITH (HOLDLOCK, TABLOCKX) 
							WHERE modele = @modele 
							AND @nameCategorie = nomCategorie)  --verifier l existence du modele
   			 BEGIN
				ROLLBACK TRANSACTION;

   				SET @message ='Erreur : le modèle ' + CAST(@modele AS VARCHAR(50)) + ' et la categorie de piston ' 
				+ CAST(@nameCategorie AS VARCHAR(50)) + ' n''existent pas dans le stock';
   				SET @codeRet = 2;
				
   			 END
   			 ELSE
   			 BEGIN
   				 UPDATE STOCK
				 SET quantiteStock = @nbCaisse + quantiteStock
				Where modele = @modele AND nomCategorie = @nameCategorie

				 COMMIT TRANSACTION;

				 SET @codeRet =0;
				 SET @message = CAST(@nbCaisse AS VARCHAR(10)) + ' caisse(s) de modèle ' + CAST(@modele AS VARCHAR(50))  
				 + ' de piston de catégorie ' + CAST(@nameCategorie AS VARCHAR(50)) + ' ajoutée(s) au stock';
				 							 
   			 END
		END TRY
   		 BEGIN CATCH
   			 -- erreur base de données
   			 SET @message='Erreur base de données' + ERROR_MESSAGE();
   			 SET @coderet=3;
			 ROLLBACK TRANSACTION;
   		 END CATCH
	END
	RETURN (@coderet);
GO




/** /17
======================================================================================================
* @author  MSDK
* @version 1.0
* @since   2016-12-01
*
*La PROC sortieCaisse permet de modifier le Stock en y retirant des caisses de piston
*
*@modele est le modele de voiture
*
*@nameCategorie est la categorie dans laquelle le piston est classé
*
*@nbcaisse est le nombre de caisse que l'ON souhaite retirer du stock
======================================================================================================
*/
CREATE PROC sortieCaisse @modele TypeNom, @nameCategorie TypeNom, @nbCaisse TypeQuantite , @message VARCHAR(255) OUTPUT

--code retour
--   		 1: un parametre possede une valeur NULL
--   		 2: le modele pour lequel ON souhaite stocker le piston n 'existe pas
--      	 3: erreur base de données( exception)
--   		 0:la saisie à bien été prise en compte
-- sortie :@message: contient le message d'erreur

AS

DECLARE @coderet INT;
DECLARE @qtStock INT;


----verification des parametres

IF @modele IS NULL OR  @modele NOT LIKE '[a-zA-Z0-9]%'
BEGIN
    SET @coderet=1;
    SET @message = 'Erreur : nom du modèle absent ou non valide';
END
ELSE IF	@nameCategorie IS NULL OR @nameCategorie NOT LIKE '[A-Za-z]%'
BEGIN
    SET @coderet=1;
    SET @message = 'Erreur : nom de catégorie absent ou non valide';
END
ELSE IF @nbCaisse IS NULL
BEGIN
    SET @coderet=1;
    SET @message = 'Erreur : paramètre quantité absent';
END
ELSE
BEGIN
   	BEGIN TRY
		BEGIN TRANSACTION 
   		IF NOT EXISTS (SELECT modele FROM STOCK WITH (HOLDLOCK, TABLOCKX) WHERE modele = @modele AND @nameCategorie = nomCategorie)  --verifier l existence du modele
   		BEGIN
			ROLLBACK TRANSACTION;

   			SET @message ='Erreur : le modèle ' + CAST(@modele AS VARCHAR(50))  + 
					' ou la catégorie de piston ' + CAST(@nameCategorie AS VARCHAR(50)) + ' n''existe pas';
   			SET @codeRet =2;
				
   		END
   		ELSE 
		BEGIN
			SELECT @qtStock = quantiteStock 
			FROM STOCK 
			WHERE modele = @modele
			AND nomCategorie = @nameCategorie

			IF @nbCaisse > @qtStock
			BEGIN
				ROLLBACK TRANSACTION;

				SET @coderet=2;
				SET @message = 'Erreur : pas assez de ' + @nameCategorie + ' en stock pour ce retrait';
			END
			ELSE
			--Fin des vérifications
   			BEGIN
   				UPDATE STOCK
				SET quantiteStock =  quantiteStock - @nbCaisse
				WHERE modele = @modele AND nomCategorie = @nameCategorie

				COMMIT TRANSACTION;

				SET @codeRet =0;
				SET @message = CAST(@nbCaisse AS VARCHAR(10)) + ' caisse(s) de modèle ' + CAST(@modele AS VARCHAR(50))  + ' de piston de catégorie ' 
							+ CAST(@nameCategorie AS VARCHAR(50)) + ' retirée(s) du stock';
			END 					 
   		END
	END TRY
   	BEGIN CATCH
   		-- erreur base de données
		ROLLBACK TRANSACTION;

   		SET @message='Erreur base de données' + ERROR_MESSAGE();
   		SET @coderet=3;
		
   	END CATCH
END
RETURN (@coderet);
GO





/** /18
======================================================================================================
* @author  MSDK
* @version 1.0
* @since   2016-12-01
*
*La fonction fnStatsReduites retourne la TABLE contenant les statistiques réduites.
*
*@numLot est le numéro du lot à analyser
======================================================================================================
*/

CREATE FUNCTION fnStatsReduites (@numLot typeNumLot)
RETURNS TABLE

AS

RETURN (SELECT '1.MOYENNE' AS STATISTIQUE, moyenneHL AS HL, moyenneHT AS HT, moyenneBL AS BL, moyenneBT AS BT
		FROM LOT
		WHERE numlot = @numLot
		UNION
			SELECT '2.MAXIMUM' AS STATISTIQUE, maximumHL AS HL, maximumHT AS HT, maximumBL AS BL, maximumBT AS BT
			FROM LOT
			WHERE numlot = @numLot
			UNION
				SELECT '3.MINIMUM' AS STATISTIQUE, minimumHL AS HL, minimumHT AS HT, minimumBL AS BL, minimumBT AS BT
				FROM LOT
				WHERE numlot = @numLot
				UNION
					SELECT '4.ECART-TYPE' AS STATISTIQUE, ecartTypeHL AS HL, ecartTypeHT AS HT, ecartTypeBL AS BL, ecartTypeBT AS BT
					FROM LOT
					WHERE numlot = @numLot
					)
GO

/** /19
====================================================================================================== 
* @author  MSDK
* @version 1.0
* @since   2016-12-01
*
*La PROC statReduites donne les valeurs de la moyenne, du MAX, du MIN et de l'écart type.
*
*@numLot est le numéro du lot à analyser
*
*@message est le message de sortie
======================================================================================================
*/

CREATE PROCEDURE statReduites @numLot typeNumLot, @message VARCHAR(255) OUTPUT

-- Code Retour
--			1 : Un parametre possede une valeur nulle ou invalide
--			2 : Le lot n'existe pas ou n est pas encore en état de fabrication
--			3 : Erreur base de données( exception)
--			0 : Ok
-- Sortie : @message: contient le message d'erreur

AS

DECLARE @codeRet INT;
BEGIN
	BEGIN TRY

		-- Vérification du paramètre
		IF @numLot IS NULL OR @numLOT < 0 
		BEGIN
			SET @codeRet = 1;
			SET @message = 'Erreur : Le paramètre @numLot est manquant ou invalide';
		END
		ELSE
		BEGIN
			-- Vérification de l'existence du lot donné en paramètre
			IF NOT EXISTS (SELECT numLot
							FROM LOT 
							WHERE numLot = @numLot)
			BEGIN
				SET @codeRet = 2;
				SET @message = 'Erreur : Le lot n. ' + CAST(@numLot AS VARCHAR(50)) + ' n''existe pas';
			END
			ELSE
			BEGIN
				-- Appel de la fonction pour l'affichage des statistiques
				SELECT * FROM fnStatsReduites(@numLot);

				SET @codeRet = 0;
				SET @message = 'Ok';
			END
		END
	END TRY
	BEGIN CATCH
   			-- erreur base de données
   			SET @message='Erreur base de données' + ERROR_MESSAGE();
   			SET @codeRet = 3;
   	END CATCH
END
RETURN @codeRet;
GO

/** /20
======================================================================================================
* @author  MSDK
* @version 1.0
* @since   2016-12-01
*
*La fonction fnStatsCat retourne la TABLE contenant les quantités de pièces du lot par catégorie :
* Quantités de Rebuts, Petits, Moyens, Gros et Total
*
*@numLot est le numéro du lot à analyser
======================================================================================================
*/

CREATE FUNCTION fnStatsCat (@numLot typeNumLot)
RETURNS TABLE

AS

RETURN (SELECT nomCategorie AS CATEGORIE, SUM (nombreDePieces) AS QUANTITE
		FROM CUMUL 
		WHERE numLot = @numLot
		GROUP BY nomCategorie

		UNION

		SELECT 'Total' AS CATEGORIE, SUM (nombreDePieces) AS QUANTITE
		FROM CUMUL 
		WHERE numLot = @numLot
		)
GO


/** /21
======================================================================================================
* @author  MSDK
* @version 1.0
* @since   2016-12-01
*
* La PROC statCat effectue les vérifications nécessaires et appelle la fonction fnStatsCat
* afin d'afficher les quantités de pièces du lot par catégorie : 
* Quantités de Rebuts, Petits, Moyens, Gros et Total
*
*@numLot est le numéro du lot à analyser
*
*@message est le message de sortie
======================================================================================================
*/

CREATE PROCEDURE statCat @numLot typeNumLot, @message VARCHAR(255) OUTPUT

-- Code Retour
--			1 : Un parametre possede une valeur nulle ou invalide
--			2 : Le lot n'existe pas ou n'est pas à l'état 'Démarré'
--			3 : Erreur base de données (exception)
--			0 : Ok
-- Sortie : @message: contient le message d'erreur

AS

DECLARE @codeRet INT;
BEGIN
	BEGIN TRY
		-- Vérification des paramètres
		IF @numLot IS NULL OR @numLOT <= 0 
		BEGIN
			SET @codeRet = 1;
			SET @message = 'Erreur : Le paramètre @numLot est manquant ou invalide';
		END
		ELSE
		BEGIN
			BEGIN TRANSACTION;
			-- Vérification de l'existence du lot donné en paramètre
			IF NOT EXISTS (SELECT numLot
							FROM LOT 
							WHERE numLot = @numLot)
			BEGIN
				ROLLBACK TRANSACTION;
				SET @codeRet = 2;
				SET @message = 'Erreur : Le lot n. ' + CAST(@numLot AS VARCHAR(50)) + ' n''existe pas';
			END
			ELSE
			BEGIN
			
				SELECT * FROM fnStatsCat(@numLot);
				
				COMMIT TRANSACTION;

				SET @codeRet = 0;
				SET @message='Ok';
			
			END
		END
	END TRY
	BEGIN CATCH
   			-- erreur base de données
   			ROLLBACK TRANSACTION;
			SET @message='Erreur base de données' + ERROR_MESSAGE();
   			SET @codeRet = 3;
   	END CATCH
END
RETURN @codeRet;
GO


/** /22
====================================================================================================== 
* @author  MSDK
* @version 1.0
* @since   2016-12-01
*
*La PROC majStats met à jour les valeurs de la moyenne, du MAX, du MIN et de l'écart type du lot
* donné.
*
*@numLot est le numéro du lot à traiter
======================================================================================================
*/
CREATE PROCEDURE majStats @numLot TypeNumLot

AS

BEGIN

IF @numLot IS NOT NULL AND @numLot > 0
	AND EXISTS (SELECT numLot
				FROM LOT
				WHERE numLot = @numLot)
	BEGIN

		UPDATE LOT

		SET moyenneHL = (SELECT AVG (PIECE.diametreHL) 
					FROM PIECE
					WHERE numLot = @numLot
						--on écarte les pièces ayant un défaut visuel
						AND NOT (PIECE.nomCategorie = 'Rebut' 
									AND PIECE.diametreBL = 0)),
		moyenneHT = (SELECT AVG (PIECE.diametreHT) 
						FROM PIECE
						WHERE numLot = @numLot
						AND NOT (PIECE.nomCategorie = 'Rebut' 
										AND PIECE.diametreBL = 0)),
		moyenneBL = (SELECT AVG (PIECE.diametreBL) 
						FROM PIECE
						WHERE numLot = @numLot
						AND NOT (PIECE.nomCategorie = 'Rebut' 
										AND PIECE.diametreBL = 0)),
		moyenneBT = (SELECT AVG (PIECE.diametreBT) 
						FROM PIECE
						WHERE numLot = @numLot
						AND NOT (PIECE.nomCategorie = 'Rebut' 
										AND PIECE.diametreBL = 0)),
		minimumHL = (SELECT MIN (PIECE.diametreHL) 
						FROM PIECE
						WHERE numLot = @numLot
						AND NOT (PIECE.nomCategorie = 'Rebut' 
										AND PIECE.diametreBL = 0)),
		minimumHT = (SELECT MIN (PIECE.diametreHT) 
						FROM PIECE
						WHERE numLot = @numLot
						AND NOT (PIECE.nomCategorie = 'Rebut' 
										AND PIECE.diametreBL = 0)),
		minimumBL = (SELECT MIN (PIECE.diametreBL) 
						FROM PIECE
						WHERE numLot = @numLot
						AND NOT (PIECE.nomCategorie = 'Rebut' 
										AND PIECE.diametreBL = 0)),
		minimumBT = (SELECT MIN (PIECE.diametreBT) 
						FROM PIECE
						WHERE numLot = @numLot
						AND NOT (PIECE.nomCategorie = 'Rebut' 
										AND PIECE.diametreBL = 0)),

		maximumHL = (SELECT MAX (PIECE.diametreHL) 
						FROM PIECE
						WHERE numLot = @numLot
						AND NOT (PIECE.nomCategorie = 'Rebut' 
										AND PIECE.diametreBL = 0)),
		maximumHT = (SELECT MAX (PIECE.diametreHT) 
						FROM PIECE
						WHERE numLot = @numLot
						AND NOT (PIECE.nomCategorie = 'Rebut' 
										AND PIECE.diametreBL = 0)),
		maximumBL = (SELECT MAX (PIECE.diametreBL) 
						FROM PIECE
						WHERE numLot = @numLot
						AND NOT (PIECE.nomCategorie = 'Rebut' 
										AND PIECE.diametreBL = 0)),
		maximumBT = (SELECT MAX (PIECE.diametreBT) 
						FROM PIECE
						WHERE numLot = @numLot
						AND NOT (PIECE.nomCategorie = 'Rebut' 
										AND PIECE.diametreBL = 0)),
		ecartTypeHL = (SELECT STDEV (PIECE.diametreHL) 
						FROM PIECE
						WHERE numLot = @numLot
						AND NOT (PIECE.nomCategorie = 'Rebut' 
										AND PIECE.diametreBL = 0)),
		ecartTypeHT = (SELECT STDEV (PIECE.diametreHT) 
						FROM PIECE
						WHERE numLot = @numLot
						AND NOT (PIECE.nomCategorie = 'Rebut' 
										AND PIECE.diametreBL = 0)),
		ecartTypeBL = (SELECT STDEV (PIECE.diametreBL) 
						FROM PIECE
						WHERE numLot = @numLot
						AND NOT (PIECE.nomCategorie = 'Rebut' 
										AND PIECE.diametreBL = 0)),
		ecartTypeBT = (SELECT STDEV (PIECE.diametreBT) 
						FROM PIECE
						WHERE numLot = @numLot
						AND NOT (PIECE.nomCategorie = 'Rebut' 
										AND PIECE.diametreBL = 0))
		WHERE numLot = @numLot
	END
END
GO

/**23/
======================================================================================================
* Le Trigger tgCumul met à jour la table CUMUL après une insertion de pièce(s) dans la table PIECE.
* Il permet les insertions multiples, si toutefois les pièces appartiennent à un seul et même lot.
*
* @author  MSDK
* @version 1.0
* @since   2016-12-01
*
======================================================================================================
*/

CREATE TRIGGER tgCumul
ON PIECE
FOR INSERT
AS

BEGIN

DECLARE @numeroLot TypeNumLot;

--Blockage du compteur de lignes affectées pour ne pas gêner le fonctionnement du trigger
SET NOCOUNT ON;

--Traitement non pris en charge si les pièces insérées appartiennent à différents lots
IF (SELECT COUNT(DISTINCT numLot)
	FROM inserted) > 1
	-- ou si le nombre de pièces ajoutées fait dépasser le nombre de pièces demandées pour le lot
	/*OR (SELECT COUNT(idPiece)
		FROM inserted)
				+ 
			(SELECT COUNT(idPiece)
				FROM PIECE p
				WHERE p.numLot = @numeroLot) 
							>
						(SELECT nbPiecesDemandees
							FROM LOT
							WHERE numLot = @numeroLot)
		*/			
	BEGIN
		ROLLBACK TRAN;
	END
ELSE
	BEGIN
		-- Récuperation du numéro de lot
		SET @numeroLot = (SELECT DISTINCT numLot
							FROM inserted);

		--Insertion dans CUMUL des lots et catégories absents et correspondant aux pièces enregistrées
		INSERT CUMUL
		SELECT DISTINCT numLot, nomCategorie, 0
		FROM inserted 
		WHERE nomCategorie NOT IN (SELECT nomCategorie
									FROM CUMUL 
									WHERE numLot = @numeroLot)

		--Mise à jour des nombres de pièces de ce lot par catégorie
		UPDATE CUMUL
		SET nombreDePieces += (SELECT COUNT(numLot)
								FROM INSERTED
								WHERE numLot = @numeroLot
									AND nomCategorie = 'Rebut')
		WHERE numLot = @numeroLot
			AND nomCategorie = 'Rebut'

		UPDATE CUMUL
		SET nombreDePieces += (SELECT COUNT(numLot)
								FROM INSERTED
								WHERE numLot = @numeroLot
									AND  nomCategorie = 'Petit')
		WHERE numLot = @numeroLot
			AND nomCategorie = 'Petit'

		UPDATE CUMUL
		SET nombreDePieces += (SELECT COUNT(numLot)
								FROM INSERTED
								WHERE numLot = @numeroLot
									AND nomCategorie = 'Moyen')
		WHERE numLot = @numeroLot
			AND nomCategorie = 'Moyen'

		UPDATE CUMUL
		SET nombreDePieces += (SELECT COUNT(numLot)
								FROM INSERTED
								WHERE numLot = @numeroLot
									AND nomCategorie = 'Gros')
		WHERE numLot = @numeroLot
			AND nomCategorie = 'Gros'

		--Mise à jour des statistiques de ce lot
		EXEC majStats @numeroLot;
	END
END
GO

--======================================================================================================
/*-- Le Trigger tgCumul met à jour la TABLE CUMUL après une insertion de pièce(s) dans la TABLE PIECE.
--Il permet les insertions multiples, si toutefois les pièces appartiennent à un seul et même lot.

--*
--* @author  MSDK
* @version 1.0
* @since   2016-12-01
*
*lorsque l'ON va supprimer un modèle celui ci sera également supprimer du stock avec ses catégorie*/
--======================================================================================================

CREATE view stockPlanif
AS
SELECT s.modele AS 'MODELE', s.quantiteStock AS 'QUANTITE', m.seuilMini AS 'SEUIL'
FROM Modele m JOIN STOCK s ON s.modele=m.modele
WHERE s.nomCategorie='Moyen';
GO

CREATE view production
AS
select numLot as 'LOT',modele as 'MODELE', nbPiecesDemandees as 'QT',
						dateDePlanification as 'DATE DE PLANIF.',etatDuLot as 'ETAT DU LOT',
								(SELECT libelle
									FROM MACHINE m JOIN LOT l ON  m.numPresse = l.numPresse
									WHERE l.numLot = lo.numLot)
									as 'PRESSE',dateDeFabrication as 'DATE DE FABRIC.' 
	from Lot lo
GO

CREATE view presse
AS 
SELECT numPresse AS 'NUMERO PRESSE', libelle AS 'NOM PRESSE', etatpresse AS ' ETAT', [dbo].prodPrecedente(libelle) AS 'PROD PRECEDENTE'
FROM machine
GO


CREATE FUNCTION [dbo].nbPiecesRestantes
(@numLot TypeNumLot)

RETURNS INT

AS

BEGIN
	
	DECLARE @nbPiecesRest INT;
	DECLARE @nbPiecesDemand INT;
	DECLARE @numPresse TypeNumPresse;
	DECLARE @retour typeNom;

	----verification du paramètre et de l'existence du Lot correspondant
	IF @numLot IS NOT NULL
		AND EXISTS (SELECT numLot FROM LOT WHERE numLot = @numLot
												AND nbPiecesDemandees IS NOT NULL) 
	
	BEGIN
		
		SELECT @nbPiecesDemand = nbPiecesDemandees
		FROM LOT
		WHERE numLot = @numLot

		SELECT @nbPiecesRest = @nbPiecesDemand - COUNT(idPiece)
		FROM LOT l JOIN PIECE p ON l.numLot = p.numLot
		WHERE p.numLot = @numLot		 			 
				
		IF @nbPiecesRest IS NULL
		SET @nbPiecesRest = 0;	
				 
   	END
RETURN (@nbPiecesRest);
END

GO
/*TEST [dbo].nbPiecesRestantes
DECLARE @nbPieces INT;
execute @nbPieces = [dbo].nbPiecesRestantes 3;
SELECT @nbPieces
*/

/*
CREATE FUNCTION [responsableProd].choixUtilisateur (@nom TypeNom)

returns TypeNom

AS
BEGIN
	
	DECLARE @coderet INT;
	DECLARE @retour typeNom;

	----verification des parametres

	--verifie que la variable n'est pas nulle et commence par une lettre
	IF @nom IS NULL OR @nom NOT LIKE '[a-zA-Z]%'
	BEGIN
		SET @coderet=1;
	END
	ELSE
	BEGIN
		
   		execute @retour = sp_helpuser @nom;
   									 							
					 SET @codeRet =0;
					
					 IF @retour IS NULL
						SET @retour= 0;			
				 

		END
		RETURN (@retour);
		
END
*/
/*
CREATE view profileConnexion
AS 
[responsableProd].choixUtilisateur 'responsableProd' AS 'Profile'
GO

SELECT * FROM profileConnexion

SELECT numPresse AS 'NUMERO PRESSE', libelle AS 'NOM PRESSE', etatpresse AS ' ETAT', [responsableProd].prodPrecedente(libelle) AS 'PROD PRECEDENTE'
FROM Machine

CREATE PROCEDURE trouverRole (@nom VARCHAR(100) OUTPUT)
AS	
		exec sp_helpuser @nom	

GO

DECLARE @msg VARCHAR(100);
DECLARE @retour INT;
exec trouverRole 'responsablePlanif'*/