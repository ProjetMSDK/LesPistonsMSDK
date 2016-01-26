/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package modeles;

/**
 *
 * @author delecourt
 */

    

import dao.ManagerMachine;
import entite.Machine;
import java.util.ArrayList;
import javax.swing.table.AbstractTableModel;



public class ModelTableMachines extends AbstractTableModel{
/**
 *
 * @author delecourt
 */
 
 
    private ArrayList<Machine> listeMachines;
    private ArrayList<String> listeColonne;

    public ModelTableMachines()
    {
        listeMachines = ManagerMachine.listeMachine();
        listeColonne = ManagerMachine.ListeColonnesMachine();       
    }
    
    @Override
    public int getRowCount()
    {
        return listeMachines.size();
    }

    @Override
    public int getColumnCount()
    {
        return listeColonne.size();
    }

    @Override
    public Object getValueAt(int rowIndex, int columnIndex) {
        Machine mac = listeMachines.get(rowIndex);
        switch (columnIndex)
        {
            case 0 : return mac.getNumPresse(); 
            case 1 : return mac.getLibelle();
            case 2 : return mac.getEtatPresse();  
            
            //Ne doit pas être nul car on ne peut pas ajouter un objet null
            default : return "";
        }
    }

    @Override
    public String getColumnName(int column)
    {

        return listeColonne.get(column);
    }

    
}
