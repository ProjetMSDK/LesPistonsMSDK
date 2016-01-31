/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package rendus;

import java.awt.Color;
import java.awt.Component;
import javax.swing.DefaultCellEditor;
import javax.swing.JComboBox;

import javax.swing.JLabel;
import javax.swing.JTable;
import javax.swing.table.TableCellRenderer;
import modeles.ModeleComboPresseProd;
import modeles.ModeleTableProdPlanif;

/**
 *
 * @author bouyadel
 */
public class RenduTableProdPlanif implements TableCellRenderer{

    @Override
    public Component getTableCellRendererComponent(JTable table, Object value, boolean isSelected, boolean hasFocus, int row, int column) {
        
        Component comp;
        
        switch(column)
        {
            case 5 : // colonne des presses
                
                ModeleTableProdPlanif mod = (ModeleTableProdPlanif) table.getModel();
                if(((String)mod.getValueAt(row, 4)).startsWith("Lancé"))
                {
                    comp = new JComboBox();
                    ((JComboBox)comp).setModel(new ModeleComboPresseProd());
                    ((JComboBox)comp).setRenderer(new RenduComboPresseProd());
                    ((JComboBox)comp).setSelectedItem(value);
                    table.getColumn("PRESSE").setCellEditor(
                            new DefaultCellEditor((JComboBox) comp));
                }
                else
                {
                    comp = new JLabel(value.toString());
                    ((JLabel)comp).setOpaque(true);
                    
                    if ( (row) % 2 == 0)
                    {
                        ((JLabel)comp).setBackground(Color.LIGHT_GRAY);
                    }
                    else
                    {
                        ((JLabel)comp).setBackground(Color.ORANGE);
                    } 
                }
                break;
            
            default : 
                comp = new JLabel(value.toString());
                    ((JLabel)comp).setOpaque(true);
                    
                    if ( (row) % 2 == 0)
                    {
                        ((JLabel)comp).setBackground(Color.LIGHT_GRAY);
                    }
                    else
                    {
                        ((JLabel)comp).setBackground(Color.ORANGE);
                    } 
                break;
         }
        return comp;
        
    }
}
