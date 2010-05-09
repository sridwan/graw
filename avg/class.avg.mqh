//+------------------------------------------------------------------+
//|                                                    class.avg.mqh |
//|                                                 Stephanus Ridwan |
//|                                             sridwan981@gmail.com |
//| Deskripsi:                                                       |
//| averaging martinangle                                            |
//+------------------------------------------------------------------+
#property copyright "Stephanus Ridwan"
#property link      "sridwan981@gmail.com"
// param
#define AV_BUY_GO             0
#define AV_SELL_GO            1
#define AV_SAVE_RANGE         2
#define AV_MAXPOS             3
#define AV_CUTLOSSPRICE_SELL  4
#define AV_1_LOT              5
#define AV_2_LOT              6
#define AV_3_LOT              7
#define AV_4_LOT              8
#define AV_5_LOT              9
#define AV_6_LOT             10
#define AV_7_LOT             11
#define AV_8_LOT             12
#define AV_9_LOT             13
#define AV_10_LOT            14
#define AV_2_SPREAD          15
#define AV_3_SPREAD          16
#define AV_4_SPREAD          17
#define AV_5_SPREAD          18
#define AV_6_SPREAD          19
#define AV_7_SPREAD          20
#define AV_8_SPREAD          21
#define AV_9_SPREAD          22
#define AV_10_SPREAD         23
#define AV_1_TP              24
#define AV_2_TP              25
#define AV_3_TP              26
#define AV_4_TP              27
#define AV_5_TP              28
#define AV_6_TP              29
#define AV_7_TP              30
#define AV_8_TP              31
#define AV_9_TP              32
#define AV_10_TP             33
#define AV_CUTLOSS           34
#define AV_CUTLOSSPRICE_BUY  35
// flag
#define AV_FLSTOP             0
#define AV_FLINITPOS          1
#define AV_FLSETUPREST        2
#define AV_FLLAUNCH           3
#define AV_FLPROCEED          4
#define AV_FLBUYAVG           8
#define AV_FLSELLAVG         16
#define AV_FLBUYNSELLAVG     24
// misc
#define AV_MAX_PARAM         36
#define AV_NUM_SCENARIOS     10

