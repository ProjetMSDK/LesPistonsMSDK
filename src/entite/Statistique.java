/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package entite;

/**
 *
 * @author mayer
 */
public class Statistique {
    
    private int numLot;

    private float diametreHL ;
    private float diametreHT;
    private float diametreBL;
    private float diametreBT;
    
    private String categorie;
    private int quantite;


    
    private String typeStat;
    private String message;

  
    
    public Statistique(String typeS, float diametreHL, float diametreHT, float diametreBL, float diametreBT) {
        typeStat = typeS;
        this.diametreHL = diametreHL;
        this.diametreHT = diametreHT;
        this.diametreBL = diametreBL;
        this.diametreBT = diametreBT;
        
        message = null;
    }

    public Statistique(String cat, int qte) {
        categorie = cat;
        quantite = qte;
    }

    public int getQuantite() {
        return quantite;
    }

    public void setQuantite(int quantite) {
        this.quantite = quantite;
    }

    
    public String getCategorie() {
        return categorie;
    }

    public void setCategorie(String categorie) {
        this.categorie = categorie;
    }

    public String getTypeStat() {
        return typeStat;
    }

    public void setTypeStat(String typeStat) {
        this.typeStat = typeStat;
    }
    
    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    
    public int getNumLot() {
        return numLot;
    }

    public void setNumLot(int numLot) {
        this.numLot = numLot;
    }
    

    public float getDiametreHL() {
        return diametreHL;
    }

    public void setDiametreHL(float diametreHL) {
        this.diametreHL = diametreHL;
    }

    public float getDiametreHT() {
        return diametreHT;
    }

    public void setDiametreHT(float diametreHT) {
        this.diametreHT = diametreHT;
    }

    public float getDiametreBL() {
        return diametreBL;
    }

    public void setDiametreBL(float diametreBL) {
        this.diametreBL = diametreBL;
    }

    public float getDiametreBT() {
        return diametreBT;
    }

    public void setDiametreBT(float diametreBT) {
        this.diametreBT = diametreBT;
    }
    
    
}
