CREATE DATABASE LesPistonsMSDK
GO
USE LesPistonsMSDK

--Cr�ations des droits


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

--Cr�ation des types

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

--Cr�ation des tables
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
('Lanc�'),
('D�marr�'),
('Suspendu'),
('Lib�r�'),
('Arr�t�')
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
etatDuLot TypeNom NULL references ETAT (nomEtat) DEFAULT 'Lanc�',
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


--Proc�dures Stock�es


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
* La PROC ajoutModele permet d'ajouter un mod�le de piston
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
--   		 2: la mod�le existe d�ja
--      	 3: erreur base de donn�es( exception)
--   		 0:ok
-- sortie :@message: contient le message d'erreur

AS

DECLARE @coderet INT;
DECLARE @dummy CHAR;
----verification des parametres

IF @modele IS NULL OR  @modele NOT LIKE '[a-zA-Z0-9]%'
BEGIN
    SET @coderet=1;
    SET @message = 'Erreur : Nom de mod�le invalide';
END
ELSE IF @diametre IS NULL OR  @diametre <= 0
BEGIN
	SET @coderet=1;
    SET @message = 'Erreur : Diam�tre invalide';
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
   			SET @message ='Erreur : le mod�le  ' + @modele + ' existe d�j�';
   			SET @codeRet =2;
			ROLLBACK TRANSACTION;
   		END
   		ELSE
   		BEGIN		 
			INSERT INTO MODELE(modele,diametre,seuilMini)
			VALUES (@modele,@diametre,0)

			SET @codeRet = 0;
			SET @message = 'Le mod�le ' + @modele + ' a �t� ajout�';
				 
			COMMIT TRANSACTION;		 					 
   		END
	END TRY
   	BEGIN CATCH
   		-- erreur base de donn�es
		ROLLBACK TRANSACTION;

   		SET @message='Erreur base de donn�es' + ERROR_MESSAGE();
   		SET @coderet=3;
		
   	END CATCH
END
RETURN (@coderet);
GO




/** /3
======================================================================================================
*
* La PROC modifierSeuil permet de modifier le Seuil d'alerte du stock pour chaque mod�le de piston
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
--   		 2: la presse existe d�j�
--      	 3: erreur base de donn�es( exception)
--   		 0: ok
-- sortie :@message: contient le message d'erreur

AS

DECLARE @coderet INT;

----verification des parametres

IF @modele IS NULL OR  @modele NOT LIKE '[a-zA-Z0-9]%'   --!! en remplacement de [A-Za-z]%
BEGIN
    SET @coderet=1;
    SET @message = 'Erreur : Nom de mod�le invalide';
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

   				SET @message ='Erreur : le mod�le ' + @modele + ' n''existe pas';
   				SET @codeRet =2;
				
   			 END
   			 ELSE
   			 BEGIN
   				 UPDATE Modele
				 SET seuilMini = @SeuilMini
				 WHERE modele = @modele
				 
				 COMMIT TRANSACTION;

				 SET @codeRet =0;
				 SET @message = 'Seuil d''alerte mis � jour' ;
				 				 		 					 
   			 END
	END TRY
   	BEGIN CATCH
   		-- erreur base de donn�es
		ROLLBACK TRANSACTION;

   		SET @message='Erreur base de donn�es' + ERROR_MESSAGE();
   		SET @coderet=3;
		
   	END CATCH
END
RETURN (@coderet);
GO




/**4/
======================================================================================================
* La PROC supprModele permet de supprimer un mod�le de piston
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
--      	 3: erreur base de donn�es( exception)
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
		SET @message = 'Erreur : mod�le invalide';
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

   			SET @message ='Erreur : le mod�le  ' + @modele + ' n''existe pas';
   			SET @codeRet =2;
				
   		END
   		ELSE IF EXISTS (SELECT modele FROM LOT  WHERE modele = @modele)
		BEGIN
			ROLLBACK TRANSACTION;

   			SET @message ='Erreur : le mod�le  ' + @modele + ' ne peut etre supprim� car un lot a d�j� �t� cr��';
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
			SET @message = 'Le mod�le ' + @modele + ' a �t� supprim�';
				 				 
   		END
	END TRY
   	BEGIN CATCH
   		-- erreur base de donn�es
		ROLLBACK TRANSACTION;

   		SET @message='Erreur base de donn�es' + ERROR_MESSAGE();
   		SET @coderet=3;
			 
   	END CATCH
END
RETURN (@coderet);
GO


/**5/
======================================================================================================
* Le Trigger supprModeleStock  permet de supprimer un mod�le de piston dans le stock
*
* @author  MSDK
* @version 1.0
* @since   2016-12-01
*
*lorsque l'on supprime un mod�le celui ci sera �galement supprim� du stock avec ses cat�gories
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
* Le Trigger addModeleStock  permet d'ajouter un mod�le de piston dans le stock
*
* @author  MSDK
* @version 1.0
* @since   2016-12-01
*
*lorsque l'ON va ajouter un mod�le celui ci sera �galement ajout� au stock avec ses cat�gorie
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
--Fonction: --Cette proc�dure ajoute une machine
--parametres : @nomPresse est le nom de la presse concern� par la PROC.
--==========================================================================================
*/
CREATE PROC ajouterMachine @nomPresse TypeNom, @message VARCHAR(255) OUTPUT

