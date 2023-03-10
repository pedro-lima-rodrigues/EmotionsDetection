import nlp from lib_nlp;

// Raw input dataset definition 
inrec := RECORD
  STRING edit_history_tweet_ids;
	STRING id;
	STRING text;
END;

inds := DATASET('~14.01_1830.json',inrec,JSON('data'));
OUTPUT(inds);

// Call to the NLP++ plugin and parsing the result
childrec := RECORD
	STRING emotion ;
	UNSIGNED counter ;
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
COUNT(myproj);

// Add timestamp field
newrec := RECORD
 UNSIGNED timestamp;
 myproj;
END;

newrec AddTime(outrec Le, UNSIGNED cnt) := TRANSFORM
  SELF.timestamp:= IF(cnt<40,1800,1830); //(placeholder, pls replace by real timestamps)
  SELF:= Le;
END;

mynewproj := PROJECT(myproj,AddTime(LEFT,COUNTER));

OUTPUT(mynewproj);
COUNT(mynewproj);

// Extract the most prevalent emotion from each tweet 
finalrec := RECORD
  UNSIGNED timestamp;
  STRING id;
  STRING text;
 	STRING emotion ;
	UNSIGNED counter ;
END;

finalrec GetTopEmot(newrec Le) := TRANSFORM
  SELF.emotion := DEDUP(SORT(Le.sentiment.test,-Le.sentiment.test.counter),Le.sentiment.test.counter)[1].emotion;
	SELF.counter := DEDUP(SORT(Le.sentiment.test,-Le.sentiment.test.counter),Le.sentiment.test.counter)[1].counter;
	SELF := Le
END;

finalproj := PROJECT(mynewproj, GetTopEmot(LEFT));

OUTPUT(finalproj);
COUNT(finalproj);

// Crosstab report to group emotion count within each timeframe

tabrec := RECORD
 finalproj.timestamp;
 finalproj.emotion;
 cnt := COUNT(GROUP);
END;

mytab := TABLE(finalproj,tabrec,timestamp,emotion);
OUTPUT(Mytab);