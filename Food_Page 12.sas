/* IF you want to change the THRESHOLD for this page, you need to change lines 175,201,211 and 235.  Normally set at N=3*/


%let text1 = 'Arial';  *swiss;   *Body;
%let text2 = 'Arial/bold';  *Header;
%let text3 = 'Arial/italic';  
 
%macro page11(items,mpage);

  /*   * Test macros;
  %let msite = Alta View Cafeteria;
  %let items=flavor clean handle helpful speed choice appear health price;

  %let mpage=11;
  %let lastdate = 20050431;
  %let Threshold=1;
  */

%let VariableCount=9;
%let Orderedvars = flavor clean handle helpful speed choice appear health price;
%let OrdVariance = VarFlavor VarClean VarHandle VarHelpful VarSpeed 
                   VarChoice VarAppear VarHealth VarPrice;
%let OrdN        = NFlavor NClean NHandle NHelpful NSpeed NChoice NAppear NHealth NPrice;

%let TotMean     = AveFlavor AveClean AveHandle AveHelpful AveSpeed 
                   AveChoice AveAppear AveHealth AvePrice ;
%let TotVariance = AveVarFlavor AveVarClean AveVarHandle AveVarHelpful AveVarSpeed 
                   AveVarChoice AveVarAppear AveVarHealth AveVarPrice;
%let TotN        = AveNFlavor AveNClean AveNHandle AveNHelpful AveNSpeed 
                   AveNChoice AveNAppear AveNHealth AveNPrice;


data subset; 
     merge MealSummary(where=(sitename="&msite") 
                         rename=(_freq_=p_freq_))
           MealTotal;  
           by Meal; 
run;


data subset2; set subset;
    if p_freq_ ge &threshold;  
run; 

data annopage&mpage; set subset2;
   length function color style $25 label text $200;
   retain StartBarsY 10 EndBarsY 85  Yposition 10
          StartBarsX 35 EndBarsX 95  
          BarToSpaceRatio1   0       /* Space between bars as % of bar width */
          BarToSpaceRatio2  .5       /* Space between groups  as % of bars width */
          EndsSpaceRatio    .5       /* Space at beginnin and end as % of bars width */
          TimePeriods        4       /* Number of time periods per question */
          xsys ysys '3'
          signif 1.645; ** .2 = 1.282 , .1 = 1.645 , .05 = 1.96 ;
   obs=_n_;
   if _n_<=TimePeriods;   /* If time periods exceed desired, then delete them; */
   Questions=&VariableCount;
   color='Black'; 
   BarEquivalent = Questions*TimePeriods + 
                   Questions*(TimePeriods-1)*BarToSpaceRatio1 + 
                   (Questions-1)*BarToSpaceRatio2 +
                   2*EndsSpaceRatio; 
   BarWidth  =(EndBarsY-StartBarsY)/BarEquivalent * 1.0;              * Width of Bars;
   BarSpace1 =(EndBarsY-StartBarsY)/BarEquivalent * BarToSpaceRatio1; * Space between bars;
   BarSpace2 =(EndBarsY-StartBarsY)/BarEquivalent * BarToSpaceRatio2; * Space between bars groups;
   EndSpace  =(EndBarsY-StartBarsY)/BarEquivalent * EndsSpaceRatio;   * Beg/End spaces;

 /* Headers and Titles */

   if _n_=1 then do;
     function='label'; color='black'; style="&text1"; 
        x=92; y=99; style="&text1" ;  position='5'; text='CHART';    size=0.6; output;  
        x=92; y=97; style="&text2";  position='5'; text="&mpage";    size=2.0; output;
        color='red';
        x=92; y=94; style="&text2";  position='5'; if sitename="Riverton Wind River Grill Cafe" then x=88; 
		text=sitename; size=0.8; output;
        color='black';

        x=50; y=96; style="&text2";  position='B'; 
              text="Comparison of Meals";
             /* size=1.7; output;      position='E'; */
			  size=1.5; output;     

x=50; y=94.5; style="&text2";   position='5'; 
              text="%sysfunc(putn(&lastdate,datef.))";
              size=1.0; output;   
