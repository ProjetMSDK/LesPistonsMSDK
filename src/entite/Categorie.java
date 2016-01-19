/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package entite;

/**
 *
 * @author bouyadel
 */
public class Categorie {
    
    private String nomCategorie;
    private double toleranceMini;
    private double toleranceMaxi;

    public Categorie(String nomCategorie, double toleranceMini, double toleranceMaxi) {
        this.nomCategorie = nomCategorie;
        this.toleranceMini = toleranceMini;
        this.toleranceMaxi = toleranceMaxi;
    }

    /**
     * @return the nomCategorie
     */
    public String getNomCategorie() {
        return nomCategorie;
    }

    /**
     * @param nomCategorie the nomCategorie to set
     */
    public void setNomCategorie(String nomCategorie) {
        this.nomCategorie = nomCategorie;
    }

    /**
     * @return the toleranceMini
     */
    public double getToleranceMini() {
        return toleranceMini;
    }

    /**
     * @return the toleranceMaxi
     */
    public double getToleranceMaxi() {
        return toleranceMaxi;
    }
    
    
}
