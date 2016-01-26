/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dao;

import entite.Machine;
import entite.MessageStatut;
import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.Statement;
import java.util.ArrayList;
import outils.Connexion;

/**
 *
 * @author delecourt
 */
public class ManagerMachine {
    
    public static ArrayList<Machine> listeMachine()
    {
       try {
            Statement st = Connexion.getInstance().getConn().createStatement();
            ResultSet rs = st.executeQuery("select numPresse as 'NUMERO PRESSE' , libelle as  'PRESSE' , etatPresse as 'ETAT' from MACHINE");
            ArrayList<Machine> liste = new ArrayList<>();
             
            while ( rs.next())
            {
                    liste.add(new Machine(rs.getInt(1),rs.getString(2),rs.getString(3)));
                   
            }
            return liste;
        } catch (Exception ex) {
           ex.printStackTrace();
           return null;
        }
        
    }
    public static ArrayList<String> ListeColonnesMachine()
    {
         try {
            Statement st = Connexion.getInstance().getConn().createStatement();
            ResultSet rs = st.executeQuery("select numPresse as 'NUMERO PRESSE' , libelle as  'PRESSE' , etatPresse as 'ETAT' from MACHINE");
            ArrayList<String> liste = new ArrayList<>();
             ResultSetMetaData md = rs.getMetaData();
             int i = 1;
            
            while ( i <= md.getColumnCount())
            {
                    liste.add(md.getColumnName(i));
                    i++;
            }
            return liste;
        } catch (Exception ex) {
           ex.printStackTrace();
           return null;
        }
    }
    
    public static ArrayList<Machine> listePresse()
    {
       try {
            Statement st = Connexion.getInstance().getConn().createStatement();
            ResultSet rs = st.executeQuery("select * from presse");
            ArrayList<Machine> liste = new ArrayList<>();
             
            while ( rs.next())
            {
                    liste.add(new Machine(rs.getInt(1),rs.getString(2),rs.getString(3), rs.getString(4)));
                   
            }
            return liste;
        } catch (Exception ex) {
           ex.printStackTrace();
           return null;
        }
        
    }
    /**
     * Cette fonction est appelée par le modèle du tableau de presse, fenêtre 
     * production
     * 4 Colonnes : Numéro Presse, Nom Presse, Etat, Prod précédente
     * @return 
     */
    public static ArrayList<String> ListeColonnesPresse()
    {
         try {
            Statement st = Connexion.getInstance().getConn().createStatement();
            ResultSet rs = st.executeQuery("select * from presse");
            ArrayList<String> liste = new ArrayList<>();
             ResultSetMetaData md = rs.getMetaData();
             int i = 1;
            while ( i <= md.getColumnCount())
            {
                    liste.add(md.getColumnName(i));
                    i++;
            }
            return liste;
        } catch (Exception ex) {
           ex.printStackTrace();
           return null;
        }
    }
    
    public static String supprimerMachine(String machine )
    {       
        int code;
        String messa= null;
        try
        {
            CallableStatement cs= Connexion.getInstance().getConn().prepareCall("{?=call supprimerMachine(?,?)}");
             
             //configuration des paramètres en sortie
             cs.registerOutParameter(1, java.sql.Types.INTEGER); //code retour
             cs.registerOutParameter(3, java.sql.Types.VARCHAR); // message
             
              //configuration des paramètres en entrée
             cs.setString(2, machine); //nom de la machine
            
            
             
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
     public static MessageStatut ajouterMachine( String nouvelle)
     {
         int code;
         MessageStatut mess= null;
         try
         {
             CallableStatement cs= Connexion.getInstance().getConn().prepareCall("{?=call ajouterMachine(?,?)}");
             
             //configuration des paramètres en sortie
             cs.registerOutParameter(1, java.sql.Types.INTEGER); //code retour
             cs.registerOutParameter(3, java.sql.Types.VARCHAR); // message
             
              //configuration des paramètres en entrée
             cs.setString(2, nouvelle); //nom de la machine
            
            
             
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
    
    
    
}
