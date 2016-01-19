/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dao;

import entite.Lot;
import entite.Modele;
import entite.Piece;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.Statement;
import java.util.ArrayList;
import outils.Connexion;


/**
 *
 * @author delecourt
 */
public class ManagerModeles {
    /*
     Constructeur en privÃ© pour interdire l'instanciation
    */
    private ManagerModeles(){}
        /*
        Cette fonction donne la liste des Modèles de la table MODELES
     * @return Cette fonction retourne un ArrayList contenant tous les Modèles
        */
    /*------------------------------------------------------------------------------------------------------------------*/
     public static ArrayList <Modele> listeModeles()
    {
        try
        {
            Statement st = Connexion.getInstance().getConn().createStatement();
            ResultSet rs = st.executeQuery("SELECT modele FROM MODELE ");
            ArrayList<Modele> liste = new ArrayList();
            while (rs.next())
            {
                liste.add(new Modele(rs.getString(1)));
            }
            return liste;
        }
        catch(Exception e)
        {
            e.printStackTrace();
            return null;
        }
        
    }
    /* ----------------------------------------------------------------------------------------------------------------*/
     
     public static ArrayList<String> columnModeles()
   {
       try
       {

           Statement st = Connexion.getInstance().getConn().createStatement();
           ResultSet rs = st.executeQuery("select * from MODELE");
           ArrayList<String> listMod = new ArrayList<>();
           int i = 1;
          
          
               listMod.add(rs.getMetaData().getColumnName(1));
               
                   
           return listMod;
        }
        catch(Exception e)
        {
            return null;
        }
   }
   
   
/*---------------------------------------------------------------------------------------------------------------------*/   
     /* public static void supprimerModele(String modeles)
    {       
        try
        {
            Statement st = Connexion.getInstance().getConn().createStatement();
            ResultSet rs = st.executeQuery("Delete modele FROM MODELES where modele = "+ modeles );
            ArrayList<Modele> liste = new ArrayList();
            return ;
        }
        catch(Exception e)
        {
            return null;
        }
        
    }
      /*---------------------------------------------------------------------------------------------------------------*/
     /*public static void ajouterModele( String nouveau, String mess)
     {
         try
         {
             Statement st= Connexion.getInstance().getConn().createStatement();
             ResultSet rs = st.executeUpdate("call ajoutModele('nouveau'+'mess' output");
             return ;
         }
         catch(Exception e)
                 {
                     e.printStacktrace();
                     return null;
                 }
     }
     
 /*---------------------------------------------------------------------------------------------------------------------*/
   
     
     
   
}


