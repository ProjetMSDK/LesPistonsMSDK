/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package entite;

import java.awt.Color;

/**
 *
 * @author Daniel
 */
public class MessageStatut {
    
    
    private String statut;
    private Color couleur;
    
    public MessageStatut(String message)
    {
        setStatut(message.trim());
        
    }

    public String getStatut() {
        return statut;
    }

    public void setStatut(String message) {
        
        statut = message;
        if(message.startsWith("Erreur"))
        {
            setCouleur(Color.RED);
        }
        else
        {
            setCouleur(new Color(9, 106, 9));
        }
        
    }

    public Color getCouleur() {
        return couleur;
    }

    private void setCouleur(Color couleur) {
        this.couleur = couleur;
    }

    @Override
    public String toString() {
        return statut;
    }
    
    
    
    
}
