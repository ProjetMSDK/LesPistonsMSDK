/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package entite;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

/**
 *
 * @author mayer
 */
public class Piece implements ActionListener{
    
    private int numPiece;
    private int numLot;
    private String nomCategorie;
    private float diamHL;
    private float diamHT;
    private float diamBL;
    private float diamBT;
    private String comRebut;
    private String bilanEnregistrement;

    public String getBilanEnregistrement() {
        return bilanEnregistrement;
    }

    public void setBilanEnregistrement(String bilanEnregistrement) {
        this.bilanEnregistrement = bilanEnregistrement;
    }
    
    
public Piece(int pNumLot , 
            float pDiamHL ,float pDiamHT , float pDiamBL, float pDiamBT , 
            String pComRebut )
{
    
    setNumLot(pNumLot);
    setDiamHL(pDiamHL);
    setDiamHT(pDiamHT);
    setDiamBL(pDiamBL);
    setDiamBT(pDiamBT);
    setComRebut(pComRebut);
}

    /**
     * @return the numPiece
     */
    public int getNumPiece() {
        return numPiece;
    }

    /**
     * @param numPiece the numPiece to set
     */
    private void setNumPiece(int numPiece) {
        this.numPiece = numPiece;
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
     * @return the diamHL
     */
    public float getDiamHL() {
        return diamHL;
    }

    /**
     * @param diamHL the diamHL to set
     */
    private void setDiamHL(float diamHL) {
        this.diamHL = diamHL;
    }

    /**
     * @return the diamHT
     */
    public float getDiamHT() {
        return diamHT;
    }

    /**
     * @param diamHT the diamHT to set
     */
    private void setDiamHT(float diamHT) {
        this.diamHT = diamHT;
    }

    /**
     * @return the diamBL
     */
    public float getDiamBL() {
        return diamBL;
    }

    /**
     * @param diamBL the diamBL to set
     */
    private void setDiamBL(float diamBL) {
        this.diamBL = diamBL;
    }

    /**
     * @return the diamBT
     */
    public float getDiamBT() {
        return diamBT;
    }

    /**
     * @param diamBT the diamBT to set
     */
    private void setDiamBT(float diamBT) {
        this.diamBT = diamBT;
    }

    /**
     * @return the comRebut
     */
    public String getComRebut() {
        return comRebut;
    }

    /**
     * @param comRebut the comRebut to set
     */
    private void setComRebut(String comRebut) {
        this.comRebut = comRebut;
    }

    @Override
    public void actionPerformed(ActionEvent e) {
        
    }
        
    
    
}
