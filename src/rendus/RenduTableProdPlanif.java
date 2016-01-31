/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package rendus;

import java.awt.Color;
import java.awt.Component;
import javax.swing.DefaultCellEditor;
import javax.swing.JButton;
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
        ModeleTableProdPlanif mod = (ModeleTableProdPlanif) table.getModel();
        // par défaut les cellules sont de simples JLabels :
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
        
        switch(column)
        {
            case 5 : // colonne des presses
                
                if(((String)mod.getValueAt(row, 4)).startsWith("Lancé"))
                {
                    comp = new JComboBox();
                    ((JComboBox)comp).setModel(new ModeleComboPresseProd());
                    ((JComboBox)comp).setRenderer(new RenduComboPresseProd());
                    ((JComboBox)comp).setSelectedItem(value);
                    table.getColumn("PRESSE").setCellEditor(
                            new DefaultCellEditor((JComboBox) comp));
                }
                
                break;
            
            case 7 : //colonne des boutons action
                if(((String)mod.getValueAt(row, 4)).startsWith("Lancé"))
                {
                    comp = new JButton("VALIDER");
                }
                else if (((String)mod.getValueAt(row, 4)).startsWith("Démarré"))
                {
                    comp = new JButton("SUSPENDRE");
                }
                else  if (((String)mod.getValueAt(row, 4)).startsWith("Suspendu"))
                {
                    comp = new JButton("REDEMARRER");
                }
                break;
                
            default : 
                
                break;
         }
        return comp;
        
    }
}
