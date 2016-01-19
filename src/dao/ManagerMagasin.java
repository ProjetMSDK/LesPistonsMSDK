/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dao;

import java.sql.CallableStatement;
import outils.Connexion;
import fenetres.*;

/**
 *
 * @author benosmane
 */
public class ManagerMagasin {
   
    public static void entreecaisse(String modele , String taille , int quantite)
    {
        
    
        try
    {
    CallableStatement cs =Connexion.getInstance().getConn().prepareCall ("{call entreeCaisse(?,?,?)}");
        
        cs.setString(1,modele);
        cs.setString(2, taille);
        cs.setInt(3, quantite);
        
    }
    catch(Exception e)
    {
        e.printStackTrace();
    }
    
}
    
    public static void sortieCaisse(String modele , String taille , int quantite)
    {
        
    
        try
    {
    CallableStatement cs =Connexion.getInstance().getConn().prepareCall ("{call sortieCaisse(?,?,?)}");
        
        cs.setString(1,modele);
        cs.setString(2, taille);
        cs.setInt(3, quantite);
        
    }
    catch(Exception e)
    {
        e.printStackTrace();
    }
    
}
}
