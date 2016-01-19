/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package modeles;

import dao.ManagerMachine;
import entite.Machine;
import java.util.ArrayList;
import javax.swing.table.AbstractTableModel;

/**
 *
 * @author bouyadel
 */
public class ModeleTablePresse extends AbstractTableModel{
    
    
    ArrayList<Machine> liste = ManagerMachine.listeMachine();
    ArrayList<String> listeColonne = ManagerMachine.ListeColonnesMachine();

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
            case 0: return liste.get(rowIndex).getNumPresse();
            case 1: return liste.get(rowIndex).getLibelle(); 
            default: return liste.get(rowIndex).getEtatPresse();    
        }
    }
    
     @Override
    public String getColumnName(int column) {
        return listeColonne.get(column); //To change body of generated methods, choose Tools | Templates.
    }
    
}
