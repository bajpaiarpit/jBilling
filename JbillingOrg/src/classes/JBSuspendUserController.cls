Global with sharing class JBSuspendUserController
{
    public static boolean issuspend {get;set;}
    
    public JBSuspendUserController(){
        issuspend = false;
    }
     
    
    Webservice static string CheckConnectionStatus()
    {
        string status;
        system.debug('In suspend Controller::');
        
        User_Credential__c ulist = User_Credential__c.getInstance();
        string uname = ulist.Uname__c;
        string pwd = ulist.Password__c;
        string url = ulist.End_Point_URL__c;
        
        //string uname = 'apiUser;120';
        //string pwd = '123qwerT!';
        //string url = 'http://demo4.jbilling.com:8080/jbilling/services/jBillingSalesforce';
        system.debug('username:'+uname +'password:'+pwd);
       
        jbillingAPI.ApiServicePort  stub = new jbillingAPI.ApiServicePort()  ;
        
        string str = url;
        //stub.endpoint_x = str;
        stub.inputHttpHeaders_x= new Map<String,String>();
        
        Blob headerValue = Blob.valueOf(uname + ':' + pwd  );
        
        String authorizationHeader = 'Basic ' +   EncodingUtil.base64Encode( headerValue);
        stub.inputHttpHeaders_x.put('Authorization',authorizationHeader);  
        system.debug('stub: '+stub);
        
        system.debug('Before Try::');
        try
        {
            system.debug('stub.getCallerId()::'+stub.getCallerId());
            system.debug('ye Pakra Error::');
            integer  U =  stub.getCallerId();
            
            status = 'true';
       }
       catch(calloutexception ex)
      {
          system.debug('Error ke under hon me::');
         if(ex.getMessage().contains('Unauthorized endpoint'))
         {
                status = 'Unauthorized endpoint ! Please contact system administrator';
         }
         else if(ex.getMessage().contains('Service Unavailable') || ex.getMessage().contains('Web service callout failed: Unexpected element')
                 || ex.getMessage().contains('but found \':html\'')) 
          {
                status = 'jBilling is currently unavailable. Contact your billing administrator.';
          }
      }
        return status;
    }
    
   

}