--code retour
--   		 1: un parametre possede une valeur nulle
--   		 2: la presse existe d�j�
--      	 3: erreur base de donn�es( exception)
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

   			SET @message ='Erreur : La presse ' + @nomPresse + ' existe d�j�';
   			SET @codeRet =2;				
   		END
   		ELSE
   		BEGIN
			-- creation d'une machine dans la TABLE MACHINE
   			INSERT MACHINE (libelle)
			VALUES (@nomPresse);

			COMMIT TRANSACTION;	

			SET @codeRet =0;
			SET @message = 'Presse ' + @nomPresse + ' cr��e';				 	 					 
   		END
	END TRY
   	BEGIN CATCH
   		-- erreur base de donn�es
		ROLLBACK TRANSACTION;

   		SET @message='Erreur base de donn�es' + ERROR_MESSAGE();
   		SET @coderet=3;
			 
   	END CATCH
END
RETURN (@coderet);
GO

/** /8 supprimerMachine
--=========================================================================================
--Auteur: MSDK
--Date : 12/01/16
--Fonction: --Cette proc�dure supprime une machine
--parametres : @nomPresse  est le nom de la presse concern� par la PROC.
--==========================================================================================
*/
CREATE PROC supprimerMachine @nomPresse TypeNom, @message VARCHAR(255) OUTPUT

--code retour
--   		 1: un parametre possede une valeur nulle
--   		 2: la presse existe d�j�
--      	 3: erreur base de donn�es( exception)
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
		--- verifie que la machine n a pas deja �t� utilis�e
		IF NOT EXISTS(SELECT libelle 
				FROM MACHINE m JOIN LOT l ON m.numPresse = l.numPresse 
				WHERE libelle = @nomPresse )
		--On supprime la machine
		BEGIN
			DELETE MACHINE
			WHERE 	libelle = @nomPresse;
				 
			COMMIT TRANSACTION;	 	

			SET @codeRet =0;
			SET @message = 'Presse ' + @nomPresse + ' supprim�e'
		END
				 
		ELSE
		--La machine passe � l'�tat inactif
		BEGIN
			UPDATE MACHINE	
			SET etatPresse ='Inactif'
			WHERE libelle = @nomPresse;
				
			COMMIT TRANSACTION;	 	

			SET @codeRet =0;
			SET @message = 'Presse ' + @nomPresse + ' inactiv�e';
		END				
	END
	END TRY
	BEGIN CATCH
		-- erreur base de donn�es
		ROLLBACK TRANSACTION;

		SET @message='Erreur base de donn�es' + ERROR_MESSAGE();
		SET @coderet=3;
			 
	END CATCH
END
RETURN (@coderet);
GO





/** /9 changerEtatLot
--=========================================================================================
--Auteur: MSDK
--Date : 11/01/16
--Fonction: --Cette proc�dure fait �voluer l'�tat du lot � l'�tat suivant 
--(Si l'�tat �tait � 'Lanc�' =>'D�marr�' , 'Suspendu'=>' D�marr�'; 'D�marr�'=> 'Lib�r�'; 'Lib�r�'=> 'Arr�t�')
--( Elle libere la presse �tat 'En Production=> 'Libre' lorsque l'�tat du Lot passe de 'D�marr�'=> 'Lib�r�')
--Elle initialise � la date courante le champs dateDeFabrication
--parametres : @numLot  est le num�ro du lot concern� par la PROC.
--==========================================================================================
*/

CREATE PROC changerEtatLot  @numLot TypeNumLot, @message VARCHAR(255) OUTPUT

--code retour
--   		 1: un parametre possede une valeur nulle  //etatDuLot
--   		 2: la presse existe d�j�
--      	 3: erreur base de donn�es( exception)
--   		 0:ok
-- sortie :@message: contient le message d'erreur

AS

DECLARE @coderet INT;
DECLARE @etatLot typeNom;

----verification des parametres