position='E';
        x=50; y=88; position='5'; style="&text1"; size=.9;
       color='blue';
           text='Blue indicates a statistically significant difference '!!
                'between that score and the average score';
                output;
           line=1; color='black';
       y=EndBarsY+1.5;  
       x=StartBarsX-3; text='Average';   position='5'; size=.8; style="&text1";* output;

  /* Legend        */

	 /*  'ORANGE'
'light yellowish orange'
'YELLOW'
'light orangish yellow'*/
          line=0; size=1;
		  color='black';    function='label'; y=91.6;  x=24; position='4'; style="&text1";
                            text='Breakfast'; output;
          color='light orangish yellow';    function='move';  y=90;  x=25; style='solid'; output;
                            function='bar';   y=92;  x=27;                output;  
          color='black';    function='bar';   y=90;  x=25; style='empty'; output;  

		  color='black';    function='label'; y=91.6;  x=39; position='4'; style="&text1";
                            text='Lunch'; output;
          color='YELLOW';    function='move';  y=90;  x=40; style='solid'; output;
                            function='bar';   y=92;  x=42;                output;  
          color='black';    function='bar';   y=90;  x=40; style='empty'; output;  

          color='black';    function='label'; y=91.6;  x=57; position='4'; style="&text1";
                            text='Dinner';     output;
          color='light yellowish orange';     function='move';  y=90;  x=58; style='solid'; output;
                            function='bar';   y=92;  x=60;                output; 
          color='black';    function='bar';   y=90;  x=58; style='empty'; output;


          color='black';    function='label'; y=91.6;  x=74; position='4'; style="&text1";
                            text='After 8';     output;
          color='ORANGE';     function='move';  y=90;  x=75; style='solid'; output;
                            function='bar';   y=92;  x=77;                output; 
          color='black';    function='bar';   y=90;  x=75; style='empty'; output;






                             
          line=1;
       function='label'; y=EndBarsY+0;
       x=StartBarsX-8; text='N';      position='5'; size=.8; style="&text1"; output;
       x=StartBarsX-4; text='Mean';   position='5'; size=.8; style="&text1"; output;

 /* X axis labels */
       do i= 2 to 5;
          size=1.0; color='black';
          position='8'; x=StartBarsX + ((i-2)/(5-2)) * (EndBarsX-StartBarsX); y=StartBarsY-1;
        /*  function='label'; text=put(i,QRESP5F9.); style="&text2"; output;*/
		  function='label'; text=put(i,QRESP5F9.); style="&text1"; output;
          size=1.0; color='black';
          position='5'; x=StartBarsX + ((i-2)/(5-2)) * (EndBarsX-StartBarsX); y=StartBarsY-1;
          function='label'; text=put(i,1.); style="&text2"; output;
          position='5'; size=1;                                         * reset parms;
       end;
       color='black'; size=3;
       function='move'; x=StartBarsX; y=StartBarsY; output;  * x axis line;
       function='draw'; x=EndBarsX  ;               output;
       function='move'; x=StartBarsX; y=StartBarsY; output;  * y axis line;
       function='draw'; y=EndBarsY  ;               output;

 /* footnote */ 
       text='= Average score for all food service sites combined';     
         
			 function='label'; color='black'; style="&text1"; size=1.0;
             x=27; y=4; style="&text1" ;  position='6'; 
           output;  
           style='empty'; color='black'; size=3;
           function='poly';     x=25+0; y=3+0; output;
           function='polycont'; x=25+1; y=3+1; output;
           function='polycont'; x=25-1; y=3+1; output;
           function='polycont'; x=25+0; y=3+0; output;
     
	  

   end;

   size=1;                            
   Yposition=EndBarsY-EndSpace;
   array   q(&VariableCount) &orderedvars;        * Question means;                  
   array   v(&VariableCount) &OrdVariance;        * Question variances;              
   array  vn(&VariableCount) &OrdN;               * Question N;                      
   array  rm(&VariableCount) &TotMean;            * Total means of questions;
   array  rv(&VariableCount) &TotVariance;        * Total variances of questions;
   array rn2(&VariableCount) &TotN;               * Total variances of questions;
   ncount=0;
   do i=1 to &VariableCount;
		if vn(i)<3 then  ncount=ncount+1;
   end;
   do i=1 to &VariableCount;
          label=vlabel(q(i));  
          Yposition=EndBarsY 
                    -(i-1)*(BarWidth*TimePeriods+
                           (TimePeriods-1)*BarSpace1+
                           BarSpace2)
                    -(obs-1)*(BarWidth+BarSpace1)
                    -3*EndSpace; 

          response=q(i); TotalMean=rm(i);
          ScaleResponse=((response -2)/(5-2))*(EndBarsX-StartBarsX);/*?*/
          TotalAverage =((TotalMean-2)/(5-2))*(EndBarsX-StartBarsX);
            
          lag1mean=lag1(q(i)); lag1var=lag1(v(i)); lag1n=lag1(vn(i));
          lag2mean=lag2(q(i)); lag2var=lag2(v(i)); lag2n=lag2(vn(i));


		  if obs=4 then color='ORANGE';
		  if obs=3 then color='light yellowish orange'; /*LIGHT orange*/
          if obs=2 then do
             ttest=(lag1mean-q(i))/((lag1var/lag1n)+(v(i)/vn(i)))**.5;
				color='YELLOW'; line=0;
		 	end;
          if obs=1 then color='LIGHT orangish YELLOW'; /*LIGHT orangish YELLOW*/
              if  vn(i)<3 then do; /*only print if n=3*/
			 end;
			 else do;
          		function='move'; y=Yposition;   x=StartBarsX;          output;
          		function='bar';  
                y=y+BarWidth; x=StartBarsX+Scaleresponse;  style='Solid'; output;  * response bars;
                y=Yposition;  x=StartBarsX; color='Black'; style='Empty'; output;  * black outline;
			 end;

 /* Bar means */
	    if  vn(i)<3 then do; /*only print if n=3*/
			 end;
			 else do;
          		function='label'; style="&text1"; size=.8; 
          		y=Yposition+.5*BarWidth+.5;  
          		x=StartBarsX- 5; text=put(response,4.2);  position='6'; output;
          		x=StartBarsX-10; text=put(vn(i),4.);      position='6'; output;
			 end;

 /* Question Text */        
          length text1 text2 s $40; 
          ii=1; text1=''; text2='';
          do until (s='');
             s=scan(label,ii,' ');  
             if length(text1)<15 then text1=trim(text1)!!' '!!s;
             else text2=trim(text2)!!' '!!s;
             ii+1;
          end;
       /*   x=3; *StartBarsX-13; size=1.1; y=Yposition; */
		  x=3; *StartBarsX-13; size=1.0; y=Yposition;
          color="black"; position='C'; text=text1; if obs=1 then output;             
          color="black"; position='F'; text=text2; if obs=1 then output;             
            
     /* Total Triangles */
		  if  vn(i)>2 then do;
          *if obs=1 then sign=1; *else SIGN=0; sign=1;
             when='A'; line=1;
             RegionAverage=((rm(i)-2)/(5-2))*(EndBarsX-StartBarsX);
             function='poly'; 
                 x=StartBarsX+TotalAverage; y=Yposition+.5*BarWidth;
                 TOTttest=(rm(i)-q(i))/((rv(i)/rn2(i)) + (v(i)/vn(i)))**.5; style='Solid';
                 if abs(TOTTTest)>signif then color='Blue'; else color='H000BF00';
                 output;
             function='polycont';  color='black';
               x=StartBarsX+TotalAverage+.5*BarWidth;
               y=Yposition+sign*Barwidth;
               output;      
             function='polycont';  color='black';
               x=StartBarsX+TotalAverage-.5*BarWidth;
               y=Yposition+sign*BarWidth;
               output;      
             function='polycont'; 
               x=StartBarsX+TotalAverage; 
               y=Yposition+.5*BarWidth;
               output;
             function='label';
               x=StartBarsX+TotalAverage;
               y=Yposition+1.35*sign*BarWidth-.1;;
     
			   text='All Sites Combined'; size=.5; style="&text1"; position='5'; color='black';
               output;
		end; *if  vn(i)>2 then do;
		
	   end;
	   /*Footnote*/
	    if ncount>0 then do;
	   text='* Scores for categories with fewer than 3 responses are not displayed';     
			 function='label'; color='black'; style="&text1"; size=1.0;
             x=25; y=2; style="&text1" ;  position='6'; 
           output;  
   end;

run;
data annopage&mpage; set annopage&mpage;
     page="page &mpage";
     size=size*(1.25/1.48);
run;

proc ganno anno=annopage&mpage(where=(y ge 0)); run;

%mend  page11;

%page11(flavor clean handle helpful speed achoice bappear chealth cprice,12);


