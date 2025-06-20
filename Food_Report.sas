 /* Run these lines to allocate cafeteria folder and read data; */
filename cafe "k:\ihc\food\food2013\";
* filename cafe "c:\patdata\fs";
 %include cafe('ReadData.sas');


goptions reset=all;
options nodate nonumber;
options nogstyle;

   /* Run options */
%let Threshold=1;
%let ShowNames = Yes; * Yes or No - to show names on left side on pages 1-9 ; 

*GOPTIONS ROTATE=PORTRAIT DEVICE=WINPRTC duplex   ; * Output to color printer duplex;
*goptions noduplex device=winprtc;                  * Output to color printer;
goptions noduplex ROTATE=PORTRAIT /*device=win targetdevice=winprtc*/; * Output to screen;

*goptions reset=all;


%macro CafeRep(msite);
    proc catalog cat=work.gseg kill; run; quit;       * Clear graphics catalog;

    %include cafe('Question Index.sas');
    %include cafe('Pages 1-9.sas');	
    %include cafe('Page 10.sas');
    %include cafe('Page 11.sas');
    %include cafe('Page 12.sas');
    run; 
	
goptions GSFMODE=APPEND;

	/* PDF CODE */   
		ods listing close;
		ods pdf file="k:\ihc\food\food2013\food2013pdf\&msite+Fall2013.pdf"; * Call this file whatever you want;
	        proc greplay igout=work.gseg nofs; replay _all_; run; quit;
		ods pdf close;
		ods listing; 

%mend CafeRep;

  /*
  When running individual cafeterias (not entire list), 
  block code to this line and submit;
  then block individual cafeteria and submit 
  */

%CafeRep(Salt Lake Clinic Cafe);
%CafeRep(Alta View Kiosk); *page 12_n2.sas for page 12;
 
%CafeRep(Alta View Cafeteria);
%CafeRep(SelectHealth Kiosk);
%CafeRep(Lake Park - The HUB);
%CafeRep(IMED Cafeteria);
%CafeRep(SelectHealth Kiosk);
%CafeRep(Riverton Wind River Grill Cafe);
%CafeRep(SelectHealth Kiosk);
%CafeRep(IMED Kiosks);
%CafeRep(Lake Park - The HUB);

 %CafeRep(AF Cafeteria);
 %CafeRep(DX East Cafeteria);
 %CafeRep(DX RR Cafeteria);
 %CafeRep(LDS Cafeteria);
 %CafeRep(Logan Cafeteria);
 %CafeRep(MKD Cafeteria);
 %CafeRep(Orem Cafeteria);
 %CafeRep(UVRMC Cafeteria);
 %CafeRep(UVRMC Cafe West);
 %CafeRep(TOSH Snack Bar);
 %CafeRep(IMED Cafeteria);
 %CafeRep(PCMC Cafeteria);
 %CafeRep(PCMC Snack Bar);
 %CafeRep(VView Cafeteria);
 %CafeRep(LDS The Grove Cafe);
 %CafeRep(Alta View Kiosk);
 %CafeRep(AF Snack Bar);
 %CafeRep(Supply Chain Center Kiosk);
 



**%CafeRep(ARMOC - Stonebridge);*no data 2010,2011,2012,2013;
**%CafeRep(MKD BHI Cafeteria);*no data 2011,2012,2013;
