/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package entite;

/**
 *
 * @author benosmane
 */
public class Modele {
    
    private String modele;
    private Float diametre;
    private int seuilMini;
    
    
    public Modele(String mModele , Float mDiametre, int mSeuilMini)
    {
        
        setModele(mModele);
        setDiametre(mDiametre);
        setSeuilMini(mSeuilMini);
        
    }
    
    public Modele(String mModele)
    {
        setModele(mModele);
    }

    /**
     * @return the modele
     */
    public String getModele() {
        return modele;
    }

    /**
     * @param modele the modele to set
     */
   private void setModele(String modele) {
        this.modele = modele;
    }

    /**
     * @return the diametre
     */
    public Float getDiametre() {
        return diametre;
    }

    /**
     * @param diametre the diametre to set
     */
    private void setDiametre(Float diametre) {
        this.diametre = diametre;
    }

    /**
     * @return the seuilMini
     */
    public int getSeuilMini() {
        return seuilMini;
    }

    /**
     * @param seuilMini the seuilMini to set
     */
    public void setSeuilMini(int seuilMini) {
        this.seuilMini = seuilMini;
    }
    
}
