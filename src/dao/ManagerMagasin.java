/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dao;

import entite.MessageStatut;
import java.sql.CallableStatement;
import outils.Connexion;
import fenetres.*;
import java.sql.PreparedStatement;

/**
 *
 * @author benosmane
 */
public class ManagerMagasin {
   
    public static MessageStatut entreecaisse( String modele , String taille , int quantite)
    {
        MessageStatut mess = null;
    
        try
    {
        //PreparedStatement ps = Connexion.getInstance().getConn().prepareCall("{?=call entreeCaisse(?,?,?)}");
    CallableStatement cs =Connexion.getInstance().getConn().prepareCall ("{?=call entreeCaisse(?,?,?,?)}");
     //   ps.setInt(1, etat);
     //   ps.setString(2,modele);
     //   ps.setString(3, taille);
     //   ps.setInt(4, quantite);
    
    cs.registerOutParameter(1, java.sql.Types.INTEGER); //code retour
    cs.registerOutParameter(5, java.sql.Types.VARCHAR); // message
    
    cs.setString(2,modele);//@modele TypeNom
    cs.setString(3,taille);//@nameCategorie TypeNom
    cs.setInt(4, quantite);
        
    cs.execute();
    
    
    int code = cs.getInt(1);
        
        
     mess = new MessageStatut(cs.getString(5));
        
        cs.close();
        //Connexion.getInstance().close();
        
     //   System.out.println("code retour : "+code+" message "+ message);
    }
    catch(Exception e)
    {
        e.printStackTrace();
    }
   return mess;
    }
    

    
    public static MessageStatut sortieCaisse(String modele , String taille , int quantite)
    {
        MessageStatut mess = null;
        try
    {
        //PreparedStatement ps = Connexion.getInstance().getConn().prepareCall("{?=call entreeCaisse(?,?,?)}");
    CallableStatement cs =Connexion.getInstance().getConn().prepareCall ("{?=call sortieCaisse(?,?,?,?)}");
     //   ps.setInt(1, etat);
     //   ps.setString(2,modele);
     //   ps.setString(3, taille);
     //   ps.setInt(4, quantite);
    
    cs.registerOutParameter(1, java.sql.Types.INTEGER); //code retour
    cs.registerOutParameter(5, java.sql.Types.VARCHAR); // message
    
    cs.setString(2,modele);//@modele TypeNom
    cs.setString(3,taille);//@nameCategorie TypeNom
    cs.setInt(4, quantite);
        
    cs.execute();
    
    
    int code = cs.getInt(1);
        
        
    mess = new MessageStatut(cs.getString(5));
        
        cs.close();
        //Connexion.getInstance().close();
    return mess;
        //System.out.println(" message "+ message+ " code retour : "+code);
    }
    catch(Exception e)
    {
        e.printStackTrace();
    }
    return mess;
 }
}