--verifie que la variable n'est pas nulle et superieur � 0
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
			 

			IF @etatLot='lanc�'
			BEGIN
				UPDATE LOT
				SET etatDuLot= 'D�marr�' WHERE  numLot = @numLot;
			END
			
			ELSE IF @etatLot= 'Suspendu' 
			BEGIN
				UPDATE LOT
				SET etatDuLot= 'D�marr�' WHERE  numLot = @numLot;
			END
			
			ELSE IF @etatLot='D�marr�'
			BEGIN
				UPDATE LOT
				SET etatDuLot= 'Lib�r�' WHERE  numLot = @numLot ;

				--La machine utilis�e par la production est lib�r�e
				UPDATE MACHINE
				SET etatPresse='Libre' WHERE numPresse IN
				(SELECT m.numPresse FROM Machine m JOIN LOT l 
				ON m.numPresse=l.numPresse 
				WHERE numLot = @numLot);

				--la date de fabrication est initialis�e
				UPDATE LOT
				SET dateDeFabrication = GETDATE()  WHERE  numLot = @numLot;
								
			END
			
			ELSE IF @etatLot='Lib�r�'
			BEGIN
				UPDATE LOT
				SET etatDuLot= 'Arr�t�'
				WHERE  numLot = @numLot;
			END
							
			COMMIT TRANSACTION;

			SET @codeRet =0;
			SET @message = 'Etat du lot '+ CAST(@numLot AS VARCHAR(50)) +' modifi�';
				 
				 		 					 
		END
	END TRY
	
	BEGIN CATCH
		-- erreur base de donn�es
		ROLLBACK TRANSACTION;

		SET @message='Erreur base de donn�es' + ERROR_MESSAGE();
		SET @coderet=3;
			 
	END CATCH
END
RETURN (@coderet);
GO

/** /10 planifierLot
--==========================================================================================================
--auteur :MSDK
--date:12/01/16
--fonction: Cette proc�dure permet de planifier un lot , initialise la date de planification � la date courante et la date de fabrication � NULL
--parametres:   @modele est le mod�le concerne par la planification
--				@quantite est le nombre de pieces du mod�le
--==========================================================================================================
*/
CREATE PROC planifierLot @modele TypeNom, @quantite TypeQuantite, @message VARCHAR(255) OUTPUT

--code retour
--   		 1: un parametre possede une valeur nulle  //etatDuLot
--   		 2: la presse existe d�j�
--      	 3: erreur base de donn�es( exception)
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
    SET @message = 'Erreur : quantit� absente ou non valide';
END
ELSE
BEGIN
   	BEGIN TRY
		 --verifier l existence du mod�le, dans la TRANSACTION
		 BEGIN TRANSACTION 
		 	
		 		DECLARE @dummy CHAR = '';
				SELECT @dummy = ''
				FROM LOT  WITH (HOLDLOCK, TABLOCKX) , 
					 MODELE  WITH (HOLDLOCK, TABLOCKX)  				     
				WHERE MODELE.modele IS NULL ;				 				 		 		 	
			
   			IF NOT EXISTS (SELECT diametre FROM MODELE  WHERE modele = @modele)  
			 BEGIN
				ROLLBACK TRANSACTION;

   				SET @message ='Erreur : le mod�le ' + @modele + ' n''existe pas';
   				SET @codeRet =2;
				
   			 END
   			 ELSE
			 
   			 BEGIN
				-- creation du lot
				-- remplit les champs nbPiecesDemandees, modele,dateDePlanification dans la TABLE LOT				
   				INSERT INTO LOT (nbPiecesDemandees, modele,dateDePlanification)
				VALUES	(@quantite, @modele,GETDATE());	

				--recuperation du num�ro de Lot pour afficher dans le message				
				SELECT @numLot= MAX(numLot) 
				FROM LOT		
				COMMIT TRANSACTION;		 
				 							
				SET @codeRet = 0;
				SET @message = 'Nouveau lot ' + CAST(@numLot AS VARCHAR(50)) + ' planifi�'; 
   			END	
		END TRY
   		 BEGIN CATCH
   			 -- erreur base de donn�es
			 ROLLBACK TRANSACTION;

   			 SET @message='Erreur base de donn�es' + ERROR_MESSAGE();
   			 SET @coderet=3;
			 
   		 END CATCH
	END
	RETURN (@coderet);
GO



/* 11*/
--==========================================================================================================
--auteur :MSDK
--date:13/01/16
--fonction: Cette proc�dure permet de d�marrer un lot en production , l'etat du lot passe de Lanc�=>D�marr�
--			grace � la proc�dure changerEtatLot
--			l'etat de la presse passe � l'�tat 'En production'
--parametres:   @numLot est le nu�mro de lot concerne par la production
--				@nomPresse est la presse choisie par l 'op�rateur
--==========================================================================================================
CREATE PROC demarrerLot   @numLot TypeNumLot, @nomPresse TypeNom, @message VARCHAR(255) OUTPUT

