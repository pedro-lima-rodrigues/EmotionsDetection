import nlp from lib_nlp;
IMPORT $;

inds := $.File_NLP_inds.File;
inds_rec := $.File_NLP_inds.Layout;

childrec := RECORD
	STRING emotion ;
	STRING contagem ;
END;

midrec := RECORD
  DATASET(childrec) test ;
END;


outrec := RECORD
  INTEGER hora;
  STRING id;
	STRING text;
	DATASET(midrec) sentiment ;
END;


outrec mytransf(inds_rec Le, unsigned cnt) := TRANSFORM
  
	myds := DATASET([nlp.AnalyzeText('emotion',inds[cnt].text)],{string line});
	SELF.sentiment := PROJECT(
	                      PARSE(
	                        myds,line,TRANSFORM(
													                    midrec,SELF.test:= XMLPROJECT('resultado',TRANSFORM(
																																						                   childrec,
                                                       SELF.emotion := XMLTEXT('emocao'),
                                                       SELF.contagem := XMLTEXT('contagem')
																											                                         )
																																					     )
																								),XML('Row/tweet'))
									  , midrec);
	SELF := Le;
END;

myproj := PROJECT(inds,mytransf(LEFT,COUNTER));
myproj;

//rec_filtro := record
//  myproj.hora;
//  myproj.id;
//  myproj.text;
//  maximo := max(GROUP,contagem);
//end;

//inds_filtro := table(myproj,rec_filtro,id);

inds_filtro := myproj(contagem > max(myproj.sentiment.test,contagem););
inds_filtro;