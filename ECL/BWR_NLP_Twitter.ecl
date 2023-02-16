import nlp from lib_nlp;
 
inrec := RECORD
  STRING edit_history_tweet_ids;
	STRING id;
	STRING text;
END;


inds := DATASET('~14.01_1830.json',inrec,JSON('data'));
inds;

childrec := RECORD
	STRING emotion ;
	STRING count ;
END;

midrec := RECORD
  DATASET(childrec) test ;
END;


outrec := RECORD
  STRING id;
	STRING text;
	DATASET(midrec) sentiment ;
END;


outrec mytransf(inrec Le, unsigned cnt) := TRANSFORM
  
	myds := DATASET([nlp.AnalyzeText('emotion',inds[cnt].text)],{string line});
	SELF.sentiment := PROJECT(
	                      PARSE(
	                        myds,line,TRANSFORM(
													                    midrec,SELF.test:= XMLPROJECT('resultado',TRANSFORM(
																																						                   childrec,
                                                       SELF.emotion := XMLTEXT('emocao'),
                                                       SELF.count := XMLTEXT('contagem')
																											                                         )
																																					     )
																								),XML('Row/tweet'))
									  , midrec);
	SELF := Le;
END;

myproj := PROJECT(inds,mytransf(LEFT,COUNTER));

output(myproj);
