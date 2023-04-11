EXPORT File_NLP_joined := MODULE
	EXPORT Layout := RECORD
      UNSIGNED hora;
      REAL torc;
      REAL raiv;
      REAL fel;
      REAL engr;
	END;
	EXPORT File := DATASET('~joined',Layout,FLAT);
END;