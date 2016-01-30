package modeles;

import dao.*;
import entite.Modele;
import java.util.ArrayList;
import javax.swing.AbstractListModel;
import javax.swing.ComboBoxModel;

/**
 *
 * @author benosmane
 */
public class ModelComboModeleMagasin extends AbstractListModel<Modele> implements ComboBoxModel<Modele>
{
    
    private final ArrayList<Modele> liste;
    private Modele selection = null;

    public ModelComboModeleMagasin()
    {
        liste = ManagerModele.listeModeleMagasin();
        /*System.out.println("test ModelComboModeleMagasin");
        for(Modele m : liste)
        {
            System.out.println(m);
        }*/
    }

    @Override
    public int getSize() {
        return liste.size(); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public Modele getElementAt(int index) 
    {
        return liste.get(index); //To change body of generated methods, choose Tools | Templates.
    }

    @Override
    public void setSelectedItem(Object anItem) {
        selection = (Modele)anItem;
    }

    @Override
    public Object getSelectedItem() {
        return selection;
    }
}

