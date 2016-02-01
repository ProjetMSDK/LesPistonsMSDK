/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package fenetres;


import entite.MessageStatut;
import java.awt.event.KeyEvent;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.sql.SQLException;
import javax.swing.JOptionPane;
import outils.Connexion;
import outils.OutilsAlpha;

/**
 *
 * @author benosmane
 */
public class Accueil extends javax.swing.JFrame {

    
/*

exec sp_adduser benosmane, responsablePlanif;
exec sp_adduser bouyadel, responsableProd;
exec sp_adduser delecourt, responsableControle;
exec sp_adduser addaboudjellal, responsableApplication
exec sp_adduser bublex, responsableQualite;

exec sp_addrolemember 'db_owner', responsablePlanif;
go
exec sp_addrolemember 'db_owner', responsableProd;
go
exec sp_addrolemember 'db_owner', responsableControle;
go
exec sp_addrolemember 'db_owner', responsableApplication;
go
exec sp_addrolemember 'db_owner', responsableQualité;
go
exec sp_addrolemember 'db_owner', responsableGestion;
go
    */
    
    /*
    private final String RESPONSABLEAPP = "AdminBJava";
    private final String RESPONSABLEATELIER ="JavaUser2";
    private final String RESPONSABLEGESTION ="JavaUser1";
    private final String RESPONSABLEMAGASIN = "JavaUser5";
    private final String RESPONSABLECONTROLE = "JavaUser4";
    private final String RESPONSABLEPROD = "JavaUser3";
    private final String RESPONSABLEQUALITE = "JavaUser6";
    */
    private MessageStatut statut;
    
    private final String RESPONSABLEAPP = "mayer";
    private final String RESPONSABLEGESTION ="benosmane";
    private final String RESPONSABLEMAGASIN = "bouyadel";
    private final String RESPONSABLECONTROLE = "mayer2";
    private final String RESPONSABLEPROD = "bublex";
    private final String RESPONSABLEQUALITE = "addaboudjellal";
    private final String RESPONSABLEATELIER ="delecourt";
    
    
    /*
    private final String roleRespMagasin = "bouyadel";
    private final String roleRespControl = "responsableControle";
    */
    /**
     * Creates new form Accueil
     */
    public Accueil() {
        initComponents();
        
        setVisible(true);
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

        jLabel1 = new javax.swing.JLabel();
        jPanel1 = new javax.swing.JPanel();
        barStatusLogin = new javax.swing.JLabel();
        jLabel4 = new javax.swing.JLabel();
        jLabel16 = new javax.swing.JLabel();
        jPanel2 = new javax.swing.JPanel();
        jButton2 = new javax.swing.JButton();
        jtPassword = new javax.swing.JPasswordField();
        jLabel2 = new javax.swing.JLabel();
        jtLogUser = new javax.swing.JTextField();
        jLabel3 = new javax.swing.JLabel();
        jPanel3 = new javax.swing.JPanel();
        jButton1 = new javax.swing.JButton();

        jLabel1.setBackground(new java.awt.Color(202, 217, 230));
        jLabel1.setFont(new java.awt.Font("Monospaced", 3, 14)); // NOI18N
        jLabel1.setForeground(new java.awt.Color(0, 102, 255));
        jLabel1.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jLabel1.setText("ACCUEIL");
        jLabel1.setBorder(javax.swing.BorderFactory.createEtchedBorder(javax.swing.border.EtchedBorder.RAISED));
        jLabel1.setDoubleBuffered(true);
        jLabel1.setHorizontalTextPosition(javax.swing.SwingConstants.CENTER);
        jLabel1.setOpaque(true);

        setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE);
        setBackground(new java.awt.Color(202, 217, 230));

        jPanel1.setBorder(javax.swing.BorderFactory.createBevelBorder(javax.swing.border.BevelBorder.RAISED));
        jPanel1.setAutoscrolls(true);

