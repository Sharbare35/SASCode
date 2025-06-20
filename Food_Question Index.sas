%let text1 = 'Arial';  *swiss;   *Body;
%let text2 = 'Arial/bold';  *Header;
%let text3 = 'Arial/italic';  


proc format;
  value qtextf                                       /* Question text as on survey      */
    1 = "Flavor/texture of food"                     /* Flavor/Texture                  */
    2 = "Cleanliness of facility"                    /* Cleanliness                     */
    3 = "Food handling practices"                    /* Food Handling                   */
    4 = "Helpfulness of employees"                   /* Employee Helpfulness            */
    5 = "Speed of getting and paying for your food"  /* Speed of Service                */
    6 = "Number of different food choices"           /* Number of Food Choices          */
    7 = "Appearance of food"                         /* Appearance of Food              */
    8 = "Availability of healthy choices"            /* Availability of Healthy Choices */
    9 = "Price";                                     /* Price                           */
run;

data AnnoQuestions;                                                                                                                     
   length function color style $25 text text1 text2 l $70;                                                                               
   retain StartRow CurrentRow 90                                                                                                        
          color 'black'  style 'zapfb'                                                                                                  
          xsys ysys hsys '3';  
 
   /* Headers and Titles */                                                                                                             
   obs=_n_;                                                                                                                             
   style="&text2"; position='6';                                                                                                         
   array ques(9)  s1-s5   o1-o4;                                                                                                       
     do j=1 to 9;                                                                                                                      
        function='label';                                                                                                               
        if j=1 then do;                                                                                                                 
           x=13; y=CurrentRow; size=1.8;                                                                                                
           text='Standard Questions'; output;                                                                                               
           CurrentRow=CurrentRow-4;                                                                                                     
        end;                                                                                                                            
        if j=6 then do;                                                                                                                 
           CurrentRow=CurrentRow-3; y=CurrentRow;                                                                                       
           text='Supplemental Questions'; x=13; size=1.8; output;                                                                               
           CurrentRow=CurrentRow-5;                                                                                                     
        end;                                                                                                                            
        x=15; y=CurrentRow;                                                                                                             
        call vname(ques(j),l);                                                                                                          
        label=put(j,qtextf.); 
        size=1.5;                                                                                                                       
            length=length(label);                                                                                                       
            spaces=length-length(compress(label));                                                                                      
            text1=''; text2='';                                                                                                         
            do k=1 to spaces+1;                                                                                                         
               s=scan(label,k,' ');                                                                                                     
               if length(text1)<121 then text1=trim(text1)!!' '!!s;                                                                     
                                    else text2=trim(text2)!!' '!!s;                                                                      
            end;                                                                                                                        
            if text2='' then position='6'; else position='C'; text=text1;                                                               
            output;                                                                                                                     
                                                position='F'; text=text2;                                                               
            output;                                                                                                                     
        CurrentRow=CurrentRow-4;                                                                                                        
     end;                                                                                                                               
run;                                                                                                                                    
                                                                                                                                        
proc ganno anno=AnnoQuestions; run; 