--code retour
--   		 1: un parametre possede une valeur nulle
--   		 2: la presse est d�j� utilis�e
--      	 3: erreur base de donn�es( exception)
--   		 0:ok
-- sortie :@message: contient le message d'erreur

AS
DECLARE @coderet INT;
DECLARE @numPresse TypeNumPresse;

----verification des parametres

IF @nomPresse IS NULL
	BEGIN
		SET @coderet=1;
		SET @message = ' Erreur : num�ro de presse absent';
	END
ELSE
IF @numLot IS NULL OR @numLot < 0
	BEGIN 
		SET @coderet= 1;
		SET @message= 'Erreur: num�ro de lot absent ou non valide';
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
				IF NOT EXISTS (SELECT numLot FROM LOT WHERE numLot = @numLot AND etatDuLot = 'Lanc�')
						BEGIN
							ROLLBACK TRANSACTION;

							SET @coderet=1;
							SET @message ='Erreur : le lot n. ' + CAST(@numLot AS VARCHAR(50)) + ' n''existe pas ou est d�j� lanc�';
							
						END			

				ELSE-- verifier que la presse demand�e est libre
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
							SET @message = 'Le lot n. ' + CAST(@numLot AS VARCHAR(50)) + ' a d�marr� sur la presse ' 
							+ @nomPresse;
						 END

						 ELSE
						 BEGIN
							ROLLBACK TRANSACTION;
						 END
					END
				
		END TRY
   		 BEGIN CATCH
   			 -- erreur base de donn�es
			 ROLLBACK TRANSACTION;

   			 SET @message='Erreur base de donn�es ' + ERROR_MESSAGE();
   			 SET @coderet=3;
			 
   		 END CATCH
	END
	RETURN (@coderet);
GO
/** /12 / suspendreLot
--=========================================================================================
--Auteur: MSDK
--Date : 11/01/16
--Fonction: --Cette proc�dure fait �voluer l'�tat du lot D�marr�'=> 'Suspendu'
--parametres : @numLot  est le num�ro du lot concern� par la PROC.

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
--   		 2: la presse existe d�j�
--      	 3: erreur base de donn�es( exception)
--   		 0:ok
-- sortie :@message: contient le message d'erreur

AS

DECLARE @coderet INT;

----verification des parametres

--verifie que la variable n'est pas nulle et superieur � 0
IF @numLot IS NULL OR @numLot < 0
BEGIN
    SET @coderet=1;
    SET @message = 'Erreur : param�tre nom du lot absent';
END
ELSE
BEGIN
   	BEGIN TRY
		--verifier l existence du Lot, dans la TRANSACTION	
		BEGIN TRANSACTION 	
		
		IF NOT EXISTS (SELECT etatDuLot 
							FROM LOT WITH (HOLDLOCK, TABLOCKX) 
							WHERE numLot = @numLot
							AND (etatDuLot = 'D�marr�'
							OR etatDuLot = 'Lib�r�')) 
   		BEGIN
   			ROLLBACK TRANSACTION;
				
			SET @message ='Erreur : le lot '+ CAST(@numLot AS VARCHAR(50)) +' n''existe pas ou n''est pas en �tat d''�tre suspendu';
   			SET @codeRet =2;
				
   		END

		ELSE

		BEGIN
			 			 
			UPDATE LOT
			SET etatDuLot= 'Suspendu'  WHERE  numLot = @numLot;

			COMMIT TRANSACTION;

			SET @codeRet = 0;
			SET @message = 'Le lot n. '+ CAST(@numLot AS VARCHAR)+' a �t� suspendu';

		END
						
		
				 			 
	END TRY
   	BEGIN CATCH
		-- erreur base de donn�es
		ROLLBACK TRANSACTION;

		SET @message='Erreur base de donn�es' + ERROR_MESSAGE();
		SET @coderet=3;
			 
   	END CATCH
END
RETURN (@coderet);
GO

/** / / arreterLot
--=========================================================================================
--Auteur: MSDK
--Date : 11/01/16
--Fonction: --Cette proc�dure change l'�tat du lot � 'Arr�t�'
--parametres : @numLot  est le num�ro du lot concern�.

--==========================================================================================
*/
CREATE PROC arreterLot  @numLot TypeNumLot, @message VARCHAR(255) OUTPUT

--code retour
--   		 1: un parametre possede une valeur nulle  //etatDuLot
--   		 2: la presse existe d�j�
--      	 3: erreur base de donn�es( exception)
--   		 0:ok
-- sortie :@message: contient le message d'erreur

