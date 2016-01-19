/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dao;

import entite.Stock;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.Statement;
import java.util.ArrayList;
import outils.Connexion;

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
    
    
    
}
