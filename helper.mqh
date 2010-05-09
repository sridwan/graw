//+------------------------------------------------------------------+
//|                                                       helper.mqh |
//|                                                 Stephanus Ridwan |
//|                                      sridwan981 at gmail dot com |
//| Deskripsi:                                                       |
//| Misc. helper function                                            |
//+------------------------------------------------------------------+
#property copyright "Stephanus Ridwan"
#property link      "sridwan981@gmail.com"
//+------------------------------------------------------------------+
bool isNewDay()
{
  static int dow = -1;
  if (dow != Day())
  {
    dow = Day();
    return(true);
  }
  return(false);
}
//+------------------------------------------------------------------+
int OrdersTotalByPair(string pair)
{
  int count = 0;
  for(int i = 0; i < OrdersTotal(); i++)
  {
    OrderSelect(i, SELECT_BY_POS);
    if (OrderSymbol() == pair) { count++; }
  }
  return(count);
}
//+------------------------------------------------------------------+

