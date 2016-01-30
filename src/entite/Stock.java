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
public class Stock {
    
    private String modele;
    private String nomCategorie;
    private int quantite;
    private int seuil;

    public Stock(String modele, String nomCategorie, int quantite) {
        this.modele = modele;
        this.nomCategorie = nomCategorie;
        this.quantite = quantite;
    }

    public Stock(String modele, int quantite, int seuil) {
        this.modele = modele;
        this.quantite = quantite;
        this.seuil = seuil;
    }

    
    public int getSeuil() {
        return seuil;
    }

    public String getModele() {
        return modele;
    }

    public void setModele(String modele) {
        this.modele = modele;
    }

    public String getNomCategorie() {
        return nomCategorie;
    }

    public void setNomCategorie(String nomCategorie) {
        this.nomCategorie = nomCategorie;
    }

    public int getQuantite() {
        return quantite;
    }

    public void setQuantite(int quantite) {
        this.quantite = quantite;
    }
    
    
    
}
