/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package modeles;

import dao.ManagerLot;
import entite.Lot;
import java.util.ArrayList;
import javax.swing.table.AbstractTableModel;

/**
 *
 * @author bouyadel
 */
public class ModeleTableProdPlanif extends AbstractTableModel{
    
    ArrayList<Lot> liste = ManagerLot.listeProdPlanif();
    ArrayList<String> listeColonne = ManagerLot.ListeColonnesProdPlanif();

    @Override
    public int getRowCount() {
      return liste.size();     
    }

    @Override
    public int getColumnCount() {
        return listeColonne.size(); 
    }

    @Override
    public Object getValueAt(int rowIndex, int columnIndex) {
        switch(columnIndex)
        {
            case 0: return affich(liste.get(rowIndex).getNumLot());
            case 1: return affich(liste.get(rowIndex).getModele());
            case 2: return affich(liste.get(rowIndex).getNbPiecesDemandees());
            case 3: return affich(liste.get(rowIndex).getDateDePlanification());
            case 4: return affich(liste.get(rowIndex).getEtatDuLot());   
            case 5: return affich(liste.get(rowIndex).getTypeNumPresse());
            default: return affich(liste.get(rowIndex).getDateDeFabric());                 
           
    }
    } 
    
    private Object affich(Object o)
    {
        if (o==null)
            return "";
        else
            return o;
    }
}
