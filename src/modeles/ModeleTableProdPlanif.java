/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package modeles;

import dao.ManagerLot;
import entite.Lot;
import java.util.ArrayList;
import javax.swing.JLabel;
import javax.swing.event.TableModelListener;
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
            case 5: return affich(liste.get(rowIndex).getLibelle());
            default: return affich(liste.get(rowIndex).getDateDeFabric());                 
           
    }
    } 

    @Override
    public String getColumnName(int column) {
        return listeColonne.get(column); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public void addTableModelListener(TableModelListener l) {
        super.addTableModelListener(l); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public boolean isCellEditable(int rowIndex, int columnIndex) {
        return columnIndex == 5 && ((String)getValueAt(rowIndex, 4)).startsWith("Lancé");
    }
    
    
    
    private Object affich(Object o)
    {
        if (o==null)
            return "";
        else
            return o;
    }
}