AS

DECLARE @coderet INT;
DECLARE @dummy CHAR;
----verification des parametres

--verifie que la variable n'est pas nulle et superieur � 0
IF @numLot IS NULL OR @numLot < 0
BEGIN
    SET @coderet=1;
    SET @message = 'Erreur : param�tre nom du lot absent ou invalide';
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
							AND (etatDuLot = 'D�marr�'
							OR etatDuLot = 'Lib�r�'
							OR etatDuLot = 'Suspendu')) 
   			 BEGIN
   				ROLLBACK TRANSACTION;
				
				SET @message ='Erreur : le lot '+ CAST(@numLot AS VARCHAR(50)) +' n''existe pas ou n''est pas en �tat d''�tre arr�t�';
   				SET @coderet =2;
				
   			 END
   			 ELSE
   			 BEGIN
				
				 --met l'�tat du lot � arr�t�
			 
   				UPDATE LOT
				SET etatDuLot= 'Arr�t�'  
				WHERE  numLot = @numLot;

				-- Lib�re la presse
				
				UPDATE MACHINE
				SET etatPresse = 'Libre'
				WHERE numPresse = (SELECT numPresse
									FROM LOT
									WHERE numLot = @numLot)
				
				 COMMIT TRANSACTION;	 					
				 SET @coderet =0;
				 SET @message = 'Le lot n. '+ CAST(@numLot AS VARCHAR)+' a �t� arr�t�';
				 
					 					 
   			   END
		 END TRY
   		 BEGIN CATCH
   			 -- erreur base de donn�es
   			 SET @message='Erreur base de donn�es' + ERROR_MESSAGE();
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
--parametres : @nomPresse  est le nom du machine concern� par la PROC.

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

	----verification du param�tre
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
* La PROC trouverCat permet de trouver, partant des c�tes d'une pi�ce et son mod�le, 
* la cat�gorie � laquelle celle-ci appartient.
* Elle teste d'abord si les dimensions de la pi�ce trait�e sont celles exig�es 
* par la cat�gorie 'Moyen'.
* Sinon elle v�rifie si elles respectent celles des cat�gories 'Petit' et 'Gros'.
* Finalement, toute pi�ce dont les mesures ne co�ncident avec aucune de ces cat�gories 
* est consid�r�e 'Rebut'.
* 
* @author  MSDK
* @version 1.0
* @since   2016-12-01
*
*
*
*@modele Nom du mod�le de piston
*
*@cote1, @cote2, @cote3, @cote4
*
*@nomCat Nom de la cat�gorie
* 
*@message Message de sortie
======================================================================================================
*/

CREATE PROC trouverCat @modele TypeNom, 
						@cote1 TypeCote, @cote2 TypeCote, @cote3 TypeCote, @cote4 TypeCote, 
						@nomCat TypeNom OUTPUT, 
						@message VARCHAR(255) OUTPUT

AS

-- D�claration de la borne inf�rieure de la cat�gorie courante
DECLARE @diamMin TypeCote;
-- D�claration de la borne sup�rieure de la cat�gorie courante
DECLARE @diamMax TypeCote;

BEGIN
	SET NOCOUNT ON; -- le nombre de lignes affect�es n'est pas renvoy�
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
	
	--On commence par v�rifier si la pi�ce peut �tre consid�r�e 'standard' ('Moyen')
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

			
			--On v�rifie si les c�tes rentrent dans l'intervalle des pi�ces de cat�gorie 'Petit'
			IF (@cote1 > @diamMin AND @cote2 > @diamMin AND @cote3 > @diamMin AND @cote4 > @diamMin) AND
				(@cote1 < @diamMax AND @cote2 < @diamMax AND @cote3 < @diamMax AND @cote4 < @diamMax)
			BEGIN
				SET @nomCat = 'Petit';
			END

			ELSE 
				-- Si non, on essaye encore avec les dimensions de la cat�gorie 'Gros'
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

					--On v�rifie si les c�tes rentrent dans l'intervalle des pi�ces de cat�gorie 'Gros'
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
   			-- erreur base de donn�es
   			SET @message='Erreur base de donn�es' + ERROR_MESSAGE();
   			--SET @codeRet=3;
   	END CATCH
END
GO

