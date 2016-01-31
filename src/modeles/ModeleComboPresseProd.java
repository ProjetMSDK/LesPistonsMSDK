/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package modeles;

import dao.ManagerMachine;
import entite.Machine;
import java.util.ArrayList;
import javax.swing.AbstractListModel;
import javax.swing.ComboBoxModel;

/**
 *
 * @author bouyadel
 */
public class ModeleComboPresseProd extends AbstractListModel<Machine> implements ComboBoxModel<Machine>
{
    private final ArrayList<Machine> liste;
    private Machine selection = null;
    
    public ModeleComboPresseProd()
    {
        liste = ManagerMachine.listeMachineDispo();
    }
    
    @Override
    public void setSelectedItem(Object anItem)
    {
        selection = (Machine) anItem ; //to select and register an item from the pull-down
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
    public Machine getElementAt(int index)
    {
        return liste.get(index);
    }  

    
}
    

