public with sharing class JBInvoicesOnAccountController {

  public Class InvoiceDetail
  {
    public Integer Invoicenumber {get;set;}
    public string invoicestatus {get;set;}
    public datetime invoicedate {get;set;}
    public datetime duedate {get;set;}
    public string amount {get;set;}
    public decimal amountAsdecimal {get;set;}
    public string balance {get;set;}
    public decimal balanceAsDecimal {get;set;}
    public string curr {get;set;}

    
    public InvoiceDetail()
    {}
  }
    
     
    public boolean Error {set; get ;}
    public String ErrorMsg {set; get ;}
    public List<Integer> InoviceIDs {get ; set ; }
    
    public List<jbillingAPI.invoicews> getallInvoices {get;set;}
    public List<InvoiceDetail> xlistInvDetail {get;set;}
    
    public JBInvoicesOnAccountController() {
         ErrorMsg = 'Missing Account ID';
         Error  = true;
         
    }
    
    public JBInvoicesOnAccountController(ApexPages.StandardController controller) {
    
      getallInvoices = new List<jbillingAPI.invoicews>();
      xlistInvDetail = new List<InvoiceDetail>();
    
    //Get the Account Validate and it  
        List<Account> Acc = [select id,JB_CustomerID__c  from Account where id = : ((Account)controller.getRecord()).id and JB_CustomerID__c != null limit 1 ] ;
        system.debug('Acc::'+Acc);
        if(Acc  == null || Acc.size() < 1)
        {
             ErrorMsg = 'jBilling Customer not associated with this Account';
             Error  = true;
             return ;
        
        }
                
        if(JBSuspendUserController.CheckConnectionStatus() != 'true')  
        {
            system.debug('This is in suspend::');
            //isexist = true;
        ErrorMsg = JBSuspendUserController.CheckConnectionStatus();
        Error  = true;
        return;
      }
       
    
    //Get Custom setting
        InoviceIDs  = new  List<Integer>();
        JBInvoiceService JbSrv = new JBInvoiceService();
        
        InoviceIDs  = JbSrv.GetInoviceIDs(integer.valueof(Acc[0].JB_CustomerID__c) ,JbSrv.JB_Record_Count );
        system.debug('This is in calling getInvoiceIDS::'+InoviceIDs);
        getallInvoices = JbSrv.GetAllInvoices(integer.valueof(Acc[0].JB_CustomerID__c) ,JbSrv.JB_Record_Count,0);
        system.debug('This is in calling getallInvoices::'+getallInvoices);
        
        if(InoviceIDs   == null )
        {
            InoviceIDs  = new  List<Integer>();        
        }
        if(getallInvoices != null)
        {
          for(integer i=0; i< getallInvoices.size(); i++)
          {
            InvoiceDetail temp = new InvoiceDetail();
            system.debug('This is in calling getallInvoices inner::'+getallInvoices);
            temp.Invoicenumber    =  getallInvoices[i].Id;
            temp.invoicestatus    =   getallInvoices[i].statusDescr;
            temp.invoicedate    =  getallInvoices[i].createDateTime;
            temp.duedate      =  getallInvoices[i].dueDate;
            temp.amount        =  getallInvoices[i].total;  
            temp.balance      =  getallInvoices[i].balance;
            
            if(getallInvoices[i].currencyid == 1)
            temp.curr       =  '$';
            if(getallInvoices[i].currencyid == 3)
            temp.curr       =  '€';
            
            if(temp.amount != null || temp.amount != '')
            {
              temp.amountAsdecimal  =  decimal.valueOf(temp.amount);  
            }
            if(temp.balance != null || temp.balance !='')
            {
              temp.balanceAsDecimal  =  decimal.valueOf(temp.balance);
            }
            
            xlistInvDetail.add(temp);
          }
        }
        
        if(JbSrv.error == true)
        {
            Error   = JbSrv.error;
            ErrorMsg = JbSrv.errorMsg;
        }
   
    }


   
}