//#==================================================================#
//#                      P R O P E R T I E S                         #
//#==================================================================#
double   _av_param[AV_NUM_SCENARIOS][AV_MAX_PARAM];
int      _av_flag_buy[AV_NUM_SCENARIOS];
int      _av_flag_sell[AV_NUM_SCENARIOS];
string   _av_market[AV_NUM_SCENARIOS];
string   _av_symbol;
double   _av_bid, _av_ask;
int      _av_scenario;
//+------------------------------------------------------------------+
//+ >>> S E T                                                        +
//+------------------------------------------------------------------+
void avg.setParam(int scenario, int field, double value)
{
   _av_param[scenario][field] = value;
}
//+------------------------------------------------------------------+
void avg.setFlag(int scenario, int flag, int type)
{
   if (type == AV_FLBUYAVG)
   {
      _av_flag_buy[scenario] = flag;
   }
   else if (type == AV_FLSELLAVG)
   {
      _av_flag_sell[scenario] = flag;
   }
}
//+------------------------------------------------------------------+
void avg.setMarket(int scenario, string market)
{
   _av_market[scenario] = market;
}
//+------------------------------------------------------------------+
void avg.setScenario(int scenario, string market, double& param[])
{
   for(int i=0; i<AV_MAX_PARAM; i++)
   {
      _av_param[scenario][i] = param[i];
   }
   _av_market[scenario] = market;
}
//+------------------------------------------------------------------+
void avg.setLotParam(double& p[], double l1, double l2, double l3,
   double l4, double l5, double l6, double l7, double l8,
   double l9, double l10)
{
   p[AV_1_LOT] = l1;
   p[AV_2_LOT] = l2;
   p[AV_3_LOT] = l3;
   p[AV_4_LOT] = l4;
   p[AV_5_LOT] = l5;
   p[AV_6_LOT] = l6;
   p[AV_7_LOT] = l7;
   p[AV_8_LOT] = l8;
   p[AV_9_LOT] = l9;
   p[AV_10_LOT] = l10;
}
//+------------------------------------------------------------------+
void avg.setSpreadParam(double& p[], double pt, int s2, int s3,
   int s4, int s5, int s6, int s7, int s8, int s9, int s10)
{
   p[AV_2_SPREAD] = s2 * pt;
   p[AV_3_SPREAD] = s3 * pt;
   p[AV_4_SPREAD] = s4 * pt;
   p[AV_5_SPREAD] = s5 * pt;
   p[AV_6_SPREAD] = s6 * pt;
   p[AV_7_SPREAD] = s7 * pt;
   p[AV_8_SPREAD] = s8 * pt;
   p[AV_9_SPREAD] = s9 * pt;
   p[AV_10_SPREAD] = s10 * pt;
}
//+------------------------------------------------------------------+
void avg.setTPParam(double& p[], double pt, int s1, int s2, int s3,
   int s4, int s5, int s6, int s7, int s8, int s9, int s10)
{
   p[AV_1_TP] = s1 * pt;
   p[AV_2_TP] = s2 * pt;
   p[AV_3_TP] = s3 * pt;
   p[AV_4_TP] = s4 * pt;
   p[AV_5_TP] = s5 * pt;
   p[AV_6_TP] = s6 * pt;
   p[AV_7_TP] = s7 * pt;
   p[AV_8_TP] = s8 * pt;
   p[AV_9_TP] = s9 * pt;
   p[AV_10_TP] = s10 * pt;
}
//+------------------------------------------------------------------+
//+ <<< G E T                                                        +
//+------------------------------------------------------------------+
double avg.getParam(int scenario, int field)
{
   return(_av_param[scenario][field]);
}
//+------------------------------------------------------------------+
int avg.getFlag(int scenario, int type)
{
   if (type == AV_FLBUYAVG)
   {
      return(_av_flag_buy[scenario]);
   }
   else if (type == AV_FLSELLAVG)
   {
      return(_av_flag_sell[scenario]);
   }
}
//#==================================================================#
//#                  P U B L I C    M E T H O D                      #
//#==================================================================#
//+------------------------------------------------------------------+
//| apakah scenario yg terakhir sudah selesai berjalan ?             |
//+------------------------------------------------------------------+
bool avg.isLastScenarioClear()
{
   int b = avg.getFlag(_av_scenario, AV_FLBUYAVG);
   int s = avg.getFlag(_av_scenario, AV_FLSELLAVG);
   if ((b == AV_FLSTOP) && (s == AV_FLSTOP))
   {
      return (true);
   }
   return (false);
}
//+------------------------------------------------------------------+
void avg.init()
{
   for(int i=0; i < AV_NUM_SCENARIOS; i++)
   {
      avg.setFlag(i, AV_FLSTOP, AV_FLBUYAVG);
      avg.setFlag(i, AV_FLSTOP, AV_FLSELLAVG);
   }
   _av_scenario = -1;
}
//+------------------------------------------------------------------+
void avg.initParam(double& param[])
{
   for(int i=0; i<AV_MAX_PARAM; i++)
   {
      param[i] = 0.0;
   }
}
//+------------------------------------------------------------------+
void avg.selectScenario(int scenario)
{
   _av_scenario = scenario;
   _av_symbol = _av_market[scenario];
}
//+------------------------------------------------------------------+
bool avg.entryMarket(int type)
{
   int flag;
   flag = avg.getFlag(_av_scenario, type);
   if (flag != AV_FLSTOP) { return(false); }
   
   // check if opposite avg have opened too many positions
   if (!avg.isOppositeAvgSafe(type)) { return(false); }

   if (type == AV_FLBUYAVG)
   {
      int buy_go = avg.getParam(_av_scenario, AV_BUY_GO);
      if (buy_go > 0)
      {
         avg.start(AV_FLBUYAVG);
         return(true);
      }
   }
   else if (type == AV_FLSELLAVG)
   {
      int sell_go = avg.getParam(_av_scenario, AV_SELL_GO);
      if (sell_go > 0)
      {
         avg.start(AV_FLSELLAVG);
         return(true);
      }
   }
   
   return(false);
}
//+------------------------------------------------------------------+
int avg.go()
{
   if (_av_scenario < 0) { return(-1); }
   _av_bid = MarketInfo(_av_symbol, MODE_BID);
   _av_ask = MarketInfo(_av_symbol, MODE_ASK);
   avg.entryMarket(AV_FLBUYAVG);
   avg.entryMarket(AV_FLSELLAVG);
   avg.main(AV_FLBUYAVG);
   avg.main(AV_FLSELLAVG);
}
//+------------------------------------------------------------------+
int avg.main(int type)
{
   int flag;
   flag = avg.getFlag(_av_scenario, type);
   switch(flag)
   {
      case AV_FLINITPOS:
         avg.createInitPos(type);
         avg.setFlag(_av_scenario, AV_FLSETUPREST, type);
         break;
      case AV_FLSETUPREST:
         if (order5.isAllOrderCreated())
         {
            // pastikan initial order tercipta
            int list[10];
            if (type == AV_FLBUYAVG)
            {
               int count = order5.getTicketList(_av_symbol, OR_TYPE_BUY, list);
            }
            else if (type == AV_FLSELLAVG)
            {
               count = order5.getTicketList(_av_symbol, OR_TYPE_SELL, list);
            }
            if (count <= 0)
            {
               avg.setFlag(_av_scenario, AV_FLINITPOS, type);
               break;
            }
            // order posisi sisanya
            avg.createTheRest(type);
            avg.setFlag(_av_scenario, AV_FLLAUNCH, type);
         }
         break;
      case AV_FLLAUNCH:
         if (order5.isAllOrderCreated())
         {
            avg.setFlag(_av_scenario, AV_FLPROCEED, type);
         }
         break;
      case AV_FLPROCEED:
         if (!avg.checkPositions(type))
         {
            avg.liquidAndStop(type);
            avg.setFlag(_av_scenario, AV_FLSTOP, type);
         }
         break;
      case AV_FLSTOP:
         return(AV_FLSTOP);
   }
   return(flag);
}
//+------------------------------------------------------------------+
void avg.liquidAndStop(int type)
{
   int list[10];
   if (type == AV_FLBUYAVG)
   {
      order5.getTicketList(_av_symbol, OR_TYPE_BUY, list);
   }
   else if (type == AV_FLSELLAVG)
   {
      order5.getTicketList(_av_symbol, OR_TYPE_SELL, list);
   }
   order5.sortTicketByLotsDescOP(list);
   order5.removeAllOrder(list);
   avg.setFlag(_av_scenario, AV_FLSTOP, type);
}
//#==================================================================#
//#                  P R I V A T E    M E T H O D                    #
//#==================================================================#
void avg.start(int type)
{
   avg.setFlag(_av_scenario, AV_FLINITPOS, type);
}
//+------------------------------------------------------------------+
void avg.createInitPos(int type)
{
   double sl, tp;
   double initial_lot = avg.getParam(_av_scenario, AV_1_LOT);
   double tp2 = avg.getParam(_av_scenario, AV_1_TP);
   double sl2 = avg.getParam(_av_scenario, AV_CUTLOSS);
      
   
   if (type == AV_FLBUYAVG)
   {
      double cl_price = avg.getParam(_av_scenario, AV_CUTLOSSPRICE_BUY);
      if (cl_price > 0.0) { sl = cl_price; }
      else { sl = _av_ask - sl2; }
      tp = _av_ask + tp2;
      order5.order(_av_symbol, OR_TYPE_BUY, initial_lot, 0, sl, tp);
   }
   else
   {
      cl_price = avg.getParam(_av_scenario, AV_CUTLOSSPRICE_SELL);
      if (cl_price > 0.0) { sl = cl_price; }
      else { sl = _av_bid + sl2; }
      tp = _av_bid - tp2;
      order5.order(_av_symbol, OR_TYPE_SELL, initial_lot, 0, sl, tp);
   }
   //Print("INITORDER _av_ask=", DoubleToStr(_av_ask,2), " tp_param=",
      //DoubleToStr(tp2,2), " sl=", DoubleToStr(sl,2), " tp=", DoubleToStr(tp,2));
}
//+------------------------------------------------------------------+
void avg.createTheRest(int type)
{
   double sl, tp, price, spreads[10], lots[10], tp2[10];
   int maxpos = avg.getParam(_av_scenario, AV_MAXPOS);
   //double lot = avg.getParam(_av_scenario, AV_INITIAL_LOT);
   double sl2 = avg.getParam(_av_scenario, AV_CUTLOSS);
   int list[10], pos, ot, m;
   
   spreads[1] = avg.getParam(_av_scenario, AV_2_SPREAD);
   spreads[2] = avg.getParam(_av_scenario, AV_3_SPREAD);
   spreads[3] = avg.getParam(_av_scenario, AV_4_SPREAD);
   spreads[4] = avg.getParam(_av_scenario, AV_5_SPREAD);
   spreads[5] = avg.getParam(_av_scenario, AV_6_SPREAD);
   spreads[6] = avg.getParam(_av_scenario, AV_7_SPREAD);
   spreads[7] = avg.getParam(_av_scenario, AV_8_SPREAD);
   spreads[8] = avg.getParam(_av_scenario, AV_9_SPREAD);
   spreads[9] = avg.getParam(_av_scenario, AV_10_SPREAD);
   lots[1] = avg.getParam(_av_scenario, AV_2_LOT);
   lots[2] = avg.getParam(_av_scenario, AV_3_LOT);
   lots[3] = avg.getParam(_av_scenario, AV_4_LOT);
   lots[4] = avg.getParam(_av_scenario, AV_5_LOT);
   lots[5] = avg.getParam(_av_scenario, AV_6_LOT);
   lots[6] = avg.getParam(_av_scenario, AV_7_LOT);
   lots[7] = avg.getParam(_av_scenario, AV_8_LOT);
   lots[8] = avg.getParam(_av_scenario, AV_9_LOT);
   lots[9] = avg.getParam(_av_scenario, AV_10_LOT);
   tp2[1] = avg.getParam(_av_scenario, AV_2_TP);
   tp2[2] = avg.getParam(_av_scenario, AV_3_TP);
   tp2[3] = avg.getParam(_av_scenario, AV_4_TP);
   tp2[4] = avg.getParam(_av_scenario, AV_5_TP);
   tp2[5] = avg.getParam(_av_scenario, AV_6_TP);
   tp2[6] = avg.getParam(_av_scenario, AV_7_TP);
   tp2[7] = avg.getParam(_av_scenario, AV_8_TP);
   tp2[8] = avg.getParam(_av_scenario, AV_9_TP);
   tp2[9] = avg.getParam(_av_scenario, AV_10_TP);
      
   if (type == AV_FLBUYAVG)
   {
      double cl_price = avg.getParam(_av_scenario, AV_CUTLOSSPRICE_BUY);
      order5.getTicketList(_av_symbol, OR_TYPE_BUY, list);
      pos = order5.findOrderPosByTicket(list[0]);
      // initial avg's price
      price = order5.getPrice(pos);
      if (cl_price > 0.0) { sl = cl_price; }
      else { sl = price - sl2; }
      ot = OR_TYPE_BUY;
      m = -1;
   }
   else
   {
      cl_price = avg.getParam(_av_scenario, AV_CUTLOSSPRICE_SELL);
      order5.getTicketList(_av_symbol, OR_TYPE_SELL, list);
      pos = order5.findOrderPosByTicket(list[0]);
      // initial avg's price
      price = order5.getPrice(pos);
      if (cl_price > 0.0) { sl = cl_price; }
      else { sl = price + sl2; }
      ot = OR_TYPE_SELL;
      m = 1;
   }
   for (int i=1; i < maxpos; i++)
   {
      price = price + (spreads[i] * m);
      tp = price - (tp2[i] * m);
      order5.order(_av_symbol, ot, lots[i], price, sl, tp);
      
      //Print("ORDER price=", price, " lot=", DoubleToStr(lots[i],4), " sl=", DoubleToStr(sl,6), " tp=", DoubleToStr(tp,6));
   }
}
//+------------------------------------------------------------------+
bool avg.checkPositions(int type)
{
   int list[10];
   if (type == AV_FLBUYAVG)
   {
      order5.getTicketList(_av_symbol, OR_TYPE_BUY, list);
   }
   else
   {
      order5.getTicketList(_av_symbol, OR_TYPE_SELL, list);
   }
   if (!order5.isAllOrderStillExist(list))
   {
      return(false);
   }
   return(true);
}
//+------------------------------------------------------------------+
bool avg.isOppositeAvgSafe(int type)
{
   int list[10];
   double current_price, order_price;
   double tmp, delta;
   if (type == AV_FLBUYAVG)
   {
      if (!order5.getTicketList(_av_symbol, OR_TYPE_SELL, list, 1)) { return(true); }
      OrderSelect(list[0], SELECT_BY_TICKET);
      if (OrderType() != OP_SELL) { return(true); }
      order_price = OrderOpenPrice();
      current_price = MarketInfo(_av_symbol, MODE_BID);
      tmp = avg.getParam(_av_scenario, AV_SAVE_RANGE);
      delta = current_price - order_price;
      if (delta < tmp) { return(true); }
   }
   else if (type == AV_FLSELLAVG)
   {
      if (!order5.getTicketList(_av_symbol, OR_TYPE_BUY, list, 1)) { return(true); }
      OrderSelect(list[0], SELECT_BY_TICKET);
      if (OrderType() != OP_BUY) { return(true); }
      order_price = OrderOpenPrice();
      current_price = MarketInfo(_av_symbol, MODE_ASK);
      tmp = avg.getParam(_av_scenario, AV_SAVE_RANGE);
      delta = order_price - current_price;
      if (delta < tmp) { return(true); }
   }
   
   return(false);
}
//+------------------------------------------------------------------+

