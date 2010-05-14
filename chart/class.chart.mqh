//+------------------------------------------------------------------+
//|                                                  class.chart.mqh |
//|                                                 Stephanus Ridwan |
//|                                      sridwan981 at gmail dot com |
//| Deskripsi:                                                       |
//| Simplify making chart objects.                                   |
//| Docs:                                                            |
//| Jenis2 garis: STYLE_SOLID, STYLE_DASH, STYLE_DOT, STYLE_DASHDOT, |
//| STYLE_DASHDOTDOT                                                 |
//+------------------------------------------------------------------+
#property copyright "Stephanus Ridwan"
#property link      "sridwan981@gmail.com"

#define CH_PREFIX          "obj"
#define CH_BOX_SUFFIX      "_box"
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
string chart.text(datetime x1, double y1, color clr, string text, int size=18,
  string font="Arial")
{
   _ch_counter++;
   string obj_name = CH_PREFIX + _ch_counter;
   ObjectCreate(obj_name, OBJ_TEXT, 0, x1, y1);
   ObjectSetText(obj_name, text, size, font, clr);
   return(obj_name);
}
//+------------------------------------------------------------------+
string chart.label(int x1, int y1, color clr, string text, int size=18,
  string font="Arial")
{
   _ch_counter++;
   string obj_name = CH_PREFIX + _ch_counter;
   ObjectCreate(obj_name, OBJ_LABEL, 0, 0, 0);
   ObjectSet(obj_name, OBJPROP_XDISTANCE, x1);
   ObjectSet(obj_name, OBJPROP_YDISTANCE, y1);
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
//+------------------------------------------------------------------+
void chart.changeBoxColor(string name, color clr)
{
  string boxname = name + CH_BOX_SUFFIX;
  ObjectSet(boxname, OBJPROP_COLOR, clr);
}
//+------------------------------------------------------------------+
string chart.getBoxName(string name)
{
  return(name + CH_BOX_SUFFIX);
}
//+------------------------------------------------------------------+
string chart.boxedLabel(int x1, int y1, int bx, int by, color txtclr,
  color boxclr, string text, int txtsize=12, int boxsize=120, string font="Arial")
{
  string obj_name = chart.label(x1, y1, txtclr, text, txtsize, font);
  string box_name = obj_name + CH_BOX_SUFFIX;
  ObjectCreate(box_name, OBJ_LABEL, 0, 0, 0);
  ObjectSet(box_name, OBJPROP_XDISTANCE, x1-bx);
  ObjectSet(box_name, OBJPROP_YDISTANCE, y1-by);
  ObjectSet(box_name, OBJPROP_BACK, true);
  ObjectSetText(box_name, "-", boxsize, "Arial Black", boxclr);
  return(obj_name);
}
//#==================================================================#
//#                  P R I V A T E    M E T H O D                    #
//#==================================================================#