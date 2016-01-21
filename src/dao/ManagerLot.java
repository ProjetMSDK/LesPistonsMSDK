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
    public static ArrayList<Lot> listeLotControle()
    {
        try
        {
            Statement st = Connexion.getInstance().getConn().createStatement();
            ResultSet rs = st.executeQuery("SELECT * FROM LOT WHERE etatDuLot = 'Démarré' OR etatDuLot = 'Libéré' OR etatDuLot = 'Suspendu'" );
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
    
     public static ArrayList<Lot> listeLots()
    {
        try
        {
            Statement st = Connexion.getInstance().getConn().createStatement();
            ResultSet rs = st.executeQuery("SELECT * FROM LOT WHERE etatDuLot = 'Démarré' OR etatDuLot = 'Libéré' OR etatDuLot = 'Suspendu' OR etatDuLot = 'Arrêté'" );
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
    
    public static ArrayList<String> ListeColonnesProdPlanif()
    {
        try
        {
            Statement st = Connexion.getInstance().getConn().createStatement();
            ResultSet rs = st.executeQuery("select numLot, nbPiecesDemandees,dateDePlanification,dateDeFabrication,etatDuLot,numPresse,modele from LOt ");
            ArrayList<String> liste = new ArrayList<>();
            ResultSetMetaData md = rs.getMetaData();
            int i = 1;
            while(i <= md.getColumnCount())
            {
                liste.add(md.getColumnName(i));
                i++;
            }
            return liste;
        }catch (Exception e)
        {
            e.printStackTrace();
            return null;
        }
    }
    
    public static ArrayList<Lot> listeProdPlanif()
    {
        try
        {
            Statement st = Connexion.getInstance().getConn().createStatement();
            ResultSet rs = st.executeQuery("select numLot, nbPiecesDemandees,dateDePlanification,dateDeFabrication,etatDuLot,numPresse,modele from LOt " );
            ArrayList<Lot> liste = new ArrayList();
            while (rs.next())
            {
                liste.add(new Lot(rs.getInt(1), rs.getInt(2),rs.getDate(3) ,rs.getDate(4),rs.getString(5),rs.getInt(6), rs.getString(7)));
            }
            return liste;
        }
        catch(Exception e)
        {
            e.printStackTrace();
            return null;
        }
        
    }
    
    public static ArrayList<Lot> listeLotProd()
    {
        try
        {
            Statement st = Connexion.getInstance().getConn().createStatement();
            ResultSet rs = st.executeQuery("SELECT * FROM LOT WHERE etatDuLot <> 'Libéré' OR etatDuLot <> 'Arrêté'" );
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
    
    public static String changerEtatLot(int numLot)
    {
        String mess=null;
        try
        {
            CallableStatement cs = Connexion.getInstance().getConn().prepareCall("{?=call changerEtatLot(?,?)}");           
            
            cs.registerOutParameter(1, java.sql.Types.INTEGER); //code retour
            cs.registerOutParameter(3, java.sql.Types.VARCHAR); // message
            
             cs.setInt(2,numLot);//@numLot TypeNumLot
            
             cs.execute();
    
    
            int code = cs.getInt(1);
        
        
             mess = cs.getString(3);
        
            cs.close();
            //Connexion.getInstance().close();     
            
        }
        catch (Exception e)
        {
            e.printStackTrace();
        }
        return mess;
    }
    
    
    
    
    
    public static String planifierLot( String modele , int quantite)
    {
        String mess=null;
    
        try
    {
        //PreparedStatement ps = Connexion.getInstance().getConn().prepareCall("{?=call entreeCaisse(?,?,?)}");
    CallableStatement cs =Connexion.getInstance().getConn().prepareCall ("{?=call planifierLot(?,?,?)}");
     
    
    cs.registerOutParameter(1, java.sql.Types.INTEGER); //code retour
    cs.registerOutParameter(4, java.sql.Types.VARCHAR); // message
    
    cs.setString(2,modele);//@modele TypeNom
    cs.setInt(3,quantite);//@quantite TypeQuantite
    
        
    cs.execute();
    
    
    int code = cs.getInt(1);
        
        
    mess = cs.getString(4);
        
        cs.close();
        //Connexion.getInstance().close();        
        
    }
    catch(Exception e)
    {
        e.printStackTrace();
    }
    return mess;
    }
    
    public static String demarrerLot( int numLot, String presse)
    {
        String mess=null;
    
        try
    {
        //PreparedStatement ps = Connexion.getInstance().getConn().prepareCall("{?=call entreeCaisse(?,?,?)}");
    CallableStatement cs =Connexion.getInstance().getConn().prepareCall ("{?=call demarrerLot(?,?,?)}");
     
    
    cs.registerOutParameter(1, java.sql.Types.INTEGER); //code retour
    cs.registerOutParameter(4, java.sql.Types.VARCHAR); // message
    
    cs.setInt(2,numLot);//@numLot numero lot
    cs.setString(3,presse);//@presse presse choisie
    
        
    cs.execute();
    
    
    int code = cs.getInt(1);
        
        
    mess = cs.getString(4);
        
        cs.close();
        //Connexion.getInstance().close();        
        
    }
    catch(Exception e)
    {
        e.printStackTrace();
    }
    return mess;
    }
   
    public static String suspendreLot( int numLot)
    {
        String mess=null;
    
        try
    {
        //PreparedStatement ps = Connexion.getInstance().getConn().prepareCall("{?=call entreeCaisse(?,?,?)}");
    CallableStatement cs =Connexion.getInstance().getConn().prepareCall ("{?=call suspendreLot(?,?)}");
     
    
    cs.registerOutParameter(1, java.sql.Types.INTEGER); //code retour
    cs.registerOutParameter(3, java.sql.Types.VARCHAR); // message
    
    cs.setInt(2,numLot);//@numLot numero lot
    
    
        
    cs.execute();
    
    
    int code = cs.getInt(1);
        
        
    mess = cs.getString(3);
        
        cs.close();
        //Connexion.getInstance().close();        
        
    }
    catch(Exception e)
    {
        e.printStackTrace();
    }
    return mess;
    }
    
    
    public static void suspendreLot(Lot lotCourant)
    {
           
        try
    {
        //PreparedStatement ps = Connexion.getInstance().getConn().prepareCall("{?=call entreeCaisse(?,?,?)}");
    CallableStatement cs =Connexion.getInstance().getConn().prepareCall ("{?=call suspendreLot(?,?)}");
     
    
    cs.registerOutParameter(1, java.sql.Types.INTEGER); //code retour
    cs.registerOutParameter(3, java.sql.Types.VARCHAR); // message
    
    cs.setInt(2,lotCourant.getNumLot());//@numLot numero lot
    
    
        
    cs.execute();
    
    
    int code = cs.getInt(1);
        
        
    lotCourant.setMessage(cs.getString(3));
        
    cs.close();
    //Connexion.getInstance().close();        
        
    }
    catch(Exception e)
    {
        e.printStackTrace();
    }
    }
    
    public static void arreterLot( Lot lotCourant)
    {
    
        try
    {
        //PreparedStatement ps = Connexion.getInstance().getConn().prepareCall("{?=call entreeCaisse(?,?,?)}");
    CallableStatement cs =Connexion.getInstance().getConn().prepareCall ("{?=call arreterLot(?,?)}");
     
    
    cs.registerOutParameter(1, java.sql.Types.INTEGER); //code retour
    cs.registerOutParameter(3, java.sql.Types.VARCHAR); // message
    
    cs.setInt(2,lotCourant.getNumLot());//@numLot numero lot
    
    
        
    cs.execute();
    
    
    int code = cs.getInt(1);
        
        
    lotCourant.setMessage(cs.getString(3));
        
        cs.close();
        //Connexion.getInstance().close();        
        
    }
    catch(Exception e)
    {
        e.printStackTrace();
    }
    }
}