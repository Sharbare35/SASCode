
%let CafeSurvey1 = 
k:\ihc\food\food2013\fs2013;


PROC IMPORT OUT= WORK.CafeteriaSurvey1  
            DATAFILE= "&CafeSurvey1" 
            DBMS=DBF REPLACE;
     GETDELETED=NO;
RUN;
/*
data work.cafeteriasurveyS; set work.cafeteriasurvey1;
	hosp=900; dept=900; hospdept=900900;
run;
data work.cafeteriasurvey1; set work.cafeteriasurvey1 work.cafeteriasurveyS;
run;
*/


proc format;
  value datef
        20040401 = Spring 2004
        20040901 = Fall 2004 
        20050401 = Spring 2005
		20050930 = Fall 2005
		20060930 = Fall 2006
		20070930 = Fall 2007
		20080930 = Fall 2008
		20090531 = Spring 2009
		20100930 = Fall 2010
		20110930 = Fall 2011
		20120930 = Fall 2012
		20130930 = Fall 2013;


	value sitef
		1  =	'Alta View Cafeteria'
		2 =		'American Fork Cafeteria'
		3 =     'American Fork Snack Bar'
		5 =		'Dixie - East Cafeteria'
		6 =		'Dixie - River Road'
		8 =		'LDS Cafeteria'
		9 =		'Logan Cafeteria'
		10 =	'MKD Mountain View Café'
		11 =	'MKD BHI Cafeteria'
		12 =	'Orem Community Cafeteria'
		13 = 	'PCMC Cafeteria'
        14 = 	'PCMC Snack Bar'
		15	=	'UVRMC Cafeteria'
		16	=	'UVRMC Café West'
		17  = 	'Valley View Cafeteria'
		19	=	'TOSH Snack Bar'
		21	=	'ARMOC - Stonebridge'
		22	=	'Lake Park - The HUB'
		23	=	'IMED Cafeteria'
		24	=	'IMED Kiosk #1'
		25  = 	'Supply Chain Center Kiosk'
		26  = 	'Riverton Wind River Grill Cafe'
		27  = 	'SelectHealth Kiosk'
		28  = 	'LDS The Grove Cafe'
		29  = 	'Alta View Kiosk'
		30  =   'Salt Lake Clinic Cafe'
		;
 
 
  value hospf
      116 = Alta View 
      118 = AF 
      124 = CW 
      126 = DX 
      128 = LDS 
      130 = Logan 
      132 = MKD 
      134 = Orem 
      138 = PCMC 
      144 = UVRMC 
      146 = VView 
	  370 =	TOSH
	  107 =	ARMOC
	  610 =	Lake Park
	  154 =	IMED
	  139 = Riverton
	  500 = Salt Lake;
      ;
  value deptf
      604 = Cafeteria
      605 = Snack Bar
	  606 = Cafeteria
	  608 = RR Cafeteria
	  609 = Kiosks
	  610 = Kiosk
	  611 = Clinic Cafe
      ;
  value hospdept
      
      126606 = 'DX East Cafeteria'
      132606 = 'MKD BHI Cafeteria'
      144606 = 'UVRMC Cafe West'
	  114606 = 'Lake Park - The HUB'
	  154606 = 'IMED Cafeteria'
	  107606 = 'ARMOC - Stonebridge'
	  139606 = 'Riverton Wind River Grill Cafe'
	  610606 = 'SelectHealth Kiosk'
	  116609 = 'Alta View Kiosk'
	  128606 = 'LDS The Grove Cafe'
	  118605 = 'American Fork Snack Bar'
	  154610 = 'Supply Chain Center Kiosk'
	  500611 = 'Salt Lake Clinic Cafe'
	  900900 = 'All Food Sites'
	  
	  ;
value employf
		2 = No
		1 = Yes
		;
  value mealf
        1 = Breakfast
        2 = Lunch
        3 = Dinner
        4 = After 8 PM
		5,6,7,8= delete;

  value qresp5f
        1 = Poor
        2 = Fair
        3 = Good
        4 = Very Good
        5 = Excellent;
run;

