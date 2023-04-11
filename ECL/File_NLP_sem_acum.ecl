EXPORT File_NLP_sem_acum := MODULE
	EXPORT Layout := RECORD
      UNSIGNED hora;
      UNSIGNED torc;
      UNSIGNED raiv;
      UNSIGNED fel;
      UNSIGNED engr;
	END;
	EXPORT File := DATASET('~sem_acum',Layout,FLAT);
END;