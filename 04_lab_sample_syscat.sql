-- Q1) Determinare per ogni table (TYPE = ‘T’) , il numero di foreign key, ignorando quelle autoreferenziali
-- (ed escludendo le tabelle con 0 foreign key) e ordinare per valori decrescenti (a parità, per nome di
-- schema e di tabella)
SELECT t.TABSCHEMA, t.TABNAME, t.PARENTS - t.SELFREFS AS NUMFK
FROM TABLES t
WHERE t.TYPE = 'T' AND t.PARENTS <> 0
ORDER BY t.PARENTS - t.SELFREFS DESC, t.TABSCHEMA, t.TABNAME

-- Q2) Mostrare gli schemi con almeno 5 table o view, ordinando in senso decrescente per numero totale
-- di oggetti
SELECT t.TABSCHEMA, COUNT(t.TABSCHEMA) AS NUMOBJECTS
FROM TABLES t
WHERE TYPE = 'V' OR TYPE = 'T'
GROUP BY t.TABSCHEMA
HAVING COUNT(t.TABSCHEMA) >= 5
ORDER BY COUNT(t.TABSCHEMA) DESC

-- Q3) Per ogni vista di SYSCAT, determinare da quanti oggetti di ciascun tipo dipende
SELECT TABNAME, BTYPE, COUNT(*) AS NUMDEP
FROM (SELECT t.TABNAME, t.BTYPE
	  FROM TABDEP t
	  JOIN TABLES t2 ON t.TABNAME = t2.TABNAME
	  WHERE t.TABSCHEMA = 'SYSCAT'
	  GROUP BY t.TABNAME, t.BNAME, t.BTYPE) AS TABELLA(TABNAME, BTYPE)
GROUP BY TABNAME, BTYPE
ORDER BY NUMDEP DESC

-- Q4) Senza usare l’attributo TABLES.COLCOUNT, né viste, determinare la table (TYPE = ‘T’) con il maggior
-- numero di colonne
WITH TABELLA(SCHEMA, NAME, NUM) AS (SELECT t.TABSCHEMA, t.TABNAME, COUNT(*)
									FROM TABLES t
									JOIN COLUMNS c ON t.TABNAME = c.TABNAME AND t.TABSCHEMA = c.TABSCHEMA
									WHERE TYPE = 'T'
									GROUP BY t.TABSCHEMA, t.TABNAME)
SELECT *
FROM TABELLA t
WHERE t.NUM = (SELECT MAX(t1.NUM)
			   FROM TABELLA t1)

-- Q5) Per ogni tipo di dato (COLUMNS.TYPENAME), il n. di oggetti in cui quel tipo è il più usato
WITH TABELLA(TABSCHEMA, TABNAME, TYPENAME, NUM) AS (SELECT t.TABSCHEMA, t.TABNAME, c.TYPENAME, COUNT(*)
													FROM TABLES t
													JOIN COLUMNS c ON t.TABSCHEMA = c.TABSCHEMA AND t.TABNAME = c.TABNAME
													GROUP BY t.TABSCHEMA, t.TABNAME, c.TYPENAME)
SELECT t.TYPENAME, COUNT(*) AS NUM_TABLES
FROM TABELLA t
WHERE t.NUM = (SELECT MAX(t1.NUM)
			   FROM TABELLA t1
			   WHERE t.TABSCHEMA = t1.TABSCHEMA AND t.TABNAME = t1.TABNAME)
GROUP BY t.TYPENAME
ORDER BY COUNT(*) DESC

-- Q6) Determinare la table (TYPE = 'T') non definita in uno schema di sistema (cioè diverso da SYS...) da
-- cui sono (direttamente) dipendenti il maggior numero di viste
WITH TABELLA(BNAME, NUM) AS (SELECT BNAME, COUNT(*)
							 FROM TABDEP
							 WHERE BTYPE = 'T' AND BSCHEMA NOT LIKE 'SYS%'
							 GROUP BY BNAME)
SELECT *
FROM TABELLA t
WHERE t.NUM = (SELECT MAX(NUM)
			   FROM TABELLA)
							 
-- Q7) Determinare i tipi di dato che compaiono nella definizione di tutte le viste (TYPE = 'V') dello schema
-- DB2INST1
WITH COLONNE(TABNAME, TYPENAME) AS (SELECT DISTINCT t.TABNAME, c.TYPENAME
									FROM COLUMNS c
									JOIN TABLES t ON c.TABNAME = t.TABNAME AND c.TABSCHEMA = t.TABSCHEMA
									WHERE t.TYPE = 'V' AND t.TABSCHEMA= 'DB2INST1')
SELECT c1.TYPENAME
FROM COLONNE c1
GROUP BY c1.TYPENAME
HAVING COUNT(c1.TYPENAME) = (SELECT COUNT(DISTINCT c2.TABNAME)
							 FROM COLONNE c2)