data CafeteriaSurvey;
  set CafeteriaSurvey1(drop=improve dowell type);
    length sitename $42;
    array dat(10) flavor clean handle helpful speed choice appear health price employ;
    do i=1 to 10;
       if dat(i)=0 then dat(i)=.;    /* set zeros to missing values */
    end;
	if meal>4 then meal=.;
	if meal<1 then meal=.;
    hospdept=hosp*1000+dept;
    SiteName=trim(put(hosp,hospf.))!!' '!!trim(put(dept,deptf.));
    if dept=606 then SiteName=put(hospdept,hospdept.);
	if hospdept=154610 then SiteName=put(hospdept,hospdept.);
	if hospdept=900900 then SiteName=put(hospdept,hospdept.);

    if a then SiteName=put(site,sitef.);
run;

data CafeteriaSurveyS;
  set CafeteriaSurvey1(drop=improve dowell type);
    array dat(10) flavor clean handle helpful speed choice appear health price employ;
    do i=1 to 10;
       if dat(i)=0 then dat(i)=.;    /* set zeros to missing values */
    end;
	if meal>4 then meal=.;
	if meal<1 then meal=.;
    hospdept=hosp*1000+dept;
    SiteName=trim(put(hosp,hospf.))!!' '!!trim(put(dept,deptf.));
    if dept=606 then SiteName=put(hospdept,hospdept.);
	if dept=610 then SiteName=put(hospdept,hospdept.);
	if hospdept=900900 then SiteName=put(hospdept,hospdept.);

    if a then SiteName=put(site,sitef.);
run;

 

proc datasets library=work;
     modify CafeteriaSurvey;
         label date     = Date
           /*  site     = Food Services Site  */
               employ   = Customer is Employee
               meal     = Meal survey reflects
               flavor   = Flavor/Texture
               clean    = Cleanliness
               handle   = Food Handling
               helpful  = Employee Helpfulness
               speed    = Speed of Service
               choice   = Number of Food Choices
               appear   = Appearance of Food
               health   = Availability of Healthy Choices
               price    = Price
              ;
         format flavor clean handle helpful speed choice appear health price qresp5f.
                date datef. /* site sitef. */ employ employf. meal mealf.;
run; 
quit;

  *** Individual Cafeterias *************************;
proc means data=CafeteriaSurvey noprint nway; 
     class sitename date; 
     var flavor clean handle helpful speed choice appear health price;
     output out=CafeteriaSummary 
            mean= 
            var=VarFlavor VarClean VarHandle VarHelpful VarSpeed 
                VarChoice VarAppear VarHealth VarPrice
              n=NFlavor NClean NHandle NHelpful NSpeed 
                NChoice NAppear NHealth NPrice;
run; 

  *** Cafeteria by Customer *************************;
proc freq data=CafeteriaSurvey; 
    tables date / noprint out=FreqDate;
run; 
data _null_;
  set FreqDate end=eof;
  by date;
  if eof; 
  call symput("LastDate",date);
run;
%put &LastDate;


proc means data=CafeteriaSurvey (where=(date=&lastdate)) noprint nway; 
     class sitename employ; 
     var flavor clean handle helpful speed choice appear health price;
     output out=EmploySummary 
            mean= 
            var=VarFlavor VarClean VarHandle VarHelpful VarSpeed 
                VarChoice VarAppear VarHealth VarPrice
              n=NFlavor NClean NHandle NHelpful NSpeed 
                NChoice NAppear NHealth NPrice;
run; 


  *** Summary Cafeterias by Customer *************************;
proc means data=EmploySummary noprint nway; 
     class employ; 
     var flavor clean handle helpful speed choice appear health price;
     output out=EmployTotal 
            mean=AveFlavor AveClean AveHandle AveHelpful AveSpeed 
                 AveChoice AveAppear AveHealth AvePrice 
            var=AveVarFlavor AveVarClean AveVarHandle AveVarHelpful AveVarSpeed 
                AveVarChoice AveVarAppear AveVarHealth AveVarPrice
              n=AveNFlavor AveNClean AveNHandle AveNHelpful AveNSpeed 
                AveNChoice AveNAppear AveNHealth AveNPrice;
run; 


  *** Summary of all Cafeterias *********************;
