%let text1 = 'Arial';  *swiss;   *Body;
%let text2 = 'Arial/bold';  *Header;
%let text3 = 'Arial/italic';  

  /*  * Macros for Test runs;

 %let mvar  = flavor; * flavor clean handle helpful speed choice appear health price;
 %let mpage = 1;
 %let lastdate = 20050930; 

 %let msite = LDS Cafeteria;
 %let ShowNames = 'Yes'; * Yes or No ; 
  */

%MACRO Page1(mvar,mpage);

proc sort data=CafeteriaSummary
               (where=(date=&lastdate))   
                out=AnnoPage&mpage; 
                by &mvar;
run;
data  null_;
     set CafeteriaSummary;   
        if SiteName="&msite" and date=&lastdate;
     call symput('CafeteriaAverage' ,&Mvar);
     call symput('CafeteriaVar'     ,Var&Mvar);
     call symput('CafeteriaN'       ,N&Mvar);
 run;
    %put &CafeteriaAverage;
    %put &CafeteriaVar;
    %put &CafeteriaN;
run;

data _null_; 
     set CafeteriaTotal
         (where=(date=&lastdate));
     call symput('TotalAverage' ,Ave&Mvar);
     call symput('TotalVar'     ,AveVar&Mvar);
     call symput('TotalN'       ,AveN&Mvar);
 run;
    %put &TotalAverage;
    %put &TotalVar;
    %put &TotalN;

%let mcompare=&TotalAverage;

******************************************************************************;