/*
Q1)

TABSCHEMA  TABNAME                             NUMFK      
---------- ----------------------------------- -----------
DB2INST1   PROJECT                                       2
DB2INST1   DEPARTMENT                                    1
DB2INST1   EMPLOYEE                                      1
DB2INST1   EMPPROJACT                                    1
DB2INST1   EMP_PHOTO                                     1
DB2INST1   EMP_RESUME                                    1
DB2INST1   PROJACT                                       1
SYSTOOLS   ADVISE_INDEX                                  1
SYSTOOLS   ADVISE_MQT                                    1
SYSTOOLS   ADVISE_PARTITION                              1
SYSTOOLS   ADVISE_TABLE                                  1
SYSTOOLS   AM_BASE_TASK_RPTS                             1
SYSTOOLS   EXPLAIN_ACTUALS                               1
SYSTOOLS   EXPLAIN_ARGUMENT                              1
SYSTOOLS   EXPLAIN_DIAGNOSTIC                            1
SYSTOOLS   EXPLAIN_DIAGNOSTIC_DATA                       1
SYSTOOLS   EXPLAIN_OBJECT                                1
SYSTOOLS   EXPLAIN_OPERATOR                              1
SYSTOOLS   EXPLAIN_PREDICATE                             1
SYSTOOLS   EXPLAIN_STATEMENT                             1
SYSTOOLS   EXPLAIN_STREAM                                1
DB2INST1   ACT                                           0

  22 record selezionato/i.


Q2)

TABSCHEMA  NUMOBJECTS 
---------- -----------
SYSIBMADM          183
SYSIBM             181
SYSCAT             154
DB2INST1            34
SYSTOOLS            29
SYSSTAT              9

  6 record selezionato/i.



Q3)

TABNAME                             BTYPE NUMDEP     
----------------------------------- ----- -----------
COLUMNS                             T               7
AUDITUSE                            T               6
HISTOGRAMTEMPLATEUSE                T               6
ROUTINES                            T               6
ROUTINEPARMS                        T               5
VARIABLES                           T               5
WORKACTIONSETS                      T               5
ATTRIBUTES                          T               4
CONDITIONS                          T               4
MODULEOBJECTS                       T               4
ROWFIELDS                           T               4
TABLES                              T               4
XSROBJECTCOMPONENTS                 T               4
CASTFUNCTIONS                       T               3
COLIDENTATTRIBUTES                  T               3
CONTEXTS                            T               3
CONTROLDEP                          T               3
CONTROLS                            T               3
DATATYPES                           T               3
INDEXES                             T               3
INVALIDOBJECTS                      T               3
PACKAGEDEP                          T               3
PERIODS                             T               3
ROLES                               T               3
SCPREFTBSPACES                      T               3
TRANSFORMS                          T               3
TRIGGERS                            T               3
WORKACTIONS                         T               3
WORKCLASSATTRIBUTES                 T               3
WORKLOADS                           T               3
XDBMAPGRAPHS                        T               3
XSROBJECTDEP                        T               3
XSROBJECTS                          T               3
AUDITPOLICIES                       T               2
CHECKS                              T               2
COLLATIONS                          T               2
CONSTDEP                            T               2
CONTEXTATTRIBUTES                   T               2
DATATYPEDEP                         T               2
FUNCDEP                             T               2
FUNCTIONS                           T               2
HISTOGRAMTEMPLATEBINS               T               2
HISTOGRAMTEMPLATES                  T               2
INDEXCOLUSE                         T               2
INDEXDEP                            T               2
INDEXEXTENSIONDEP                   T               2
INDEXEXTENSIONPARMS                 T               2
LIBRARYBINDFILES                    T               2
LIBRARYVERSIONS                     T               2
MODULEAUTH                          T               2
MODULES                             T               2
NICKNAMES                           T               2
PACKAGES                            T               2
PREDICATESPECS                      T               2
PROCEDURES                          T               2
ROUTINEDEP                          T               2
ROUTINEOPTIONS                      T               2
ROUTINEPARMOPTIONS                  T               2
ROUTINESFEDERATED                   T               2
SCHEMATA                            T               2
SECURITYLABELCOMPONENTS             T               2
SECURITYLABELS                      T               2
SECURITYPOLICIES                    T               2
SEQUENCEAUTH                        T               2
SEQUENCES                           T               2
SERVICECLASSES                      T               2
STATEMENTS                          T               2
STOGROUPS                           T               2
TABDEP                              T               2
TABLESPACES                         T               2
THRESHOLDS                          T               2
TRIGDEP                             T               2
USAGELISTS                          T               2
VARIABLEAUTH                        T               2
VARIABLEDEP                         T               2
VIEWDEP                             T               2
WORKCLASSES                         T               2
WORKCLASSSETS                       T               2
WORKLOADAUTH                        T               2
WORKLOADCONNATTR                    T               2
XDBMAPSHREDTREES                    T               2
XSROBJECTHIERARCHIES                T               2
ATTRIBUTES                          F               1
BUFFERPOOLDBPARTITIONS              T               1
BUFFERPOOLEXCEPTIONS                T               1
BUFFERPOOLNODES                     T               1
BUFFERPOOLS                         T               1
CHECKS                              F               1
COLAUTH                             T               1
COLCHECKS                           T               1
COLDIST                             T               1
COLGROUPCOLS                        T               1
COLGROUPDIST                        T               1
COLGROUPDISTCOUNTS                  T               1
COLGROUPS                           T               1
COLLATIONS                          F               1
COLOPTIONS                          T               1
COLUMNS                             F               1
COLUSE                              T               1
CONTROLS                            F               1
DATAPARTITIONEXPRESSION             T               1
DATAPARTITIONS                      T               1
DATATYPES                           F               1
DBAUTH                              T               1
DBPARTITIONGROUPDEF                 T               1
DBPARTITIONGROUPS                   T               1
EVENTMONITORS                       T               1
EVENTS                              T               1
EVENTTABLES                         T               1
FULLHIERARCHIES                     T               1
FUNCMAPOPTIONS                      T               1
FUNCMAPPARMOPTIONS                  T               1
FUNCMAPPINGS                        T               1
FUNCPARMS                           T               1
HIERARCHIES                         T               1
INDEXAUTH                           T               1
INDEXCOLUSE                         F               1
INDEXEXPLOITRULES                   T               1
INDEXEXTENSIONMETHODS               T               1
INDEXEXTENSIONPARMS                 F               1
INDEXEXTENSIONS                     T               1
INDEXOPTIONS                        T               1
INDEXPARTITIONS                     T               1
INDEXXMLPATTERNS                    T               1
INVALIDOBJECTS                      F               1
KEYCOLUSE                           T               1
LIBRARIES                           T               1
LIBRARYAUTH                         T               1
MEMBERSUBSETATTRS                   T               1
MEMBERSUBSETMEMBERS                 T               1
MEMBERSUBSETS                       T               1
NAMEMAPPINGS                        T               1
NODEGROUPDEF                        T               1
NODEGROUPS                          T               1
PACKAGEAUTH                         T               1
PACKAGES                            F               1
PARTITIONMAPS                       T               1
PASSTHRUAUTH                        T               1
PROCPARMS                           T               1
REFERENCES                          T               1
ROLEAUTH                            T               1
ROUTINEAUTH                         T               1
ROUTINEPARMS                        F               1
ROUTINES                            F               1
ROWFIELDS                           F               1
SCHEMAAUTH                          T               1
SECURITYLABELACCESS                 T               1
SECURITYLABELCOMPONENTELEMENTS      T               1
SECURITYLABELS                      F               1
SECURITYPOLICYCOMPONENTRULES        T               1
SECURITYPOLICYEXEMPTIONS            T               1
SERVEROPTIONS                       T               1
SERVERS                             T               1
STATEMENTTEXTS                      T               1
SURROGATEAUTHIDS                    T               1
TABAUTH                             T               1
TABCONST                            T               1
TABDETACHEDDEP                      T               1
TABLES                              F               1
TABOPTIONS                          T               1
TBSPACEAUTH                         T               1
THRESHOLDS                          F               1
TRIGGERS                            F               1
TYPEMAPPINGS                        T               1
USEROPTIONS                         T               1
VARIABLES                           F               1
VIEWS                               T               1
WRAPOPTIONS                         T               1
WRAPPERS                            T               1
XMLSTRINGS                          T               1
XSROBJECTAUTH                       T               1
XSROBJECTDETAILS                    T               1

  172 record selezionato/i.



Q4)

TABSCHEMA  TABNAME                             NUMCOLS    
---------- ----------------------------------- -----------
SYSIBM     SYSROUTINES                                  84

  1 record selezionato/i.



Q5)

TYPE                 NUM_TABLES 
-------------------- -----------
VARCHAR                      411
CHARACTER                    112
INTEGER                       61
BIGINT                        47
SMALLINT                      33
DECIMAL                       10
CLOB                           9
TIMESTAMP                      9
DOUBLE                         7
BLOB                           5
DATE                           4
TIME                           1

  12 record selezionato/i.



Q6)

SCHEMA  |TABLE   |NUMVIEW
--------+--------+-------
DB2INST1|EMPLOYEE|      9

  1 record selezionato/i.



Q7)

TYPENAME 
---------
CHARACTER

  1 record selezionato/i.
*/