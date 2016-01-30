/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package rendus;

import entite.Lot;
import java.awt.Color;
import java.awt.Component;
import javax.swing.JLabel;
import javax.swing.JList;
import javax.swing.ListCellRenderer;

/**
 *
 * @author mayer
 */
public class RenduComboLotControle implements ListCellRenderer<Lot> {
    
    
    @Override
    public Component getListCellRendererComponent(JList<? extends Lot> list, Lot value, int index, boolean isSelected, boolean cellHasFocus) {
        if ( value != null)
        {    
            JLabel lab = new JLabel("" + value.getNumLot());
            lab.setOpaque(true);
        if ( index % 2 == 0)
            lab.setBackground(Color.LIGHT_GRAY);
        else
            lab.setBackground(Color.ORANGE);
        return lab;
        }
        else
            return new JLabel("");
    }
    
    
}