proc means data=CafeteriaSurvey noprint nway; 
     class date; 
     var flavor clean handle helpful speed choice appear health price;
     output out=CafeteriaTotal   
            mean=AveFlavor AveClean AveHandle AveHelpful AveSpeed 
                 AveChoice AveAppear AveHealth AvePrice 
            var=AveVarFlavor AveVarClean AveVarHandle AveVarHelpful AveVarSpeed 
                AveVarChoice AveVarAppear AveVarHealth AveVarPrice
              n=AveNFlavor AveNClean AveNHandle AveNHelpful AveNSpeed 
                AveNChoice AveNAppear AveNHealth AveNPrice;
run;

/*new for page 12 SPLIT OUT BY MEAL*/
 *** Cafeteria by Customer *************************;
proc freq data=CafeteriaSurvey; 
    tables date / noprint out=FreqDate;
run; 
data _null_;
  set FreqDate end=eof;
  by date;
  if eof; 
  call symput("LastDate",date);
run;
%put &LastDate;
* %let lastdate = 20050401;         
proc means data=CafeteriaSurvey (where=(date=&lastdate)) noprint nway; /*new for page 12 SPLIT OUT BY MEAL*/
     class sitename Meal; 
     var flavor clean handle helpful speed choice appear health price;
     output out=MealSummary 
            mean= 
            var=VarFlavor VarClean VarHandle VarHelpful VarSpeed 
                VarChoice VarAppear VarHealth VarPrice
              n=NFlavor NClean NHandle NHelpful NSpeed 
                NChoice NAppear NHealth NPrice;
run; 

*** Summary Cafeterias by meal *************************;
proc means data=MealSummary noprint nway; 
     class meal; 
     var flavor clean handle helpful speed choice appear health price;
     output out=MealTotal 
            mean=AveFlavor AveClean AveHandle AveHelpful AveSpeed 
                 AveChoice AveAppear AveHealth AvePrice 
            var=AveVarFlavor AveVarClean AveVarHandle AveVarHelpful AveVarSpeed 
                AveVarChoice AveVarAppear AveVarHealth AveVarPrice
              n=AveNFlavor AveNClean AveNHandle AveNHelpful AveNSpeed 
                AveNChoice AveNAppear AveNHealth AveNPrice;
run; 


  *** Summary of all Cafeterias *********************;/*do I need to run this again?*/
/*proc means data=CafeteriaSurvey noprint nway; 
     class date; 
     var flavor clean handle helpful speed choice appear health price;
     output out=CafeteriaTotal   
            mean=AveFlavor AveClean AveHandle AveHelpful AveSpeed 
                 AveChoice AveAppear AveHealth AvePrice 
            var=AveVarFlavor AveVarClean AveVarHandle AveVarHelpful AveVarSpeed 
                AveVarChoice AveVarAppear AveVarHealth AveVarPrice
              n=AveNFlavor AveNClean AveNHandle AveNHelpful AveNSpeed 
                AveNChoice AveNAppear AveNHealth AveNPrice;
run;*/

LIBNAME GFONT0 'c:\CAT810';
data arrowfont;
   input char $ x y segment ptype $ lp $;
   CARDS;
C   0  50 1 V P
C  30  70 1 V P
C  35  65 1 V P
C  20  55 1 V P
C  65  55 1 V P
C  65  45 1 V P
C  20  45 1 V P
C  35  35 1 V P
C  30  30 1 V P
A   0  50 1 V P
A  30  80 1 V P
A  40  70 1 V P
A  27  57 1 V P
A  70  57 1 V P
A  70  43 1 V P
A  27  43 1 V P
A  40  30 1 V P
A  30  20 1 V P
>  70  50 1 V P
>  40  80 1 V P
>  30  70 1 V P
>  43  57 1 V P
>   0  57 1 V P
>   0  43 1 V P
>  43  43 1 V P
>  30  30 1 V P
>  40  20 1 V P 
D  50  70 1 V L
D  70  50 1 V L
D  50  30 1 V L
D  30  50 1 V L
D  50  70 1 V L
F  50  70 1 V P
F  70  50 1 V P
F  50  30 1 V P
F  30  50 1 V P
F  50  70 1 V P
;
proc gfont data=arrowfont
           name=arrow
           filled
           SHOWROMAN
           NODISPLAY;
run;

