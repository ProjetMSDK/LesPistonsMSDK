/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dao;

import entite.Machine;
import entite.Stock;
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
            ResultSet rs = st.executeQuery("select * from MACHINE");
            ArrayList<Machine> liste = new ArrayList<>();
             
            while ( rs.next())
            {
                    liste.add(new Machine(rs.getInt(1),rs.getString(2)));
                   
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
            ResultSet rs = st.executeQuery("select * from MACHINE");
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
