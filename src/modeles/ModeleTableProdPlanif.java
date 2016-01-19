/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package modeles;

import dao.ManagerPlanification;
import entite.Lot;
import java.util.ArrayList;
import javax.swing.table.AbstractTableModel;

/**
 *
 * @author bouyadel
 */
public class ModeleTableProdPlanif extends AbstractTableModel{
    
    ArrayList<Lot> liste = ManagerPlanification.listeProdPlanif();
    ArrayList<String> listeColonne = ManagerPlanification.ListeColonnesProdPlanif();

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
            case 0: return liste.get(rowIndex).getNumLot();
            case 1: return liste.get(rowIndex).getModele();
            case 2: return liste.get(rowIndex).getNbPiecesDemandees();
            case 3: return liste.get(rowIndex).getTypeNumPresse();
            case 4: return liste.get(rowIndex).getDateDePlanification();
            case 5: return liste.get(rowIndex).getDateDeFabric();                   
            default: return liste.get(rowIndex).getEtatDuLot();                 
           
    }
    }
}