data AnnoPage&mpage;
   set AnnoPage&mpage
       nobs=CafeteriaCount end=eof;  
   doc+1;
   length function color style $25 text $200;
   retain StartBarsY  9 EndBarsY 85  Yposition 10
          StartBarsX 25 EndBarsX 90  
          BarToSpaceRatio .7 
          xsys ysys hsys '3'
          FirstGrayBar LastGrayBar 1 FoundFirstGrayBar 0
          signif 1.645; ** .2 = 1.282 , .1 = 1.645 , .05 = 1.96 ;
   if "&ShowNames"='Yes' then StartBarsX=35;
   if put(site,sitef.)="&msite" then select=1;
   if         SiteName="&msite" then select=1;

   ScaleResponse=((&mvar-2)/(5-2))*(EndBarsX-StartBarsX);
   CafeT=(&mvar-&CafeteriaAverage)/
     ((Var&mvar/N&mvar)+(&CafeteriaVar/&CafeteriaN))**.5; 
   TotalT=(&mvar-&TotalAverage)/
     ((Var&mvar/N&mvar)+(&TotalVar/&TotalN))**.5; 

   color='Black'; 
   if      50<=CafeteriaCount    then WidthKeyBar=1.5;  ** Width of Site Red Bar;
   else if 30<=CafeteriaCount<50 then WidthKeyBar=2.0;
   else if 30<=CafeteriaCount<50 then WidthKeyBar=3.0;
   else if 15<=CafeteriaCount<30 then WidthKeyBar=3.0;
   else if     CafeteriaCount<15 then WidthKeyBar=6.0;
   KeyBarSpace=1;

   BarWidth=((EndBarsY-StartBarsY -2*KeyBarSpace)*   BarToSpaceRatio) /(CafeteriaCount); 
   BarSpace=((EndBarsY-StartBarsY -2*KeyBarSpace)*(1-BarToSpaceRatio))/(CafeteriaCount); 
               
   KeyBarSpace=BarSpace;
   WidthKeyBar=BarWidth;

   if select=1 then do;
     function='label'; color='black'; style="&text1"; 
        x=92; y=99; style="&text1" ;  position='5'; text='CHART';  size=0.9; output;  
        x=92; y=97; style="&text2";  position='5'; text="&mpage"; size=3.0; output;
        color='red';
        x=92; y=94; style="&text2";  position='5';
		if sitename="Riverton Wind River Grill Cafe" then x=90; 
        text=sitename; size=1.2; output;/*here*/
        color='black';

        x=50; y=95; style="&text2";  position='B'; 
              text="Food Services Comparison Across Sites";
			  size=2.3; output;
        x=50; y=93; style="&text2";   position='5'; 
              text= vlabel(&mvar);
              size=2.3; output;
        x=50; y=90.5; style="&text2";   position='5'; 
              text="%sysfunc(putn(&lastdate,datef.))";
              size=1.7; output;                    
        x=50; y=88.5; position='5'; style="&text3"; size=1.5;
           color='blue';
           text='Blue indicates a statistically significant difference between that '!!
                'score and your score'; output;**here;
           y=EndBarsY+.3; x=50; position='2';
           text='Each bar represents a food service site';    
           color='black'; style="&text1";output;
           size=1; y=EndBarsY; position='5'; size=1.2;
           text='N'; x=StartBarsX-8;    output;
           text='Mean'; x=StartBarsX-2.5; output;

       /* X axis labels */
       do i= 2 to 5;
          size=1.5; color='black';
          position='8'; x=StartBarsX + ((i-2)/(5-2)) * (EndBarsX-StartBarsX); 
                        y=StartBarsY-1;
          *function='label'; *text=put(i,QRESP5F9.); *style="&text2"; *output;
		  function='label'; text=put(i,QRESP5F9.); style="&text1"; output;
          size=1.5; color='black';
         position='5'; x=StartBarsX + ((i-2)/(5-2)) * (EndBarsX-StartBarsX); 
		                          y=StartBarsY-1;
        /*  function='label'; text=put(i,1.); style="&text2"; output; */
		  function='label'; text=put(i,1.); style="&text1"; output;
          position='5'; size=1;                                         * reset parms;
       end;

       /* axis lines */
       color='black'; size=.2;
       function='move'; x=StartBarsX; y=StartBarsY; output;  * x axis line;
       function='draw'; x=EndBarsX  ;               output;
       function='move'; x=StartBarsX; y=StartBarsY; output;  * y axis line;
       function='draw'; y=EndBarsY  ;               output;

       /* footnote */ 
       style='empty'; color='black'; 
       function='poly';     x=25+0; y=1+0; output;
       function='polycont'; x=25+1; y=1+1; output;
       function='polycont'; x=25-1; y=1+1; output;
       function='polycont'; x=25+0; y=1+0; output;

       text='= Average score for all food service sites combined';     
       /*  function='label'; color='black'; style="&text1"; size=1.2; */
		 function='label'; color='black'; style="&text1"; size=1.5;
         x=27; y=2; style="&text1" ;  position='6'; 
       output;  

   end;

   /* Code to help detect non-contiguous significant bars */
      if not FoundFirstGrayBar and CafeT>(-signif) then do;
         FirstGrayBar=doc;
         FoundFirstGrayBar=1;
      end;
   if CafeT<signif then LastGrayBar=doc;

   /* Response Bar */
   function='move'; size=1; color='black';
       if      _n_=1 and select then Yposition=StartBarsY+Barspace;
       else if _n_=1            then Yposition=StartBarsY+KeyBarSpace;
       else if           select then Yposition+KeyBarSpace-Barspace;
       y=Yposition;   x=StartBarsX;          output;
   function='bar'; 
       style='Solid'; color='H000BF00'; line=0;
       if abs(CafeT)>signif then color='blue';
       if select then do; style='Solid'; color='red'; end;
       if select then y=y+WidthKeyBar;
       else           y=y+BarWidth;
       x=StartBarsX+Scaleresponse; output;  
   x=StartBarsX; y=Yposition; color='Black'; style='Empty';   output;   * black outline;

   *** Average triangles ************************************************************;
   if select then do;
      line=1;
       CAverage = ((&Mcompare -2)/(5-2))*(EndBarsX-StartBarsX);
        function='poly'; 
          x=StartBarsX+CAverage; 
          y=Yposition+.5*WidthKeyBar;   style='solid';
          if abs(TotalT)>signif then color='blue'; else color='H000BF00';
          output;
        function='polycont';  color='black';
          x=StartBarsX+CAverage+.5*WidthKeyBar;
          y=Yposition;             y=Yposition+WidthKeyBar;
          output;      
        function='polycont';
          x=StartBarsX+CAverage-.5*WidthKeyBar;
          y=Yposition;             y=Yposition+WidthKeyBar;
          output;      
        function='polycont'; 
          x=StartBarsX+CAverage; 
          y=Yposition+.5*WidthKeyBar;
          output;
        function='label';
          x=StartBarsX+CAverage;
          y=Yposition-.5*KeyBarSpace+.3;   y=Yposition+WidthKeyBar+.3; 
          text="All Sites Combined"; size=1.0; style="&text1"; position='B'; color='black';
          output;
          when='B';
   end;

   /* Bar means */
      function='label'; style="&text1"; size=1.5; color='black'; 
      y=Yposition+.5*(BarWidth); 

      x=StartBarsX-4;  text=put(&mvar,4.2); position='6'; output;
      x=StartBarsX-10; text=put(N&Mvar,4.); position='6'; output;
      if "&ShowNames"='Yes' and not select then do;
        x=StartBarsX-12; text=sitename; position='4'; size=1.5; output; 
      end;

   /* Your Score Arrow */
   if select then do;
      function='label'; size=1.5; style="&text2"; x=StartBarsX-22;
          text='Your Score';  position='6';  output;   
      style='Arrow'; text='>'; 
      x=StartBarsX-12;      
        position='6'; output;  
   end;

   Yposition + BarSpace    + BarWidth   ; 

   if eof then do;
      call symput('FirstGrayBar',FirstGrayBar);
      call symput('LastGrayBar',LastGrayBar);
   end;
run; 

   /* Adjust for bar significance not being contiguous */
    data AnnoPage&mpage; set AnnoPage&mpage end=eof;
       if doc>&FirstGrayBar and CafeT < (-signif) and function='bar' and color='blue' 
          then color='H000BF00';
       if doc<&LastGrayBar and CafeT > signif and function='bar' and color='blue' 
          then color='H000BF00';
     size=size*(1.25/1.48);
     page="page &mpage";
    run; 

proc ganno anno=AnnoPage&mpage name=page;  
run;
options obs=max;
%mend page1;

%Page1(flavor,1);
%Page1(clean,2);
%Page1(handle,3);
%Page1(helpful,4);
%Page1(speed,5);
%Page1(choice,6);
%Page1(appear,7);
%Page1(health,8);
%Page1(price,9);
   
