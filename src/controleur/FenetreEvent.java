/*
 * Cette classe définit les évènements liés à l'ouverture ou la fermeture de la
 * fenêtre active.
 */
package controleur;

import java.util.EventObject;
import javax.swing.JFrame;

/**
 *
 * @author Daniel
 */
public class FenetreEvent extends EventObject {
    
    public FenetreEvent(JFrame source) {
        super(source);
    }
    
}
