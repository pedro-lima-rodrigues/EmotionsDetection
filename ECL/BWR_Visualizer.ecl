IMPORT Visualizer;
IMPORT $;

joined_ := $.File_NLP_joined.File;
OUTPUT(joined_, NAMED('joined'));

sem_acum := $.File_NLP_sem_acum.File;
OUTPUT(sem_acum, NAMED('sem_acum'));

//mappings :=  DATASET([  {'raiva', 'raiv'}, 
  //                      {'felicidade', 'fel'}, 
   //                     {'engraçado', 'engr'}, 
  //                      {'horário', 'hora'}, 
   //                     {'torcida', 'torc'}], Visualizer.KeyValueDef);
properties := DATASET([ {'paletteID', 'Set1'}
                        ], Visualizer.KeyValueDef);

//  Create the visualization, giving it a uniqueID "bubble" and supplying the result name "RegionProfit_Viz"
//Visualizer.MultiD.column('myChart', /*datasource*/, 'Emocoes', /*mappings*/, /*filteredBy*/, /*properties*/ );
Visualizer.MultiD.area('myChart', /*datasource*/, 'joined', /*mappings*/, /*filteredBy*/, properties );
Visualizer.MultiD.area('myChart2', /*datasource*/, 'sem_acum', /*mappings*/, /*filteredBy*/, properties );