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

int choch_high;

datetime orderblock;
int OnInit()
  {
//---
     //---
   ChartSetInteger(0,CHART_SHOW_GRID,false);
ChartSetInteger(0,CHART_COLOR_CANDLE_BEAR,clrCrimson);
ChartSetInteger(0,CHART_COLOR_CANDLE_BULL,clrSeaGreen);
ChartSetInteger(0,CHART_COLOR_CHART_DOWN,clrCrimson);
ChartSetInteger(0,CHART_COLOR_CHART_UP,clrSeaGreen);
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
  count=0;
  double maxvela=500;
  
  int depth=3;
  int desviation=2;
  int backstep=1;
  
  int choch_high=0;
 
//---
 LecturaPrecio(Ask,120,50,"x1","Ask: ",5);
 LecturaPrecio(Bid,120,70,"x2","Bid: ",5);
  
 LecturaPrecio(zigzagg,5,50,".","ZigZag: ",5);
 LecturaPrecio(L1,5,70,"..","L1: ",5);
 LecturaPrecio(H1,5,90,"...","H1: ",5);
 LecturaPrecio(L2,5,110,"....","L2: ",5);
 LecturaPrecio(H2,5,130,".....","H2: ",5); 
 
 //**********************************************************************
 //DETECTAR PATRON CHOCH ALCISTA ****************************************
 //**********************************************************************
 PatronChochAlcistaDos(depth,desviation,backstep,maxvela);
 PatronChochAlcista(depth,desviation,backstep,maxvela);
 PatronBossAlcista(depth,desviation,backstep,maxvela);
     
 drawrectangleTime(iTime(NULL,PERIOD_D1,L1_V),Low[L1_V],
                       iTime(NULL,PERIOD_D1,1),High[L1_V],"A");
        
     
     
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
ObjectSetText(name, texto,8,"Arial", clx);
ObjectMove(name,0,Time[posvela],precio);
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
}  
void drawrectangle(int posVelaStart,double pricestart, int postVelaEnd, double pricend,string name){
  string lineName = "Rectangle"+name;
   ObjectDelete(lineName); 
  ObjectCreate(lineName,OBJ_RECTANGLE,0,Time[posVelaStart],pricestart,Time[postVelaEnd],pricend);
  ObjectSet(lineName,OBJPROP_COLOR,"128,128,128");
}
void drawrectangleTime(datetime datestart,double pricestart, datetime dateend, double pricend,string name){
  string lineName = "Rectangle"+name;
   ObjectDelete(lineName); 
  ObjectCreate(lineName,OBJ_RECTANGLE,0,datestart,pricestart,dateend,pricend);
  ObjectSet(lineName,OBJPROP_COLOR,"128,128,128");
}

