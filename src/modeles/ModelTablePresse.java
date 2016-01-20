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
 * @author delecourt
 */
public class ModelTablePresse extends AbstractTableModel{
 
 
    private final ArrayList<Machine> listePresse;
    private final ArrayList<String> listeColonne;

    public ModelTablePresse()
    {
        listePresse = ManagerMachine.listePresse();
        listeColonne = ManagerMachine.ListeColonnesPresse();
    }
    
    @Override
    public int getRowCount()
    {
        return listePresse.size();
    }

    @Override
    public int getColumnCount()
    {
        return listeColonne.size();
    }

    @Override
    public Object getValueAt(int rowIndex, int columnIndex) {
        Machine mac = listePresse.get(rowIndex);
        switch (columnIndex)
        {
            case 0 : return mac.getLibelle();       
            case 1 : return mac.getEtat();
                
            //Ne doit pas être nul car on ne peut pas ajouter un objet null
            default : return mac.getProdPrec();
        }
    }

    @Override
    public String getColumnName(int column)
    {

        return listeColonne.get(column);
    }
}