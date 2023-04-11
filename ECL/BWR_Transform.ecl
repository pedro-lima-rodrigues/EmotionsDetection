IMPORT $;

mytab := $.File_NLP_mytab.File;
mytab_rec := $.File_NLP_mytab.Layout;
// mytab;

torc := mytab(emotion = 'torcida');
new_torc_rec := RECORD
   UNSIGNED hora;
   UNSIGNED torcida;
END;
new_torc_rec MudarNomeCol(mytab_rec Le) := TRANSFORM
  SELF.torcida := Le.cnt;
  SELF := Le;
END;
new_torc := PROJECT(torc, MudarNomeCol(LEFT));
// new_torc;

raiv := mytab(emotion = 'raiva');
new_raiv_rec := RECORD
   UNSIGNED hora;
   UNSIGNED raiva;
END;
new_raiv_rec MudarNomeCol2(mytab_rec Le) := TRANSFORM
  SELF.raiva := Le.cnt;
  SELF := Le;
END;
new_raiv := PROJECT(raiv, MudarNomeCol2(LEFT));
// new_raiv;

fel := mytab(emotion = 'felicidade');
new_fel_rec := RECORD
   UNSIGNED hora;
   UNSIGNED felicidade;
END;
new_fel_rec MudarNomeCol3(mytab_rec Le) := TRANSFORM
  SELF.felicidade := Le.cnt;
  SELF := Le;
END;
new_fel := PROJECT(fel, MudarNomeCol3(LEFT));
// new_fel;

engr := mytab(emotion = 'engracado');
new_engr_rec := RECORD
   UNSIGNED hora;
   UNSIGNED engracado;
END;
new_engr_rec MudarNomeCol4(mytab_rec Le) := TRANSFORM
  SELF.engracado := Le.cnt;
  SELF := Le;
END;
new_engr := PROJECT(engr, MudarNomeCol4(LEFT));
// new_engr;

joined1_rec := RECORD
  new_raiv;
  new_torc.torcida;
END;
joined1_rec Mytransf1(new_raiv_rec Le, new_torc_rec Ri) := TRANSFORM
  SELF := Le;
  SELF := Ri;
END;
joined1 := JOIN(new_raiv,new_torc,LEFT.hora=RIGHT.hora,Mytransf1(LEFT,RIGHT),FULL OUTER);
// joined1;

joined2_rec := RECORD
  joined1;
  new_fel.felicidade;
END;
joined2_rec Mytransf2(joined1_rec Le, new_fel_rec Ri) := TRANSFORM
  SELF := Le;
  SELF := Ri;
END;
joined2 := JOIN(joined1,new_fel,LEFT.hora=RIGHT.hora,Mytransf2(LEFT,RIGHT),FULL OUTER);
// joined2;

joined3_rec := RECORD
  joined2;
  new_engr.engracado;
END;
joined3_rec Mytransf3(joined2_rec Le, new_engr_rec Ri) := TRANSFORM
  SELF := Le;
  SELF := Ri;
END;
joined3 := JOIN(joined2,new_engr,LEFT.hora=RIGHT.hora,Mytransf3(LEFT,RIGHT),FULL OUTER);
joined3;

norm_rec := RECORD
  UNSIGNED hora;
  REAL torc_;
  REAL raiv_;
  REAL fel_;
  REAL engr_;
END;
norm_rec Normalizar(joined3_rec Le) := TRANSFORM
  SELF.torc_ := Le.torcida / (Le.torcida + Le.raiva + Le.felicidade + Le.engracado);
  SELF.raiv_ := Le.raiva / (Le.torcida + Le.raiva + Le.felicidade + Le.engracado);
  SELF.fel_ := Le.felicidade / (Le.torcida + Le.raiva + Le.felicidade + Le.engracado);
  SELF.engr_ := Le.engracado / (Le.torcida + Le.raiva + Le.felicidade + Le.engracado);
  SELF := Le;
END;
norm := PROJECT(joined3, Normalizar(LEFT));
norm;

acum_rec := RECORD
  UNSIGNED hora;
  REAL torc;
  REAL raiv;
  REAL fel;
  REAL engr;
END;
acum_rec Acumular(norm_rec Le) := TRANSFORM
  SELF.torc := Le.torc_ + Le.fel_ + Le.engr_;
  SELF.raiv := Le.torc_ + Le.raiv_ + Le.fel_ + Le.engr_;
  SELF.fel := Le.fel_ + Le.engr_;
  SELF.engr := Le.engr_;
  SELF := Le;
END;
acum := PROJECT(norm, Acumular(LEFT));
acum;

OUTPUT(acum,,'~joined',overwrite);

acum2_rec := RECORD
  UNSIGNED hora;
  UNSIGNED torc;
  UNSIGNED raiv;
  UNSIGNED fel;
  UNSIGNED engr;
END;
acum2_rec Acumular2(joined3_rec Le) := TRANSFORM
  SELF.torc := Le.torcida + Le.felicidade + Le.engracado;
  SELF.raiv := Le.torcida + Le.raiva + Le.felicidade + Le.engracado;
  SELF.fel := Le.felicidade + Le.engracado;
  SELF.engr := Le.engracado;
  SELF := Le;
END;
OUTPUT(PROJECT(joined3, Acumular2(LEFT)),,'~sem_acum',overwrite);
