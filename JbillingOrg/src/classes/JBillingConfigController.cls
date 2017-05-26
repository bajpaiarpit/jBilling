public with sharing class JBillingConfigController {
    
    
    public string username {get;set;}
    public string pwd {get;set;}
    public string partner {get;set;}
    public string jbUrl {get;set;}
    public string orderstatus {get;set;}
    public string companyId {get;set;}
    
    public boolean isQuoteManage {get;set;}
    public boolean isQuoteEdit {get;set;}
    
    //public User_Credential__c uc = new User_Credential__c();
    public Transient User_Credential__c ulist {get;set;}
    public Transient User_Credential__c applist {get;set;}
    public Transient User_Credential__c statlist {get;set;}
    public Quote_Term__c quoteTerm {get;set;}
    public List<Quote_Term__c> tempQuote {get;set;}
    public Map<string,string> QuoteName = new Map<string,string>();
    //public JBOrderService ordersrv = new JBOrderService();
    
     
    public JBillingConfigController()
    {
        //ulist = new List<User_Credential__c>();
        ulist = new User_Credential__c();
        applist = new User_Credential__c();
        statlist = new User_Credential__c();
    }

    public pagereference pageload()
    {
        isQuoteManage = false;
        isQuoteEdit = false;
        quoteTerm = new Quote_Term__c();
        
        //List<Quote_Term__c> 
        tempQuote = new List<Quote_Term__c>();
        tempQuote =  [select id,Name,Quote_Terms__c,Quote_Types__c from Quote_Term__c limit 10000];//limit 1
        for(Quote_Term__c qn:tempQuote)
        {
            QuoteName.put(qn.Name,qn.Id);
        }
        
        
        if(ApexPages.currentPage().getparameters().get('isquote') != null)
        {
            string xstr = ApexPages.currentPage().getparameters().get('isquote');
            if(xstr != null && xstr == 'true')
            {isQuoteManage = true;}
            if(ApexPages.currentPage().getparameters().get('isdel')=='true')
            {
                apexpages.addMessage(new Apexpages.Message(apexpages.SEVERITY.Confirm,'Quote Deleted successfully!',''));
            }
        }
        
        
        ulist = new User_Credential__c();
        applist = new User_Credential__c();
        applist = User_Credential__c.getInstance();//getInstance(userinfo.getUserId());//userinfo.getUserId()
        statlist = User_Credential__c.getInstance();
        
        orderstatus = statlist.Order_Status__c;
        if(orderstatus == null){orderstatus = 'Suspended';}
        partner = applist.Partner_Field__c;
        jbUrl = applist.End_Point_URL__c;
        companyId = applist.Company_ID__c;
        username =  applist.UName__c;
        pwd = applist.Password__c;
        
        
        return null;
    }
    
    
    
    public List<SelectOption> getOrderst()
    {
        List<SelectOption> options = new List<SelectOption>();
            
        options.add(new SelectOption('Active','Active'));
        options.add(new SelectOption('Suspended','Suspended'));
            
        return options;
    }
    public pagereference SaveCredentials()
    {

        ulist = User_Credential__c.getInstance();//getInstance(userinfo.getUserId());//userinfo.getUserId()
       
        
        if(!CredentialsValidation(username,pwd)){return null;}
         //create username proper
        
        username = RetUserName(username,companyId);
        
        system.debug('Username: '+username);
        
        if(!saveToSettings(username,pwd,jbUrl)){username = username.split(';')[0] ;return null;}
        system.debug('ulist values:'+ulist.Id);
        if(ulist.id!=null)
        {
            ulist.uname__c = username;
            ulist.password__c = pwd;
            ulist.Company_ID__c =  companyId;//RetCompanyId(username);
            //ulist.End_Point_URL__c = jbUrl;
            
            //companyId = ulist.Company_ID__c;
            jbUrl = jbUrl.removeEnd('/');
            ulist.End_Point_URL__c = jbUrl;
            if(!saveToSettings(username,pwd,jbUrl)){username = username.split(';')[0] ;return null;}
            try
            {
                update ulist;

                username = '';
                apexpages.addMessage(new Apexpages.Message(apexpages.SEVERITY.Confirm,'Credentials updated successfully!',''));
                return null;
            }
            catch(exception ex){
                apexpages.addMessage(new Apexpages.Message(apexpages.SEVERITY.error,'Error in updating credentials!',''));
                return null;
            }
        }
        else
        {
            User_Credential__c uc = new User_Credential__c();
            //uc.SetupOwnerId = userinfo.getuserId();
            uc.Uname__c =username;
            uc.Password__c = pwd;
            uc.End_Point_URL__c = jbUrl;
            uc.Company_ID__c =  companyId;//RetCompanyId(username);
            //ulist.Uname__c =username;
            //ulist.Password__c = pwd;
            if(!saveToSettings(username,pwd,jbUrl)){return null;}
            
            companyId = uc.Company_ID__c;
            jbUrl = jbUrl.removeEnd('/');
            uc.End_Point_URL__c = jbUrl;

            try{upsert uc;
                username = '';
                apexpages.addMessage(new Apexpages.Message(apexpages.SEVERITY.Confirm,'Credentials saved successfully!',''));
                
                return null;
            }
            catch(exception e){system.debug('credentials updated!');
                
                apexpages.addMessage(new Apexpages.Message(apexpages.SEVERITY.error,'Error in saving credentials!',''));
                return null;
            }
            
        } 

        return null;
    }
    
    public pagereference SavePartner()
    {
        applist = User_Credential__c.getInstance();//getInstance(userinfo.getUserId());//userinfo.getUserId()
        
        if(applist == null)
        {
            apexpages.addMessage(new Apexpages.Message(apexpages.SEVERITY.error,'In order to save Partner Field, please save credentials!'));
            return null;
        }
        if(partner == null || partner == '')
        {
            apexpages.addMessage(new Apexpages.Message(apexpages.SEVERITY.error,'Enter partner Field if you want to save it for futher use!'));
            return null;
        }
        try
        {
            applist.Partner_Field__c = partner ;
            update applist;
            apexpages.addMessage(new Apexpages.Message(apexpages.SEVERITY.Confirm,'Partner Field saved successfully!',''));
            return null;
        }catch(exception ex){
            apexpages.addMessage(new Apexpages.Message(apexpages.SEVERITY.error,'Error in saving record!'));            
            return null;}
        return null;
    }
    public pagereference SaveStatus()
    {
        statlist = User_Credential__c.getInstance();//getInstance(userinfo.getUserId());//userinfo.getUserId()
        
        if(statlist == null)
        {
            apexpages.addMessage(new Apexpages.Message(apexpages.SEVERITY.error,'In order to save OrderStatus, please save credentials!'));
            return null;
        }
        if(orderstatus == null || orderstatus == '')
        {
            apexpages.addMessage(new Apexpages.Message(apexpages.SEVERITY.error,'Enter Order status if you want to save it for futher use!'));
            return null;
        }
        try
        {
            statlist.Order_Status__c = orderstatus; 
            statlist.Partner_Field__c = partner ;
            update statlist;
            apexpages.addMessage(new Apexpages.Message(apexpages.SEVERITY.Confirm,'Order status saved successfully!',''));
            return null;
        }catch(exception ex){
            apexpages.addMessage(new Apexpages.Message(apexpages.SEVERITY.error,'Error in saving record!'));            
            return null;}
        return null;
    }
    
    public pagereference SaveTerms()
    {
        if(quoteTerm.Name == null || quoteTerm.Name == '')
        {
            apexpages.addMessage(new Apexpages.Message(apexpages.SEVERITY.error,'Enter Terms\' Name to save Record!'));         
            return null;
        }
        if(QuoteName.containskey(quoteTerm.Name) && QuoteName.get(quoteTerm.Name) != quoteTerm.Id)
        {
            apexpages.addMessage(new Apexpages.Message(apexpages.SEVERITY.error,'Quote term already saved with this name.Please enter different name!'));           
            return null;
        }
        if(quoteTerm.Quote_Types__c == null || quoteTerm.Quote_Types__c == '')
        {
            apexpages.addMessage(new Apexpages.Message(apexpages.SEVERITY.error,'Enter Quote Type to save Record!'));           
            return null;
        }
        if(quoteTerm.Quote_Terms__c == null || quoteTerm.Quote_Terms__c == '')
        {
            apexpages.addMessage(new Apexpages.Message(apexpages.SEVERITY.error,'Enter Terms to save Record!'));            
            return null;
        }
        
        
        try
        {
            upsert quoteTerm;
            apexpages.addMessage(new Apexpages.Message(apexpages.SEVERITY.Confirm,'Terms saved successfully!'));            
        }
        catch(exception ex)
        {apexpages.addMessage(new Apexpages.Message(apexpages.SEVERITY.error,'Error in saving record!'));           
            return null;}
        
        return new PageReference(URL.getSalesforceBaseUrl().toExternalForm() + '/apex/JBilling_Config_Panel?isquote=true');
        
    }
    public pagereference EditQuoteTerm()
    {
        string qtid = Apexpages.currentPage().getParameters().get('SelectedTerm');//.get('SelectedTerm');
        if(qtId != null)
        {
            Quote_Term__c EditTerm =  [select id,Name,Quote_Terms__c,Quote_Types__c from Quote_Term__c where id =: qtId limit 1];
            quoteTerm = EditTerm;
        }
        isQuoteEdit = true;
        return null;    
    }
    
    
    public pagereference DeleteQuoteTerm()
    {
        string qtid = Apexpages.currentPage().getParameters().get('SelectedTerm');//.get('SelectedTerm');
        if(qtId != null)
        {
            
            try
            {
                delete [select id from Quote_Term__c where id=: qtId];
                return new pagereference(URL.getSalesforceBaseURL().toExternalForm()+'/apex/JBilling_Config_Panel?isquote=true&isdel=true');
            }
            catch(exception ex)
            {
                apexpages.addMessage(new Apexpages.Message(apexpages.SEVERITY.error,'Error in deleting record!'));
            }
        }
        return null;
        
    }
    
    public boolean CredentialsValidation(string uname,string password)
    {
        if(uname=='' || pwd=='')
        {
            apexpages.addMessage(new Apexpages.Message(apexpages.SEVERITY.error,'Id/Password can not be null!',''));
            return false;
        }
        if(companyId == '')
        {
            apexpages.addMessage(new Apexpages.Message(apexpages.SEVERITY.error,'Please enter company Id!',''));
            return false;
        }
        if(uname.contains(';'))
        {
            apexpages.addMessage(new Apexpages.Message(apexpages.SEVERITY.error,'Invalid username!',''));
            return false;
        }
        
        return true;
    }
    
    public pagereference Cancel()
    {
        return new PageReference(URL.getSalesforceBaseUrl().toExternalForm() + '/apex/JBillingAdminPanel');
    }
    
    public boolean saveToSettings(string uname, string pwd, string url)
    {
        if(url == null)
        {
            apexpages.addMessage(new Apexpages.Message(apexpages.SEVERITY.error,'End point url can not be null!',''));
            return false;
        }
        system.debug('username:'+uname +'password:'+pwd);
        jbillingAPI.ApiServicePort  stub = new jbillingAPI.ApiServicePort()  ;

        // stub.endpoint_x= 'http://demo.jbilling.com:8089/jbilling-salesforce/services/';
        
        string str = url;
        if(str.lastindexof('/') < str.length()-1 || str.lastindexOf('/')<0)
        {
        
            //str += '/services/api';
        }
        else
        {
            //str+= 'services/api';
        }
        
        stub.endpoint_x = str;
        stub.inputHttpHeaders_x= new Map<String,String>();
    
        Blob headerValue = Blob.valueOf(uname + ':' + pwd  );
 
        String authorizationHeader = 'Basic ' +   EncodingUtil.base64Encode( headerValue);
        stub.inputHttpHeaders_x.put('Authorization',authorizationHeader);  
        system.debug('stub: '+stub);
        if(!Test.isRunningTest())
        {
            try
            {
                //system.debug('stub: '+stub.getCallerId ());
                integer  U =  stub.getCallerId ();
                SYSTEM.DEBUG('caller Id: '+u);
                
                 
                //update order period from jBilling to SF
                //UpdateOrderPeriodFromJbilling(stub);
               
            }   
            catch(CalloutException ex)
            {
                
                system.debug('exception: '+ex);
                system.debug('exception Message: '+ex.getMessage());
                system.debug('exception line number: '+ex.getLineNumber());
                if(ex.getMessage().contains('Unauthorized endpoint'))
                {
                    system.debug(ex.getMessage()); //'please check Setup->Security->Remote site settings. endpoint = http://demo.jbilling.com:8089' );
                    apexpages.addMessage(new Apexpages.Message(apexpages.SEVERITY.error,'Unauthorized Endpoint.Please contact your administrator !',''));
                    return false;
                }
                else if(ex.getMessage().contains('Service Unavailable') || ex.getMessage().contains('Web service callout failed: Unexpected element')
                    || ex.getMessage().contains('but found \':html\''))
                {
                    apexpages.addMessage(new Apexpages.Message(apexpages.SEVERITY.error,'jBilling is currently unavailable. Contact your billing administrator.',''));
                }
                else
                {
                    system.debug('Wrong Username/Password !');
                    apexpages.addMessage(new Apexpages.Message(apexpages.SEVERITY.error,'New Credentials failed validation and are not saved.Please try again !',''));
                    return false;
                }
                return false;
            }
        }
                        
        return true;
    }
    
    
    //parse company Id 
    public string RetUserName (string Uname,string company)
    {
        string x_Uname ='';
        system.debug('uname: '+uname);
        system.debug('company: '+company);
        if(Uname != null && Uname != '' && company != null && company != '' && !Uname.contains(';'))
        {
            system.debug('in if ');
            //string[] strsplit = Uname.split(';');
            x_Uname = uname+';'+company; //strsplit[1];
            system.debug('uname in if:'+x_Uname);
        }
        else
        x_Uname = Uname;
        system.debug('uname after: '+x_Uname);
        return x_Uname;
    }
    

}