/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package modeles;

import dao.ManagerModele;
import entite.Modele;
import java.util.ArrayList;
import javax.swing.AbstractListModel;
import javax.swing.ComboBoxModel;

/**
 *
 * @author bouyadel
 */
public class ModeleComboProdPlanif extends AbstractListModel<Modele> implements ComboBoxModel<Modele>
{

    private final ArrayList<Modele> liste;
    private Modele selection=null;
    
    public ModeleComboProdPlanif()
    {
        liste=ManagerModele.listeModeleMagasin();
    }
    
    @Override
    public int getSize() {
        return liste.size();
    }

    @Override
    public Modele getElementAt(int index) {
        return liste.get(index);
    }

    @Override
    public void setSelectedItem(Object anItem) {
        selection=(Modele)anItem;
    }

    @Override
    public Object getSelectedItem() {
        return selection;
    }
    
}
