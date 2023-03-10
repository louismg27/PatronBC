//+------------------------------------------------------------------+
//|                                                     PatronBC.mq4 |
//|                        Copyright 2022, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2022, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
datetime expiryDate = D'2023.02.01 00:00'; //change as per your requirement

int count;
double zigzagg;
double H1;
double H2;
double H3;

double L1;
double L2;
double L3;

int H1_V;
int H2_V;
int H3_V;

int L1_V;
int L2_V;
int L3_V;

datetime H1_V_Date;
datetime H2_V_Date;
datetime H3_V_Date;

datetime L1_V_Date;
datetime L2_V_Date;
datetime L3_V_Date;

int choch_high;
datetime choch_high_date;
  
int choch_low;

datetime dateUpL1[8000];
datetime dateUpL1fin[8000];
datetime dateUpPH4fin[8000];

datetime dateUpL2[8000];
datetime dateUpH1[8000];
datetime dateUpH2[8000];

int foundUp=0;
int foundEqual;

extern bool pa=false;
extern bool pb=false;

datetime orderblock;
int OnInit()
  {
//---
     //---
   ChartSetInteger(0,CHART_SHOW_GRID,false);
ChartSetInteger(0,CHART_COLOR_CANDLE_BEAR,clrLightSlateGray);
ChartSetInteger(0,CHART_COLOR_CANDLE_BULL,clrLightCyan);
ChartSetInteger(0,CHART_COLOR_CHART_DOWN,clrLightSlateGray);
ChartSetInteger(0,CHART_COLOR_CHART_UP,clrLightCyan);
ChartSetInteger(0,CHART_MODE, CHART_CANDLES);
ChartSetInteger(0,CHART_COLOR_BACKGROUND, Black);
              
   
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+

void OnTick()
  {
  
   if(TimeCurrent() > expiryDate)
     {
      Alert("Expired copy. Please contact vendor.");
      return;
     } 
     
  count=0;
  double maxvela=1000;
  
  int depth=3;
  int desviation=2;
  int backstep=2;
  
  //int choch_high=0;

  int choch_low=0;
  
  foundEqual=0;
 
//---
 LecturaPrecio(Ask,120,50,"x1","Ask: ",5);
 LecturaPrecio(Bid,120,70,"x2","Bid: ",5);
  
 LecturaPrecio(zigzagg,5,50,".","ZigZag: ",5);
 LecturaPrecio(L1,5,70,"..","L1: ",5);
 LecturaPrecio(H1,5,90,"...","H1: ",5);
 LecturaPrecio(L2,5,110,"....","L2: ",5);
 LecturaPrecio(H2,5,130,".....","H2: ",5); 
 LecturaPrecio(H3,5,150,".......","H3: ",5); 
 
 int g=180;
 /*
 for(int i=0;i<=5;i++){
   if(foundUp>i){
      LecturaPrecio(dateUpL1[i],5,g,".......x2"+g,"dateUpL1[n]: ",5);  
   }
   g=g+20;
 }*/
 
 

 
 //**********************************************************************
 //DETECTAR PATRON CHOCH ALCISTA ****************************************
 //**********************************************************************
 //PatronChochAlcistaDos(depth,desviation,backstep,maxvela);
 PatronChochAlcista(depth,desviation,backstep,maxvela);
 //PatronBossAlcista(depth,desviation,backstep,maxvela);
 
 
 
 //PatronChochBajista(depth,desviation,backstep,maxvela);
 //PatronChochBajistaDos(depth,desviation,backstep,maxvela); 
 //PatronBossBajista(depth,desviation,backstep,maxvela);
     /*
 drawrectangleTime(iTime(NULL,PERIOD_D1,L1_V),Low[L1_V],
                       iTime(NULL,PERIOD_D1,1),High[L1_V],"A");
        */
        
  DrawOrderBlocks();
     
     
  }
//+------------------------------------------------------------------+

void LecturaPrecio(double precio_sto,int cx, int cy, string name,string name2,int digitos){

   ObjectCreate(name,OBJ_LABEL,0,0,0);
   ObjectSet(name,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
   ObjectSet(name,OBJPROP_XDISTANCE,cx);
   ObjectSet(name,OBJPROP_YDISTANCE,cy); 
   ObjectSetText(name,name2 +DoubleToStr(precio_sto,digitos),10,"Arial",clrAzure);

}
void LecturaString(string precio_sto,int cx, int cy, string name,string name2){

   ObjectCreate(name,OBJ_LABEL,0,0,0);
   ObjectSet(name,OBJPROP_CORNER,CORNER_RIGHT_UPPER);
   ObjectSet(name,OBJPROP_XDISTANCE,cx);
   ObjectSet(name,OBJPROP_YDISTANCE,cy);
   ObjectSetText(name,name2 +precio_sto,10,"Arial",clrAzure);

}
void drawVerticalLine(int barsBack, string name) {
   
   string lineName = "Line"+name;
   ObjectDelete(lineName);
   ObjectCreate(lineName,OBJ_VLINE,0,Time[barsBack],0);
   ObjectSet(lineName,OBJPROP_COLOR, clrGreen);
   ObjectSet(lineName,OBJPROP_WIDTH,1);
   ObjectSet(lineName,OBJPROP_STYLE,STYLE_DOT);
    
}
 
bool isPatronL(int posvela,int periodo){
   bool result=false;
   if ((iLow(NULL,periodo,posvela)<iLow(NULL,periodo,posvela+1))&&
         (iLow(NULL,periodo,posvela)<iLow(NULL,periodo,posvela-1))){
      result=true;
   }   
   return result;
}
bool isPatronH(int posvela,int periodo){
   bool result=false;
   if ((iHigh(NULL,periodo,posvela)>iHigh(NULL,periodo,posvela+1))&&
         (iHigh(NULL,periodo,posvela)>iHigh(NULL,periodo,posvela-1))){
      result=true;
   }   
   return result;
}
void drawtext(string texto, color clx,string name,double precio,int posvela){
      
     // ObjectDelete(name);
   ObjectCreate (name, OBJ_TEXT,0,0,0);
   ObjectSetText(name, texto,6,"Arial", clx);
   ObjectMove(name,0,iTime(NULL,PERIOD_D1,posvela),precio);
}
void drawTLH(int i,string text,int colorx,string name,double precio){ 
   drawtext(text, colorx,name,precio,i);
} 

void DrawPriceTrendLine(datetime x1, datetime x2, double y1, 
                        double y2, color lineColor, double style)
{
   string label = "Stochastic_DivergenceLine_v1.0# " + DoubleToStr(x1, 0);
   ObjectDelete(label);
   ObjectCreate(label, OBJ_TREND, 0, x1, y1, x2, y2, 0, 0);
   ObjectSet(label, OBJPROP_RAY, 0);
   ObjectSet(label, OBJPROP_COLOR, lineColor);
   ObjectSet(label, OBJPROP_STYLE, style);
   ObjectSet(label, OBJPROP_WIDTH, 1);
}  
void drawrectangle(int posVelaStart,double pricestart, int postVelaEnd, double pricend,string name){
  string lineName = "Rectangle"+name;
   ObjectDelete(lineName); 
  ObjectCreate(lineName,OBJ_RECTANGLE,0,Time[posVelaStart],pricestart,Time[postVelaEnd],pricend);
  ObjectSet(lineName,OBJPROP_COLOR,"128,128,128");
}
void drawrectangleTime(datetime datestart,double pricestart, datetime dateend, double pricend,string name,int colorx){
  string lineName = "Rectangle"+name;
   ObjectDelete(lineName); 
  ObjectCreate(lineName,OBJ_RECTANGLE,0,datestart,pricestart,dateend,pricend);
  ObjectSet(lineName,OBJPROP_COLOR,colorx);
}

//*****************************************************************************************
//*********************PATRON CHOCH ALCISTA 1**************************************
//*****************************************************************************************
void PatronChochAlcista(double depth,double desviation,double backstep,int maxvela){
   
    //DETECTAR L1
    sensorPatronL(2,depth,desviation,backstep,maxvela,1);
    
    //DETECTAR H1
    sensorPatronH(count,depth,desviation,backstep,maxvela,1);
       
    //DETECTAR L2
     sensorPatronL(count,depth,desviation,backstep,maxvela,2);
      
    //DETECTAR H2      
    sensorPatronH(count,depth,desviation,backstep,maxvela,2);
   
    
      //COMPARAR Patron LHLH-Choch 
    if((H2>H1)&&(H1>L2)&&(H1>L1)&&(iHigh(NULL,PERIOD_D1,1)>H1)){ //&&(L2>L1)
    
      //Ubicamos la vela que contiene el CHOCH
      for (int velascan=iBarShift(NULL,PERIOD_D1,L1_V_Date,0);velascan>=1;velascan--){
         if (iHigh(NULL,PERIOD_D1,velascan)>H1){
           // choch_high=velascan;
            choch_high_date=iTime(NULL,PERIOD_D1,velascan);
            break;
         }
      }
      
      //Verificar si se encuentra en el array
      for (int i=0;i<8000;i++){
         if(dateUpL1[i]==L1_V_Date){
            foundEqual++;
         } 
      }
      for (int i=0;i<8000;i++){
         if(dateUpH1[i]==H1_V_Date){
            foundEqual++;
         } 
      }
      
      //Almacenamos el datetime de la vela posicion L1_V
      if (foundEqual==0){
         dateUpL1[foundUp]=L1_V_Date;
         dateUpL1fin[foundUp]=iTime(NULL,PERIOD_D1,1);
         
         dateUpL2[foundUp]=L2_V_Date;
         dateUpH1[foundUp]=H1_V_Date;
         
         dateUpPH4fin[foundUp]=iTime(NULL,PERIOD_H4,1);
          
         foundUp++;
      }
    
      //DIBUJAR Puntos H y L detectados y verticales           
     /*   drawVerticalLine(iBarShift(NULL,PERIOD_D1,L1_V_Date,0),"gv1");//Dibujar Vertical Line
      drawTLH(iBarShift(NULL,PERIOD_D1,L1_V_Date,0),"L1",clrYellow,"n1",iLow(NULL,PERIOD_D1,iBarShift(NULL,PERIOD_D1,L1_V_Date,0)));//Dibujar Texto
           
      drawVerticalLine(H1_V,"gv2");//Dibujar Vertical Line
      drawTLH(H1_V,"H1",clrYellow,"n2",iHigh(NULL,PERIOD_D1,H1_V));//Dibujar Texto
   
      drawVerticalLine(L2_V,"gv3");//Dibujar Vertical Line
      drawTLH(L2_V,"L2",clrYellow,"n3",iLow(NULL,PERIOD_D1,L2_V));//Dibujar Texto
            
      drawVerticalLine(H2_V,"gv4");//Dibujar Vertical Line
      drawTLH(H2_V,"H2",clrYellow,"n4",iHigh(NULL,PERIOD_D1,H2_V));//Dibujar Texto
      */
      
     //if (pa==true){
         //DIBUJAR CHOCH
         DrawPriceTrendLine(choch_high_date, H1_V_Date,  H1,   H1, clrGold, STYLE_DASHDOT); 
         drawTLH(iBarShift(NULL,PERIOD_D1,L1_V_Date,0),"CHOCH",clrGold,"n5",H1);//Dibujar Texto 
                                   
         //DIBUJAR ZIGZAG                              
          DrawPriceTrendLine(H1_V_Date, L1_V_Date,  H1, L1,clrGold, STYLE_SOLID);
         DrawPriceTrendLine(L2_V_Date, H1_V_Date,   L2,  H1,clrGold, STYLE_SOLID);
         DrawPriceTrendLine(H2_V_Date, L2_V_Date,   H2,  L2,clrGold, STYLE_SOLID); 
     // }  
                            
   } 
}
//*****************************************************************************************
//*********************PATRON CHOCH ALCISTA 2**************************************
//*****************************************************************************************
void PatronChochAlcistaDos(double depth,double desviation,double backstep,int maxvela){

     //DETECTAR L1 
     sensorPatronL(2,depth,desviation,backstep,maxvela,1);
    
     //DETECTAR H1 
     sensorPatronH(count,depth,desviation,backstep,maxvela,1);
     
     //DETECTAR L2
     sensorPatronL(count,depth,desviation,backstep,maxvela,2);
     
     //DETECTAR H2     
     sensorPatronH(count,depth,desviation,backstep,maxvela,2);
     
    //DETECTAR L3
     sensorPatronL(count,depth,desviation,backstep,maxvela,3);
   
      //COMPARAR Patron LHLH-Choch 
    if((L1>L2&&L3>L2&&H2>H1&&H1>L1)&&(iHigh(NULL,PERIOD_D1,1)>H1)){ //&&(L2>L1)
      //Ubicamos la vela que contiene el CHOCH
      for (int velascan=iBarShift(NULL,PERIOD_D1,L1_V_Date,0);velascan>=1;velascan--){
         if (iHigh(NULL,PERIOD_D1,velascan)>H1){
           // choch_high=velascan;
            choch_high_date=iTime(NULL,PERIOD_D1,velascan);
            break;
         }
      }
          //Verificar si se encuentra en el array
      for (int i=0;i<8000;i++){
         if(dateUpL1[i]==L1_V_Date){
            foundEqual++;
         }
      }
      
      //Almacenamos el datetime de la vela posicion L1_V
      if (foundEqual==0){
         dateUpL1[foundUp]=L1_V_Date;
         dateUpL1fin[foundUp]=iTime(NULL,PERIOD_D1,1);
         
         dateUpL2[foundUp]=L2_V_Date;
          
         foundUp++;
      }
      /*
      //DIBUJAR Puntos H y L detectados y verticales           
      drawVerticalLine(L1_V,"gv1");//Dibujar Vertical Line
      drawTLH(L1_V,"L1",clrYellow,"n1",iLow(NULL,PERIOD_D1,L1_V));//Dibujar Texto
            
      drawVerticalLine(H1_V,"gv2");//Dibujar Vertical Line
      drawTLH(H1_V,"H1",clrYellow,"n2",iHigh(NULL,PERIOD_D1,H1_V));//Dibujar Texto
   
      drawVerticalLine(L2_V,"gv3");//Dibujar Vertical Line
      drawTLH(L2_V,"L2",clrYellow,"n3",iLow(NULL,PERIOD_D1,L2_V));//Dibujar Texto
            
      drawVerticalLine(H2_V,"gv4");//Dibujar Vertical Line
      drawTLH(H2_V,"H2",clrYellow,"n4",iHigh(NULL,PERIOD_D1,H2_V));//Dibujar Texto
      
      drawVerticalLine(L3_V,"gv5");//Dibujar Vertical Line
      drawTLH(L3_V,"L3",clrYellow,"n5",iLow(NULL,PERIOD_D1,L3_V));//Dibujar Texto
      */     
      //DIBUJAR CHOCH
      DrawPriceTrendLine(choch_high_date, H1_V_Date,  H1,   H1, clrGold, STYLE_DASHDOT); 
      drawTLH(iBarShift(NULL,PERIOD_D1,L1_V_Date,0),"CHOCH",clrGold,"n6",H1);//Dibujar Texto 
                                
      //DIBUJAR ZIGZAG                             
      DrawPriceTrendLine(H1_V_Date, L1_V_Date,  H1, L1,clrGold, STYLE_SOLID);
      DrawPriceTrendLine(L2_V_Date, H1_V_Date,   L2,  H1,clrGold, STYLE_SOLID);
      DrawPriceTrendLine(H2_V_Date, L2_V_Date,   H2,  L2,clrGold, STYLE_SOLID); 
      DrawPriceTrendLine(L3_V_Date, H2_V_Date,   L3,  H2,clrGold, STYLE_SOLID);                             
   } 
}


//*****************************************************************************************
//*********************PATRON BOSS ALCISTA **************************************
//*****************************************************************************************
void PatronBossAlcista(double depth,double desviation,double backstep,int maxvela){

    //DETECTAR L1
    sensorPatronL(2,depth,desviation,backstep,maxvela,1);
    
    //DETECTAR H1 
    sensorPatronH(count,depth,desviation,backstep,maxvela,1);
     
     
    //DETECTAR L2
    sensorPatronL(count,depth,desviation,backstep,maxvela,2);
    
    //DETECTAR H2
    sensorPatronH(count,depth,desviation,backstep,maxvela,2);
  
   
      //COMPARAR Patron LHLH-Choch 
    if((L1>L2&&H1>H2&&H2>L2)&&(iHigh(NULL,PERIOD_D1,1)>H1)){ //&&(L2>L1)
      //Ubicamos la vela que contiene el CHOCH
      for (int velascan=iBarShift(NULL,PERIOD_D1,L1_V_Date,0);velascan>=1;velascan--){
         if (iHigh(NULL,PERIOD_D1,velascan)>H1){
           // choch_high=velascan;
            choch_high_date=iTime(NULL,PERIOD_D1,velascan);
            break;
         }
      }
      //Verificar si se encuentra en el array
      for (int i=0;i<8000;i++){
         if(dateUpL1[i]==L1_V_Date){
            foundEqual++;
         }
      }
      
      //Almacenamos el datetime de la vela posicion L1_V
      if (foundEqual==0){
         dateUpL1[foundUp]=L1_V_Date;
         dateUpL1fin[foundUp]=iTime(NULL,PERIOD_D1,1);
         dateUpPH4fin[foundUp]=iTime(NULL,PERIOD_H4,1);
       //  dateUpL2[foundUp]=L2_V_Date;
          
         foundUp++;
      }
      /*
      //DIBUJAR Puntos H y L detectados y verticales           
      drawVerticalLine(L1_V,"gv1");//Dibujar Vertical Line
      drawTLH(L1_V,"L1",clrYellow,"n1",iLow(NULL,PERIOD_D1,L1_V));//Dibujar Texto
            
      drawVerticalLine(H1_V,"gv2");//Dibujar Vertical Line
      drawTLH(H1_V,"H1",clrYellow,"n2",iHigh(NULL,PERIOD_D1,H1_V));//Dibujar Texto
   
      drawVerticalLine(L2_V,"gv3");//Dibujar Vertical Line
      drawTLH(L2_V,"L2",clrYellow,"n3",iLow(NULL,PERIOD_D1,L2_V));//Dibujar Texto
            
      drawVerticalLine(H2_V,"gv4");//Dibujar Vertical Line
      drawTLH(H2_V,"H2",clrYellow,"n4",iHigh(NULL,PERIOD_D1,H2_V));//Dibujar Texto
      */
           
      //DIBUJAR CHOCH
      DrawPriceTrendLine(choch_high_date, H1_V_Date,  H1,   H1, clrGold, STYLE_DASHDOT); 
      drawTLH(iBarShift(NULL,PERIOD_D1,choch_high_date,0),"BOSS",clrGold,"n6", H1);//Dibujar Texto 
                                
      //DIBUJAR ZIGZAG                             
      DrawPriceTrendLine(H1_V_Date, L1_V_Date,  H1, L1,clrGold, STYLE_SOLID);
      DrawPriceTrendLine(L2_V_Date, H1_V_Date,   L2,  H1,clrGold, STYLE_SOLID);
      DrawPriceTrendLine(H2_V_Date, L2_V_Date,   H2,  L2,clrGold, STYLE_SOLID);                              
   } 
}

//---------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------
//---------------------------------------------------------------------------------------------

//*****************************************************************************************
//*********************PATRON CHOCH BAJISTA 1**************************************
//*****************************************************************************************
void PatronChochBajista(double depth,double desviation,double backstep,int maxvela){ 

    //DETECTAR H1
    sensorPatronH(2,depth,desviation,backstep,maxvela,1);
    
    //DETECTAR L1
    sensorPatronL(count,depth,desviation,backstep,maxvela,1);
    
    //DETECTAR H2      
    sensorPatronH(count,depth,desviation,backstep,maxvela,2);
       
    //DETECTAR L2
    sensorPatronL(count,depth,desviation,backstep,maxvela,2);
    
    int inhibit=0;   
     
      //COMPARAR Patron LHLH-Choch 
    if((L1>L2&&H2>L1)&&(iLow(NULL,PERIOD_D1,1)<L1)){ //(H1>H2)&&
      
      for(int data=H2_V;data>H1_V;data--){
         if(iHigh(NULL,PERIOD_D1,data)>H1){
            inhibit=1;
            break;
         }
      }
      if (inhibit==0){
         //Ubicamos la vela que contiene el CHOCH
          for (int velascan=H1_V;velascan>=1;velascan--){
            if (iLow(NULL,PERIOD_D1,velascan)<L1){
               choch_low=velascan;
               break;
            }
         }
             //DIBUJAR Puntos H y L detectados y verticales           
         drawVerticalLine(L1_V,"gv1");//Dibujar Vertical Line
         drawTLH(L1_V,"L1",clrYellow,"n1",iLow(NULL,PERIOD_D1,L1_V));//Dibujar Texto
               
         drawVerticalLine(H1_V,"gv2");//Dibujar Vertical Line
         drawTLH(H1_V,"H1",clrYellow,"n2",iHigh(NULL,PERIOD_D1,H1_V));//Dibujar Texto
      
         drawVerticalLine(L2_V,"gv3");//Dibujar Vertical Line
         drawTLH(L2_V,"L2",clrYellow,"n3",iLow(NULL,PERIOD_D1,L2_V));//Dibujar Texto
               
         drawVerticalLine(H2_V,"gv4");//Dibujar Vertical Line
         drawTLH(H2_V,"H2",clrYellow,"n4",iHigh(NULL,PERIOD_D1,H2_V));//Dibujar Texto
          
         
         //DIBUJAR CHOCH
         DrawPriceTrendLine(Time[choch_low], Time[L1_V],  L1,   L1, clrDeepPink, STYLE_DASHDOT); 
         drawTLH(choch_low,"CHOCH",clrDeepPink,"n5",L1);//Dibujar Texto 
                                   
         //DIBUJAR ZIGZAG                             
         DrawPriceTrendLine(Time[L1_V], Time[H1_V],  L1, H1,clrDeepPink, STYLE_SOLID);
         DrawPriceTrendLine(Time[H2_V], Time[L1_V],   H2,  L1,clrDeepPink, STYLE_SOLID);
         DrawPriceTrendLine(Time[L2_V], Time[H2_V],   L2,  H2,clrDeepPink, STYLE_SOLID);  
      }
       
       
     
       
                            
   } 
}


//*****************************************************************************************
//*********************PATRON CHOCH BAJISTA 2**************************************
//*****************************************************************************************
void PatronChochBajistaDos(double depth,double desviation,double backstep,int maxvela){

     //DETECTAR H1 
     sensorPatronH(2,depth,desviation,backstep,maxvela,1);

     //DETECTAR L1 
     sensorPatronL(count,depth,desviation,backstep,maxvela,1);
    
     //DETECTAR H2
     sensorPatronH(count,depth,desviation,backstep,maxvela,2);
     
     //DETECTAR L2     
     sensorPatronL(count,depth,desviation,backstep,maxvela,2);
     
    //DETECTAR H3
     sensorPatronH(count,depth,desviation,backstep,maxvela,3);
   
      //COMPARAR Patron LHLH-Choch 
    if((H2>H1&&H2>H3&&L1>L2)&&(iLow(NULL,PERIOD_D1,1)<L1)){ //&&(L2>L1)
      //Ubicamos la vela que contiene el CHOCH
      for (int velascan=H1_V;velascan>=1;velascan--){
         if (iLow(NULL,PERIOD_D1,velascan)<L1){
            choch_low=velascan;
            break;
         }
      }
      /*
     //DIBUJAR Puntos H y L detectados y verticales   
      drawVerticalLine(H1_V,"gv2");//Dibujar Vertical Line
      drawTLH(H1_V,"H1",clrYellow,"n2",iHigh(NULL,PERIOD_D1,H1_V));//Dibujar Texto
      
      drawVerticalLine(L1_V,"gv1");//Dibujar Vertical Line
      drawTLH(L1_V,"L1",clrYellow,"n1",iLow(NULL,PERIOD_D1,L1_V));//Dibujar Texto
      
      drawVerticalLine(H2_V,"gv4");//Dibujar Vertical Line
      drawTLH(H2_V,"H2",clrYellow,"n4",iHigh(NULL,PERIOD_D1,H2_V));//Dibujar Texto
      
      drawVerticalLine(L2_V,"gv3");//Dibujar Vertical Line
      drawTLH(L2_V,"L2",clrYellow,"n3",iLow(NULL,PERIOD_D1,L2_V));//Dibujar Texto
       
      drawVerticalLine(H3_V,"gv5");//Dibujar Vertical Line
      drawTLH(H3_V,"L3",clrYellow,"n5",iHigh(NULL,PERIOD_D1,H3_V));//Dibujar Texto
*/
     //DIBUJAR CHOCH
      DrawPriceTrendLine(Time[choch_low], Time[L1_V],  L1,   L1, clrDeepPink, STYLE_DASHDOT); 
      drawTLH(choch_low,"CHOCH",clrDeepPink,"n6",iLow(NULL,PERIOD_D1,choch_low));//Dibujar Texto 
            
     //DIBUJAR ZIGZAG                             
      DrawPriceTrendLine(Time[L1_V], Time[H1_V],  L1, H1,clrDeepPink, STYLE_SOLID);
      DrawPriceTrendLine(Time[H2_V], Time[L1_V],   H2,  L1,clrDeepPink, STYLE_SOLID);
      DrawPriceTrendLine(Time[L2_V], Time[H2_V],   L2,  H2,clrDeepPink, STYLE_SOLID); 
      DrawPriceTrendLine(Time[H3_V], Time[L2_V],   H3,  L2,clrDeepPink, STYLE_SOLID);       
                                  
   } 
}

//*****************************************************************************************
//*********************PATRON BOSS BAJISTA **************************************
//*****************************************************************************************
void PatronBossBajista(double depth,double desviation,double backstep,int maxvela){

    //DETECTAR H1 
    sensorPatronH(2,depth,desviation,backstep,maxvela,1);
    
    //DETECTAR L1
    sensorPatronL(count,depth,desviation,backstep,maxvela,1);
    
    //DETECTAR H2
    sensorPatronH(count,depth,desviation,backstep,maxvela,2);     
     
    //DETECTAR L2
    sensorPatronL(count,depth,desviation,backstep,maxvela,2);
    

  
   
      //COMPARAR Patron LHLH-Choch 
    if((L2>L1&&H2>H1)&&(iLow(NULL,PERIOD_D1,1)<L1)){ //&&(L2>L1)
      //Ubicamos la vela que contiene el CHOCH
      for (int velascan=L1_V;velascan>=1;velascan--){
         if (iLow(NULL,PERIOD_D1,velascan)<L1){
            choch_low=velascan;
            break;
         }
      }
      /*
      //DIBUJAR Puntos H y L detectados y verticales           
      drawVerticalLine(L1_V,"gv1");//Dibujar Vertical Line
      drawTLH(L1_V,"L1",clrYellow,"n1",iLow(NULL,PERIOD_D1,L1_V));//Dibujar Texto
            
      drawVerticalLine(H1_V,"gv2");//Dibujar Vertical Line
      drawTLH(H1_V,"H1",clrYellow,"n2",iHigh(NULL,PERIOD_D1,H1_V));//Dibujar Texto
   
      drawVerticalLine(L2_V,"gv3");//Dibujar Vertical Line
      drawTLH(L2_V,"L2",clrYellow,"n3",iLow(NULL,PERIOD_D1,L2_V));//Dibujar Texto
            
      drawVerticalLine(H2_V,"gv4");//Dibujar Vertical Line
      drawTLH(H2_V,"H2",clrYellow,"n4",iHigh(NULL,PERIOD_D1,H2_V));//Dibujar Texto
      
           */
      //DIBUJAR CHOCH
      DrawPriceTrendLine(Time[choch_low], Time[L1_V],  L1,   L1, clrDeepPink, STYLE_DASHDOT); 
      drawTLH(choch_low,"BOSS",clrDeepPink,"n6",iLow(NULL,PERIOD_D1,choch_low));//Dibujar Texto 
                                
      //DIBUJAR ZIGZAG                             
      DrawPriceTrendLine(Time[L1_V], Time[H1_V],  L1, H1,clrDeepPink, STYLE_SOLID);
      DrawPriceTrendLine(Time[H2_V], Time[L1_V],   H2,  L1,clrDeepPink, STYLE_SOLID);
      DrawPriceTrendLine(Time[L2_V], Time[H2_V],   L2,  H2,clrDeepPink, STYLE_SOLID);                              
   } 
}





//************************************************************************************************
//******************FUNCIONES ********************************************************************
//************************************************************************************************
void sensorPatronL(int startVela,int depth,int desviation, int backstep,int maxvela,int number){
//DETECTAR L1
    for(int vela = startVela; vela < maxvela; vela++){   // Get most recent ZigZag
         //Detectar L1
          if(iCustom(NULL, PERIOD_D1, "ZigZag.ex4", depth, desviation, backstep, 0, vela)!=0){
              
              zigzagg =iCustom(NULL, PERIOD_D1, "ZigZag.ex4", depth, desviation, backstep, 0, vela);
              //Detectamos patron L y Almacenamos info
              if(isPatronL(vela,PERIOD_D1)==true){ 
                  count=vela; //En esta vela se encontro el patron L
                  writeL(number,vela);//Se guarda el precio y la vela n
                 
                  break;
              }         
          } 
    }
}
void sensorPatronH(int startVela,int depth,int desviation, int backstep,int maxvela,int number){
//DETECTAR H1
      for (int vela =startVela; vela<maxvela;vela++){
      //Detectar cuando el valor es diferente a 0 en las ultimas N velas
      if(iCustom(NULL, PERIOD_D1, "ZigZag.ex4", depth, desviation, backstep, 0, vela)!=0){
            
           zigzagg =iCustom(NULL, PERIOD_D1, "ZigZag.ex4", depth, desviation, backstep, 0, vela);
           //Detectamos patron H y Almacenamos info
           if(isPatronH(vela,PERIOD_D1)==true){               
               count=vela;
               writeH(number,vela);         
               break;
           }         
      }
     }
}
  
void writeL(int n,int vela){
   switch(n){
      case 1:
         L1=iLow(NULL,PERIOD_D1,vela);//Guardar Valor
         L1_V=vela;
         L1_V_Date=iTime(NULL,PERIOD_D1,vela);
         break;
      case 2:
         L2=iLow(NULL,PERIOD_D1,vela);//Guardar Valor
         L2_V=vela;
         L2_V_Date=iTime(NULL,PERIOD_D1,vela);
         break;   
      case 3:
         L3=iLow(NULL,PERIOD_D1,vela);//Guardar Valor
         L3_V=vela;
         L3_V_Date=iTime(NULL,PERIOD_D1,vela);
         break;            
   }
}
void writeH(int n,int vela){
   switch(n){
      case 1:
         H1=iHigh(NULL,PERIOD_D1,vela);//Guardar Valor
         H1_V=vela;
         H1_V_Date=iTime(NULL,PERIOD_D1,vela);
         break;
      case 2:
         H2=iHigh(NULL,PERIOD_D1,vela);//Guardar Valor
         H2_V=vela;
         H2_V_Date=iTime(NULL,PERIOD_D1,vela);
         break;   
      case 3:
         H3=iHigh(NULL,PERIOD_D1,vela);//Guardar Valor
         H3_V=vela;
         H3_V_Date=iTime(NULL,PERIOD_D1,vela);
         break; 
   }
}

bool isAlcista(int vela,int periodo){
   bool result=false;
   if(iClose(NULL,periodo,vela)>iOpen(NULL,periodo,vela)){
      result=true;
   }   
   return result;
}
bool isBajista(int vela,int periodo){
   bool result=false;
   if(iClose(NULL,periodo,vela)<iOpen(NULL,periodo,vela)){
      result=true;
   }   
   return result;
}

void DrawOrderBlocks(){
   for (int sdate=0;sdate<foundUp;sdate++){
         //obtenemos fecha del array
         datetime fecha_iL1=dateUpL1[sdate]; 
         datetime fecha_f=dateUpL1fin[sdate]; 
         datetime fecha_iL2=dateUpL2[sdate];
         
         datetime fecha_iH1=dateUpH1[sdate];
         
         datetime fecha_f_PH4=dateUpPH4fin[sdate];
         
         int minimo=99999;
         int vminimo;
         //Dibujar proyeccion Order Blocks PARA L1         
         proyectDrawRec(fecha_iL1,fecha_f,PERIOD_D1,clrGreen,"A");
         //********************************************--------*******************
         //-------------------------------------------------------------///-------
        //Dibujar proyeccion Order Blocks PARA L2    
         if(dateUpL2[sdate]>0){ 
             if(iLow(NULL,PERIOD_D1,iBarShift(NULL,PERIOD_D1,fecha_iL1,0))>
                  iLow(NULL,PERIOD_D1,iBarShift(NULL,PERIOD_D1,fecha_iL2,0))){
                   proyectDrawRec(fecha_iL2,fecha_f,PERIOD_D1,clrIndigo,"B");           
            }  
         }
         int vFin_PH4 = iBarShift(NULL,PERIOD_H4,fecha_f,0);
         int vH1_PH4 = iBarShift(NULL,PERIOD_H4,fecha_iH1,0);
         
         for (int i=vFin_PH4;i<vH1_PH4;i++){
          if (iLow(NULL,PERIOD_H4,i)<minimo ){
            minimo = iLow(NULL,PERIOD_H4,i);
            vminimo=i;
          }
         }
         int cantV_PH4=vH1_PH4-vFin_PH4;
         
         int val_index=iLowest(NULL,PERIOD_H4,MODE_LOW,cantV_PH4,vFin_PH4);
            
       /*  drawVerticalLine(vH1_PH4,"AAA");
         drawVerticalLine(vFin_PH4,"BBB");
         drawVerticalLine(val_index,"CCC");*/
         
          LecturaPrecio(vH1_PH4,50,180,"a8c","h1: ",2);
         LecturaPrecio(val_index,50,200,"a8","lowest: ",2);
          LecturaPrecio(vFin_PH4,50,220,"ax","fin: ",2);
          
         
         
         //Afinar DrawRec en TimeFrame inferior
         
        /* int vLowH4=iLowest(NULL,PERIOD_H4,MODE_LOW,10, vFin_PH4);
         datetime fechaLowH4 = iTime(NULL,PERIOD_H4,vLowH4);  */
          
          proyectDrawRec(iTime(NULL,PERIOD_H4,val_index),fecha_f_PH4,PERIOD_H4,clrYellow,"C");
          
        
  } 
}

void proyectDrawRec(datetime fecha_iL1,datetime fecha_f,double periodo,int colorx,string name){
      double price_i=iLow(NULL,periodo,iBarShift(NULL,periodo,fecha_iL1,0));
         if (isAlcista(iBarShift(NULL,periodo,fecha_iL1,0),periodo)==true){
            double price_f=iOpen(NULL,periodo,iBarShift(NULL,periodo,fecha_iL1,0));
            drawrectangleTime(fecha_iL1,price_i,
                              fecha_f,price_f,name+fecha_iL1,colorx); 
         }
         if(isBajista(iBarShift(NULL,periodo,fecha_iL1,0),periodo)==true){
           double price_f=iClose(NULL,periodo,iBarShift(NULL,periodo,fecha_iL1,0));
           drawrectangleTime(fecha_iL1,price_i,
                             fecha_f,price_f,name+fecha_iL1,colorx); 
         }  

}