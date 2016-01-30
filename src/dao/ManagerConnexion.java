/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package dao;

import java.sql.CallableStatement;
import outils.Connexion;

/**
 *
 * @author Daniel
 */
public class ManagerConnexion {
    
    
        public static String trouverRole(String utilisateur)
        {
            try
            {
                CallableStatement cs = Connexion.getInstance().getConn().prepareCall
                    ("{? = call PROCEDURE trouverRole (?)}");
                //configuration des paramètres en sortie
                cs.registerOutParameter(1, java.sql.Types.INTEGER); //code retour
                cs.registerOutParameter(2, java.sql.Types.VARCHAR); // nom du rôle retourné
                
                //configuration des paramètres en entrée
                cs.setString(2, utilisateur); //nom de la machine
                
                cs.execute();
                
                if (cs.getInt(1) ==0)
                    return cs.getString(1);
                else return "";
        
        
            }catch(Exception e)
            {
                e.printStackTrace();
                return null;
            }
        }
}
