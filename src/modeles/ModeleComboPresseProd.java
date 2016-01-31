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
 * Ce modèle de comboBox est utilisé dans le tableau des lots de la fenêtre
 * Production. Les machines sont ici identifiées par leur libellé, 
 * contenus sous forme de String.
 * 
 * @author bouyadel
 */
public class ModeleComboPresseProd extends AbstractListModel<String> implements ComboBoxModel<String>
{
    private final ArrayList<String> liste;
    private String selection = null;
    
    public ModeleComboPresseProd()
    {
        liste = ManagerMachine.listeMachineDispo();
    }
    
    @Override
    public void setSelectedItem(Object anItem)
    {
        selection = (String) anItem ; 
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
    public String getElementAt(int index)
    {
        return liste.get(index);
    }  

    
}
    