/** /15 enregistrerPiece
======================================================================================================
*
* La PROC enregistrerPiece enregistre une nouvelle pi�ce et donne la cat�gorie 
* et le num�ro de la pi�ce cr��e.
* Si la pi�ce courante est la derni�re du lot, la proc�dure arreterLot est appel�e pour
* faire passer l'�tat du lot � 'Arr�t�'
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
--			2 : Le lot n'existe pas ou n'est pas � 'D�marr�'
--			3 : Erreur base de donn�es( exception)
--			0 : Ok
-- Sortie : @message: contient le message d'erreur

AS
DECLARE @codeRet INT;
DECLARE @modelePiece TypeNom;
DECLARE @dummy CHAR;

BEGIN
	BEGIN TRY
	SET NOCOUNT ON; -- le nombre de lignes affect�es n'est pas renvoy�
		--V�rifications des param�tres

		IF @lot IS NULL
		BEGIN
			SET @codeRet = 1;
			SET @message = 'Erreur : Param�tre @lot absent';
		END

		ELSE
		BEGIN
			IF @hl IS NULL OR @ht IS NULL OR @bl IS NULL OR @bt IS NULL
				OR @hl < 0 OR @ht < 0 OR @bl < 0 OR @bt < 0
			BEGIN
				SET @codeRet = 1;
				SET @message = 'Erreur : Param�tres C�tes manquants ou invalides';
			END -- Fin de la v�rification des param�tres

			ELSE -- Si les param�tres sont corrects, on poursuit le traitement
			BEGIN
				BEGIN TRANSACTION 
				SELECT @dummy = ' ' -- Blockage des tables
								FROM LOT  WITH (HOLDLOCK, TABLOCKX) , 
									MODELE  WITH (HOLDLOCK, TABLOCKX) , 
									CATEGORIE  WITH (HOLDLOCK, TABLOCKX) 
								WHERE numLot IS NULL ;

				-- V�rification de l'existence du lot donn� en param�tre
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
				--V�rification de l'�tat du lot donn� en param�tre
					IF NOT EXISTS (SELECT numLot
									FROM LOT
									WHERE numLot = @lot
										AND (etatDuLot LIKE 'D�marr�'
										OR etatDuLot LIKE 'Lib�r�'))
					BEGIN
						ROLLBACK TRANSACTION;
						SET @codeRet = 2;
						SET @message = 'Erreur : Le lot n. ' + CAST(@lot AS VARCHAR(50)) + ' n''est pas en �tat d''�tre contr�l�';
					END 
						
					ELSE --Si l'�tat du lot est correct, d�but du traitement
					BEGIN
						-- R�cup�ration du mod�le du lot donn�
						SELECT @modelePiece = MODELE.modele
								FROM MODELE JOIN LOT ON LOT.modele = MODELE.modele
								WHERE LOT.numLot = @lot
		
						-- Appel de la proc�dure trouverCat pour conna�tre la cat�gorie de la pi�ce courante
						EXEC trouverCat @modelePiece, @hl, @ht , @bl, @bt, @categorie OUTPUT, @message OUTPUT;
				
						--Insertion de la pi�ce dans la TABLE PIECE
				
						INSERT INTO PIECE (numLot, nomCategorie, diametreHL, diametreHT, diametreBL, diametreBT, commentaireRebut)
						VALUES (@lot, @categorie, @hl, @ht , @bl, @bt, @commentaireRebut)
		
						--On r�cup�re le num�ro de pi�ce de ce dernier enregistrement 
						SELECT @numPiece = MAX(idPiece) 
						FROM PIECE 
						WHERE numLot = @lot
						
						-- Mise � jour du @message et du code Retour
						SET @codeRet = 0;
						SET @message = 'La pi�ce n.' + CAST(@numPiece AS VARCHAR(50)) + ' a �t� enregistr�e';
						

						--Si ON a atteint le nombre de pi�ces demand�es pour ce lot (donc fin de lot)
				
						IF EXISTS (SELECT * FROM LOT WHERE numLot = @lot 
													AND nbPiecesDemandees = (SELECT COUNT(*)
																			 FROM PIECE
																			 WHERE numLot = @lot
																			 )
								  )
				
						--On fait passer l'�tat du lot � Arr�t�
						BEGIN
							EXEC @codeRet = arreterLot  @lot, @message OUTPUT
						
							IF @codeRet = 0
							BEGIN
								-- On peut valider la TRANSACTION et lib�rer les tables
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
		-- erreur base de donn�es
   		SET @message='Erreur base de donn�es' + ERROR_MESSAGE();
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
*@nameCategorie est la categorie dans laquelle le piston est class�
*
*@nbcaisse est le nombre de caisse que l'ON souhaite ajouter au stock
======================================================================================================
*/


CREATE PROC entreeCaisse @modele TypeNom, @nameCategorie TypeNom, @nbCaisse Typequantite , @message VARCHAR(255) OUTPUT

--code retour
--   		 1: un parametre possede une valeur NULL
--   		 2: le modele pour lequel ON souhaite stocker le piston n 'existe pas
--      	 3: erreur base de donn�es( exception)
--   		 0:la saisie � bien �t� prise en compte
-- sortie :@message: contient le message d'erreur

