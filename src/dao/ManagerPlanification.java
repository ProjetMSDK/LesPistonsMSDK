/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dao;

import entite.Lot;
import entite.Piece;
import entite.Stock;
import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.Statement;
import java.util.ArrayList;
import outils.Connexion;
import outils.DateFR;

/**
 *
 * @author bouyadel
 */
public class ManagerPlanification {
    
    public static ArrayList<Stock> listeStockPlanif()
    {
       try {
            Statement st = Connexion.getInstance().getConn().createStatement();
            ResultSet rs = st.executeQuery("select * from stockPlanif");
            ArrayList<Stock> liste = new ArrayList<>();
             
            while ( rs.next())
            {
                    liste.add(new Stock(rs.getString(1),rs.getInt(2), rs.getInt(3)));
                   
            }
            return liste;
        } catch (Exception ex) {
           ex.printStackTrace();
           return null;
        }
        
    }
    public static ArrayList<String> ListeColonnesStockPlanif()
    {
         try {
            Statement st = Connexion.getInstance().getConn().createStatement();
            ResultSet rs = st.executeQuery("select * from stockPlanif");
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
    
    public static ArrayList<Lot> listeProdPlanif()
    {
       try {
            Statement st = Connexion.getInstance().getConn().createStatement();
            ResultSet rs = st.executeQuery("select numLot, modele, nbPiecesDemandees, dateDePlanification, numPresse,dateDeProduction, etatDuLot from Lot ");
            ArrayList<Lot> liste = new ArrayList<>();
             
            while ( rs.next())
            {
                    liste.add(new Lot(rs.getInt(1),rs.getInt(2), (DateFR)rs.getDate(3), (DateFR)rs.getDate(4),rs.getString(5),rs.getInt(6),rs.getString(7)));
                   
            }
            return liste;
        } catch (Exception ex) {
           ex.printStackTrace();
           return null;
        }
        
    }
    public static ArrayList<String> ListeColonnesProdPlanif()
    {
         try {
            Statement st = Connexion.getInstance().getConn().createStatement();
            ResultSet rs = st.executeQuery("select numLot, modele, nbPiecesDemandees, dateDePlanification, numPresse,dateDeProduction, etatDuLot from Lot ");
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
    
    public static String planifierLot(String modele, int quantite)
    {
        int codeRetour;
        String message = null;
        
        try
        {
           
            
            CallableStatement cs = Connexion.getInstance().getConn().prepareCall("{? = call planifierLot (?, ?,?)}");
            
            //configuration des paramètres en sortie
            cs.registerOutParameter(1, java.sql.Types.INTEGER); //code retour            
            cs.registerOutParameter(4, java.sql.Types.VARCHAR); // message
            
            //configuration des paramètres en entrée
            cs.setString(2,modele); //modele
            cs.setDouble(3,quantite); //quantite
            
            
            //exécution de la requête
            cs.execute();
            
            //récupération du code Retour
            
            codeRetour = cs.getInt(1);
            message=cs.getString(4);
            
            cs.close();
            Connexion.getInstance().close();
            
            
        }
        catch(Exception e)
        {
            e.printStackTrace();
            
        }
        
        return message;
    }    
}
