EXPORT File_NLP_inds := MODULE
	EXPORT Layout := RECORD
      INTEGER hora;
      STRING id;
      STRING text;
	END;
	EXPORT File := DATASET('~inds_06.10',Layout,FLAT);
END;