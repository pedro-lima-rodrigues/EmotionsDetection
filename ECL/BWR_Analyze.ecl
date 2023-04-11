import nlp from lib_nlp;
IMPORT $;

inds := $.File_NLP_inds.File;
inds_rec := $.File_NLP_inds.Layout;

// Call to the NLP++ plugin and parsing the result
childrec := RECORD
	STRING emotion ;
	UNSIGNED counter ;
END;

midrec := RECORD
  DATASET(childrec) test ;
END;

outrec := RECORD
  UNSIGNED hora;
  STRING id;
	STRING text;
	DATASET(midrec) sentiment ;
END;

outrec mytransf(inds_rec Le, unsigned cnt) := TRANSFORM
  myds := DATASET([nlp.AnalyzeText('emotion',inds[cnt].text)],{string line});
	SELF.sentiment := PROJECT(PARSE(myds,line,TRANSFORM(midrec,
	                                                    SELF.test:= XMLPROJECT('resultado',TRANSFORM(childrec,
                                                                                                   SELF.emotion := XMLTEXT('emocao'),
                                                                                                   SELF.counter := (UNSIGNED)XMLTEXT('contagem')
																											                                             )
																																					    )
																								      ),XML('Row/tweet')),midrec);
	SELF := Le;
END;

myproj := PROJECT(inds,mytransf(LEFT,COUNTER));

output(myproj);
// COUNT(myproj);

// Extract the most prevalent emotion from each tweet 
finalrec := RECORD
  UNSIGNED hora;
  STRING id;
  STRING text;
 	STRING emotion ;
	UNSIGNED counter ;
END;

finalrec GetTopEmot(outrec Le) := TRANSFORM
  SELF.emotion := DEDUP(SORT(Le.sentiment.test,-Le.sentiment.test.counter),Le.sentiment.test.counter)[1].emotion;
	SELF.counter := DEDUP(SORT(Le.sentiment.test,-Le.sentiment.test.counter),Le.sentiment.test.counter)[1].counter;
	SELF := Le
END;

finalproj := PROJECT(myproj, GetTopEmot(LEFT));

OUTPUT(finalproj);
// COUNT(finalproj);

// Crosstab report to group emotion count within each timeframe

tabrec := RECORD
 finalproj.hora;
 finalproj.emotion;
 cnt := COUNT(GROUP);
END;

mytab := TABLE(finalproj,tabrec,hora,emotion);
OUTPUT(mytab,,'~mytab',overwrite);