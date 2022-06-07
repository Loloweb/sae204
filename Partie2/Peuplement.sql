DROP SCHEMA IF EXISTS partie2 CASCADE;
CREATE SCHEMA partie2; 
SET SCHEMA 'partie2';

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
    
    CONSTRAINT pk_candidat PRIMARY KEY (id_individu),
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

-- Modifications 

ALTER TABLE _candidat
  DROP CONSTRAINT fk_candidat_individu;

ALTER TABLE _individu
  ALTER ville TYPE VARCHAR(50),
  ALTER COLUMN INE DROP NOT NULL,
  ALTER code_postal TYPE VARCHAR(50),
  ALTER id_individu TYPE VARCHAR(12);

ALTER TABLE _candidat
  ALTER boursier_lycee TYPE VARCHAR(50),
  ALTER niveau_etude TYPE VARCHAR(50),
  ALTER serie_prec TYPE VARCHAR(100),
  ALTER dominante_prec TYPE VARCHAR(50),
  ALTER specialite_prec TYPE VARCHAR(100),
  ALTER id_individu TYPE VARCHAR(12),
  ALTER profil_candidat TYPE VARCHAR(100),
  ALTER etablissement TYPE VARCHAR(100),
  ALTER dept_etablissement TYPE VARCHAR(100),
  ALTER ville_etablissement TYPE VARCHAR(100),
  ALTER COLUMN boursier_lycee DROP NOT NULL,
  ALTER COLUMN profil_candidat DROP NOT NULL,
  ALTER COLUMN etablissement DROP NOT NULL,
  ALTER COLUMN dept_etablissement DROP NOT NULL,
  ALTER COLUMN ville_etablissement DROP NOT NULL,
  ALTER COLUMN niveau_etude DROP NOT NULL,
  ALTER COLUMN type_formation DROP NOT NULL,
  ALTER COLUMN serie_prec DROP NOT NULL,
  ALTER COLUMN dominante_prec DROP NOT NULL,
  ALTER COLUMN specialite_prec DROP NOT NULL,
  ALTER COLUMN lv1 DROP NOT NULL,
  ALTER COLUMN lv2 DROP NOT NULL,
  ADD CONSTRAINT fk_candidat_individu FOREIGN KEY (id_individu) REFERENCES _individu(id_individu);
  
ALTER TABLE _etudiant
  ALTER cat_socio_etu TYPE VARCHAR(50),
  ALTER mention_bac TYPE VARCHAR(15),
  ALTER code_nip TYPE VARCHAR(15),
  ALTER COLUMN bourse_superieur DROP NOT NULL,
  ALTER COLUMN serie_bac DROP NOT NULL,
  ALTER COLUMN dominante_bac DROP NOT NULL,
  ALTER COLUMN specialite_bac DROP NOT NULL,
  ALTER COLUMN mois_annee_obtention_bac DROP NOT NULL,
  ALTER cat_socio_parent TYPE VARCHAR(50);

ALTER TABLE _module
  ALTER id_module TYPE CHAR(6),
  ALTER ue TYPE CHAR(4),
  ALTER libelle_module TYPE VARCHAR(110);
  
ALTER TABLE _programme
  ALTER id_module TYPE CHAR(6);
    
ALTER TABLE _semestre
  ALTER annee_univ TYPE VARCHAR(20);
    
ALTER TABLE _resultat
  ALTER id_module TYPE CHAR(6);


-- Peuplement
-- Les filecolumns restent à remplir. Pour skip une colonne du csv, faut écrire $wb_skip$

-- Peuplement de la table _individu à partir du fichier v_candidatures.csv

WbImport -file=./v_candidatures.csv
         -header=true
         -delimiter=';'
         -table=_individu
         -schema=partie2
         -filecolumns= $wb_skip$,$wb_skip$,$wb_skip$,nom,prenom,sexe,date_naissance,nationalite,code_postal,ville,$wb_skip$,$wb_skip$,$wb_skip$,id_individu
;

-- Peuplement de la table _candidat à partir du fichier v_candidatures.csv
  
WbImport -file=./v_candidatures.csv
         -header=true
         -delimiter=';'
         -table=_candidat
         -schema=partie2
         -filecolumns= $wb_skip$,no_candidat,classement,$wb_skip$,$wb_skip$,$wb_skip$,$wb_skip$,$wb_skip$,$wb_skip$,$wb_skip$,$wb_skip$,boursier_lycee,profil_candidat,id_individu,$wb_skip$,etablissement,ville_etablissement,dept_etablissement,$wb_skip$,niveau_etude,type_formation_prec,serie_prec,dominante_prec,specialite_prec,LV1,LV2 
;

-- Peuplement de la table _etudiant à partir du fichier v_inscription.csv
-- !! Erreur dans ce fichier, un code_nip est en double !!

WbImport -file=./v_inscriptions.csv
         -header=true
         -delimiter=';'
         -table=_etudiant
         -schema=partie2
         -filecolumns= $wb_skip$,$wb_skip$,$wb_skip$,$wb_skip$,code_nip,id_individu,$wb_skip$,$wb_skip$,$wb_skip$,$wb_skip$,$wb_skip$,$wb_skip$,$wb_skip$,cat_socio_etu,cat_socio_parent,serie_bac,mention_bac,$wb_skip$,$wb_skip$,$wb_skip$,$wb_skip$,$wb_skip$,bourse_superieur
;

-- Peuplement de la table _module à partir du fichier ppn.csv
-- !! Erreur dans ce fichier, un id_smestre est NULL, alors qu'il ne devrait pas !!

WbImport -file=./ppn.csv
         -header=true
         -delimiter=';'
         -table=_module
         -schema=partie2
         -filecolumns= id_module,ue,libelle_module
;

-- Peuplement de la table _semestre à partir du fichier v_resu_s1.csv

WbImport -file=./v_resu_s1.csv
         -header=true
         -delimiter=';'
         -table=_semestre
         -schema=partie2
         -filecolumns=annee_univ,num_semestre
;

-- Peuplement de la table _inscription à partir du fichier v_resu_s1.csv

WbImport -file=./v_resu_s1.csv
         -header=true
         -delimiter=';'
         -table=_inscription
         -schema=partie2
         -filecolumns= annee_univ,num_semestre,code_nip,$wb_skip$,$wb_skip$,$wb_skip$,$wb_skip$,$wb_skip$,$wb_skip$,groupe_tp
;

-- Peuplement de la table _programme à partir du fichier ppn.csv

WbImport -file=./ppn.csv
         -header=true
         -delimiter=';'
         -table=_programme
         -schema=partie2
         -filecolumns=id_module,$wb_skip$,$wb_skip$,coefficient,$wb_skip$,$wb_skip$,$wb_skip$,id_semestre
;

-- Peuplement de la table _resultat à partir du fichier v_resu_s1.csv
-- Beaucoups d'éssais sur cette importation, mais nous n'avons pas réussit à remplir cette table finalement

-- WbImport -file=./v_resu_s1.csv
--         -header=true
--         -delimiter=';'
--         -table=_resultat
--         -schema=partie2
--         -filecolumns= 
--;

