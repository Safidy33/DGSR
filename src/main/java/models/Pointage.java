    package models; // Ou servlets, selon votre organisation

    import java.sql.Timestamp;

    public class Pointage {
        private Timestamp datePointage;
        private String type;
        private String nomPersonnel;
        private String prenomPersonnel;
        private String statut;

        // Getters et Setters
        public Timestamp getDatePointage() {
            return datePointage;
        }

        public void setDatePointage(Timestamp datePointage) {
            this.datePointage = datePointage;
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
    }
    