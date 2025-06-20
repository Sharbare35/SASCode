%let text1 = 'Arial';  *swiss;   *Body;
%let text2 = 'Arial/bold';  *Header;
%let text3 = 'Arial/italic';  

%macro page10(items,mpage);
      
  /*  
   * Macros for testing;
  %let msite = Alta View Cafeteria;
  %let msite = Logan Cafeteria;
  %let items=flavor clean handle helpful speed choice appear health price;
  %let mpage=10;
  %let Threshold=1;  
  */

proc transpose data=CafeteriaSummary(where=(SiteName="&msite" and date=&lastdate))    
               out=VarTranspose;
     var &items;  
     run;
     proc sort; by descending col1; run;
data _null_1; set VarTranspose end=eof;
     length OrderedVars OrdVariance  OrdN 
            TotMean     TotVariance  TotN  $150;
     Retain OrderedVars OrdVariance  OrdN 
            TotMean     TotVariance  TotN '';
     OrderedVars=trim(OrderedVars)!!' '!!compress(_name_);
     OrdVariance=trim(OrdVariance)!!' Var'!!compress(_name_);
     OrdN=trim(OrdN)!!' N'!!compress(_name_);
     TotMean     =trim(TotMean     )!!' Ave'!!compress(_name_);
     TotVariance =trim(TotVariance )!!' AveVar'!!compress(_name_);
     TotN        =trim(TotN        )!!' AveN'!!compress(_name_);

     vcnt+1;
     if eof then do;
        call symput('OrderedVars',OrderedVars);  
        call symput('OrdVariance',OrdVariance);  
        call symput('OrdN',OrdN);  
        call symput('VariableCount',vcnt);
        call symput('TotMean',TotMean);
        call symput('TotVariance',TotVariance);
        call symput('TotN',TotN);  
     end;
run;    
         /*  * check values;
             %put &msite;       %put &VariableCount; 
             %put &orderedvars; %put &ordvariance;  %put &OrdN;  
             %put &TotMean;     %put &TotVariance;  %put &TotN;
        */

data subset; 
     merge CafeteriaSummary(where=(SiteName="&msite") rename=(_freq_=p_freq_))
           CafeteriaTotal;  
           by date; run;
    proc sort; by descending date; run; 
data _null_; set subset; put date 9.; run; 

data subset2;    
     set subset; by descending date;
     if first.date then obs+1;
run;

data subset2; set subset2;
    if p_freq_ ge &Threshold;  
run; 
data annopage&mpage; set subset2;
   length function color style $25 label text $200;
   retain StartBarsY 8 EndBarsY 85  Yposition 10
          StartBarsX 30 EndBarsX 95  
          BarToSpaceRatio1  .45      /* Space between bars as % of bar width */
          BarToSpaceRatio2  2.0       /* Space between groups  as % of bars width */
          EndsSpaceRatio    .5       /* Space at beginnin and end as % of bars width */
          TimePeriods        4       /* Number of time periods per question */
          xsys ysys hsys '3'
          signif 1.645; ** .2 = 1.282 , .1 = 1.645 , .05 = 1.96 ;
   obs=_n_;
   if _n_<=TimePeriods;   /* If time periods exceed desired, then delete them; */
   Questions=&VariableCount;
   color='Black'; 
   BarEquivalent = Questions*TimePeriods + 
                   Questions*(TimePeriods-1)*BarToSpaceRatio1 + 
                   (Questions-1)*BarToSpaceRatio2 +
                   2*EndsSpaceRatio; 
   BarWidth  =(EndBarsY-StartBarsY)/BarEquivalent * 1.3;              * Width of Bars;* 1.0;
   BarSpace1 =0;*(EndBarsY-StartBarsY)/BarEquivalent * BarToSpaceRatio1; * Space between bars;
   BarSpace2 =(EndBarsY-StartBarsY)/BarEquivalent * BarToSpaceRatio2; * Space between bars groups;
   EndSpace  =(EndBarsY-StartBarsY)/BarEquivalent * EndsSpaceRatio;   * Beg/End spaces;
