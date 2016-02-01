package outils;

import java.sql.Connection;
import java.sql.SQLException;


public class Connexion
{
	private static Connexion instance;
        private static String _url ;
        private static String _user;
        private static String _password;
	private Connection conn;
	
	private Connexion(String user , String pass) throws Exception
        {
            
            //_url = "DESKTOP-AJ19R1G\\SQLEXPRESS";
            _url = "serveur-sql2012\\server2012";
            _user = user;
            _password = pass;
            
            
           
             creer(_url ,"LesPistonsMSDK",_user ,_password);
         
            
        }
        
       
	private Connection creer(String serveur, String db, String login, String pswd)
	{
		String url = "jdbc:sqlserver://" + serveur + "; databaseName = " + db + ";";
		try
		{
			conn = java.sql.DriverManager.getConnection(url, login, pswd);
		}
		catch (Exception e)
		{
			System.out.println("La connexion a échoué !\r> " + e.getMessage());
		}
		return conn;
	}
        

    public static String getUser() {
        return _user;
    }

    public static void setUser(String _user) {
        Connexion._user = _user;
    }
        
        public static Connexion getInstance(String user , String password)
                
        {
            if (instance == null)
        {
            try
            {
                instance = new Connexion(user,password);
            }
            catch(Exception e)
            {
            e.printStackTrace();
            }
            
            }
            return instance;
        }   
        public static Connexion getInstance()
                
        {
            if (instance == null)
        {
            try
            {
                instance = new Connexion(_user,_password);
            }
            catch(Exception e)
            {
            e.printStackTrace();
            }
            
            }
            return instance;
        }
      
        public Connection getConn()
        {
            return conn;
        }
        
        
	public void close()
	{
		try
		{
			conn.close();
		}
		catch (SQLException e)
		{
			e.printStackTrace();
		}
	}
	@Override
	public Object clone() throws CloneNotSupportedException
	{
		throw new CloneNotSupportedException();
	}
}