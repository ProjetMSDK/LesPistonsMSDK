/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package controleur;

import javax.swing.event.TableColumnModelListener;
import javax.swing.event.TableModelEvent;
import javax.swing.event.TableModelListener;
import modeles.ModeleTableProdPlanif;

/**
 *
 * @author Daniel
 */
public class EcouteurTableModeleProdPlanif implements TableModelListener {

    private ModeleTableProdPlanif mt;

    public EcouteurTableModeleProdPlanif(ModeleTableProdPlanif mt) {
        //on récupère le modèle de données, et on s'y abonne
        this.mt = mt;
        this.mt.addTableModelListener(this);
    }
    
    
    
    @Override
    public void tableChanged(TableModelEvent e) {
        
        if(e.getColumn() == 2) //si changement de l'état du lot
        {
            
        }
    }
    
}
