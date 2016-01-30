/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dao;


import entite.MessageStatut;
import entite.Modele;
import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
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
            ResultSet rs= st.executeQuery("Select * from MODELE");
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
            ResultSet rs = st.executeQuery("select modele as MODELE, diametre as 'DIAMETRE', seuilMini as 'SEUIL' from MODELE");
            ArrayList<Modele> liste = new ArrayList();
            while (rs.next())
            {
                liste.add(new Modele(rs.getString(1),rs.getFloat(2),rs.getInt(3)));
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
           ResultSet rs = st.executeQuery("select modele as MODELE, diametre as 'DIAMETRE', seuilMini as 'SEUIL' from MODELE");
           ArrayList<String> listMod = new ArrayList<>();
           ResultSetMetaData md = rs.getMetaData();
           int i = 1;
          while (i <= md.getColumnCount())
          {
          
               listMod.add(rs.getMetaData().getColumnName(i));
               i++;
               
          }
               
                   
           return listMod;
        }
        catch(Exception e)
        {
            return null;
        }
   }
    /* ----------------------------------------------------------------------------------------------------------------------*/
          public static MessageStatut supprimerModele(String modele)
    {       
        int code;
        MessageStatut mess= null;
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
             mess= new MessageStatut(cs.getString(3));
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
      /*---------------------------------------------------------------------------------------------------------------*/
     public static  MessageStatut  ajouterModele( String nouveau, float taille)
     {
         MessageStatut mess = null;
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
             mess= new MessageStatut(cs.getString(4));
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
     
     public static MessageStatut modifierSeuil(String modele , int quantite)
    {
        MessageStatut mess=null;
    
        try
    {
    //procedure modifierSeuil @modele TypeNom, @SeuilMini TypeQuantite , @message varchar(255) Output
    CallableStatement cs =Connexion.getInstance().getConn().prepareCall ("{?=call modifierSeuil(?,?,?)}");
     
    
    cs.registerOutParameter(1, java.sql.Types.INTEGER); //code retour
    cs.registerOutParameter(4, java.sql.Types.VARCHAR); // message
    
    cs.setString(2,modele);//@modele TypeNom
    cs.setInt(3,quantite);//@quantite TypeQuantite
    
        
    cs.execute();
    
    
    int code = cs.getInt(1);
            
    mess = new MessageStatut(cs.getString(4));
        
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
