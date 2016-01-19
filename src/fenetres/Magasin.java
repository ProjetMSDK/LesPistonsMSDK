/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package fenetres;

import entite.Modele;
import javax.swing.JFrame;
import modeles.ModelComboModeleMagasin;
import rendus.RenduComboModeleMagasin;

/**
 *
 * @author benosmane
 */
public class Magasin extends javax.swing.JFrame {

    /**
     * Creates new form Enregistrement
     */
     private String tailleModele;
     
    public Magasin() {
        initComponents();
        
        setVisible(true);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setLocationRelativeTo(null);
       
                
    }

    /**
     * This method is called from within the constructor to initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is always
     * regenerated by the Form Editor.
     */
    @SuppressWarnings("unchecked")
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        bouttonQuiter = new javax.swing.JButton();
        jLabel4 = new javax.swing.JLabel();
        jPanel1 = new javax.swing.JPanel();
        jLabel2 = new javax.swing.JLabel();
        jLabel1 = new javax.swing.JLabel();
        saisieQuantite = new javax.swing.JTextField();
        jPanel2 = new javax.swing.JPanel();
        bouttonEntree = new javax.swing.JButton();
        bouttonSortie = new javax.swing.JButton();
        boutonPetit = new javax.swing.JButton();
        bouttonMoyen = new javax.swing.JButton();
        bouttonGrand = new javax.swing.JButton();
        Combo_modele = new javax.swing.JComboBox();
        bouttonStock = new javax.swing.JButton();
        barStatusMagasin = new javax.swing.JLabel();

        setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE);

        bouttonQuiter.setText("Quitter");
        bouttonQuiter.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                bouttonQuiterActionPerformed(evt);
            }
        });

        jLabel4.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jLabel4.setText("MAGASIN");
        jLabel4.setBorder(javax.swing.BorderFactory.createTitledBorder(""));
        jLabel4.setPreferredSize(new java.awt.Dimension(50, 30));

        jPanel1.setBorder(javax.swing.BorderFactory.createBevelBorder(javax.swing.border.BevelBorder.RAISED));

        jLabel2.setText("Modèle");

        jLabel1.setText("Nombre de Caisses");

        saisieQuantite.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                saisieQuantiteMouseClicked(evt);
            }
        });
        saisieQuantite.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                saisieQuantiteActionPerformed(evt);
            }
        });

        bouttonEntree.setText("Entrée");
        bouttonEntree.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                bouttonEntreeMouseClicked(evt);
            }
        });
        bouttonEntree.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                bouttonEntreeActionPerformed(evt);
            }
        });

        bouttonSortie.setText("Sortie");
        bouttonSortie.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                bouttonSortieActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel2Layout = new javax.swing.GroupLayout(jPanel2);
        jPanel2.setLayout(jPanel2Layout);
        jPanel2Layout.setHorizontalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel2Layout.createSequentialGroup()
                .addGap(42, 42, 42)
                .addComponent(bouttonEntree)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, 67, Short.MAX_VALUE)
                .addComponent(bouttonSortie, javax.swing.GroupLayout.PREFERRED_SIZE, 69, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(32, 32, 32))
        );

        jPanel2Layout.linkSize(javax.swing.SwingConstants.HORIZONTAL, new java.awt.Component[] {bouttonEntree, bouttonSortie});

        jPanel2Layout.setVerticalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel2Layout.createSequentialGroup()
                .addContainerGap(34, Short.MAX_VALUE)
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(bouttonEntree)
                    .addComponent(bouttonSortie))
                .addGap(40, 40, 40))
        );

        boutonPetit.setBackground(new java.awt.Color(0, 204, 153));
        boutonPetit.setText("Petit");
        boutonPetit.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                boutonPetitMouseClicked(evt);
            }
        });

        bouttonMoyen.setBackground(new java.awt.Color(153, 0, 0));
        bouttonMoyen.setText("Moyen");
        bouttonMoyen.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                bouttonMoyenMouseClicked(evt);
            }
        });

        bouttonGrand.setBackground(new java.awt.Color(204, 204, 0));
        bouttonGrand.setText("Grand");
        bouttonGrand.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                bouttonGrandMouseClicked(evt);
            }
        });

        Combo_modele.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "  ", "Mod1", "mod2", "mod3", "mod4" }));
        Combo_modele.setModel(new ModelComboModeleMagasin());
        Combo_modele.setRenderer(new RenduComboModeleMagasin());
        Combo_modele.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                Combo_modeleActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel1Layout = new javax.swing.GroupLayout(jPanel1);
        jPanel1.setLayout(jPanel1Layout);
        jPanel1Layout.setHorizontalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                    .addComponent(jPanel2, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(javax.swing.GroupLayout.Alignment.LEADING, jPanel1Layout.createSequentialGroup()
                        .addContainerGap()
                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                            .addGroup(jPanel1Layout.createSequentialGroup()
                                .addComponent(jLabel1)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                .addComponent(saisieQuantite, javax.swing.GroupLayout.PREFERRED_SIZE, 61, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addGroup(jPanel1Layout.createSequentialGroup()
                                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(boutonPetit)
                                    .addComponent(jLabel2))
                                .addGap(43, 43, 43)
                                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addGroup(jPanel1Layout.createSequentialGroup()
                                        .addComponent(bouttonMoyen)
                                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                        .addComponent(bouttonGrand))
                                    .addGroup(jPanel1Layout.createSequentialGroup()
                                        .addComponent(Combo_modele, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                                        .addGap(0, 0, Short.MAX_VALUE)))))))
                .addContainerGap(11, Short.MAX_VALUE))
        );

        jPanel1Layout.linkSize(javax.swing.SwingConstants.HORIZONTAL, new java.awt.Component[] {boutonPetit, bouttonGrand});

        jPanel1Layout.setVerticalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel2)
                    .addComponent(Combo_modele, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(40, 40, 40)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(bouttonMoyen)
                    .addComponent(boutonPetit)
                    .addComponent(bouttonGrand))
                .addGap(29, 29, 29)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel1)
                    .addComponent(saisieQuantite, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jPanel2, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(23, Short.MAX_VALUE))
        );

        bouttonStock.setText("Stock");
        bouttonStock.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseClicked(java.awt.event.MouseEvent evt) {
                bouttonStockMouseClicked(evt);
            }
        });

        barStatusMagasin.setText("Status Bar");
        barStatusMagasin.setBorder(javax.swing.BorderFactory.createEtchedBorder());

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(barStatusMagasin, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
            .addGroup(layout.createSequentialGroup()
                .addGap(33, 33, 33)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(layout.createSequentialGroup()
                        .addGap(0, 0, Short.MAX_VALUE)
                        .addComponent(bouttonQuiter))
                    .addGroup(layout.createSequentialGroup()
                        .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(bouttonStock, javax.swing.GroupLayout.PREFERRED_SIZE, 74, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jPanel1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addGap(0, 14, Short.MAX_VALUE)))
                .addContainerGap())
            .addComponent(jLabel4, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addComponent(jLabel4, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(29, 29, 29)
                .addComponent(jPanel1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(18, 18, 18)
                .addComponent(bouttonStock)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addComponent(bouttonQuiter)
                .addGap(10, 10, 10)
                .addComponent(barStatusMagasin))
        );

        pack();
    }// </editor-fold>//GEN-END:initComponents

    private void saisieQuantiteActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_saisieQuantiteActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_saisieQuantiteActionPerformed

    private void Combo_modeleActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_Combo_modeleActionPerformed
      
    }//GEN-LAST:event_Combo_modeleActionPerformed

    private void bouttonQuiterActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_bouttonQuiterActionPerformed
        System.exit(0);
        
    }//GEN-LAST:event_bouttonQuiterActionPerformed

    private void saisieQuantiteMouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_saisieQuantiteMouseClicked
 //jTextField1.setText("");
    }//GEN-LAST:event_saisieQuantiteMouseClicked

    private void boutonPetitMouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_boutonPetitMouseClicked
        tailleModele = "Petit";
        System.out.println(tailleModele);
    }//GEN-LAST:event_boutonPetitMouseClicked

    private void bouttonMoyenMouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_bouttonMoyenMouseClicked
        tailleModele = "Moyen";
        System.out.println(tailleModele);
    }//GEN-LAST:event_bouttonMoyenMouseClicked

    private void bouttonGrandMouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_bouttonGrandMouseClicked
    tailleModele = "Grand";
    System.out.println(tailleModele);
    }//GEN-LAST:event_bouttonGrandMouseClicked

    private void bouttonStockMouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_bouttonStockMouseClicked
        new Stocks().setVisible(true);
    }//GEN-LAST:event_bouttonStockMouseClicked

    private void bouttonEntreeMouseClicked(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_bouttonEntreeMouseClicked
        
        
        
        
                
    }//GEN-LAST:event_bouttonEntreeMouseClicked

    private void bouttonEntreeActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_bouttonEntreeActionPerformed
        
       String modele= ((Modele)Combo_modele.getSelectedItem()).getModele();
       int quantite = (int) Integer.parseInt(saisieQuantite.getText());
       dao.ManagerMagasin.entreecaisse(modele, tailleModele, quantite);
       saisieQuantite.setText("");
       barStatusMagasin.setText(tailleModele+", "+modele+" , "+quantite);
        
    }//GEN-LAST:event_bouttonEntreeActionPerformed

    private void bouttonSortieActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_bouttonSortieActionPerformed
        String modele= (String)Combo_modele.getSelectedItem().toString();
       int quantite = (int) Integer.parseInt(saisieQuantite.getText());
       dao.ManagerMagasin.sortieCaisse(modele, tailleModele, quantite);
       saisieQuantite.setText("");
    }//GEN-LAST:event_bouttonSortieActionPerformed

    /**
     * @param args the command line arguments
     */
    public static void main(String args[]) {
        /* Set the Nimbus look and feel */
        //<editor-fold defaultstate="collapsed" desc=" Look and feel setting code (optional) ">
        /* If Nimbus (introduced in Java SE 6) is not available, stay with the default look and feel.
         * For details see http://download.oracle.com/javase/tutorial/uiswing/lookandfeel/plaf.html 
         */
        try {
            for (javax.swing.UIManager.LookAndFeelInfo info : javax.swing.UIManager.getInstalledLookAndFeels()) {
                if ("Nimbus".equals(info.getName())) {
                    javax.swing.UIManager.setLookAndFeel(info.getClassName());
                    break;
                }
            }
        } catch (ClassNotFoundException ex) {
            java.util.logging.Logger.getLogger(Magasin.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (InstantiationException ex) {
            java.util.logging.Logger.getLogger(Magasin.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (IllegalAccessException ex) {
            java.util.logging.Logger.getLogger(Magasin.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (javax.swing.UnsupportedLookAndFeelException ex) {
            java.util.logging.Logger.getLogger(Magasin.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        }
        //</editor-fold>
        //</editor-fold>

        /* Create and display the form */
        java.awt.EventQueue.invokeLater(new Runnable() {
            public void run() {
                new Magasin().setVisible(true);
            }
        });
    }

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JComboBox Combo_modele;
    private javax.swing.JLabel barStatusMagasin;
    private javax.swing.JButton boutonPetit;
    private javax.swing.JButton bouttonEntree;
    private javax.swing.JButton bouttonGrand;
    private javax.swing.JButton bouttonMoyen;
    private javax.swing.JButton bouttonQuiter;
    private javax.swing.JButton bouttonSortie;
    private javax.swing.JButton bouttonStock;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JLabel jLabel2;
    private javax.swing.JLabel jLabel4;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JPanel jPanel2;
    private javax.swing.JTextField saisieQuantite;
    // End of variables declaration//GEN-END:variables
}
