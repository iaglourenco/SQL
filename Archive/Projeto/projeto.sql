--PROJETO DE BD
--IAGO LOURENÇO 1560116

CREATE TABLE CURSOS (
  NUM VARCHAR2(4),
  NOME VARCHAR2(20),
  PRIMARY KEY(NUM)
);

CREATE TABLE PROFESSOR (
  idPROFESSOR VARCHAR2(4),
  NOME VARCHAR2(20),
  NUM_CURSO VARCHAR(4),
  PRIMARY KEY(idPROFESSOR)
);

CREATE TABLE DISCIPLINAS (
  COD_DISCIPLINAS VARCHAR2(4),
  PROFESSOR_idPROFESSOR VARCHAR2(4),
  NOME VARCHAR,
  CREDITOS NUMBER,
  PRIMARY KEY(COD_DISCIPLINAS),
  FOREIGN KEY(PROFESSOR_idPROFESSOR)
    REFERENCES PROFESSOR(idPROFESSOR) 
);

CREATE TABLE ALUNOS (
  RA VARCHAR2(8),
  CURSOS_NUM VARCHAR2(4),
  NOME VARCHAR2(20),
  DATA_NASC DATE,
  NUM_CURSO VARCHAR2(4),
  PRIMARY KEY(RA, CURSOS_NUM),
  FOREIGN KEY(CURSOS_NUM)
    REFERENCES CURSOS(NUM)
);

CREATE TABLE PRE_REQ (
  DISCIPLINAS_COD_DISCIPLINAS VARCHAR2(4),
  COD_PREREQ NUMBER,
  PRIMARY KEY(DISCIPLINAS_COD_DISCIPLINAS),
  FOREIGN KEY(DISCIPLINAS_COD_DISCIPLINAS)
    REFERENCES DISCIPLINAS(COD_DISCIPLINAS)
  );

CREATE TABLE ALUNOS_CURSANDO (
  ALUNOS_RA VARCHAR2(8),
  DISCIPLINAS_COD_DISCIPLINAS VARCHAR2(4),
  ALUNOS_CURSOS_NUM VARCHAR2(4),
  FREQUENCIA NUMBER,
  PRIMARY KEY(ALUNOS_RA, DISCIPLINAS_COD_DISCIPLINAS),
  FOREIGN KEY(ALUNOS_RA, ALUNOS_CURSOS_NUM)
    REFERENCES ALUNOS(RA, CURSOS_NUM)
  FOREIGN KEY(DISCIPLINAS_COD_DISCIPLINAS)
    REFERENCES DISCIPLINAS(COD_DISCIPLINAS)
  );

CREATE TABLE GRADE (
  CURSOS_NUM VARCHAR2(4),
  DISCIPLINAS_COD_DISCIPLINAS VARCHAR2(4),
  PRIMARY KEY(CURSOS_NUM, DISCIPLINAS_COD_DISCIPLINAS),
  FOREIGN KEY(DISCIPLINAS_COD_DISCIPLINAS)
    REFERENCES DISCIPLINAS(COD_DISCIPLINAS)
  FOREIGN KEY(CURSOS_NUM)
    REFERENCES CURSOS(NUM)
  );

CREATE TABLE ALUNOS_QUE_CURSARAM (
  ALUNOS_RA VARCHAR2(8),
  DISCIPLINAS_COD_DISCIPLINAS VARCHAR2(4),
  ALUNOS_CURSOS_NUM VARCHAR2(4),
  NOTA NUMBER(2,2),
  NOME VARCHAR2(20),
  FREQUENCIA NUMBER,
  SEMESTRE/ANO NUMBER,
  SITUACAO CHAR,
  PRIMARY KEY(ALUNOS_RA, DISCIPLINAS_COD_DISCIPLINAS),
  FOREIGN KEY(ALUNOS_RA, ALUNOS_CURSOS_NUM)
    REFERENCES ALUNOS(RA, CURSOS_NUM)
     FOREIGN KEY(DISCIPLINAS_COD_DISCIPLINAS)
    REFERENCES DISCIPLINAS(COD_DISCIPLINAS)
  CHECK(SITUACAO) IN ('A','R');
);

CREATE TABLE POSGRADUACAO (
  ALUNOS_CURSOS_NUM VARCHAR2(4),
  ALUNOS_RA VARCHAR2(8),
  ORIENTADOR VARCHAR NULL,
  PRIMARY KEY(ALUNOS_RA),
  FOREIGN KEY(ALUNOS_RA, ALUNOS_CURSOS_NUM)
    REFERENCES ALUNOS(RA, CURSOS_NUM)
  );

CREATE TABLE GRADUACAO (
  CD VARCHAR2(4)
  ALUNOS_CURSOS_NUM VARCHAR2(4),
  ALUNOS_RA VARCHAR2(8),
  COD_CURSO VARCHAR NULL,
  PRIMARY KEY(CD),
  FOREIGN KEY(ALUNOS_RA, ALUNOS_CURSOS_NUM)
    REFERENCES ALUNOS(RA, CURSOS_NUM)
  );

CREATE TABLE DEFINICAO_PREREQ (
  COD_PREREQ NUMBER,
  PRE_REQ_DISCIPLINAS_COD_DISCIPLINAS VARCHAR2(4),
  DEFINICAO VARCHAR2(40),
  PRIMARY KEY(COD_PREREQ),
  FOREIGN KEY(PRE_REQ_DISCIPLINAS_COD_DISCIPLINAS)
    REFERENCES PRE_REQ(DISCIPLINAS_COD_DISCIPLINAS)
   );

