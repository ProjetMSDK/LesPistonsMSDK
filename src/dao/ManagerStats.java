/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dao;

import entite.Lot;
import entite.Statistique;
import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.Statement;
import java.util.ArrayList;
import outils.Connexion;

/**
 *
 * @author mayer
 */
public class ManagerStats {
    
    
    
    
    public static ArrayList<Statistique> ListeStatsReduites(Lot lotStat)
    {
        try
        {
            ArrayList<Statistique> liste = new ArrayList<>();
            //statReduites @numLot typeNumLot, @message varchar(255) OUTPUT
            CallableStatement cs = Connexion.getInstance().getConn().prepareCall("{call statReduites (?, ?)}");
            
            //passage du paramètre en entrée numéro du lot
            cs.setInt(1, lotStat.getNumLot()); // numéro du lot
            
            //passage du paramètre en sortie message
            cs.registerOutParameter(2, java.sql.Types.VARCHAR );
            
            //execution de la requête
            
            ResultSet rs = cs.executeQuery();
            
            while(rs.next())
            {
                liste.add(new Statistique(
                            rs.getString(1),
                            rs.getFloat(2),
                            rs.getFloat(3),
                            rs.getFloat(4),
                            rs.getFloat(5)));
            }
            //récupération du message d'erreur
            lotStat.setMessage(cs.getString(2));
            rs.close();
            cs.close();
            //Connexion.getInstance().getConn().close();
            return liste;
        }
        catch (Exception ex) {
           ex.printStackTrace();
           return null;
        }
        
    }
    
    public static ArrayList<String> ListeColonnesStatsReduites()
    {
         try {
            
             ArrayList<String> liste = new ArrayList<>();
             CallableStatement cs = Connexion.getInstance().getConn().prepareCall
                                                    ("{call statReduites (1, '')}");
            
            //passage du paramètre en sortie message
            //cs.registerOutParameter(1, java.sql.Types.INTEGER);
            //cs.registerOutParameter(2, java.sql.Types.VARCHAR );
            
            ResultSet rs = cs.executeQuery();
            ResultSetMetaData md = rs.getMetaData();
            while (rs.next())
            {
                
            }
            int i = 1;
            while ( i <= md.getColumnCount())
            {
                    liste.add(md.getColumnName(i));
                    i++;
            }
            
            rs.close();
            cs.close();
            //Connexion.getInstance().getConn().close();
            return liste;
            
        } catch (Exception ex) {
           ex.printStackTrace();
           return null;
        }
    }
    
    public static ArrayList<Statistique> ListeStatsCumul(Lot lotStat)
    {
        try
        {
            ArrayList<Statistique> liste = new ArrayList<>();
            //PROCEDURE statCat @numLot typeNumLot, @message varchar(255) OUTPUT
            CallableStatement cs = Connexion.getInstance().getConn().prepareCall("{? = call statCat (?, ?)}");
            
            cs.registerOutParameter(1, java.sql.Types.INTEGER);
            //passage du paramètre en sortie message
            cs.registerOutParameter(3, java.sql.Types.VARCHAR ); 
            
            //passage du paramètre en entrée numéro du lot
            cs.setInt(2, lotStat.getNumLot()); // numéro du lot
            
            
            
            //execution de la requête
            
            ResultSet rs = cs.executeQuery();
            
            while(rs.next())
            {
                liste.add(new Statistique(
                            rs.getString(1),
                            rs.getInt(2)));
            }
            //récupération du message d'erreur
            lotStat.setMessage(cs.getString(3));
            rs.close();
            cs.close();
            //Connexion.getInstance().getConn().close();
            return liste;
        }
        catch (Exception ex) {
           ex.printStackTrace();
           return null;
        }
        
    }
}
