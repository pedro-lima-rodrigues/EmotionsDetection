EXPORT File_NLP_mytab := MODULE
	EXPORT Layout := RECORD
    UNSIGNED hora;
    STRING emotion ;
    UNSIGNED cnt ;
	END;
	EXPORT File := DATASET('~mytab',Layout,FLAT);
END;