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
        
        ModeleTableProdPlanif mod = (ModeleTableProdPlanif) table.getModel();
        if(column == 5 && ((String)mod.getValueAt(row, 4)).startsWith("Lancé"))
        {
            JComboBox comboTabPresse = new JComboBox();
            comboTabPresse.setModel(new ModeleComboPresseProd());
            comboTabPresse.setRenderer(new RenduComboPresseProd());
            ((JComboBox<String>)comboTabPresse).setSelectedItem(value);
            table.getColumn("PRESSE").setCellEditor(new DefaultCellEditor((JComboBox) comboTabPresse));
            
            return comboTabPresse;
        }
        else
        {
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
    
}
