/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package modeles;

import dao.ManagerLot;
import entite.Lot;
import java.util.ArrayList;
import javax.swing.AbstractListModel;
import javax.swing.ComboBoxModel;

/**
 *
 * @author bouyadel
 */
public class ModeleComboLotProd extends AbstractListModel<Lot> implements ComboBoxModel<Lot>
{
    private final ArrayList<Lot> liste;
    private Lot selection = null;
    
    public ModeleComboLotProd()
    {
        liste = ManagerLot.listeLotProd();
    }
    
    @Override
    public void setSelectedItem(Object anItem)
    {
        selection = (Lot) anItem ; //to select and register an item from the pull-down
        //list
    }
        
    //Méthode implémentée de l'interface ComboBoxModel
    @Override
    public Object getSelectedItem()
    {
        return selection;
    }
    
    @Override
    public int getSize()
    {
        return liste.size();
    }
    
    @Override
    public Lot getElementAt(int index)
    {
        return liste.get(index);
    }  
}

    

