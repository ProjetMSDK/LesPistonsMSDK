/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package modeles;

import dao.ManagerStock;
import entite.Stock;
import java.util.ArrayList;
import javax.swing.table.AbstractTableModel;

/**
 *
 * @author bouyadel
 */
public class ModeleTableStock extends AbstractTableModel{
    
    ArrayList<Stock> liste = ManagerStock.listeStock();
    ArrayList<String> listeColonne = ManagerStock.ListeColonnesStock();
    

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
            case 1: return liste.get(rowIndex).getNomCategorie();
            default: return liste.get(rowIndex).getQuantite();
        }
    }
    
     @Override
    public String getColumnName(int column) {
        return listeColonne.get(column); //To change body of generated methods, choose Tools | Templates.
    }
}
