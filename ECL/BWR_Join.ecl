inrec := RECORD
  STRING edit_history_tweet_ids;
	STRING id;
	STRING text;
END;


inds1 := DATASET('~14.01_1830.json',inrec,JSON('data'));
inds2 := DATASET('~14.01_1845.json',inrec,JSON('data'));
inds3 := DATASET('~14.01_1900.json',inrec,JSON('data'));
inds4 := DATASET('~14.01_1915.json',inrec,JSON('data'));
inds5 := DATASET('~14.01_1930.json',inrec,JSON('data'));
inds6 := DATASET('~14.01_1945.json',inrec,JSON('data'));
inds7 := DATASET('~14.01_2000.json',inrec,JSON('data'));
inds8 := DATASET('~14.01_2015.json',inrec,JSON('data'));
inds9 := DATASET('~14.01_2030.json',inrec,JSON('data'));

rec1 := RECORD
  hora := '1830';
  inds1.id;
  inds1.text;
END;

rec2 := RECORD
  hora := '1845';
  inds2.id;
  inds2.text;
END;

rec3 := RECORD
  hora := '1900';
  inds3.id;
  inds3.text;
END;

rec4 := RECORD
  hora := '1915';
  inds4.id;
  inds4.text;
END;

rec5 := RECORD
  hora := '1930';
  inds5.id;
  inds5.text;
END;

rec6 := RECORD
  hora := '1945';
  inds6.id;
  inds6.text;
END;

rec7 := RECORD
  hora := '2000';
  inds7.id;
  inds7.text;
END;

rec8 := RECORD
  hora := '2015';
  inds8.id;
  inds8.text;
END;

rec9 := RECORD
  hora := '2030';
  inds9.id;
  inds9.text;
END;

inds1_hora := TABLE(inds1,rec1); 
inds2_hora := TABLE(inds2,rec2); 
inds3_hora := TABLE(inds3,rec3); 
inds4_hora := TABLE(inds4,rec4); 
inds5_hora := TABLE(inds5,rec5); 
inds6_hora := TABLE(inds6,rec6); 
inds7_hora := TABLE(inds7,rec7); 
inds8_hora := TABLE(inds8,rec8); 
inds9_hora := TABLE(inds9,rec9); 

inds:=inds1_hora + inds2_hora + inds3_hora + inds4_hora + inds5_hora + inds6_hora + inds7_hora + inds8_hora + inds9_hora;
inds_sort := SORT(inds,hora);
inds_sort;
// COUNT(inds_sort);
OUTPUT(inds_sort,,'~inds_14.01',overwrite);