void PatronChochAlcista(double depth,double desviation,double backstep,int maxvela){
   //DETECTAR L1
    for(int vela = 2; vela < maxvela; vela++){   // Get most recent ZigZag
         //Detectar L1
          if(iCustom(NULL, PERIOD_D1, "ZigZag", depth, desviation, backstep, 0, vela)!=0){
              //Found++;
              zigzagg =iCustom(NULL, PERIOD_D1, "ZigZag", depth, desviation, backstep, 0, vela);
              if(isPatronL(vela,PERIOD_D1)==true){
                  
                  count=vela;
                  L1=iLow(NULL,PERIOD_D1,vela);//Guardar Valor
                  L1_V=vela;
                 
                  break;
              }         
          } 
    }
    
     //DETECTAR H1
     for (int vela =count; vela<maxvela;vela++){
      //Detectar cuando el valor es diferente a 0 en las ultimas N velas
      if(iCustom(NULL, PERIOD_D1, "ZigZag", depth, desviation, backstep, 0, vela)!=0){
           //Found++;FB
           zigzagg =iCustom(NULL, PERIOD_D1, "ZigZag", depth, desviation, backstep, 0, vela);
           if(isPatronH(vela,PERIOD_D1)==true){
               
               count=vela;
               H1=iHigh(NULL,PERIOD_D1,vela);//Guardar Valor
               H1_V=vela;
               
               break;
           }         
      }
     }
     
     
     //DETECTAR L2
     for (int vela =count; vela<maxvela;vela++){
      //Detectar cuando el valor es diferente a 0 en las ultimas N velas
      if(iCustom(NULL, PERIOD_D1, "ZigZag", depth, desviation, backstep, 0, vela)!=0){
           //Found++;
           zigzagg =iCustom(NULL, PERIOD_D1, "ZigZag", depth, desviation, backstep, 0, vela);
           if(isPatronL(vela,PERIOD_D1)==true){
               
               count=vela;
               L2=iLow(NULL,PERIOD_D1,vela);//Guardar Valor
               L2_V=vela;
               
               break;
           }         
      }
     }
     //DETECTAR H2     
     for (int vela =count; vela<maxvela;vela++){
      //Detectar cuando el valor es diferente a 0 en las ultimas N velas
      if(iCustom(NULL, PERIOD_D1, "ZigZag", depth, desviation, backstep, 0, vela)!=0){
           //Found++;
           zigzagg =iCustom(NULL, PERIOD_D1, "ZigZag", depth, desviation, backstep, 0, vela);
           if(isPatronH(vela,PERIOD_D1)==true){
              
               count=vela;
               H2=iHigh(NULL,PERIOD_D1,vela);//Guardar Valor
               H2_V=vela;
               
               
               break;
           }         
      }
     }
     
      //COMPARAR Patron LHLH-Choch 
 if((H2>H1)&&(L2>L1)&&(iHigh(NULL,PERIOD_D1,1)>H1)){ //&&(L2>L1)
      //Ubicamos la vela que contiene el CHOCH
      for (int velascan=L1_V;velascan>=1;velascan--){
         if (iHigh(NULL,PERIOD_D1,velascan)>H1){
            choch_high=velascan;
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
      DrawPriceTrendLine(Time[choch_high], Time[H1_V],  H1,   H1, clrMediumSpringGreen, STYLE_DASHDOT); 
      drawTLH(choch_high,"CHOCH",clrAqua,"n5",iHigh(NULL,PERIOD_D1,choch_high));//Dibujar Texto 
                                
      //DIBUJAR ZIGZAG                             
      DrawPriceTrendLine(Time[H1_V], Time[L1_V],  H1, L1,clrCornflowerBlue, STYLE_SOLID);
      DrawPriceTrendLine(Time[L2_V], Time[H1_V],   L2,  H1,clrCornflowerBlue, STYLE_SOLID);
      DrawPriceTrendLine(Time[H2_V], Time[L2_V],   H2,  L2,clrCornflowerBlue, STYLE_SOLID); 
       
                            
   } 
}
//*****************************************************************************************
//*********************PATRON CHOCH ALCISTA 2**************************************
//*****************************************************************************************
void PatronChochAlcistaDos(double depth,double desviation,double backstep,int maxvela){

   //DETECTAR L1
    for(int vela = 2; vela < maxvela; vela++){   // Get most recent ZigZag
         //Detectar L1
          if(iCustom(NULL, PERIOD_D1, "ZigZag", depth, desviation, backstep, 0, vela)!=0){
              //Found++;
              zigzagg =iCustom(NULL, PERIOD_D1, "ZigZag", depth, desviation, backstep, 0, vela);
              if(isPatronL(vela,PERIOD_D1)==true){                  
                  count=vela;
                  L1=iLow(NULL,PERIOD_D1,vela);//Guardar Valor
                  L1_V=vela;                 
                  break;
              }         
          } 
    }
    
     //DETECTAR H1
     for (int vela =count; vela<maxvela;vela++){
      //Detectar cuando el valor es diferente a 0 en las ultimas N velas
      if(iCustom(NULL, PERIOD_D1, "ZigZag", depth, desviation, backstep, 0, vela)!=0){
           //Found++;FB
           zigzagg =iCustom(NULL, PERIOD_D1, "ZigZag", depth, desviation, backstep, 0, vela);
           if(isPatronH(vela,PERIOD_D1)==true){               
               count=vela;
               H1=iHigh(NULL,PERIOD_D1,vela);//Guardar Valor
               H1_V=vela;               
               break;
           }         
      }
     }
     
     
     //DETECTAR L2
     for (int vela =count; vela<maxvela;vela++){
      //Detectar cuando el valor es diferente a 0 en las ultimas N velas
      if(iCustom(NULL, PERIOD_D1, "ZigZag", depth, desviation, backstep, 0, vela)!=0){
           //Found++;
           zigzagg =iCustom(NULL, PERIOD_D1, "ZigZag", depth, desviation, backstep, 0, vela);
           if(isPatronL(vela,PERIOD_D1)==true){               
               count=vela;
               L2=iLow(NULL,PERIOD_D1,vela);//Guardar Valor
               L2_V=vela;               
               break;
           }         
      }
     }
     //DETECTAR H2     
     for (int vela =count; vela<maxvela;vela++){
      //Detectar cuando el valor es diferente a 0 en las ultimas N velas
      if(iCustom(NULL, PERIOD_D1, "ZigZag", depth, desviation, backstep, 0, vela)!=0){
           //Found++;
           zigzagg =iCustom(NULL, PERIOD_D1, "ZigZag", depth, desviation, backstep, 0, vela);
           if(isPatronH(vela,PERIOD_D1)==true){              
               count=vela;
               H2=iHigh(NULL,PERIOD_D1,vela);//Guardar Valor
               H2_V=vela;
               break;
           }         
      }
     }
    //DETECTAR L3
     for (int vela =count; vela<maxvela;vela++){
      //Detectar cuando el valor es diferente a 0 en las ultimas N velas
      if(iCustom(NULL, PERIOD_D1, "ZigZag", depth, desviation, backstep, 0, vela)!=0){
           //Found++;
           zigzagg =iCustom(NULL, PERIOD_D1, "ZigZag", depth, desviation, backstep, 0, vela);
           if(isPatronL(vela,PERIOD_D1)==true){               
               count=vela;
               L3=iLow(NULL,PERIOD_D1,vela);//Guardar Valor
               L3_V=vela;               
               break;
           }         
      }
     }
   
      //COMPARAR Patron LHLH-Choch 
 if((L1>L2&&L3>L2&&H2>H1)&&(iHigh(NULL,PERIOD_D1,1)>H1)){ //&&(L2>L1)
      //Ubicamos la vela que contiene el CHOCH
      for (int velascan=L1_V;velascan>=1;velascan--){
         if (iHigh(NULL,PERIOD_D1,velascan)>H1){
            choch_high=velascan;
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
      
      drawVerticalLine(L3_V,"gv5");//Dibujar Vertical Line
      drawTLH(L3_V,"L3",clrYellow,"n5",iLow(NULL,PERIOD_D1,L3_V));//Dibujar Texto
           
      //DIBUJAR CHOCH
      DrawPriceTrendLine(Time[choch_high], Time[H1_V],  H1,   H1, clrMediumSpringGreen, STYLE_DASHDOT); 
      drawTLH(choch_high,"CHOCH",clrAqua,"n6",iHigh(NULL,PERIOD_D1,choch_high));//Dibujar Texto 
                                
      //DIBUJAR ZIGZAG                             
      DrawPriceTrendLine(Time[H1_V], Time[L1_V],  H1, L1,clrCornflowerBlue, STYLE_SOLID);
      DrawPriceTrendLine(Time[L2_V], Time[H1_V],   L2,  H1,clrCornflowerBlue, STYLE_SOLID);
      DrawPriceTrendLine(Time[H2_V], Time[L2_V],   H2,  L2,clrCornflowerBlue, STYLE_SOLID); 
      DrawPriceTrendLine(Time[L3_V], Time[H2_V],   L3,  H2,clrCornflowerBlue, STYLE_SOLID);                             
   } 
}


//*****************************************************************************************
//*********************PATRON BOSS ALCISTA **************************************
//*****************************************************************************************
void PatronBossAlcista(double depth,double desviation,double backstep,int maxvela){

   //DETECTAR L1
    for(int vela = 2; vela < maxvela; vela++){   // Get most recent ZigZag
         //Detectar L1
          if(iCustom(NULL, PERIOD_D1, "ZigZag", depth, desviation, backstep, 0, vela)!=0){
              //Found++;
              zigzagg =iCustom(NULL, PERIOD_D1, "ZigZag", depth, desviation, backstep, 0, vela);
              if(isPatronL(vela,PERIOD_D1)==true){                  
                  count=vela;
                  L1=iLow(NULL,PERIOD_D1,vela);//Guardar Valor
                  L1_V=vela;                 
                  break;
              }         
          } 
    }
    
     //DETECTAR H1
     for (int vela =count; vela<maxvela;vela++){
      //Detectar cuando el valor es diferente a 0 en las ultimas N velas
      if(iCustom(NULL, PERIOD_D1, "ZigZag", depth, desviation, backstep, 0, vela)!=0){
           //Found++;FB
           zigzagg =iCustom(NULL, PERIOD_D1, "ZigZag", depth, desviation, backstep, 0, vela);
           if(isPatronH(vela,PERIOD_D1)==true){               
               count=vela;
               H1=iHigh(NULL,PERIOD_D1,vela);//Guardar Valor
               H1_V=vela;               
               break;
           }         
      }
     }
     
     
     //DETECTAR L2
     for (int vela =count; vela<maxvela;vela++){
      //Detectar cuando el valor es diferente a 0 en las ultimas N velas
      if(iCustom(NULL, PERIOD_D1, "ZigZag", depth, desviation, backstep, 0, vela)!=0){
           //Found++;
           zigzagg =iCustom(NULL, PERIOD_D1, "ZigZag", depth, desviation, backstep, 0, vela);
           if(isPatronL(vela,PERIOD_D1)==true){               
               count=vela;
               L2=iLow(NULL,PERIOD_D1,vela);//Guardar Valor
               L2_V=vela;               
               break;
           }         
      }
     }
     //DETECTAR H2     
     for (int vela =count; vela<maxvela;vela++){
      //Detectar cuando el valor es diferente a 0 en las ultimas N velas
      if(iCustom(NULL, PERIOD_D1, "ZigZag", depth, desviation, backstep, 0, vela)!=0){
           //Found++;
           zigzagg =iCustom(NULL, PERIOD_D1, "ZigZag", depth, desviation, backstep, 0, vela);
           if(isPatronH(vela,PERIOD_D1)==true){              
               count=vela;
               H2=iHigh(NULL,PERIOD_D1,vela);//Guardar Valor
               H2_V=vela;
               break;
           }         
      }
     }
  
   
      //COMPARAR Patron LHLH-Choch 
 if((L1>L2&&H1>H2)&&(iHigh(NULL,PERIOD_D1,1)>H1)){ //&&(L2>L1)
      //Ubicamos la vela que contiene el CHOCH
      for (int velascan=L1_V;velascan>=1;velascan--){
         if (iHigh(NULL,PERIOD_D1,velascan)>H1){
            choch_high=velascan;
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
      DrawPriceTrendLine(Time[choch_high], Time[H1_V],  H1,   H1, clrMediumSpringGreen, STYLE_DASHDOT); 
      drawTLH(choch_high,"BOSS",clrAqua,"n6",iHigh(NULL,PERIOD_D1,choch_high));//Dibujar Texto 
                                
      //DIBUJAR ZIGZAG                             
      DrawPriceTrendLine(Time[H1_V], Time[L1_V],  H1, L1,clrCornflowerBlue, STYLE_SOLID);
      DrawPriceTrendLine(Time[L2_V], Time[H1_V],   L2,  H1,clrCornflowerBlue, STYLE_SOLID);
      DrawPriceTrendLine(Time[H2_V], Time[L2_V],   H2,  L2,clrCornflowerBlue, STYLE_SOLID);                              
   } 
}