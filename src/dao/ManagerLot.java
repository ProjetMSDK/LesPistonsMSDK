package dao;

import entite.Lot;
import entite.Piece;
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
public class ManagerLot {
    /**
     * Constructeur en privÃ© pour interdire l'instanciation
     */
    private ManagerLot() {}
    
    /**
     * Cette fonction donne la liste des pilotes de la table PILOTE
     * @return Cette fonction retourne un ArrayList contenant tous les pilotes
     */
    public static ArrayList<Lot> listeLots()
    {
        try
        {
            Statement st = Connexion.getInstance().getConn().createStatement();
            ResultSet rs = st.executeQuery("SELECT * FROM LOT WHERE etatDuLot = 'Démarré' OR etatDuLot = 'Libéré' OR etatDuLot = 'Suspendu' OR etatDuLot = 'Arrêté'");
            ArrayList<Lot> liste = new ArrayList();
            while (rs.next())
            {
                liste.add(new Lot(rs.getInt(1), rs.getInt(2), rs.getString(5), rs.getString(7)));
            }
            return liste;
        }
        catch(Exception e)
        {
            e.printStackTrace();
            return null;
        }
        
    }
    
    public static void changerEtatLot()
    {
        try
        {
            CallableStatement st = Connexion.getInstance().getConn().prepareCall("{call changerEtatLot (?)}");
            
            st.setInt(1, 1);
            st.registerOutParameter(1, java.sql.Types.VARCHAR);
            
            st.close();
            
        }
        catch (Exception e)
        {
            e.printStackTrace();
        }
    }
}