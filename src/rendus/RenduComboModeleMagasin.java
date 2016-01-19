/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package rendus;

import entite.Modele;
import java.awt.Color;
import java.awt.Component;
import javax.swing.JLabel;
import javax.swing.JList;
import javax.swing.ListCellRenderer;

/**
 *
 * @author benosmane
 */
public class RenduComboModeleMagasin implements ListCellRenderer<Modele> {
    



 
    
    
    @Override
    public Component getListCellRendererComponent(JList<? extends Modele> list, Modele value, int index, boolean isSelected, boolean cellHasFocus) {
        if ( value != null)
        {    
            JLabel lab = new JLabel("" + value.getModele());
            lab.setOpaque(true);
        if ( index % 2 == 0)
            lab.setBackground(Color.RED);
        else
            lab.setBackground(Color.GREEN);
        return lab;
        }
        else
            return new JLabel("");
    }
    
    
}