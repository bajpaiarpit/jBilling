public with sharing class JBInvoiceViewController {



    
    
    
    public boolean SetTest = false;
   
    public boolean Error {set; get ;}
    public String ErrorMsg {set; get ;}
    public boolean isunpaid {get;set;}
    public decimal balanceOfInv {get;set;}
   
    public JBUserWrapper UPWS {get; set ;}
     
     
    public JBInvoiceWrapper JIWS {get ; set ; }
  
    
  
    
    
    public void CatchError(JBInvoiceService JbSrv)
    {
         system.debug('Incatch Error::'+JbSrv.error);
         this.Error   = JbSrv.error;
         ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,JbSrv.errorMsg));
         ErrorMsg = JbSrv.errorMsg;
    }

    public JBInvoiceViewController() {
        Error = false;
        UPWS = new JBUserWrapper();
        system.debug('Error::'+Error);
        if(ApexPages.CurrentPage().getParameters().get('Jid') == null || ApexPages.CurrentPage().getParameters().get('Jid') == '' )
        {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Fatal,'jBilling Invoice ID not found in URL')); 
            return ;
        }
       
   
        //Get Custom setting
       
        system.debug('Before JBInvoiceService instance:::');
        JBInvoiceService JbSrv = new JBInvoiceService();
        system.debug('Before JBInvoiceWrapper instance:::');
        JIWS  = new JBInvoiceWrapper();
        system.debug('Before calling GetInvoice instance:::');
        JIWS   = JbSrv.GetInovice(integer.valueof(ApexPages.CurrentPage().getParameters().get('Jid')));
        system.debug('After calling GetInvoice instance:::'+JIWS);
        system.debug('Out where Error JIWS.getBalanceString:::'+JIWS.getBalanceString());
        if(JIWS != null && JIWS.getBalanceString() != null)
        {
            system.debug('In where Error JIWS.getBalanceString:::'+JIWS.getBalanceString());    
            balanceOfInv = decimal.valueOF(JIWS.getBalanceString());
        }
        //to render payinvoice button
        system.debug('Out where Error JIWS.getbalanceInt:::'+JIWS.getbalanceInt());
        system.debug('Out where Error JIWS.getstatusString:::'+JIWS.getstatusString());
        if(JIWS.getbalanceInt() != 0 || JIWS.getstatusString().tolowercase() == 'unpaid')
        {
            system.debug('In where Error JIWS.getbalanceInt:::'+JIWS.getbalanceInt());
            system.debug('In where Error JIWS.getstatusString:::'+JIWS.getstatusString());
            isunpaid = true;
        }
        else{ isunpaid = false;}
        system.debug('Out where Error JbSrv.error:::'+JbSrv.error);
        if(JbSrv.error == true)
        {
            system.debug('In where Error JbSrv.error:::'+JbSrv);
            CatchError(JbSrv);
            return ;
        } 
              

        UPWS  = GetUser(JIWS.getuserid());
        system.debug('Out where Error UPWS:::'+UPWS);
         system.debug('Out where Error JbSrv.error:::'+JbSrv.error);
        if(JbSrv.error == true)
        {
            CatchError(JbSrv);
            return ;
        }
               
         
    }
    
      public string MessageParser(string Message)
   {
       //string str ='CalloutException Message:Web service callout failed: WebService returned a SOAP Fault: Could not execute JDBC batch update; SQL [/* insert com.sapienter.jbilling.server.user.db.CreditCardDTO */ insert into credit_card (cc_expiry, cc_number_plain, cc_type, deleted, gateway_key, name, cc_number, optlock, id) values (?, ?, ?, ?, ?, ?, ?, ?, ?)]; constraint [null]; nested exception is org.hibernate.exception.ConstraintViolationException: Could not execute JDBC batch update faultcode=soap:Server faultactor=';
    string str = '';
    str = Message ;
    system.debug('string stage1: '+str);
    
    if(str != null && str != '')
    {
      integer int_x = str.lastIndexOf('SOAP Fault:');
      system.debug('last index of:' +int_x);
      if(int_x != -1)
        str = str.substring(int_x,str.length());
      
      system.debug('string 2nd stage: '+str);
      
      integer int_x2 = str.lastIndexOf('faultcode');
      system.debug(int_x2);
      if(int_x2 != -1)
        str = str.substring(0,int_x2);
      system.debug('string stage 3: '+str);
      
      str = str.replace('SOAP Fault:','');
    
       }
    
    system.debug('string final stage: '+str);
    return str;
       
   }
   
    Public void ErrorHandler(Exception Ex)
    {
        IF(SetTest  == true || eX.getMessage().contains('Unauthorized endpoint'))
        {
            ErrorMsg = 'Unauthorized endpoint ! Please contact system administrator';
            Error  = true;
            //SYSTEM.DEBUG(eX.getMessage()); //'please check Setup->Security->Remote site settings. endpoint = http://demo.jbilling.com:8089' );
        }     
        ELSE
        {
            //ErrorMsg = 'Some error has occured during access ! Please contact system administrator'+string.valueOf(ex.getMessage());
            ErrorMsg = MessageParser(ex.getMessage());//''+string.valueOf(ex.getMessage());
            Error  = true;
            //SYSTEM.DEBUG('Wrong Username/Password');
        }
    }
    
    public JBUserWrapper GetUser(integer  UserID)
    { 
        
        User_Credential__c ulist = User_Credential__c.getInstance();
		
        //string uname = 'apiUser;120';
        string uname = ulist.Uname__c;
        //string pwd = '123qwerT!';
        string pwd = ulist.Password__c;
        //string url = 'http://demo4.jbilling.com:8080/jbilling/services/jBillingSalesforce';
        string url = ulist.End_Point_URL__c;
        system.debug('username:'+uname +'password:'+pwd);
        jbillingAPI.APIServicePort  Connection = new jbillingAPI.APIServicePort()  ;
        
        string str = url;
        Connection.endpoint_x = str;
        Connection.inputHttpHeaders_x= new Map<String,String>();
        
        Blob headerValue = Blob.valueOf(uname + ':' + pwd  );
        
        String authorizationHeader = 'Basic ' +   EncodingUtil.base64Encode( headerValue);
        Connection.inputHttpHeaders_x.put('Authorization',authorizationHeader);  
        system.debug('stub: '+Connection);
        
        
        
        
        if(Error == false ){
        //Create Jbiling Api Instance and AUTH
            
            
            TRY{
                    Return   new JBUserWrapper(Connection.getUserWS(UserID));
                
            }CATCH(CalloutException EX){
                       ErrorHandler(EX);
            }
        }Else
        {
            ErrorMsg = ErrorMsg ;
            Error  = true;
        }
        
        return new JBUserWrapper() ;
    }
   
    
}