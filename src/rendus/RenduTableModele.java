/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package rendus;

import java.awt.Color;
import java.awt.Component;
import javax.swing.JLabel;
import javax.swing.JTable;
import javax.swing.table.TableCellRenderer;

/**
 *
 * @author delecourt
 */
public class RenduTableModele implements TableCellRenderer {

    @Override
    public Component getTableCellRendererComponent(JTable table, Object value, boolean isSelected, boolean hasFocus, int row, int column) {
         JLabel lab = new JLabel(value.toString());
        lab.setOpaque(true);
        if ( (row + column) % 2 == 0)
        {
            lab.setBackground(Color.LIGHT_GRAY);
        }
        else
        {
            lab.setBackground(Color.ORANGE);
        }
        return lab;
    }
}