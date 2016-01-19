/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dao;

import entite.Piece;
import java.sql.CallableStatement;
import outils.Connexion;

/**
 *
 * @author mayer
 */
public class ManagerPiece {
    
    
    public static void enregistrerPiece(Piece pieceCourante)
    {
        try
        {
            String message = "";
            String nomCateg = "";
            int codeRetour;
            CallableStatement cs = Connexion.getInstance().getConn().prepareCall("{? = call enregistrerPiece (?, ?, ?,?, ?, ?, ?, ?, ?)}");
            
            //configuration des paramètres en sortie
            cs.registerOutParameter(1, java.sql.Types.INTEGER); //code retour
            cs.registerOutParameter(7, java.sql.Types.VARCHAR); // catégorie
            cs.registerOutParameter(8, java.sql.Types.INTEGER); // numéro de la pièce
            cs.registerOutParameter(10, java.sql.Types.VARCHAR); // message
    
            //configuration des paramètres en entrée
            cs.setInt(2, pieceCourante.getNumLot());
            cs.setFloat(3, pieceCourante.getDiamHL());
            cs.setFloat(4, pieceCourante.getDiamHT());
            cs.setFloat(5, pieceCourante.getDiamBL());
            cs.setFloat(6, pieceCourante.getDiamBT());
            cs.setString(9, pieceCourante.getComRebut());
            
            //exécution de la requête
            cs.execute();
            
            //récupération du code Retour
            
            codeRetour = cs.getInt(1);
            pieceCourante.setNomCategorie(cs.getString(7));
            
            pieceCourante.setNumLot(cs.getInt(8));
            System.out.println(""+pieceCourante.getNumLot());
            
            pieceCourante.setBilanEnregistrement(cs.getString(10));
            
            cs.close();
            Connexion.getInstance().close();
            
            
        }
        catch(Exception e)
        {
            e.printStackTrace();
            
        }
        
        
    }
}
