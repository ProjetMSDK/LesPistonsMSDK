/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package modeles;

import dao.ManagerStats;
import entite.Lot;
import entite.Statistique;
import java.util.ArrayList;
import javax.swing.table.AbstractTableModel;

/**
 *
 * @author mayer
 */
public class ModelTableStatsReduites extends AbstractTableModel{
    
    private ArrayList<Statistique> listeModeles;
    private ArrayList<String> listeColonne;
    //private int numLot;

    public ModelTableStatsReduites(int numeroLot)
    {
        listeModeles = ManagerStats.ListeStatsReduites(new Lot(numeroLot));
        listeColonne = ManagerStats.ListeColonnesStatsReduites();
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
        Statistique stat = listeModeles.get(rowIndex);
        switch (columnIndex)
        {
            case 0 : return stat.getTypeStat();
            case 1 : return stat.getDiametreHL();
            case 2 : return stat.getDiametreHT();
            case 3 : return stat.getDiametreBL();
            case 4 : return stat.getDiametreBT();
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
