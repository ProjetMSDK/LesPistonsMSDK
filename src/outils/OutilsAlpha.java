package outils;

public class OutilsAlpha
{
	
	public static boolean estAlpha(String s)
	{
		return s != null && s.matches("^[\\p{L}]+$");
	}
	
	public static boolean estAlphaS(String s)
	{
		return s != null && s.trim().matches("^[\\p{L} ]+$");	
	}
	
	
	public static boolean estAlphaNum(String s)
	{
		return s != null && s.matches("^[\\p{L}\\p{N}]+$");		
	}
	
	
	public static boolean estAlphaNumS(String s)
	{
		return s != null && s.matches("^[\\p{L}\\p{N} ]+$");			
	}
	
	public static boolean estEntier(String s)
	{
		return s != null && s.matches("[0-9]+");
	}
        
        public static boolean estEntierNonNul(String s)
	{
		return s != null && s.matches("[1-9]+");
	}
	
	public static boolean estEntier5(String s)
	{
		return s != null && s.matches("^[0-9]{5}$");
	}
	
	public static int convertir(String s)
	{
		int nbConverti = 0;
		if(estEntier(s))
			nbConverti = Integer.parseInt(s);
		return nbConverti;
			
	}
	
	

}
