/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package modeles;

import dao.ManagerModele;
import entite.Modele;
import java.util.ArrayList;
import javax.swing.table.AbstractTableModel;

/**
 *
 * @author delecourt
 */
public class ModelTableModele extends AbstractTableModel{
 
 
    private final ArrayList<Modele> listeModeles;
    private final ArrayList<String> listeColonne;

    public ModelTableModele()
    {
        listeModeles = ManagerModele.listeModeles();
        listeColonne = ManagerModele.columnModeles();       
    }
    
    @Override
    public int getRowCount()
    {
        return listeModeles.size();
    }

    @Override
    public int getColumnCount()
    {
        return listeColonne.size();
    }

    @Override
    public Object getValueAt(int rowIndex, int columnIndex) {
        Modele mod = listeModeles.get(rowIndex);
        switch (columnIndex)
        {
            case 0 : return mod.getModele();       
            
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
