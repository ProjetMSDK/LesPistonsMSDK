/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package entite;

import java.util.Date;



/**
 *
 * @author mayer
 */
public class Lot {
    
    private int numLot;
    private int nbPiecesDemandees;
    private Date dateDePlanification;
    private Date dateDeFabric;
    private String etatDuLot; 
    private int TypeNumPresse; 
    private String modele;
    private double moyenneHL; 
    private double moyenneHT; 
    private double moyenneBL;
    private double moyenneBT;
    private double maximumHL; 
    private double maximumHT; 
    private double maximumBL;
    private double maximumBT;    
    private double minimumBL;     
    private double minimumBT;
    private double minimumHL;
    private double minimumHT;
    private double ecartTypeHL;
    private double ecartTypeHT;
    private double ecartTypeBL;
    private double ecartTypeBT;

    private String message;
    
    
    public Lot(int numLot, int nbPiecesDemandees, String etatDuLot, String modele) {
        this.numLot = numLot;
        this.nbPiecesDemandees = nbPiecesDemandees;
        this.etatDuLot = etatDuLot;
        this.modele = modele;
    }

    public Lot(int numLot, int nbPiecesDemandees, Date dateDePlanification, Date dateDeFabric, String etatDuLot, int TypeNumPresse, String modele) {
        this.numLot = numLot;
        this.nbPiecesDemandees = nbPiecesDemandees;
        this.dateDePlanification = dateDePlanification;
        this.dateDeFabric = dateDeFabric;
        this.etatDuLot = etatDuLot;
        this.TypeNumPresse = TypeNumPresse;
        this.modele = modele;
    }
    
    

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    /**
     * Constructeur pour gestion des statistiques
     */
    public Lot(int numeroLot)
    {
        numLot = numeroLot;
        
    }
    
    
    
    /**
     * @return the numLot
     */
    public int getNumLot() {
        return numLot;
    }

    /**
     * @param numLot the numLot to set
     */
    public void setNumLot(int numLot) {
        this.numLot = numLot;
    }

    /**
     * @return the nbPiecesDemandees
     */
    public int getNbPiecesDemandees() {
        return nbPiecesDemandees;
    }

    /**
     * @return the dateDeFabric
     */
    public Date getDateDeFabric() {
        return dateDeFabric;
    }

    /**
     * @return the etatDuLot
     */
    public String getEtatDuLot() {
        return etatDuLot;
    }

    /**
     * @return the TypeNumPresse
     */
    public int getTypeNumPresse() {
        return TypeNumPresse;
    }

    /**
     * @return the modele
     */
    public String getModele() {
        return modele;
    }

    
    public void setModele(String modele) {
        this.modele = modele;
    }
    /**
     * @return the moyenneHL
     */
    public double getMoyenneHL() {
        return moyenneHL;
    }

    /**
     * @return the moyenneHT
     */
    public double getMoyenneHT() {
        return moyenneHT;
    }

    /**
     * @return the moyenneBL
     */
    public double getMoyenneBL() {
        return moyenneBL;
    }

    /**
     * @return the moyenneBT
     */
    public double getMoyenneBT() {
        return moyenneBT;
    }

    /**
     * @return the maximumHL
     */
    public double getMaximumHL() {
        return maximumHL;
    }

    /**
     * @return the maximumHT
     */
    public double getMaximumHT() {
        return maximumHT;
    }

    /**
     * @return the maximumBL
     */
    public double getMaximumBL() {
        return maximumBL;
    }

    /**
     * @return the maximumBT
     */
    public double getMaximumBT() {
        return maximumBT;
    }

    /**
     * @return the minimumBL
     */
    public double getMinimumBL() {
        return minimumBL;
    }

    /**
     * @return the minimumBT
     */
    public double getMinimumBT() {
        return minimumBT;
    }

    /**
     * @return the minimumHL
     */
    public double getMinimumHL() {
        return minimumHL;
    }

    /**
     * @return the minimumHT
     */
    public double getMinimumHT() {
        return minimumHT;
    }

    /**
     * @return the ecartTypeHL
     */
    public double getEcartTypeHL() {
        return ecartTypeHL;
    }

    /**
     * @return the ecartTypeHT
     */
    public double getEcartTypeHT() {
        return ecartTypeHT;
    }

    /**
     * @return the ecartTypeBL
     */
    public double getEcartTypeBL() {
        return ecartTypeBL;
    }

    /**
     * @return the ecartTypeBT
     */
    public double getEcartTypeBT() {
        return ecartTypeBT;
        
    }

    public Date getDateDePlanification() {
        return dateDePlanification;
    }

    public void setDateDePlanification(Date dateDePlanification) {
        this.dateDePlanification = dateDePlanification;
    }

    
    @Override
    public String toString() {
        return "Lot{" + "numLot=" + numLot + '}';
    }

    public void setVire(Boolean aBoolean) {
        throw new UnsupportedOperationException("Not supported yet."); //To change body of generated methods, choose Tools | Templates.
    }
    
    
}