put BarEquivalent= BarWidth= BarSpace1= BarSpace2= EndSpace=;
   /* Headers and Titles */

     function='label'; color='black'; style="&text1"; 
        x=92; y=99; style="&text1" ;  position='5'; text='CHART';  size=0.9; output;  
        x=92; y=97; style="&text2";  position='5'; text="&mpage"; size=3.0; output;
        color='red';
        x=92; y=94; style="&text2";  position='5'; if sitename="Riverton Wind River Grill Cafe" then x=90; 
		text=SiteName; size=1.2; output;
        color='black';

        x=50; y=95; style="&text2";  position='B'; 
              text="Comparison of Your Scores Across Time";
              size=2.3; output;      position='E';
        x=50; y=93; position='5'; style="&text1"; size=1.2;
       color='blue';
           text='Blue indicates a statistically significant difference '!!
                'between that score and your current score';
                output;
           line=1; color='black';
       y=EndBarsY+1.5;  
       x=StartBarsX-8; text='N';      position='5'; size=1.2; style="&text1"; output;
       x=StartBarsX-4; text='Mean';   position='5'; size=1.2; style="&text1"; output;

       /* X axis labels */
       do i= 2 to 5;
          size=1.3; color='black';
          position='8'; x=StartBarsX + ((i-2)/(5-2)) * (EndBarsX-StartBarsX); y=StartBarsY-1;
          function='label'; text=put(i,QRESP5F9.); style="&text1"; output;
          size=1.5; color='black';
          position='5'; x=StartBarsX + ((i-2)/(5-2)) * (EndBarsX-StartBarsX); y=StartBarsY-1;
          function='label'; text=put(i,1.); style="&text2"; output;
          position='5'; size=1;                                         * reset parms;
       end;
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
		style="&text1";
       text='= Average score for all food service sites combined';     
         function='label'; color='black'; size=1.5;
         x=27; y=2;  position='6'; 
       output;  

   size=1;                           
   Yposition=EndBarsY-EndSpace;
   array   q(&VariableCount) &orderedvars;        * Question means;                  
   array   v(&VariableCount) &OrdVariance;        * Question variances;              
   array  vn(&VariableCount) &OrdN;               * Question N;                      
   array  rm(&VariableCount) &TotMean;            * Total means of questions;
   array  rv(&VariableCount) &TotVariance;        * Total variances of questions;
   array rn2(&VariableCount) &TotN;               * Total variances of questions;
   do i=1 to &VariableCount;
          label=vlabel(q(i));  
          Yposition=EndBarsY 
                    -(i-1)*(BarWidth*TimePeriods+
                           (TimePeriods-1)*BarSpace1+
                           BarSpace2)
                    -(obs-1)*(BarWidth+BarSpace1)
                    -2*EndSpace; 
          response=q(i); TotalMean=rm(i);
          ScaleResponse=((response -2)/(5-2))*(EndBarsX-StartBarsX);
          TotalAverage =((TotalMean-2)/(5-2))*(EndBarsX-StartBarsX);
            
          lag1mean=lag1(q(i)); lag1var=lag1(v(i)); lag1n=lag1(vn(i));
          lag2mean=lag2(q(i)); lag2var=lag2(v(i)); lag2n=lag2(vn(i));
            
          if obs=2 then
             ttest=(lag1mean-q(i))/((lag1var/lag1n)+(v(i)/vn(i)))**.5; 
          if obs=3 then
             ttest=(lag2mean-q(i))/((lag2var/lag2n)+(v(i)/vn(i)))**.5; 
          if obs=1 then color='RED'; 
             else do; 
                  color='H078EEFF'; line=0; 
                  if abs(ttest)>signif then color='blue';
             end; 
          function='move'; y=Yposition;   x=StartBarsX;          output;
          function='bar';  y=y+BarWidth;  x=StartBarsX+Scaleresponse; style='Solid'; output;  * response bars;
             x=StartBarsX; y=Yposition; color='Black'; style='Empty'; output;  * black outline;

             /* Bar means */
             function='label'; style="&text1"; size=1.2; 
          y=Yposition+.5*BarWidth+.5;  
          x=StartBarsX- 5; text=put(response,4.2);  position='6'; output;
		 * x=StartBarsX-10; *text=put(vn(i),4.2);    * position='6'; output;
          x=StartBarsX-10; text=put(vn(i),4.);     position='6'; output;
          x=StartBarsX-14; text=put(date,datef.); position='4'; size=1.2; output;
          if obs=1 then do;
             when='A';

             *** Total Triangle ****;
             RegionAverage=((rm(i)-2)/(5-2))*(EndBarsX-StartBarsX);
             function='poly'; 
                 x=StartBarsX+TotalAverage; y=Yposition+.5*BarWidth;
                 TOTttest=(rm(i)-q(i))/((rv(i)/rn2(i)) + (v(i)/vn(i)))**.5; 
                 put TOTTTest= +2 signif= rm(i)= q(i)= rv(i)= rn2(i)= v(i)= vn(i)=; style='Solid';
                 if abs(TOTTTest)>signif then color='Blue'; else color='H000BF00';
                 output;
             function='polycont';  color='black';
               x=StartBarsX+TotalAverage+.5*BarWidth;
               y=Yposition+Barwidth;
               output;      
             function='polycont';  color='black';
               x=StartBarsX+TotalAverage-.5*BarWidth;
               y=Yposition+BarWidth;
               output;      
             function='polycont'; 
               x=StartBarsX+TotalAverage; 
               y=Yposition+.5*BarWidth;
               output;
             function='label';
               x=StartBarsX+TotalAverage;
               y=Yposition+1.5*BarWidth;
               text='All Sites Combined'; size=.8; style="&text1"; position='5'; color='black';
               output;

             *** Question label ****;
             text=label; size=1.2; color='black'; style="&text1"; x=(EndBarsX-startBarsX)/2;
             x=StartBarsX+4;
             position='5'; y=Yposition+BarWidth+BarSpace1+.3; 
             position='C'; output;
          end;
   end;

run;
data annopage&mpage; set annopage&mpage;
     page="page &mpage";
     *size=size*(1.25/1.48);
run;

proc ganno anno=annopage&mpage(where=(y ge 0)); run;

%mend  page10;

%page10(flavor clean handle helpful speed choice appear health price,10);


