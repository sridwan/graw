//+------------------------------------------------------------------+
//|                                                  class.chart.mqh |
//|                                                 Stephanus Ridwan |
//|                                             sridwan981@gmail.com |
//| Deskripsi:                                                       |
//| Saat ini hanya membuat garis :D                                  |
//| Docs:                                                            |
//| Jenis2 garis: STYLE_SOLID, STYLE_DASH, STYLE_DOT, STYLE_DASHDOT, |
//| STYLE_DASHDOTDOT                                                 |
//+------------------------------------------------------------------+
#property copyright "Stephanus Ridwan"
#property link      "sridwan981@gmail.com"

#define CH_PREFIX          "obj"
//#==================================================================#
//#                      P R O P E R T I E S                         #
//#==================================================================#
int   _ch_counter;
//+------------------------------------------------------------------+
//+ >>> P U T                                                        +
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//+ <<< G E T                                                        +
//+------------------------------------------------------------------+
//#==================================================================#
//#                  P U B L I C    M E T H O D                      #
//#==================================================================#
void chart.init()
{
   _ch_counter = 0;
}
//+------------------------------------------------------------------+
string chart.line(datetime x1, double y1, datetime x2, double y2,
   color clr, int width=1, int line_type=STYLE_SOLID, bool ray=false)
{
   _ch_counter++;
   string obj_name = CH_PREFIX + _ch_counter;
   ObjectCreate(obj_name, OBJ_TREND, 0, x1, y1, x2, y2);
   ObjectSet(obj_name, OBJPROP_COLOR, clr);
   ObjectSet(obj_name, OBJPROP_STYLE, line_type);
   ObjectSet(obj_name, OBJPROP_RAY, ray);
   ObjectSet(obj_name, OBJPROP_WIDTH, width);
   return(obj_name);
}
//+------------------------------------------------------------------+
string chart.text(datetime x1, double y1, color clr, string text, int size=18, string font="")
{
   _ch_counter++;
   string obj_name = CH_PREFIX + _ch_counter;
   ObjectCreate(obj_name, OBJ_TEXT, 0, x1, y1);
   ObjectSetText(obj_name, text, size, font, clr);
   return(obj_name);
}
//+------------------------------------------------------------------+
string chart.label(int x1, int y1, color clr, string text, int size=18, string font="")
{
   _ch_counter++;
   string obj_name = CH_PREFIX + _ch_counter;
   ObjectCreate(obj_name, OBJ_LABEL, 0, x1, y1);
   ObjectSetText(obj_name, text, size, font, clr);
   return(obj_name);
}
//+------------------------------------------------------------------+
string chart.box(datetime x1, double y1, datetime x2, double y2,
   color clr, int width=1, int line_type=STYLE_SOLID)
{
   _ch_counter++;
   string obj_name = CH_PREFIX + _ch_counter;
   ObjectCreate(obj_name, OBJ_RECTANGLE, 0, x1, y1, x2, y2);
   ObjectSet(obj_name, OBJPROP_COLOR, clr);
   ObjectSet(obj_name, OBJPROP_STYLE, line_type);
   ObjectSet(obj_name, OBJPROP_WIDTH, width);
   ObjectSet(obj_name, OBJPROP_BACK, true);
   return(obj_name);
}
//#==================================================================#
//#                  P R I V A T E    M E T H O D                    #
//#==================================================================#