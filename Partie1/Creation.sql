DROP SCHEMA IF EXISTS partie1 CASCADE;
CREATE SCHEMA partie1; 
SET SCHEMA 'partie1';

CREATE TABLE _individu(
    id_individu INTEGER NOT NULL,
    nom VARCHAR(20) NOT NULL,
    prenom VARCHAR(20) NOT NULL,
    date_naissance DATE NOT NULL,
    code_postal VARCHAR(5) NOT NULL,
    ville VARCHAR(30) NOT NULL,
    sexe CHAR(1) NOT NULL,
    nationalite VARCHAR(20) NOT NULL,
    INE VARCHAR(11) NOT NULL,
    
    CONSTRAINT pk_individu PRIMARY KEY (id_individu)
);

CREATE TABLE _candidat (
    no_candidat INTEGER NOT NULL,
    id_individu INTEGER NOT NULL,
    classement VARCHAR(20),
    boursier_lycee VARCHAR(15) NOT NULL,
    profil_candidat VARCHAR(50) NOT NULL,
    etablissement VARCHAR(50) NOT NULL,
    dept_etablissement VARCHAR(50) NOT NULL,
    ville_etablissement VARCHAR(50) NOT NULL,
    niveau_etude VARCHAR(20) NOT NULL,
    type_formation VARCHAR(20) NOT NULL,
    serie_prec VARCHAR(20) NOT NULL,
    dominante_prec VARCHAR(20) NOT NULL,
    specialite_prec VARCHAR(20) NOT NULL,
    lv1 VARCHAR(20) NOT NULL,
    lv2 VARCHAR(20) NOT NULL,
    
    CONSTRAINT pk_candidat PRIMARY KEY (no_candidat),
    CONSTRAINT fk_candidat_individu FOREIGN KEY (id_individu) REFERENCES _individu(id_individu)
);

CREATE TABLE _etudiant (
    code_nip VARCHAR(10) NOT NULL,
    cat_socio_etu VARCHAR(20) NOT NULL,
    cat_socio_parent VARCHAR(20) NOT NULL,
    bourse_superieur BOOLEAN NOT NULL,
    mention_bac VARCHAR(10),
    serie_bac VARCHAR(20) NOT NULL,
    dominante_bac VARCHAR(20) NOT NULL,
    specialite_bac VARCHAR(20) NOT NULL,
    mois_annee_obtention_bac CHAR(7) NOT NULL,

    CONSTRAINT pk_etudiant PRIMARY KEY (code_nip)
); 
CREATE TABLE _semestre (
    id_semestre INTEGER NOT NULL,
    num_semestre CHAR(5) NOT NULL,
    annee_univ CHAR(9) NOT NULL,

    CONSTRAINT pk_semestre PRIMARY KEY (id_semestre)
);

CREATE TABLE _inscription (
    groupe_tp CHAR(2) NOT NULL,
    amenagement_evaluation VARCHAR(5) NOT NULL,
    code_nip VARCHAR(10) NOT NULL,
    id_semestre INTEGER NOT NULL,

    CONSTRAINT pk_inscription PRIMARY KEY (groupe_tp),
    CONSTRAINT fk_inscription_etudiant FOREIGN KEY (code_nip) REFERENCES _etudiant(code_nip),
    CONSTRAINT fk_inscription_semestre FOREIGN KEY (id_semestre) REFERENCES _semestre(id_semestre)
);

CREATE TABLE _module (
    id_module CHAR(5) NOT NULL,
    libelle_module VARCHAR(10) NOT NULL,
    ue CHAR(2) NOT NULL,
    
    CONSTRAINT pk_module PRIMARY KEY (id_module)
);

CREATE TABLE _programme (
    coefficient FLOAT NOT NULL,
    id_semestre INTEGER NOT NULL,
    id_module CHAR(5) NOT NULL,

    CONSTRAINT pk_programme PRIMARY KEY (coefficient),
    CONSTRAINT fk_programme_semestre FOREIGN KEY (id_semestre) REFERENCES _semestre(id_semestre),
    CONSTRAINT fk_programme_module FOREIGN KEY (id_module) REFERENCES _module(id_module)
);

CREATE TABLE _resultat (
    moyenne FLOAT NOT NULL,
    code_nip VARCHAR(10) NOT NULL,
    id_module CHAR(5) NOT NULL,
    id_semestre INTEGER NOT NULL,

    CONSTRAINT pk_resultat PRIMARY KEY (moyenne),
    CONSTRAINT fk_resultat_etudiant FOREIGN KEY (code_nip) REFERENCES _etudiant(code_nip),
    CONSTRAINT fk_resultat_module FOREIGN KEY (id_module) REFERENCES _module(id_module),
    CONSTRAINT fk_resultat_semestre FOREIGN KEY (id_semestre) REFERENCES _semestre(id_semestre)
);