AS

DECLARE @coderet INT;

----verification des parametres

IF @modele IS NULL OR  @modele NOT LIKE '[a-zA-Z0-9]%'
BEGIN
    SET @coderet=1;
    SET @message = 'Erreur : nom du mod�le absent ou non valide';
END
ELSE IF	@nameCategorie IS NULL OR @nameCategorie NOT LIKE '[A-Za-z]%'
BEGIN
    SET @coderet=1;
    SET @message = 'Erreur : nom de cat�gorie absent ou non valide';
END
ELSE IF @nbCaisse IS NULL  OR @nbCaisse < 0
BEGIN
    SET @coderet=1;
    SET @message = 'Erreur : quantit� absente ou non valide';
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

   				SET @message ='Erreur : le mod�le ' + CAST(@modele AS VARCHAR(50)) + ' et la categorie de piston ' 
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
				 SET @message = CAST(@nbCaisse AS VARCHAR(10)) + ' caisse(s) de mod�le ' + CAST(@modele AS VARCHAR(50))  
				 + ' de piston de cat�gorie ' + CAST(@nameCategorie AS VARCHAR(50)) + ' ajout�e(s) au stock';
				 							 
   			 END
		END TRY
   		 BEGIN CATCH
   			 -- erreur base de donn�es
   			 SET @message='Erreur base de donn�es' + ERROR_MESSAGE();
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
*@nameCategorie est la categorie dans laquelle le piston est class�
*
*@nbcaisse est le nombre de caisse que l'ON souhaite retirer du stock
======================================================================================================
*/
CREATE PROC sortieCaisse @modele TypeNom, @nameCategorie TypeNom, @nbCaisse TypeQuantite , @message VARCHAR(255) OUTPUT

--code retour
--   		 1: un parametre possede une valeur NULL
--   		 2: le modele pour lequel ON souhaite stocker le piston n 'existe pas
--      	 3: erreur base de donn�es( exception)
--   		 0:la saisie � bien �t� prise en compte
-- sortie :@message: contient le message d'erreur

AS

DECLARE @coderet INT;
DECLARE @qtStock INT;


----verification des parametres

IF @modele IS NULL OR  @modele NOT LIKE '[a-zA-Z0-9]%'
BEGIN
    SET @coderet=1;
    SET @message = 'Erreur : nom du mod�le absent ou non valide';
END
ELSE IF	@nameCategorie IS NULL OR @nameCategorie NOT LIKE '[A-Za-z]%'
BEGIN
    SET @coderet=1;
    SET @message = 'Erreur : nom de cat�gorie absent ou non valide';
END
ELSE IF @nbCaisse IS NULL
BEGIN
    SET @coderet=1;
    SET @message = 'Erreur : param�tre quantit� absent';
END
ELSE
BEGIN
   	BEGIN TRY
		BEGIN TRANSACTION 
   		IF NOT EXISTS (SELECT modele FROM STOCK WITH (HOLDLOCK, TABLOCKX) WHERE modele = @modele AND @nameCategorie = nomCategorie)  --verifier l existence du modele
   		BEGIN
			ROLLBACK TRANSACTION;

   			SET @message ='Erreur : le mod�le ' + CAST(@modele AS VARCHAR(50))  + 
					' ou la cat�gorie de piston ' + CAST(@nameCategorie AS VARCHAR(50)) + ' n''existe pas';
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
			--Fin des v�rifications
   			BEGIN
   				UPDATE STOCK
				SET quantiteStock =  quantiteStock - @nbCaisse
				WHERE modele = @modele AND nomCategorie = @nameCategorie

				COMMIT TRANSACTION;

				SET @codeRet =0;
				SET @message = CAST(@nbCaisse AS VARCHAR(10)) + ' caisse(s) de mod�le ' + CAST(@modele AS VARCHAR(50))  + ' de piston de cat�gorie ' 
							+ CAST(@nameCategorie AS VARCHAR(50)) + ' retir�e(s) du stock';
			END 					 
   		END
	END TRY
   	BEGIN CATCH
   		-- erreur base de donn�es
		ROLLBACK TRANSACTION;

   		SET @message='Erreur base de donn�es' + ERROR_MESSAGE();
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
*La fonction fnStatsReduites retourne la TABLE contenant les statistiques r�duites.
*
*@numLot est le num�ro du lot � analyser
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
*La PROC statReduites donne les valeurs de la moyenne, du MAX, du MIN et de l'�cart type.
*
*@numLot est le num�ro du lot � analyser
*
*@message est le message de sortie
======================================================================================================
*/

CREATE PROCEDURE statReduites @numLot typeNumLot, @message VARCHAR(255) OUTPUT

