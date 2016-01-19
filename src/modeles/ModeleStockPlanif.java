/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package modeles;

import dao.ManagerPlanification;
import dao.ManagerStock;
import entite.Stock;
import java.util.ArrayList;
import javax.swing.table.AbstractTableModel;

/**
 *
 * @author bouyadel
 */
public class ModeleStockPlanif extends AbstractTableModel{    

    
    ArrayList<Stock> liste = ManagerPlanification.listeStockPlanif();
    ArrayList<String> listeColonne = ManagerPlanification.ListeColonnesStockPlanif();
    
    

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
            case 0: return liste.get(rowIndex).getModele();
            case 1: return liste.get(rowIndex).getQuantite();
            default: return liste.get(rowIndex).getSeuil();
        }
    }
    
     @Override
    public String getColumnName(int column) {
        return listeColonne.get(column); //To change body of generated methods, choose Tools | Templates.
    }
}
