package outils;
import java.util.GregorianCalendar;
import java.util.Locale;

public class DateFR extends GregorianCalendar
{

	private static final long serialVersionUID = 1L;
	

	public void affiche()
	{
		System.out.println(this);
	}
	
	public String toString()
	{
		return 
	
				getDisplayName(DAY_OF_WEEK, LONG, Locale.FRANCE).substring(0,1).toUpperCase() + 
				getDisplayName(DAY_OF_WEEK, LONG, Locale.FRANCE).substring(1) + " " + 
				get(DAY_OF_MONTH) + " " + 
				getDisplayName(MONTH, LONG, Locale.FRANCE).substring(0,1).toUpperCase() + 
				getDisplayName(MONTH, LONG, Locale.FRANCE).substring(1) + " " +
				get(YEAR) + " " + get(HOUR_OF_DAY) + "h" + ("0" + get(MINUTE)).substring(Math.max(("0" + get(MINUTE)).length() - 2, 0)) 
				+ "mn" + ("0" + get(SECOND)).substring(Math.max(("0" + get(SECOND)).length() - 2, 0))
				+ "s" + String.format("%03d", get(MILLISECOND));
	}

}
