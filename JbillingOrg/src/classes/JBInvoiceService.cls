public with sharing class JBInvoiceService  {
    

    public boolean Error {set; get ;}
    public String ErrorMsg {set; get ;}
    public boolean SetTest = false;
    public integer JB_Record_Count {set; get ;}
    
    public jbillingAPI.ApiServicePort   Connection {set; get ;} 
    
    public JBInvoiceService ()
    {
        this.Error  = false;
        User_Credential__c ulist = User_Credential__c.getInstance();//getInstance();
        if(ulist != null    ){        
        }else
        { 
            this.ErrorMsg = 'Please Setup you account for Jbilling (Username/Password not found)';
            this.Error  = true;
            return ;
        }
      
        //setup Api Record Count
        this.JB_Record_Count  = (ulist.JB_Api_Record_Count__c != null?Integer.valueof(ulist.JB_Api_Record_Count__c) : 50);
        
        //Setup Api Conection 
        this.Connection= new   jbillingAPI.ApiServicePort()  ;
        
         
         string uname = ulist.Uname__c;
         string pwd = ulist.Password__c;
         string url = ulist.End_Point_URL__c;
        
        //string uname = 'apiUser;120';
        //string pwd = '123qwerT!';
        //string url = 'http://demo4.jbilling.com:8080/jbilling/services/jBillingSalesforce';
        system.debug('username:'+uname +'password:'+pwd);
       
        
        
        string str = url;
        
        this.Connection.inputHttpHeaders_x= new Map<String,String>();
        
        Blob headerValue = Blob.valueOf(uname + ':' + pwd  );
        
        String authorizationHeader = 'Basic ' +   EncodingUtil.base64Encode( headerValue);
        this.Connection.inputHttpHeaders_x.put('Authorization',authorizationHeader);  
        this.Connection.timeout_x=120000;
        this.Connection.endpoint_x = str;
        
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
 
   public string getPaperInvoicePDFGetInovice(integer  InvoiceId )
   { 
         if(Error == false && SetTest  == false ){
        //Create Jbiling Api Instance and AUTH
            
            
            TRY{
                      Return    Connection.getPaperInvoicePDF(InvoiceId );
             }CATCH(CalloutException EX){
                        ErrorHandler(EX);

                        //return MessageParser(ex.getMessage());
            } 
        }Else
        {
            ErrorMsg = ErrorMsg ;
            Error  = true;
        }
        
        return '';//Blob.toPdf('');  
    }    

      
        
     public JBInvoiceWrapper GetInovice(integer  InvoiceId )
     { 
         if(Error == false && SetTest  == false ){
        //Create Jbiling Api Instance and AUTH
            
            
            TRY{
                      Return   new JBInvoiceWrapper(Connection.getInvoiceWS(InvoiceId ));
             }CATCH(CalloutException EX){
                        ErrorHandler(EX);
            }
        }Else
        {
            ErrorMsg = ErrorMsg ;
            Error  = true;
        }
        
        return new JBInvoiceWrapper() ;
    }
    

     public List<integer> GetInoviceIDs(integer UserID,integer RecordCount)
     { 
         if(Error == false && SetTest  == false ){
        //Create Jbiling Api Instance and AUTH
            
            TRY{
                
                 system.debug('UserID::'+UserID);
                 system.debug('RecordCount::'+RecordCount);
                 Return   Connection.getLastInvoices(UserID,RecordCount);
             }CATCH(CalloutException EX){
                        ErrorHandler(EX);
            }
        }Else
        {
            ErrorMsg = ErrorMsg ;
            Error  = true;
            
        
        }
        return   New List<integer>();
    } 
    
    public List<JbillingAPI.InvoiceWS> GetallInvoicesForUser(integer UserID)
     { 
         if(Error == false && SetTest  == false ){
        //Create Jbiling Api Instance and AUTH
            
            TRY{
                
                 Return   Connection.getallInvoicesForUser(UserID);
             }CATCH(CalloutException EX){
                        ErrorHandler(EX);
            }
        }Else
        {
            ErrorMsg = ErrorMsg ;
            Error  = true;
            
        
        }
        return   New List<JbillingAPI.InvoiceWS>();
    }   
    
    public List<Integer> Getunpaidinvoices(integer UserID)
     { 
         if(Error == false && SetTest  == false ){
        //Create Jbiling Api Instance and AUTH
            
            TRY{
                
                 Return   Connection.Getunpaidinvoices(UserID);
             }CATCH(CalloutException EX){
                        ErrorHandler(EX);
            }
        }Else
        {
            ErrorMsg = ErrorMsg ;
            Error  = true;
            
        
        }
        return   New List<Integer>();
    }   
    
    public List<jbillingAPI.invoicews> GetAllInvoices(Integer userId,Integer x_limit,Integer offset)
     { 
         if(Error == false && SetTest  == false ){
        //Create Jbiling Api Instance and AUTH
            
            TRY{
                
                 Return   Connection.getUserInvoicesPage(UserID,x_limit,offset);
             }CATCH(CalloutException EX){
                        ErrorHandler(EX);
            }
        }Else
        {
            ErrorMsg = ErrorMsg ;
            Error  = true;
            
        
        }
        return   New List<jbillingAPI.invoicews>();
    }   


}