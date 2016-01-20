package outils;

import java.sql.Connection;
import java.sql.SQLException;

public class Connexion
{
	private static Connexion instance;
	private static Connection conn;
	
	private Connexion() {
            
            conn = creer("serveur-sql2012\\server2012","LesPistonsMSDK","delecourt","developpeur");
            
        }
	
	public static synchronized Connexion getInstance()
	{
		try
		{
			if (instance == null || conn.isClosed())
				instance = new Connexion();
		}
		catch (SQLException e)
		{
			e.printStackTrace();
			instance = null;
		}
		return instance;
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