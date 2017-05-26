public with sharing class JBillingCodeEnumContoller{
//class to controll code reference for fields 
  //documented in API reference Appendix A
  
  //get language code in customer
  public integer GetLanguageCode(string lang)
  {
    integer xcode;
    if(lang.toLowerCase()=='english')
    {  xcode=1;  }
    else if (lang.tolowerCAse() == 'portuguese')
    {  xcode=2;  }
    return xcode;
  }
  //return currency symbols
  
  public string GetCurrencysymbol(string curr)
  { 
    string xcode;
    if(curr.tolowercase() =='United States Dollars' || curr.tolowercase() =='USA'){xcode = '$';}
    if(curr.tolowercase() =='Canadian Dollar' || curr.tolowercase() =='Canada'){xcode = 'CA$';}
    if(curr.tolowercase() =='Euro'|| curr.tolowercase() =='Europe'){xcode = '€';}
    if(curr.tolowercase() =='Yen'|| curr.tolowercase() =='Japan'){xcode = '¥';}
    if(curr.tolowercase() =='Pound Sterling'|| curr.tolowercase() =='United Kingdom'){xcode = '£';}
    if(curr.tolowercase() =='South Korean Won'|| curr.tolowercase() =='South Korea'){xcode = '₩';}
    if(curr.tolowercase() =='Swiss Franc'|| curr.tolowercase() =='Switzerland'){xcode = '₣';}
    if(curr.tolowercase() =='Swedish Krona'|| curr.tolowercase() =='Sweden'){xcode = 'kr';}
    if(curr.tolowercase() =='Singapore Dollar'|| curr.tolowercase() =='Singapore'){xcode = 'S$';}
    if(curr.tolowercase() =='Ringgit'|| curr.tolowercase() =='Malaysia'){xcode = 'RM';}
    if(curr.tolowercase() =='Australian Dollar'|| curr.tolowercase() =='Australia'){xcode = 'A$';}
    return xcode;
  }
  
  public string GetCurrencySign (integer xcode)
  {
    string CurrSign = '';
    if(xcode== 1){return GetCurrencysymbol('United States Dollars');}
    else if(xcode== 2){return GetCurrencysymbol('Canadian Dollar');}
    else if(xcode== 3){return GetCurrencysymbol('Euro');}
    else if(xcode== 4){return GetCurrencysymbol('Yen');}
    else if(xcode== 5){return GetCurrencysymbol('Pound Sterling');}
    else if(xcode== 6){return GetCurrencysymbol('South Korean Won');}
    else if(xcode== 7){return GetCurrencysymbol('Swiss Franc');}
    else if(xcode== 8){return GetCurrencysymbol('Swedish Krona');}
    else if(xcode== 9){return GetCurrencysymbol('Singapore Dollar');}
    else if(xcode== 10){return GetCurrencysymbol('Ringgit');}
    else if(xcode== 11){return GetCurrencysymbol('Australian Dollar');}

    return CurrSign;
  }
  
  
  //currency codes & country codes
  public integer GetCurrencyCode(string curr)
  {
    integer xcode;
    if(curr.tolowercase() =='United States Dollars' || curr.tolowercase() =='USA'){xcode = 1;}
    if(curr.tolowercase() =='Canadian Dollar' || curr.tolowercase() =='Canada'){xcode = 2;}
    if(curr.tolowercase() =='Euro'|| curr.tolowercase() =='Europe'){xcode = 3;}
    if(curr.tolowercase() =='Yen'|| curr.tolowercase() =='Japan'){xcode = 4;}
    if(curr.tolowercase() =='Pound Sterling'|| curr.tolowercase() =='United Kingdom'){xcode = 5;}
    if(curr.tolowercase() =='South Korean Won'|| curr.tolowercase() =='South Korea'){xcode = 6;}
    if(curr.tolowercase() =='Swiss Franc'|| curr.tolowercase() =='Switzerland'){xcode = 7;}
    if(curr.tolowercase() =='Swedish Krona'|| curr.tolowercase() =='Sweden'){xcode = 8;}
    if(curr.tolowercase() =='Singapore Dollar'|| curr.tolowercase() =='Singapore'){xcode = 9;}
    if(curr.tolowercase() =='Ringgit'|| curr.tolowercase() =='Malaysia'){xcode = 10;}
    if(curr.tolowercase() =='Australian Dollar'|| curr.tolowercase() =='Australia'){xcode = 11;}
    return xcode;
  }
  
  //role codes
  public integer GetRoleCodes(string role)
  {
    integer xcode;
    if(role.tolowercase() =='Internal'){xcode = 1;}
    if(role.tolowercase() =='Super User'){xcode = 2;}
    if(role.tolowercase() =='Clerk'){xcode = 3;}
    if(role.tolowercase() =='Partner'){xcode = 4;}
    if(role.tolowercase() =='Customer'){xcode = 5;}  
    return xcode;
  }
  
  //user status code
  public integer GetStatusCode(string status)
  {
    integer xcode;
    if(status.tolowercase() =='Active'){xcode = 1;}
    if(status.tolowercase() =='Overdue'){xcode = 2;}
    if(status.tolowercase() =='Overdue 2'){xcode = 3;}
    if(status.tolowercase() =='Overdue 3'){xcode = 4;}
    if(status.tolowercase() =='Suspended'){xcode = 5;}  
    if(status.tolowercase() =='Suspended 2'){xcode = 6;}
    if(status.tolowercase() =='Suspended 3'){xcode = 7;}
    if(status.tolowercase() =='Deleted'){xcode = 8;}  
    return xcode;
  }
  
  //subscriber status codes
  public integer GetSubStatusCode(string subst)
  {
    integer xcode;
    if(subst.tolowercase() =='Active'){xcode = 1;}
    if(subst.tolowercase() =='Pending Unsubscription'){xcode = 2;}
    if(subst.tolowercase() =='Unsubscribed'){xcode = 3;}
    if(subst.tolowercase() =='Pending Expiration'){xcode = 4;}
    if(subst.tolowercase() =='Expired'){xcode = 5;}  
    if(subst.tolowercase() =='Nonsubscriber'){xcode = 6;}  
    return xcode;
  }
  
  //payment method codes
  
  public integer GetPaymentMethodCode (string paymeth)
  {
    integer xcode;
    if(paymeth != null && paymeth != '')
    {
        if(paymeth.tolowercase() =='Cheque'){xcode = 1;}
        if(paymeth.tolowercase() =='Visa'){xcode = 2;}
        if(paymeth.tolowercase() =='MasterCard'){xcode = 3;}
        if(paymeth.tolowercase() =='AMEX'){xcode = 4;}
        if(paymeth.tolowercase() =='ACH'){xcode = 5;}  
        if(paymeth.tolowercase() =='Discovery'){xcode = 6;}
        if(paymeth.tolowercase() =='Diners'){xcode = 7;}
        if(paymeth.tolowercase() =='PayPal'){xcode = 8;}  
    }
    return xcode;
  }
  
  //order status codes
  /*
    1  Active
    2  Finished
    3  Suspended
    4  Suspended (auto)
  */
  //order billing type code
  /*
    1  Pre-paid
    2  Post-paid
  */
  
  //order line type code
  /*
    1  Item
    2  Tax
    3  Penalty
  */
  
  //invoice status code
  /*  1  Paid
    2  Unpaid
    3  Unpaid, balance carried to a new invoice.
  
  */
  
  //period units (units of time)
  public integer GetPeriodUnitCode (string punit)
  {
    integer xcode;
    if(punit.tolowercase() =='Month'){xcode = 1;}
    if(punit.tolowercase() =='Week'){xcode = 2;}
    if(punit.tolowercase() =='Day'){xcode = 3;}
    if(punit.tolowercase() =='Year'){xcode = 4;} 
    return xcode;
  }
  
  public string GetPeriodUnitstring (integer xcode)
  {
    string punit;
    if(xcode == 1){punit ='Month';}
    if(xcode == 2){punit ='Week';}
    if(xcode == 3){punit ='Day';}
    if(xcode == 4){punit ='Year';} 
    return punit;
  }
  /*  1  Month
    2  Week
    3  Day
    4  Year
  */
  
  //payment result [implement when needed]
  /*public integer GetPayResultCode(string payres)
  {
    1  Successful
    2  Failed
    3  Payment gateway not available
    4  Manually entered (payment gateway not involved, such as a cheque).
  }*/
  
  //dynamic balance code
  public integer GetDynBalCode(string dbal)
  {
    system.debug('dynamic balance'+dbal);
    integer xcode;
    if(dbal.tolowercase() =='No dynamic balance'){xcode = 1;}
    if(dbal.tolowercase() == 'Pre Paid'){xcode = 2;}
    if(dbal.tolowercase() =='Credit Limit'){xcode = 3;}
    return xcode;
  }
  
  //provisioning status codes
  public integer GetProStatusCode(string pstatus)
  {
    integer xcode;
    if(pstatus.tolowercase() =='Active'){xcode = 1;}
    if(pstatus.tolowercase() =='Inactive'){xcode = 2;}
    if(pstatus.tolowercase() =='Pending Active'){xcode = 3;}
    if(pstatus.tolowercase() =='Pending Inactive'){xcode = 4;}
    if(pstatus.tolowercase() =='Failed'){xcode = 5;}  
    if(pstatus.tolowercase() =='Unavailable'){xcode = 6;}  
    return xcode;
  }
  
  //automatic payment type
  public integer GetAutoPayTypeCode(string paytype)
  {
    integer xcode;
    if(paytype.tolowercase() =='Credit Card'){xcode = 1;}
    if(paytype.tolowercase() =='ACH'){xcode = 2;}
    if(paytype.tolowercase() =='Cheque'){xcode = 3;}
    return xcode;
  }
  
  //invoice delivery method
  public integer GetInvDelMethodCode(string inv)
  {
    integer xcode;
    if(inv.tolowercase() =='Email'){xcode = 1;}
    if(inv.tolowercase() =='Paper'){xcode = 2;}
    if(inv.tolowercase() =='Email & Paper'){xcode = 3;}
    return xcode;
  }
  
  
  Public static  String  GetPaymentResultMap(integer I )
  {
      Map<Integer,String> PaymentMap = new Map<Integer,String>();
          PaymentMap.put(0,'');
          PaymentMap.put(1,'Successful');
          PaymentMap.put(2,'Failed');
          PaymentMap.put(3,'Payment gateway not available');
          PaymentMap.put(4,'Manually entered (payment gateway not involved, such as a cheque).');
      
      if (PaymentMap.containskey(I)){
          return PaymentMap.get(I);
      }else
      {
          return '';
      }
      
  }
  
 Public static  String  GetInvoiceStatusMap(integer I )
  {
      Map<Integer,String> InvoiceMap = new Map<Integer,String>();
          InvoiceMap.put(0,'');
          InvoiceMap.put(1,'Paid');
          InvoiceMap.put(2,'Unpaid');
          InvoiceMap.put(3,'Unpaid, balance carried to a new invoice.');
          
      
      if (InvoiceMap.containskey(I)){
          return InvoiceMap.get(I);
      }else
      {
          return '';
      }
      
  }  
  
  
 Public static  String  GetOrderStatusMap(integer I )
  {
      Map<Integer,String> OrderMap = new Map<Integer,String>();
          OrderMap.put(0,'');
          OrderMap.put(1,'Active');
          OrderMap.put(2,'Finished');
          OrderMap.put(3,'Suspended');
          OrderMap.put(4,'Suspended (auto)');
          
      
      if (OrderMap.containskey(I)){
          return OrderMap.get(I);
      }else
      {
          return '';
      }
      
  }  
  
  
  
  
  
}