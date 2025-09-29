package models;

import java.sql.Timestamp;

public class Pointage {
    private Timestamp datePointage;   // Heure d'entrée
    private Timestamp dateSortie;     // Heure de sortie
    private String type;
    private String nomPersonnel;
    private String prenomPersonnel;
    private String statut;
    private String departement;
    private String localisation;

    // --- Getters et Setters ---
    public Timestamp getDatePointage() {
        return datePointage;
    }

    public void setDatePointage(Timestamp datePointage) {
        this.datePointage = datePointage;
    }

    public Timestamp getDateSortie() {
        return dateSortie;
    }

    public void setDateSortie(Timestamp dateSortie) {
        this.dateSortie = dateSortie;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getNomPersonnel() {
        return nomPersonnel;
    }

    public void setNomPersonnel(String nomPersonnel) {
        this.nomPersonnel = nomPersonnel;
    }

    public String getPrenomPersonnel() {
        return prenomPersonnel;
    }

    public void setPrenomPersonnel(String prenomPersonnel) {
        this.prenomPersonnel = prenomPersonnel;
    }

    public String getStatut() {
        return statut;
    }

    public void setStatut(String statut) {
        this.statut = statut;
    }

    public String getDepartement() {
        return departement;
    }

    public void setDepartement(String departement) {
        this.departement = departement;
    }

    public String getLocalisation() {
        return localisation;
    }

    public void setLocalisation(String localisation) {
        this.localisation = localisation;
    }

    // --- Constructeurs ---
    public Pointage() {}

    public Pointage(Timestamp datePointage, Timestamp dateSortie, String type,
                    String nomPersonnel, String prenomPersonnel,
                    String statut, String departement, String localisation) {
        this.datePointage = datePointage;
        this.dateSortie = dateSortie;
        this.type = type;
        this.nomPersonnel = nomPersonnel;
        this.prenomPersonnel = prenomPersonnel;
        this.statut = statut;
        this.departement = departement;
        this.localisation = localisation;
    }

}
