public with sharing class JBUserServices{
    
    public boolean Error {set; get ;}
    public String ErrorMsg {set; get ;}
    public boolean SetTest = false;
    public integer JB_Record_Count {set; get ;}
    
    public jbillingAPI.ApiServicePort   Connection {set; get ;}
    
    public JBUserServices()
    {
    	Error = false;
    	
		User_Credential__c ulist = User_Credential__c.getInstance();
        string uname = ulist.Uname__c;
        string pwd = ulist.Password__c;
        string url = ulist.End_Point_URL__c;
        
        //string uname = 'apiUser;120';
		//string pwd = '123qwerT!';
		//string url = 'http://demo4.jbilling.com:8080/jbilling/services/jBillingSalesforce';
		
		system.debug('username:'+uname +'password:'+pwd);
	
		this.connection = new jbillingAPI.ApiServicePort();
		string str = url;
		Connection.endpoint_x = str;        
		Connection.inputHttpHeaders_x= new Map<String,String>();
		Connection.timeout_x=120000;
		Blob headerValue = Blob.valueOf(uname + ':' + pwd  );
		
		String authorizationHeader = 'Basic ' +   EncodingUtil.base64Encode( headerValue);
		Connection.inputHttpHeaders_x.put('Authorization',authorizationHeader);  
		system.debug('stub::: '+Connection);
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
    public JBillingWSErrorLoggingController jerr = new JBillingWSErrorLoggingController();
    public List<string> paramlist = new List<string>();
    public static integer getusernameRes {get;set;}
    
    
    public class AccountClass
    { 
        // class to update account created after loop
        public string method {get;set;}
        public List<String> paramlist {get;set;}
        public exception ex {get;set;}
        public string apiresponse {get;set;}
        public datetime timestamp {get;set;}
        public string password {get;set;}// when account ceated
        public string jBId {get;set;} // when account created
        public string JbUpdatestatus {get;set;}
        public boolean iscreate {get;set;}
        public boolean isexception {get;set;}
        public boolean iserror {get;set;}
        public string accId {get;set;}
        
         
        public AccountClass()
        {
            paramlist = new List<string>();
            iserror = false;
            isexception = false;
            iscreate = false;
        }
    }
    
    
    //list for wrapper 
    public List<AccountClass> xlist_logs = new List<AccountClass>();
    
    
    @future (callout=true)
    public static void  CreateUserOnJbilling(List<string> xlistId)
    {
        string accId;
        string username;
        
        List<Account> xlist = [select id,Name,Email__c from Account where id IN:xlistId];
        JBUserServices ju = new JBUserServices();
        
        for(Account a:xlist)
        {
           system.debug('username'+username);
           string usname = a.Name;
           ju.CreateUser(a.Id,usname);
        }
        //update jbId and status
        ju.updateAccountJBCustomerID();
        //create error logs
        ju.batchinsertErrorLog();
    }
    @future (callout=true)
    public static void  UPdateUseronJbilling(List<string> accId)
    {
        boolean isach = false;
        boolean isCC = false;
        
        List<Account> xlist = [select id,Email__c,ABA_Routing_Number__c,Name_on_Cust_Acc__c,
                                Account_Type__c,Bank_Acc_Number__c,Bank_Name__c,CExpiry_Date__c,
                                Name_OnC_Card__c,Credit_Card_Number__c,JB_CustomerID__c
                                from Account 
                                where id IN:accId];
        for(Account a : xlist)
        {
            JBUserServices ju = new JBUserServices();
            
            if(a.ABA_Routing_Number__c != null && a.Name_on_Cust_Acc__c != null && a.Account_Type__c != null && a.Bank_Acc_Number__c !=null && a.Bank_Name__c !=null  )
            {isach = true;}
            if(a.CExpiry_Date__c != null && a.Name_OnC_Card__c != null && a.Credit_Card_Number__c != null )
            {isCc = true;}  
            
            if(isach == false && isCc== false)
            {
                ju.UpdateUser(a.Id);
            }
            else if (isach == true && isCc == false)
            {
                ju.UpdateUser(a.Id);
            }
            else if (isach == false && isCc == true)
            {
                ju.UpdateUser(a.Id);
            }
            else 
            {
                ju.UpdateUser(a.Id);
            } 
        }
    }
    public void getJbusername(string username)
    {
        //integer userId;
        paramlist.add(Json.Serialize(username));
        if(Error == false && SetTest  == false )
        {
        //Create Jbiling Api Instance and AUTH
            system.debug('in if getuserID');
            try
            {  
                    getusernameRes = Connection.getUserId(username);
                    system.debug('static val'+getusernameRes);
                    jerr.LogWSResponse('getUserId()',paramlist,'success',system.now());
             }
             catch(CalloutException EX){ErrorHandler(EX);
             system.debug('in cathc getuserID');
             jerr.LogWSResponse('getUserId()',paramlist,ex,system.now());
             
             }
        }
        else
        {
            system.debug('in else getuserID');
            ErrorMsg = ErrorMsg ;
            Error  = true;
            jerr.LogWSResponse('getUserId()',paramlist,ErrorMsg,system.now());
        }
    }
    
    
    
    
 
    public List<JBUserWrapper> getContactsWSList(integer  UserID)
     { 
         if(Error == false && SetTest  == false ){
        //Create Jbiling Api Instance and AUTH
            TRY{
                    List <JBUserWrapper> Contacts = new List<JBUserWrapper>();
                    for(JbillingApi.ContactWS CS : Connection.getUserContactsWS(UserID))
                    {
                        Contacts.add(new JBUserWrapper(CS ));
                    }
                    Return   Contacts ;
             }CATCH(CalloutException EX){
                        ErrorHandler(EX);
            }
        }Else
        {
            ErrorMsg = ErrorMsg ;
            Error  = true;
        }
        
        return new List<JBUserWrapper>() ;
    } 
 
 
    public void  CreateUser(string accId,string username)
    {

        system.debug('username in createuser'+username);
        JBUserWrapper userwrap = new JBUserWrapper ();
        
        Integer jBillingUserId;  
        JbillingAPI.userWS Cuser = new jbillingAPI.userWS();         
        Cuser = userwrap.MakeUserWSData(accId); 
        paramlist.add(Json.Serialize(cuser)); 
                
        system.debug('user data :'+cuser); 
        
        
        // Account class tem obj
        
        AccountClass temp = new AccountClass ();
        
        temp.accId = accId;
        temp.paramlist = paramlist;
        temp.iscreate = true;
        temp.method = 'CreateUser()';
        temp.timestamp = system.now();
        
        system.debug('before if:: temp: '+temp);
        system.debug('username ----------'+username);
        
        system.debug('error variable1::: '+Error);
        system.debug('error variable2::: '+setTest);
        if(Error == false && SetTest  == false ){
        //Create Jbiling Api Instance and AUTH
            system.debug('in my if:: connection: '+connection);
             
            try
            {          
                    
                    try{
                    getusernameRes = Connection.getUserId(username);
                    system.debug('user id in if:: '+getusernameRes);
                    system.debug('user data in if:: '+Cuser);
                    jBillingUserId = Connection.createUser(Cuser);
                    //jerr.LogWSResponse('CreateUser()',paramlist,'User already Exsist with username '+username,system.now());
                    
                    
                    }catch(exception ex){
                        system.debug('exception in ex; '+ex.getMessage());
                        /*
                            *if user exists on jbiliing webservice returns userId
                            *else it will return exception
                            *We will create user if username doesnot already 
                            *exist on jbilling 
                        */
                        
                        if( eX.getMessage().contains ('Method: getUserId Cause: null')){
                        	temp.JbUpdatestatus  = 'User already exists with username';
                    		temp.isexception = true;
                        	Connection.updateUser(Cuser);
                        } 
                        else if(eX.getMessage().contains('time out')== true || eX.getMessage().contains('Service Unavailable')== true ||
                 eX.getMessage().contains('Unexpected element') || eX.getMessage().contains('but found \':html\''))
                        {
                            temp.ex = eX;
                            temp.isexception = true;
                        }
                        
                        }
                    
                    system.debug('user Id from Jbilling :'+jBillingUserId);
              }
             catch(CalloutException EX){ErrorHandler(EX);
              
              system.debug('CalloutException:'+ ex);
              system.debug('CalloutException Cause:'+ ex.getCause());
              system.debug('CalloutException Line Number:'+ ex.getLineNumber());
              system.debug('CalloutException Message:'+ ex.getMessage());
              system.debug('CalloutException stack traces:'+ ex.getStackTraceString());
              system.debug('CalloutException TYpe:'+ ex.getTypeName());
              
              temp.JbUpdatestatus = ex.getMessage();
              temp.ex = ex;
              temp.isexception = true;
              //jerr.LogWSResponse('CreateUser()',paramlist,ex,system.now());
              //userwrap.updateJBUpStatusField(accId,ex.getMessage());
             }
             
             if(jBillingUserId != null){
             
             temp.jBId = string.ValueOf(jBillingUserId);
             temp.password = JBUserWrapper.Temppassword;
             temp.apiresponse = 'Success';

             }
             
        }
        else
        {
            ErrorMsg = ErrorMsg ;
            Error  = true;
            
            temp.iserror = true;
            temp.apiresponse = ErrorMsg;
            temp.JbUpdatestatus = ErrorMsg;
            
        }
        
        xlist_logs.add(temp);
           
    }
    
    
    public void  UpdateUser(string accId)
    {
        JBUserWrapper userwrap = new JBUserWrapper ();
        JbillingAPI.userWS Cuser = new jbillingAPI.userWS();
        //jbillingAPI.jBillingSalesforceServicePort JBsCon = JBs.Connection;
        Cuser = userwrap.MakeUserWSData(accId);   
        paramlist.add(Json.Serialize(cuser)); 
        
        if(Error == false && SetTest  == false ){
        //Create Jbiling Api Instance and AUTH     
            try
            {                        
                    system.debug('user data :'+cuser);
                    Connection.UpdateUser(Cuser);
                    jerr.LogWSResponse('UpdateUser()',paramlist,'success',system.now());
                    
              }
             catch(CalloutException EX){ErrorHandler(EX);
             jerr.LogWSResponse('UpdateUser()',paramlist,ex,system.now());}
       
        }
        else
        {
            system.debug('in else');
            ErrorMsg = ErrorMsg ;
            Error  = true;
            jerr.LogWSResponse('UpdateUser()',paramlist,ErrorMsg,system.now());
        }
            
    }
    
    public void SuspendUser(JbillingAPI.userWS userdata)
    {
        paramlist.add(Json.Serialize(userdata));
        if(Error == false && SetTest  == false ){
        //Create Jbiling Api Instance and AUTH     
            try
            {          
                   JBUserWrapper userwrap = new JBUserWrapper ();
                   Connection.UpdateUser(userdata);
                   jerr.LogWSResponse('SuspendUser()',paramlist,'success',system.now());
                   
              }
             catch(CalloutException EX){ErrorHandler(EX);
             jerr.LogWSResponse('SuspendUser()',paramlist,ex,system.now());}
       
        }
        else
        {
            system.debug('in else');
            ErrorMsg = ErrorMsg ;
            Error  = true;
            jerr.LogWSResponse('SuspendUser()',paramlist,ErrorMsg,system.now());
        }
    }


   
    public Integer getUserIdByEmail(string Email)
    {
        Integer userId;
        if(Error == false && SetTest  == false ){
        //Create Jbiling Api Instance and AUTH     
            try
            {          
                   userId = Connection.getUserIdByEmail(Email);
                   
            }
            catch(CalloutException EX){ErrorHandler(EX);}
       
        }
        else
        {
            system.debug('in else');
            ErrorMsg = ErrorMsg ;
            Error  = true;
        }
        return userId;
    }
    
    public Integer Createuser(JbillingAPI.userWS user)
    {
        Integer userId;
        paramlist.add(Json.Serialize(user));
        system.debug('before create user ------------------------ '+paramlist);
        
        if(Error == false && SetTest  == false ){
        //Create Jbiling Api Instance and AUTH     
            try
            {          
            	system.debug('-----------------------'+user);
                   userId = Connection.Createuser(user);
                   jerr.LogWSResponse('CreateUser()',paramlist,'Success',system.now());
                   
             }
             catch(CalloutException EX){
             	system.debug('in exception -------------'+EX);
             	ErrorHandler(EX);
             	jerr.LogWSResponse('CreateUser()',paramlist,ex,system.now());
             }
       
        }
        else
        {
            system.debug('in else');
            ErrorMsg = ErrorMsg ;
            Error  = true;
            jerr.LogWSResponse('CreateUser()',paramlist,ErrorMsg,system.now());
        }
        return userId;
    }
    public Integer CreateuserfromOrder(JbillingAPI.userWS user)
    {
        Integer userId;
        paramlist.add(Json.Serialize(user));
        system.debug('before main create user method:: '+paramlist);
        if(Error == false && SetTest  == false ){
        //Create Jbiling Api Instance and AUTH     
            try
            {          
            		system.debug('------------------------------------------------------------------');
            		system.debug('in trying user creatiion:: ');
                   userId = Connection.Createuser(user);
                   //jerr.LogWSResponse('CreateUser()',paramlist,'Success',system.now());
                   
             }
             catch(CalloutException EX){
             	system.debug('------------------------------------------------------------------');
             	system.debug('in esception::: '+EX);
             	ErrorHandler(EX);
             
             //jerr.LogWSResponse('CreateUser()',paramlist,ex,system.now());
             }
       
        }
        else
        {
            system.debug('in else');
            ErrorMsg = ErrorMsg ;
            Error  = true;
            //jerr.LogWSResponse('CreateUser()',paramlist,ErrorMsg,system.now());
        }
        return userId;
    }
    
    public JbillingAPI.userWS getUserWS(integer userID)
    {
        JbillingAPI.userWS userws = new  JbillingAPI.userWS ();
        if(Error == false && SetTest  == false ){
        //Create Jbiling Api Instance and AUTH     
            try
            {          
                 userws = Connection.getuserWS(userID);
                   
             }
             catch(CalloutException EX){ErrorHandler(EX);}
       
        }
        else
        {
            system.debug('in else');
            ErrorMsg = ErrorMsg ;
            Error  = true;
        }
        return userws;
    }
    
   
    
    // method overload
    
    JBUserWrapper juw = new JBUserWrapper();
    
   public void updateAccountJBCustomerID()
   {
   		system.debug('In update account method');
        JBUserWrapper.istriggerrunning = true; 
        
        List<Account> updateList = new List<Account>();
        system.debug('xlist_logs::: '+xlist_logs);
        for (AccountClass ac: xlist_logs)
        {
            

            Account accupdate = juw.getAccountMap(ac.accId);
            system.debug('accupdate:::: '+accupdate);
            system.debug('ac:::: '+ac);
            if(ac.iscreate == true)
            {
                system.debug('In create');
                accupdate.JB_CustomerID__c = ac.jBId ;
                accupdate.ispassword__c = true; 
                accupdate.Temporary_Password__c = ac.password ;
                if(ac.iserror == false && ac.isexception == false)
                accupdate.Jbilling_Update_Status__c = 'jBilling account created';
                
                if(ac.iserror == true)
                //accupdate.Jbilling_Update_Status__c = returnError(ac.apiresponse);
                
                system.debug('before exception'+ac.isexception);
                if(ac.isexception == true)
                {
                    system.debug('In exception');
                    //if(ac.ex != null)
                    //accupdate.Jbilling_Update_Status__c = returnError(ac.ex.getMessage());
                    //else
                    //accupdate.Jbilling_Update_Status__c = returnError(ac.JbUpdatestatus);
                }
                updateList.add(accupdate);
            }
            //Send Email
            juw.updatePassword(accupdate.Id, ac.password);
            //juw.SendEmail(ac.accId);
        }
        try 
        {
            update updateList;
        }
        catch(exception ex){}

   } 
   
   
   //method to insert error logs
   JBillingWSErrorLoggingController jerrl = new JBillingWSErrorLoggingController();
   
   public void batchinsertErrorLog()
   {
   		system.debug('In batchinsertErrorLog method');
        List<jBilingWSLog__c> insertlist = new List<jBilingWSLog__c>(); 
        for (AccountClass ac: xlist_logs)
        {
            jBilingWSLog__c jws = new jBilingWSLog__c();
            jws.Timestamp__c = ac.timestamp;
            jws.API_method_call__c = ac.method ;
            jws.API_method_parameters__c = jerrl.ListToString(ac.paramlist );
            //jws.API_Response__c ='';
            system.debug('exception: '+ac.JbUpdatestatus);
            if(ac.isexception == true)
            jws.Exception__c = ac.JbUpdatestatus;//ac.ex.getMessage();
            else
            jws.API_Response__c = ac.apiresponse;
            
            insertlist.add(jws);
        }
        
        try
        {
            //insert insertlist;
        }
        catch (exception ex)
        {}
    /*jBilingWSLog__c jws = new jBilingWSLog__c();
        jws.Timestamp__c = timestamp;
        jws.API_method_call__c = methodname;
        jws.API_method_parameters__c = ListToString(parameters);
        //jws.API_Response__c ='';
        jws.Exception__c = e.getMessage();*/
   }
   
   public string returnError(string errstr)
   {
    
    system.debug('error in service: '+errstr);
    
    string xstr='';
        if(errstr.contains('User already exists with username')== true)
        {
            xstr = 'Failed to create jBilling account - You may link to an existing account';
        }
        else if (errstr.contains('Validation of \'createUser()\' arguments failed')== true)
        {
            xstr= 'Failed to create jBilling account';
        }
        else if (errstr.contains('time out')== true || errstr.contains('Service Unavailable')== true ||
                 errstr.contains('Web service callout failed: Unexpected element') || errstr.contains('but found \':html\''))
        {
            xstr = 'Failed to connect to jBilling. System unavailable';
        }
        else
        {
            xstr = 'Failed to create jBilling account';
        }
      return xstr;
   }
   
    public void DeleteCreditCard()
    {
        
    } 
}