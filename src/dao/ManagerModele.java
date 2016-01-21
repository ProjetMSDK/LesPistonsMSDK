/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dao;


import entite.Modele;
import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import outils.Connexion;

/**
 *
 * @author benosmane
 */
public class ManagerModele {
    
    private ManagerModele() {}
    
    
 
    
    
    public static ArrayList<Modele> listeModeleMagasin()
    {
        try
        {
            Statement st = Connexion.getInstance().getConn().createStatement();
            ResultSet rs= st.executeQuery("Select Modele From Lot");
            ArrayList<Modele> liste = new ArrayList();
            while (rs.next())
            {
                liste.add(new Modele(rs.getString(1)));
            }
            return liste;
        }
        catch (Exception e)
        {
            e.printStackTrace();
            return null;
        }
    }
    
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
    /* ----------------------------------------------------------------------------------------------------------------------*/
          public static String supprimerModele(String modele)
    {       
        int code;
        String messa= null;
        try
        {
            CallableStatement cs= Connexion.getInstance().getConn().prepareCall("{?=call supprModele(?,?)}");
             
             //configuration des paramètres en sortie
             cs.registerOutParameter(1, java.sql.Types.INTEGER); //code retour
             cs.registerOutParameter(3, java.sql.Types.VARCHAR); // message
             
              //configuration des paramètres en entrée
             cs.setString(2, modele); //nom du modele
            
            
             
             // execute la mise a jour
             int ret = cs.executeUpdate();
             
             
             
             //recuperation du code retour
             code =cs.getInt(1);
             messa = cs.getString(3);
             //fermeture de la connection
             cs.close();
             //Connexion.getInstance().close();
           
       }
        catch(Exception e)
        {
            e.printStackTrace();
        }
        return messa;
    }
      /*---------------------------------------------------------------------------------------------------------------*/
     public static  String  ajouterModele( String nouveau, float taille)
     {
         String mess = null;
         int code;
         try
         {
             CallableStatement cs= Connexion.getInstance().getConn().prepareCall("{?=call ajoutModele(?,?,?)}");
             
             //configuration des paramètres en sortie
             cs.registerOutParameter(1, java.sql.Types.INTEGER); //code retour
             cs.registerOutParameter(4, java.sql.Types.VARCHAR); // message
             
              //configuration des paramètres en entrée
             cs.setString(2, nouveau); //nom du modele
             cs.setFloat(3,taille);// taille du modele
            
             
             // execute la mise a jour
             int ret = cs.executeUpdate();
             
             
             
             //recuperation du code retour
             code =cs.getInt(1);
             mess= cs.getString(4);
             //fermeture de la connection
             cs.close();
             //Connexion.getInstance().close();
           
         }
         catch(Exception e)
                 {
                     e.printStackTrace();
   
                  }
         return mess;
     }
}
