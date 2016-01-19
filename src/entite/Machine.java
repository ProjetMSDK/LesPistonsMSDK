/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package entite;

/**
 *
 * @author delecourt
 */
public class Machine {
    private int numPresse;
    private String libelle;

   
    
    public Machine(int mNumPresse , String mLibelle)
           
    {
        setNumPresse(mNumPresse);
        setLibelle(mLibelle);
    }

    /**
     * @return the numPresse
     */
    public int getNumPresse() {
        return numPresse;
    }

    /**
     * @param numPresse the numPresse to set
     */
    private void setNumPresse(int numPresse) {
        this.numPresse = numPresse;
    }

    /**
     * @return the libelle
     */
    public String getLibelle() {
        return libelle;
    }

    /**
     * @param libelle the libelle to set
     */
    private void setLibelle(String libelle) {
        this.libelle = libelle;
    }
}