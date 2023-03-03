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

inds:=inds1 + inds2 + inds3 + inds4 + inds5 + inds6 + inds7 + inds8 + inds9;
inds;
COUNT(inds);
