/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dao;


import entite.Modele;
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
}
