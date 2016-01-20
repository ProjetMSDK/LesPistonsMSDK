/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package modeles;


import dao.ManagerStats;
import entite.Lot;
import entite.Modele;
import entite.Statistique;
import java.util.ArrayList;
import javax.swing.table.AbstractTableModel;

/**
 *
 * @author mayer
 */
public class ModelTableStatsCumul extends AbstractTableModel{

    private ArrayList<Statistique> listeModeles;
    private ArrayList<String> listeColonne;

    public ModelTableStatsCumul(int numeroLot) {
        
        this.listeModeles = ManagerStats.ListeStatsCumul(new Lot(numeroLot));;
        
        listeColonne = new ArrayList();
        listeColonne.add("Catégorie");
        listeColonne.add("Quantités");
    }

    @Override
    public int getRowCount() {
        return listeModeles.size();
    }

    @Override
    public int getColumnCount() {
        return listeColonne.size();
    }

    @Override
    public Object getValueAt(int rowIndex, int columnIndex) {
        Statistique stat = listeModeles.get(rowIndex);
        switch (columnIndex)
        {
            case 0 : return affich(stat.getCategorie());
            case 1 : return affich(stat.getQuantite());
            
            //Ne doit pas être nul car on ne peut pas ajouter un objet null
            default : return "";
        }
    }
    
    @Override
    public String getColumnName(int column)
    {

        return listeColonne.get(column);
    }
    
    private Object affich(Object o)
    {
        if (o==null)
            return "";
        else
            return o;
    }
}
