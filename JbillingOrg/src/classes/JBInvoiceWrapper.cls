public with sharing class JBInvoiceWrapper {

    public class invoicelineWrapper {
        public String amount {set ; get ; }
        public Decimal amountAsDecimal{set ; get ; }
        public Integer deleted{set ; get ; }
        public String description{set ; get ; }
        public Integer id{set ; get ; }
        public Integer itemId{set ; get ; }
        public Integer percentage{set ; get ; }
        public String price{set ; get ; }
        public Decimal priceAsDecimal{set ; get ; }
        public String quantity{set ; get ; }
        public Decimal quantityAsDecimal{set ; get ; }
        public Integer sourceUserId{set ; get ; }
        
        public invoicelineWrapper(jbillingAPI.invoice_line iLitem )
        { 
           if(iLitem != null){
            amount  =   iLitem.amount;
            amountAsDecimal =   iLitem.amountAsDecimal;
            deleted =   iLitem.deleted;
            description =   iLitem.description;
            id  =   iLitem.id;
            itemId  =   iLitem.itemId;
            percentage  =   iLitem.percentage;
            price   =   iLitem.price;
            priceAsDecimal  =   iLitem.priceAsDecimal;
            if(iLitem.quantity != null)
            quantity    = iLitem.quantity;
            else
            quantity    = '';
            quantityAsDecimal   =   iLitem.quantityAsDecimal;
            sourceUserId    =   iLitem.sourceUserId;
            }
        }
        
      } 
 
   public list<invoicelineWrapper> LineItems {get; set; }
    
   public JbillingApi.InvoiceWS IWS  { get ; set ; }
   public JBInvoiceWrapper()
   {
       IWS = new JbillingApi.InvoiceWS();
       LineItems = new list<invoicelineWrapper>();
   }

   public JBInvoiceWrapper(JbillingApi.InvoiceWS IWSParam)
   {
       LineItems = new list<invoicelineWrapper>();
       IWS = new JbillingApi.InvoiceWS();
       IWS  = IWSParam;//
       if(IWS != null && IWS.invoiceLines != null)
       {
           for(jbillingAPI.invoice_line Litem : IWS.invoiceLines )
           {
                 LineItems.add(new invoicelineWrapper(Litem) ) ; 
           }
       }
   }

    public  Decimal getcarriedBalance(){  try { return     Integer.valueof(IWS.carriedBalance); }catch(exception ex){ return 0;  }  }
    public  DateTime    getcreateDateTime(){    return IWS.createDateTime; }
    public  DateTime    getcreateTimeStamp(){   return IWS.createTimeStamp;    }
    public  Integer getcurrencyId(){    return IWS.currencyId; }
    public  String  getcustomerNotes(){ return IWS.customerNotes;  }
    public  Integer getdelegatedInvoiceId(){    return IWS.delegatedInvoiceId; }
    public  Integer getdeleted(){   return IWS.deleted;    }
    public  DateTime    getdueDate(){   return IWS.dueDate;    }
    public  Integer getid(){    return IWS.id; }
    public  Integer getinProcessPayment(){  return IWS.inProcessPayment;   }
    public  jbillingAPI.invoice_line[]  getinvoiceLines(){  return IWS.invoiceLines;   }
    public  Integer getisReview(){  return IWS.isReview;   }
    public  DateTime    getlastReminder(){  return IWS.lastReminder;   }
    public  jbillingAPI.metaFieldValueWS[]  getmetaFields(){    return IWS.metaFields; }
    public  String  getnumber_x(){  return IWS.number_x;   }
    public  Integer[]   getorders(){   if(IWS != null ){ return IWS.orders; } else {return new List<integer>(); } }
    public  Integer getoverdueStep(){   return IWS.overdueStep;    }
    public  Integer getpaymentAttempts(){   return IWS.paymentAttempts;    }
    public  Integer[]   getpayments(){    return IWS.payments;   }
    public  String  getstatusDescr(){   return IWS.statusDescr;    }
    public  Integer getstatusId(){  return IWS.statusId;   }
    
    public  string getstatusString(){  if(IWS != null){ return JBillingCodeEnumContoller.GetInvoiceStatusMap(IWS.statusId);} else{ return '';}   }
    public  Integer gettoProcess(){ return IWS.toProcess;  }
    public  String  gettotal(){ return IWS.total;  }
    public  Integer getuserId(){   try{ return IWS.userId; }catch(exception ex){return 0;} }
    
    public  Decimal gettotalInt(){  try { return  Decimal.valueof(IWS.total); }catch(exception ex){ return 0;  } }
    public  Decimal getbalanceInt(){  try { return     Integer.valueof(IWS.balance); }catch(exception ex){ return 0;  }  }
    public  string  getBalanceString() {try{return IWS.balance;}catch(exception ex){return null;}}


   

}