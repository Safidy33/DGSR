package models;

import java.sql.Date;

public class HeureDeTravail {
    private String nomComplet;
    private Date dateTravail;
    private String heures; // Utilisé pour afficher les heures selon le contexte

    public HeureDeTravail(String nomComplet, Date dateTravail, String heures) {
        this.nomComplet = nomComplet;
        this.dateTravail = dateTravail;
        this.heures = heures;
    }

    public String getNomComplet() { return nomComplet; }
    public Date getDateTravail() { return dateTravail; }
    public String getHeures() { return heures; }
}