-- Code Retour
--			1 : Un parametre possede une valeur nulle ou invalide
--			2 : Le lot n'existe pas ou n est pas encore en �tat de fabrication
--			3 : Erreur base de donn�es( exception)
--			0 : Ok
-- Sortie : @message: contient le message d'erreur

AS

DECLARE @codeRet INT;
BEGIN
	BEGIN TRY

		-- V�rification du param�tre
		IF @numLot IS NULL OR @numLOT < 0 
		BEGIN
			SET @codeRet = 1;
			SET @message = 'Erreur : Le param�tre @numLot est manquant ou invalide';
		END
		ELSE
		BEGIN
			-- V�rification de l'existence du lot donn� en param�tre
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
   			-- erreur base de donn�es
   			SET @message='Erreur base de donn�es' + ERROR_MESSAGE();
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
*La fonction fnStatsCat retourne la TABLE contenant les quantit�s de pi�ces du lot par cat�gorie :
* Quantit�s de Rebuts, Petits, Moyens, Gros et Total
*
*@numLot est le num�ro du lot � analyser
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
* La PROC statCat effectue les v�rifications n�cessaires et appelle la fonction fnStatsCat
* afin d'afficher les quantit�s de pi�ces du lot par cat�gorie : 
* Quantit�s de Rebuts, Petits, Moyens, Gros et Total
*
*@numLot est le num�ro du lot � analyser
*
*@message est le message de sortie
======================================================================================================
*/

CREATE PROCEDURE statCat @numLot typeNumLot, @message VARCHAR(255) OUTPUT

-- Code Retour
--			1 : Un parametre possede une valeur nulle ou invalide
--			2 : Le lot n'existe pas ou n'est pas � l'�tat 'D�marr�'
--			3 : Erreur base de donn�es (exception)
--			0 : Ok
-- Sortie : @message: contient le message d'erreur

AS

DECLARE @codeRet INT;
BEGIN
	BEGIN TRY
		-- V�rification des param�tres
		IF @numLot IS NULL OR @numLOT <= 0 
		BEGIN
			SET @codeRet = 1;
			SET @message = 'Erreur : Le param�tre @numLot est manquant ou invalide';
		END
		ELSE
		BEGIN
			BEGIN TRANSACTION;
			-- V�rification de l'existence du lot donn� en param�tre
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
   			-- erreur base de donn�es
   			ROLLBACK TRANSACTION;
			SET @message='Erreur base de donn�es' + ERROR_MESSAGE();
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
*La PROC majStats met � jour les valeurs de la moyenne, du MAX, du MIN et de l'�cart type du lot
* donn�.
*
*@numLot est le num�ro du lot � traiter
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
						--on �carte les pi�ces ayant un d�faut visuel
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
* Le Trigger tgCumul met � jour la table CUMUL apr�s une insertion de pi�ce(s) dans la table PIECE.
* Il permet les insertions multiples, si toutefois les pi�ces appartiennent � un seul et m�me lot.
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

--Blockage du compteur de lignes affect�es pour ne pas g�ner le fonctionnement du trigger
SET NOCOUNT ON;

--Traitement non pris en charge si les pi�ces ins�r�es appartiennent � diff�rents lots
IF (SELECT COUNT(DISTINCT numLot)
	FROM inserted) > 1
	-- ou si le nombre de pi�ces ajout�es fait d�passer le nombre de pi�ces demand�es pour le lot
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
		-- R�cuperation du num�ro de lot
		SET @numeroLot = (SELECT DISTINCT numLot
							FROM inserted);

		--Insertion dans CUMUL des lots et cat�gories absents et correspondant aux pi�ces enregistr�es
		INSERT CUMUL
		SELECT DISTINCT numLot, nomCategorie, 0
		FROM inserted 
		WHERE nomCategorie NOT IN (SELECT nomCategorie
									FROM CUMUL 
									WHERE numLot = @numeroLot)

		--Mise � jour des nombres de pi�ces de ce lot par cat�gorie
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

		--Mise � jour des statistiques de ce lot
		EXEC majStats @numeroLot;
	END
END
GO

--======================================================================================================
/*-- Le Trigger tgCumul met � jour la TABLE CUMUL apr�s une insertion de pi�ce(s) dans la TABLE PIECE.
--Il permet les insertions multiples, si toutefois les pi�ces appartiennent � un seul et m�me lot.

--*
--* @author  MSDK
* @version 1.0
* @since   2016-12-01
*
*lorsque l'ON va supprimer un mod�le celui ci sera �galement supprimer du stock avec ses cat�gorie*/
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

	----verification du param�tre et de l'existence du Lot correspondant
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