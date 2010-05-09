//+------------------------------------------------------------------+
//|                                                 class.order5.mqh |
//|                                                 Stephanus Ridwan |
//|                                             sridwan981@yahoo.com |
//| Deskripsi:                                                       |
//| object utk pesan harga                                           |
//| FUNGSI YG DISEDIAKAN                                             |
//| 1. request order (order5.order)                                  |
//| 2. liquid order (order5.removeOrderByTicket)                     |
//| 3. check if order still exist                                    |
//| 4. get ticket, type of requested order                           |
//+------------------------------------------------------------------+
#property copyright "Stephanus Ridwan"
#property link      "sridwan981@yahoo.com"

#include <stderror.mqh>

#define OR_ARRSIZE      200
#define OR_INTSIZE      5
#define OR_DBLSIZE      4
#define OR_STRSIZE      1
// int
#define OR_TICKET       0
#define OR_TYPE         1
#define OR_DIGITS       2
#define OR_EXPIRES      3
#define OR_MARK         4
// double
#define OR_LOTS         0
#define OR_OPENPRICE    1
#define OR_SL           2
#define OR_TP           3
// string
#define OR_SYMBOL       0
// tipe order
#define OR_TYPE_BUY     1
#define OR_TYPE_SELL    2
#define OR_MARKED       1
#define OR_NOTMARKED    0
//#==================================================================#
//#                      P R O P E R T I E S
//#==================================================================#
double _orderDbl[OR_ARRSIZE][OR_DBLSIZE];
int    _orderInt[OR_ARRSIZE][OR_INTSIZE];
string _orderStr[OR_ARRSIZE][OR_STRSIZE];
int    _orderCount;
double _waitDbl[OR_ARRSIZE][OR_DBLSIZE];
int    _waitInt[OR_ARRSIZE][OR_INTSIZE];
string _waitStr[OR_ARRSIZE][OR_STRSIZE];
int    _waitCount;
//+------------------------------------------------------------------+
//| _order getter function                                           |
//+------------------------------------------------------------------+
int order5.getTicket(int i)
{
   return(_orderInt[i][OR_TICKET]);
}
//+------------------------------------------------------------------+
int order5.getType(int i)
{
   return(_orderInt[i][OR_TYPE]);
}
//+------------------------------------------------------------------+
string order5.getSymbol(int i)
{
   return(_orderStr[i][OR_SYMBOL]);
}
//+------------------------------------------------------------------+
int order5.getDigits(int i)
{
   return(_orderInt[i][OR_DIGITS]);
}
//+------------------------------------------------------------------+
double order5.getPrice(int i)
{
   if (_orderDbl[i][OR_OPENPRICE] == 0)
   {
      int ticket = order5.getTicket(i);
      OrderSelect(ticket, SELECT_BY_TICKET);
      _orderDbl[i][OR_OPENPRICE] = OrderOpenPrice();
   }
   return(NormalizeDouble(_orderDbl[i][OR_OPENPRICE], order5.getDigits(i)));
}
//+------------------------------------------------------------------+
double order5.getLots(int i)
{
   return(_orderDbl[i][OR_LOTS]);
}
//+------------------------------------------------------------------+
int order5.getTicketList(string symbol, int type, int& list[], int count=100000)
{
   int listPtr = 0;
   int oc = _orderCount;
   // init Array
   ArrayInitialize(list, -1);
   for(int i=0; (i < oc) && (i < count); i++)
   {
      if ((order5.getSymbol(i) == symbol) && (order5.getType(i) == type))
      {
         list[listPtr] = order5.getTicket(i);
         listPtr++;
      }
   }
   return(listPtr);
}
//+------------------------------------------------------------------+
//| _wait setter function                                                  |
//+------------------------------------------------------------------+
void order5.setWaitType(int ptr, int type)
{
   _waitInt[ptr][OR_TYPE] = type;
}
//+------------------------------------------------------------------+
void order5.setWaitTicket(int ptr, int ticket)
{
   _waitInt[ptr][OR_TICKET] = ticket;
}
//+------------------------------------------------------------------+
void order5.setWaitDbl(int ptr, double lots, double price, double sl, double tp)
{
   _waitDbl[ptr][OR_LOTS]      = lots;
   _waitDbl[ptr][OR_OPENPRICE] = price;
   _waitDbl[ptr][OR_SL]        = sl;
   _waitDbl[ptr][OR_TP]        = tp;
}
//+------------------------------------------------------------------+
void order5.setWaitSymbol(int ptr, string symbol)
{
   _waitStr[ptr][OR_SYMBOL] = symbol;
   // karena symbol sdh tahu, kita masukkan digits (int)
   int d = MarketInfo(symbol, MODE_DIGITS);
   _waitInt[ptr][OR_DIGITS] = d;
}
//+------------------------------------------------------------------+
void order5.setWaitMark(int ptr, int mark=OR_MARKED)
{
   _waitInt[ptr][OR_MARK] = mark;
}
//+------------------------------------------------------------------+
void order5.setWaitExpires(int ptr, int ex)
{
   _waitInt[ptr][OR_EXPIRES] = ex;
}
//+------------------------------------------------------------------+
//| _wait getter function                                            |
//+------------------------------------------------------------------+
int order5.getWaitType(int ptr)
{
   return(_waitInt[ptr][OR_TYPE]);
}
//+------------------------------------------------------------------+
double order5.getWaitPrice(int ptr)
{
   return(NormalizeDouble(_waitDbl[ptr][OR_OPENPRICE], order5.getWaitDigits(ptr)));
}
//+------------------------------------------------------------------+
string order5.getWaitSymbol(int ptr)
{
   return(_waitStr[ptr][OR_SYMBOL]);
}
//+------------------------------------------------------------------+
int order5.getWaitDigits(int ptr)
{
   return(_waitInt[ptr][OR_DIGITS]);
}
//+------------------------------------------------------------------+
double order5.getWaitLots(int ptr)
{
   return(NormalizeDouble(_waitDbl[ptr][OR_LOTS], 2));
}
//+------------------------------------------------------------------+
double order5.getWaitSL(int ptr)
{
   return(NormalizeDouble(_waitDbl[ptr][OR_SL], order5.getWaitDigits(ptr)));
}
//+------------------------------------------------------------------+
double order5.getWaitTP(int ptr)
{
   return(NormalizeDouble(_waitDbl[ptr][OR_TP], order5.getWaitDigits(ptr)));
}
//+------------------------------------------------------------------+
int order5.getWaitTicket(int ptr)
{
   return(_waitInt[ptr][OR_TICKET]);
}
//+------------------------------------------------------------------+
int order5.getWaitMark(int ptr)
{
   return(_waitInt[ptr][OR_MARK]);
}
//+------------------------------------------------------------------+
int order5.getWaitExpires(int ptr)
{
   return(_waitInt[ptr][OR_EXPIRES]);
}
//#==================================================================#
//#                  P U B L I C    M E T H O D
//#==================================================================#
//+------------------------------------------------------------------+
//| clear order                                                      |
//+------------------------------------------------------------------+
void order5.clearOrder()
{
   ArrayInitialize(_orderDbl, 0.0);
   ArrayInitialize(_orderInt, 0);
   ArrayInitialize(_orderStr, "");
   //_orderPtr = 0;
   _orderCount = 0;
}
//+------------------------------------------------------------------+
//| queue order                                                      |
//+------------------------------------------------------------------+
void order5.order(string symbol, int type, double volume, double price,
   double stoploss, double takeprofit, int expires=0)
{
   order5.setWaitSymbol(_waitCount, symbol);
   order5.setWaitDbl(_waitCount, volume, price, stoploss, takeprofit);
   order5.setWaitType(_waitCount, type);
   order5.setWaitExpires(_waitCount, expires);
   order5.setWaitMark(_waitCount, OR_NOTMARKED);
   _waitCount++;
}
//+------------------------------------------------------------------+
//| modify order's Stop Loss                                         |
//+------------------------------------------------------------------+
bool order5.modifySLByTicket(int ticket, double stoploss)
{
   OrderSelect(ticket, SELECT_BY_TICKET);
   int pos = order5.findOrderPosByTicket(ticket);
   if (pos < 0) { return(false); }
   int digits = order5.getDigits(pos);
   double sl = NormalizeDouble(stoploss, digits);
   bool result = OrderModify(ticket, OrderOpenPrice(), sl, OrderTakeProfit(), 0);
   if (result) { _orderDbl[pos][OR_SL] = sl; }
   return(result);
}
//+------------------------------------------------------------------+
//| modify order's Take Profit                                       |
//+------------------------------------------------------------------+
bool order5.modifyTPByTicket(int ticket, double takeprofit)
{
   OrderSelect(ticket, SELECT_BY_TICKET);
   int pos = order5.findOrderPosByTicket(ticket);
   if (pos < 0) { return(false); }
   int digits = order5.getDigits(pos);
   double tp = NormalizeDouble(takeprofit, digits);
   bool result = OrderModify(ticket, OrderOpenPrice(), OrderStopLoss(), tp, 0);
   return(result);
}
//+------------------------------------------------------------------+
//| is all order have been created?                                  |
//+------------------------------------------------------------------+
bool order5.isAllOrderCreated()
{
   if (_waitCount > 0) { return(false); }
   return(true);
}
//+------------------------------------------------------------------+
//| remove order                                                     |
//+------------------------------------------------------------------+
void order5.removeOrderByPos(int ptr)
{
   if (ptr >= _orderCount) { return; } // posisi tdk valid
   if (order5.isLiveOrder(ptr))
   {
      order5.liquidLiveOrder(ptr);
   }
   else if (order5.isPendingOrder(ptr))
   {
      int ticket = order5.getTicket(ptr);
      if (order5.isOrderStillExist(ptr)) { OrderDelete(ticket); }
   }
   order5.deleteOrder(ptr);
}
//+------------------------------------------------------------------+
void order5.removeOrderByTicket(int ticket)
{
   int pos = order5.findOrderPosByTicket(ticket);
   if (pos > -1) { order5.removeOrderByPos(pos); }
}
//+------------------------------------------------------------------+
//| find order's position by ticket                                  |
//+------------------------------------------------------------------+
int order5.findOrderPosByTicket(int ticket)
{
   int oc = _orderCount;
   for(int i=0; i < oc; i++)
   {
      if (order5.getTicket(i) == ticket) { return(i); }
   }
   return(-1); // ticket not found
}
//+------------------------------------------------------------------+
//| main loop proses queue, panggil per tick                         |
//+------------------------------------------------------------------+
void order5.processOrder()
{
   //int doneCount = 0;
   int wc = _waitCount;
   for(int i=0; i < wc; i++)
   {
      if (order5.try(i))
      {
         order5.copyFromWaitToOrder(i);
         order5.setWaitMark(i);
      }
   }
   order5.deleteMarkedWait();
}
//+------------------------------------------------------------------+
//| cek apakah semua order masih lengkap                             |
//+------------------------------------------------------------------+
bool order5.isAllOrderStillExist(int& list[])
{
   int i = 0;
   while(list[i] != -1)
   {
      OrderSelect(list[i], SELECT_BY_TICKET);
      if (OrderCloseTime() > 0) { return(false); }
      i++;
   }
   return(true);
}
//+------------------------------------------------------------------+
//| same as order5.isAllOrderStillExist, but also count profitloss   |
//+------------------------------------------------------------------+
bool order5.isAllOrderStillExistPL(int& list[], double& pl)
{
   int i = 0;
   bool result = true;
   pl = 0.0;
   while(list[i] != -1)
   {
      OrderSelect(list[i], SELECT_BY_TICKET);
      if (OrderCloseTime() > 0) { result = false; }
      pl += OrderProfit();
      i++;
   }
   return(result);
}
//+------------------------------------------------------------------+
//| cek profit / loss dari semua order                               |
//+------------------------------------------------------------------+
double order5.profitLoss(int& list[])
{
   int i = 0;
   double pl = 0.0;
   while(list[i] != -1)
   {
      OrderSelect(list[i], SELECT_BY_TICKET);
      pl += OrderProfit();
      i++;
   }
   return(pl);
}
//+------------------------------------------------------------------+
//| liquid semua posisi                                              |
//+------------------------------------------------------------------+
bool order5.removeAllOrder(int& list[])
{
   int i = 0;
   while(list[i] != -1)
   {
      order5.removeOrderByTicket(list[i]);
      i++;
   }
}
//+------------------------------------------------------------------+
//| sort ticket by lots descending                                   |
//| (biggest lots & Open Position first)                             |
//+------------------------------------------------------------------+
void order5.sortTicketByLotsDescOP(int& list[])
{
   double lots[20];
   int t, count = 0;
   double l;
   // get lots
   for(int i=0; list[i] != -1; i++)
   {
      int pos = order5.findOrderPosByTicket(list[i]);
      lots[i] = order5.getLots(pos);
      if (order5.isLiveOrder(pos)) { lots[i] += 100; }
      count++;
   }
   // sort
   for(i=0; i < count-1; i++)
   {
      for(int j=i+1; j < count; j++)
      {
         if (lots[i] >= lots[j]) { continue; }
         // lot
         l = lots[i];
         lots[i] = lots[j];
         lots[j] = l;
         // ticket
         t = list[i];
         list[i] = list[j];
         list[j] = t;
      }
   }
}
//+------------------------------------------------------------------+
//| sort ticket by lots descending (biggest lots first)              |
//+------------------------------------------------------------------+
void order5.sortTicketByLotsDesc(int& list[])
{
   double lots[20];
   int t, count = 0;
   double l;
   // get lots
   for(int i=0; list[i] != -1; i++)
   {
      int pos = order5.findOrderPosByTicket(list[i]);
      lots[i] = order5.getLots(pos);
      count++;
   }
   // sort
   for(i=0; i < count-1; i++)
   {
      for(int j=i+1; j < count; j++)
      {
         if (lots[i] >= lots[j]) { continue; }
         // lot
         l = lots[i];
         lots[i] = lots[j];
         lots[j] = l;
         // ticket
         t = list[i];
         list[i] = list[j];
         list[j] = t;
      }
   }
}
//+------------------------------------------------------------------+
//| apakah order sudah jadi open                                     |
//+------------------------------------------------------------------+
bool order5.isLiveOrder(int ptr)
{
   OrderSelect(order5.getTicket(ptr),SELECT_BY_TICKET);
   // apakah sudah open (type = OP_BUY / OP_SELL)
   int op = OrderType();
   if ((op == OP_BUY) || (op == OP_SELL))
   {
      if (OrderCloseTime() == 0) { return(true);  }
      else                       { return(false); }
   }
   return(false);
}
//+------------------------------------------------------------------+
bool order5.isLiveOrderByTicket(int ticket)
{
   int pos = order5.findOrderPosByTicket(ticket);
   bool result = order5.isLiveOrder(pos);
   return(result);
}
//+------------------------------------------------------------------+
//| apakah order masih pending                                       |
//+------------------------------------------------------------------+
bool order5.isPendingOrder(int ptr)
{
   OrderSelect(order5.getTicket(ptr),SELECT_BY_TICKET);
   // apakah sudah open (type = OP_BUY / OP_SELL)
   int op = OrderType();
   if ((op != OP_BUY) && (op != OP_SELL))
   {
      if (OrderMagicNumber() == 0) { return(true);  }
      else                         { return(false); }
   }
   return(false);
}
//+------------------------------------------------------------------+
bool order5.isOrderStillExist(int ptr)
{
   int ttl = OrdersTotal();
   int ticket = order5.getTicket(ptr);
   OrderSelect(ticket, SELECT_BY_TICKET);
   if (OrderCloseTime() == 0) { return(true); }
   return(false);
}
//+------------------------------------------------------------------+
void order5.liquidLiveOrder(int ptr)
{
   string symbol = order5.getSymbol(ptr);
   int the_ticket = order5.getTicket(ptr);
   int type = order5.getType(ptr);
   int dgt = order5.getDigits(ptr);
   double prefPrice;
   if (type == OR_TYPE_BUY) { prefPrice = MarketInfo(symbol, MODE_BID); }
   else                     { prefPrice = MarketInfo(symbol, MODE_ASK); }
   
   OrderSelect(the_ticket, SELECT_BY_TICKET);
   if (OrderCloseTime() > 0) { return; } // sudah tertutup sendiri, mission accomplished :p
   bool closed = OrderClose(the_ticket, OrderLots(), NormalizeDouble(prefPrice,dgt), 5);
   if (!closed)
   { 
      // fix utk kadang2 order yg baru TP, tapi close time-nya belum terupdate (masih bernilai 0)
      if (GetLastError() == ERR_INVALID_TICKET) { return; }
      while(true)
      {
         RefreshRates();
         if (type == OR_TYPE_BUY) { prefPrice = MarketInfo(symbol, MODE_BID); }
         else                     { prefPrice = MarketInfo(symbol, MODE_ASK); }
         closed = OrderClose(the_ticket, OrderLots(), NormalizeDouble(prefPrice,dgt), 5);
         if (GetLastError() == ERR_INVALID_TICKET) { break; }
         if (closed || (OrderCloseTime() > 0)) { break; }
      }
   }
}
//#==================================================================#
//#                  P R I V A T E    M E T H O D
//#==================================================================#
//+------------------------------------------------------------------+
//| hapus order dari list                                            |
//+------------------------------------------------------------------+
void order5.deleteOrder(int i)
{
   ArrayCopy(_orderDbl, _orderDbl, i*OR_DBLSIZE, (i+1)*OR_DBLSIZE);
   ArrayCopy(_orderInt, _orderInt, i*OR_INTSIZE, (i+1)*OR_INTSIZE);
   ArrayCopy(_orderStr, _orderStr, i*OR_STRSIZE, (i+1)*OR_STRSIZE);
   _orderCount--;
}
//+------------------------------------------------------------------+
//| proses queue / wait                                              |
//+------------------------------------------------------------------+
bool order5.try(int i)
{
   string symbol = order5.getWaitSymbol(i);
   int type = order5.getWaitType(i);
   double reqPrice = order5.getWaitPrice(i);
   // if price is 0, use current Bid / Ask
   if (reqPrice <= 0)
   {
      if (type == OR_TYPE_BUY)
      {
         reqPrice = MarketInfo(symbol, MODE_ASK);
      }
      else if (type == OR_TYPE_SELL)
      {
         reqPrice = MarketInfo(symbol, MODE_BID);
      }
   }
   int cmd = order5.bestOperationType(symbol, type, reqPrice);
   int expires = order5.getWaitExpires(i);
   
   int ticket = OrderSend(symbol, cmd, order5.getWaitLots(i), reqPrice, 5,
      order5.getWaitSL(i), order5.getWaitTP(i), NULL, 0, expires);
   if (ticket == -1)
   {
      int error_code = GetLastError();
      if (!order5.isRetriable(error_code))
      {
         // hapus order dari wait list
         order5.setWaitMark(i);
      }
      return(false);
   }
   order5.setWaitTicket(i, ticket);
   return(true);
}
//+------------------------------------------------------------------+
//| menentukan apakah order error yg fatal atau tidak                |
//+------------------------------------------------------------------+
bool order5.isRetriable(int err_code)
{
   if (err_code == 130) { return(false); }
   return(true);
}
//+------------------------------------------------------------------+
//| menentukan operation type terbaik utk OrderSend                  |
//+------------------------------------------------------------------+
int order5.bestOperationType(string symbol, int type, double reqPrice)
{
   double runningPrice;
   
   if (type == OR_TYPE_BUY)
   {
      runningPrice = MarketInfo(symbol, MODE_ASK);
      if (reqPrice > runningPrice) { return(OP_BUYSTOP); }
      if (reqPrice < runningPrice) { return(OP_BUYLIMIT); }
      return(OP_BUY);
   }
   
   if (type == OR_TYPE_SELL)
   {
      runningPrice = MarketInfo(symbol, MODE_BID);
      if (reqPrice > runningPrice) { return(OP_SELLLIMIT); }
      if (reqPrice < runningPrice) { return(OP_SELLSTOP); }
      return(OP_SELL);
   }
}
//+------------------------------------------------------------------+
//| order done, copy from _wait to _order                            |
//+------------------------------------------------------------------+
void order5.copyFromWaitToOrder(int ptr)
{
   // copy to _order, _order tambah 1
   ArrayCopy(_orderDbl, _waitDbl, _orderCount*OR_DBLSIZE, ptr*OR_DBLSIZE, OR_DBLSIZE);
   ArrayCopy(_orderInt, _waitInt, _orderCount*OR_INTSIZE, ptr*OR_INTSIZE, OR_INTSIZE);
   ArrayCopy(_orderStr, _waitStr, _orderCount*OR_STRSIZE, ptr*OR_STRSIZE, OR_STRSIZE);
   _orderCount++;
}
//+------------------------------------------------------------------+
//| delete order from wait                                           |
//+------------------------------------------------------------------+
void order5.deleteMarkedWait()
{
   // delete from _wait
   for(int i = _waitCount-1; i >=0; i--)
   {
      if (order5.getWaitMark(i) == OR_MARKED)
      {
         ArrayCopy(_waitDbl, _waitDbl, i*OR_DBLSIZE, (i+1)*OR_DBLSIZE);
         ArrayCopy(_waitInt, _waitInt, i*OR_INTSIZE, (i+1)*OR_INTSIZE);
         ArrayCopy(_waitStr, _waitStr, i*OR_STRSIZE, (i+1)*OR_STRSIZE);
         _waitCount--;
      }
   }
}
//+------------------------------------------------------------------+
//| debug function                                                   |
//+------------------------------------------------------------------+
void order5.debugWait()
{
   //writeToLog("ticket,symbol,type,lots,digits,price,sl,tp");
   int wc = _waitCount;
   for(int i=0; i < wc; i++)
   {
      string str = StringConcatenate(_waitCount, ", ", order5.getWaitTicket(i));
      str = StringConcatenate(str,",",order5.getWaitSymbol(i),",");
      str = StringConcatenate(str,order5.getWaitType(i),",");
      str = StringConcatenate(str,order5.getWaitLots(i),",");
      str = StringConcatenate(str,order5.getWaitDigits(i),",");
      str = StringConcatenate(str,order5.getWaitPrice(i),",");
      str = StringConcatenate(str,order5.getWaitSL(i),",");
      str = StringConcatenate(str,order5.getWaitTP(i));
      Print(str);
      //writeToLog(str);
   }
}
//+------------------------------------------------------------------+
void order5.debugOrder()
{
   //writeToLog("ticket,symbol,type,lots,digits,price,sl,tp");
   int oc = _orderCount;
   for(int i=0; i < oc; i++)
   {
      string str = order5.getTicket(i);
      str = StringConcatenate(str,",",_orderStr[i][OR_SYMBOL],",");
      str = StringConcatenate(str,order5.getType(i),",");
      str = StringConcatenate(str,_orderDbl[i][OR_LOTS],",");
      str = StringConcatenate(str,_orderInt[i][OR_DIGITS],",");
      str = StringConcatenate(str,_orderDbl[i][OR_OPENPRICE],",");
      str = StringConcatenate(str,_orderDbl[i][OR_SL],",");
      str = StringConcatenate(str,_orderDbl[i][OR_TP]);
      Print(str);
      //writeToLog(str);
   }
}
//+------------------------------------------------------------------+