        barStatusLogin.setText(" ");
        barStatusLogin.setBorder(javax.swing.BorderFactory.createEtchedBorder());

        jLabel4.setBackground(new java.awt.Color(204, 255, 204));
        jLabel4.setFont(new java.awt.Font("Aharoni", 1, 18)); // NOI18N
        jLabel4.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jLabel4.setText("ACCUEIL");
        jLabel4.setBorder(javax.swing.BorderFactory.createTitledBorder(""));
        jLabel4.setPreferredSize(new java.awt.Dimension(44, 30));

        jLabel16.setBackground(new java.awt.Color(202, 217, 230));
        jLabel16.setFont(new java.awt.Font("Arabic Typesetting", 3, 24)); // NOI18N
        jLabel16.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jLabel16.setText("Bretagne Ouest Unité Moteurs");
        jLabel16.setOpaque(true);

        jPanel2.setBackground(new java.awt.Color(202, 217, 230));
        jPanel2.setBorder(javax.swing.BorderFactory.createEtchedBorder());

        jButton2.setText("Valider");
        jButton2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton2ActionPerformed(evt);
            }
        });

        jtPassword.setText("developpeur");
        jtPassword.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jtPasswordActionPerformed(evt);
            }
        });
        jtPassword.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyTyped(java.awt.event.KeyEvent evt) {
                jtPasswordKeyTyped(evt);
            }
        });

        jLabel2.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jLabel2.setText("Login");

        jtLogUser.setText("mayer");
        jtLogUser.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jtLogUserActionPerformed(evt);
            }
        });

        jLabel3.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jLabel3.setText("Password");

        javax.swing.GroupLayout jPanel2Layout = new javax.swing.GroupLayout(jPanel2);
        jPanel2.setLayout(jPanel2Layout);
        jPanel2Layout.setHorizontalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel2Layout.createSequentialGroup()
                .addGap(100, 100, 100)
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.CENTER)
                    .addComponent(jButton2, javax.swing.GroupLayout.PREFERRED_SIZE, 111, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jtLogUser, javax.swing.GroupLayout.PREFERRED_SIZE, 111, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel3, javax.swing.GroupLayout.PREFERRED_SIZE, 71, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jtPassword, javax.swing.GroupLayout.PREFERRED_SIZE, 111, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel2, javax.swing.GroupLayout.PREFERRED_SIZE, 65, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(100, 100, 100))
        );

        jPanel2Layout.linkSize(javax.swing.SwingConstants.HORIZONTAL, new java.awt.Component[] {jButton2, jLabel2, jLabel3, jtLogUser, jtPassword});

        jPanel2Layout.setVerticalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel2Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jLabel2, javax.swing.GroupLayout.PREFERRED_SIZE, 26, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(18, 18, 18)
                .addComponent(jtLogUser, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(27, 27, 27)
                .addComponent(jLabel3, javax.swing.GroupLayout.PREFERRED_SIZE, 14, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jtPassword, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(28, 28, 28)
                .addComponent(jButton2)
                .addContainerGap(52, Short.MAX_VALUE))
        );

        jPanel2Layout.linkSize(javax.swing.SwingConstants.VERTICAL, new java.awt.Component[] {jButton2, jLabel2, jLabel3, jtLogUser, jtPassword});

        jButton1.setText("Quitter");
        jButton1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton1ActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel3Layout = new javax.swing.GroupLayout(jPanel3);
        jPanel3.setLayout(jPanel3Layout);
        jPanel3Layout.setHorizontalGroup(
            jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel3Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jButton1)
                .addContainerGap())
        );
        jPanel3Layout.setVerticalGroup(
            jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel3Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jButton1)
                .addContainerGap())
        );

        javax.swing.GroupLayout jPanel1Layout = new javax.swing.GroupLayout(jPanel1);
        jPanel1.setLayout(jPanel1Layout);
        jPanel1Layout.setHorizontalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.CENTER, jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.CENTER)
                .addComponent(jLabel16, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addComponent(jPanel2, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
            .addComponent(jLabel4, javax.swing.GroupLayout.Alignment.CENTER, javax.swing.GroupLayout.DEFAULT_SIZE, 499, Short.MAX_VALUE)
            .addComponent(barStatusLogin, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addContainerGap(412, Short.MAX_VALUE)
                .addComponent(jPanel3, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
        );
        jPanel1Layout.setVerticalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addComponent(jLabel4, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addComponent(jLabel16, javax.swing.GroupLayout.PREFERRED_SIZE, 44, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jPanel2, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, 46, Short.MAX_VALUE)
                .addComponent(jPanel3, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(barStatusLogin))
        );

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jPanel1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jPanel1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );

        pack();
    }// </editor-fold>//GEN-END:initComponents

    private void connecter(String login, String pass)
    {
        try
            {
                if(Connexion.getInstance(login, pass).getConn().isValid(5))
                {

                    //Thread.sleep(500);
                    statut = new MessageStatut("Connexion réussie");
                    barStatusLogin.setForeground(statut.getCouleur());
                    barStatusLogin.setText(statut.toString());
                    
                    
                    //Thread.sleep(5000);
                    switch (login)
                    {
                        case RESPONSABLEAPP :  RespApp rApp = new RespApp();
                                            rApp.addWindowListener(new EcouteFenetre());
                                            setVisible(false);
                                           
                                                break;
                    case RESPONSABLEATELIER : Planification1 plan = new Planification1();
                                               plan.addWindowListener(new EcouteFenetre());
                                               setVisible(false);
                                                break;
                    case RESPONSABLEMAGASIN : Magasin mag = new Magasin();
                                                mag.addWindowListener(new EcouteFenetre());
                                               setVisible(false);
                                                break;
                    case RESPONSABLECONTROLE : Controle contr = new Controle();
                                                contr.addWindowListener(new EcouteFenetre());
                                               setVisible(false);
                                                break;
                    case RESPONSABLEPROD : Production1 prod = new Production1();
                                            prod.addWindowListener(new EcouteFenetre());
                                               setVisible(false);
                                               break;
                    case RESPONSABLEGESTION : GestionBis gest = new GestionBis();
                                            gest.addWindowListener(new EcouteFenetre());
                                               setVisible(false);
                                               break;
                    case RESPONSABLEQUALITE : StatistiquesReduites stats = new StatistiquesReduites();
                                            stats.addWindowListener(new EcouteFenetre());
                                               setVisible(false);
                                               break;
                    
                    default : StatistiquesReduites stats2 = new StatistiquesReduites();
                       stats2.addWindowListener(new EcouteFenetre());
                          setVisible(false);
                          break;
                    }

                    setVisible(false);
                }
                else
                {
                    JOptionPane.showMessageDialog(null, "Échec de l'ouverture de session de l'utilisateur " + login +
                        ". \nVeuillez vérifier vos identifiants.", "Echec de Connexion", JOptionPane.ERROR_MESSAGE);
                    statut = new MessageStatut("Erreur : Echec de Connexion");
                    barStatusLogin.setForeground(statut.getCouleur());  
                    barStatusLogin.setText(statut.toString());
                }
        }
        catch(Exception e)
        {

            JOptionPane.showMessageDialog(null, "Échec de l'ouverture de session de l'utilisateur " + login +
                    ". \nVeuillez vérifier vos identifiants.", "Echec de Connexion", JOptionPane.ERROR_MESSAGE);
            statut = new MessageStatut("Erreur : Echec de Connexion");
            barStatusLogin.setForeground(statut.getCouleur());  
            barStatusLogin.setText(statut.toString());

        }
    }
    private boolean verifierChamps()
    {
        boolean champsOk = false;
        if(jtLogUser.getText().trim().isEmpty())
        {
            JOptionPane.showMessageDialog(null, "Veuillez entrer un nom d'utilisateur", "Nom d'utilisateur", JOptionPane.ERROR_MESSAGE);
            statut = new MessageStatut("Erreur : Champ nom utilisateur vide");
            barStatusLogin.setForeground(statut.getCouleur());
            barStatusLogin.setText(statut.toString());
            
        }
        else if (jtPassword.getText().trim().isEmpty())
        {
            JOptionPane.showMessageDialog(null, "Veuillez entrer votre mot de passe", "Mot de passe", JOptionPane.ERROR_MESSAGE);
            statut = new MessageStatut("Erreur : Champ mot de passe vide");
            barStatusLogin.setForeground(statut.getCouleur());
            barStatusLogin.setText(statut.toString());
        }
        else if(!OutilsAlpha.estAlphaNum(jtLogUser.getText().trim()))
        {
            JOptionPane.showMessageDialog(null, "Format nom utilisateur non valide", "Erreur Format Nom d'utilisateur", JOptionPane.ERROR_MESSAGE);
            statut = new MessageStatut("Erreur : Format nom utilisateur non valide");
            barStatusLogin.setForeground(statut.getCouleur());
            barStatusLogin.setText(statut.toString());
        }
        else champsOk = true;
        
        return champsOk;
    
    }
    private void jButton1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton1ActionPerformed

        if(JOptionPane.showConfirmDialog(this,
             "Quitter?", 
             "Confirmation",
             JOptionPane.OK_CANCEL_OPTION) == JOptionPane.OK_OPTION)
        {
            System.exit(0);
        }
    }//GEN-LAST:event_jButton1ActionPerformed

    private void jButton2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton2ActionPerformed
        
        if (verifierChamps())
        
        {
            connecter(jtLogUser.getText(), jtPassword.getText());
             
        }
    }//GEN-LAST:event_jButton2ActionPerformed

    private void jtLogUserActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jtLogUserActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_jtLogUserActionPerformed

    private void jtPasswordActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jtPasswordActionPerformed
        // TODO add your handling code here:
    }//GEN-LAST:event_jtPasswordActionPerformed

    private void jtPasswordKeyTyped(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_jtPasswordKeyTyped
       if (evt.getKeyCode() == KeyEvent.VK_ENTER)
       {
           if (verifierChamps())
           connecter(jtLogUser.getText(), jtPassword.getText());
       }
           
    }//GEN-LAST:event_jtPasswordKeyTyped

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
            java.util.logging.Logger.getLogger(Accueil.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (InstantiationException ex) {
            java.util.logging.Logger.getLogger(Accueil.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (IllegalAccessException ex) {
            java.util.logging.Logger.getLogger(Accueil.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        } catch (javax.swing.UnsupportedLookAndFeelException ex) {
            java.util.logging.Logger.getLogger(Accueil.class.getName()).log(java.util.logging.Level.SEVERE, null, ex);
        }
        //</editor-fold>

        /* Create and display the form */
        java.awt.EventQueue.invokeLater(new Runnable() {
            public void run() {
                new Accueil().setVisible(true);
            }
        });
    }
    class EcouteFenetre extends WindowAdapter
    {

                
        @Override
        public void windowClosed(WindowEvent e) {
            Accueil.this.setVisible(true);
        }
        
    }

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JLabel barStatusLogin;
    private javax.swing.JButton jButton1;
    private javax.swing.JButton jButton2;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JLabel jLabel16;
    private javax.swing.JLabel jLabel2;
    private javax.swing.JLabel jLabel3;
    private javax.swing.JLabel jLabel4;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JPanel jPanel2;
    private javax.swing.JPanel jPanel3;
    private javax.swing.JTextField jtLogUser;
    private javax.swing.JPasswordField jtPassword;
    // End of variables declaration//GEN-END:variables
}
