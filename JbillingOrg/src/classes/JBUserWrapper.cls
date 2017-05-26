public with sharing class JBUserWrapper {
 
   public Transient User_Credential__c ulist {get;set;}
   private JBValidator jbv = new JBValidator(); 
   public JbillingApi.UserWS UWS  { get ; set ; }
   public List<Account> xlistCustomer {get;set;}
   public JBillingCodeEnumContoller jbc {get;set;}
   public static boolean istriggerrunning {get;set;} 
   public static string Temppassword {get;set;}
   private Map<string,Account> AccountMap = new Map<string,Account>();
   private Map<string,string> CountryMap = new Map<string,string>();
   
   
   public string getFullName(){ 
    
        List<jBillingAPI.metaFieldValueWS> meta = UWS.metafields;
        String FirstName = '';
        String LastName = '';
        for(jBillingAPI.metaFieldValueWS m: meta)
        {
            if(m.fieldName == 'contact.first.name'){
                FirstName = m.stringValue + ' ';
            }
            
            if(m.fieldName == 'contact.last.name'){
                LastName = m.stringValue;
            }
        }
        String CustomerName = FirstName + LastName;
        return (CustomerName) ;
    
   }
   
    
   public string getEmail(){ return (UWS.contact != null && UWS.contact.email!= null ? UWS.contact.email+ '' : '') ;}
   public string getcompanyName(){ 
    return  (UWS.companyName != null ? UWS.companyName : '');
    }
   public string getUserName(){ return UWS.userName;}
   
   
   public JBUserWrapper()
   {
        ulist = new User_Credential__c();
        istriggerrunning = false;
        UWS = new JbillingApi.UserWS();
        xlistCustomer = new List<Account>();
        UWS.contact = new JbillingApi.contactWs();
        jbc = new JBillingCodeEnumContoller();
        
        //Create Map for country codes
        List<CountryCodes__c> xListCode = [Select c.Name, c.Country__c, c.Code__c 
        From CountryCodes__c c limit 10000];
        
        for(CountryCodes__c cc: xListCode)
        {
            CountryMap.put(cc.Country__c.toLowercase(),cc.Code__c);
        }
        
        
   }
   
   public void setAccountMap(string Idstr)
   {
        AccountMap = new Map<string,Account>();
        
        for(Account ac : [Select a.include_in_notification__c, a.ABA_Routing_Number__c, a.Email__c,
                        a.Website, a.Use_Parent_Pricing__c,a.Type,
                        a.TickerSymbol, a.SystemModstamp,a.Subscriber_Status__c, 
                        a.Status__c, a.Site, a.Sic, a.ShippingStreet, a.ShippingState,
                         a.ShippingPostalCode, a.ShippingCountry, a.ShippingCity,  
                         a.Rating, a.Preferred_Payment_Type__c, a.Phone,
                         a.Partner_Id__c, a.ParentId, a.Ownership, a.OwnerId, 
                         a.Organization_Name__c,
                         a.NumberOfEmployees, a.Name_on_Cust_Acc__c,
                         a.Name_OnC_Card__c, a.Name, a.MasterRecordId,
                         a.Main_Subscription__c, a.Last_Name__c,
                          a.LastModifiedDate, a.LastModifiedById, a.LastActivityDate, 
                          a.Language__c, a.JB_CustomerID__c, a.IsDeleted, a.Invoice_If_Child__c,
                          a.Invoice_Delivery_Method__c, a.Industry, a.Id, a.Fax, a.CExpiry_Date__c, 
                          a.Exclude_from_Ageing__c, a.Due_Date__c, a.Description, 
                          a.Currency__c, a.Credit_Limit__c, a.CreatedDate, a.CreatedById,  a.Credit_Card_Number__c,//a.Card_Number__c,
                          a.Billing_Address_2__c, a.BillingStreet, a.BillingState, a.BillingPostalCode, 
                          a.BillingCountry, a.BillingCity, a.Bank_Name__c, a.Bank_Acc_Number__c, 
                          a.Balance_Type__c, a.Auto_Recharge_Thershold__c, a.AnnualRevenue, a.Allow_Sub_Accounts__c, 
                          a.Account_Type__c, a.AccountNumber,a.ispassword__c ,a.Temporary_Password__c,//,a.password__c
                          a.Due_Date_Unit__c,a.Due_Date_Value__c,a.paymentMethod__c,a.First_Name__c, a.Bank_Account_Number__c
                            From Account a where id=:Idstr] )
        {
             AccountMap.put(ac.Id,ac);     
        }
   }
   
   public Account getAccountMap (string accId)
   {
    return [Select a.include_in_notification__c, a.ABA_Routing_Number__c, a.Email__c,
                        a.Website, a.Use_Parent_Pricing__c, a.Type,
                        a.TickerSymbol, a.SystemModstamp,a.Subscriber_Status__c, 
                        a.Status__c, a.Site, a.Sic, a.ShippingStreet, a.ShippingState,
                         a.ShippingPostalCode, a.ShippingCountry, a.ShippingCity,   
                         a.Rating, a.Preferred_Payment_Type__c, a.Phone,
                         a.Partner_Id__c, a.ParentId, a.Ownership, a.OwnerId, 
                         a.Organization_Name__c,
                         a.NumberOfEmployees, a.Name_on_Cust_Acc__c,
                         a.Name_OnC_Card__c, a.Name, a.MasterRecordId,
                         a.Main_Subscription__c, a.Last_Name__c,
                          a.LastModifiedDate, a.LastModifiedById, a.LastActivityDate, 
                          a.Language__c, a.JB_CustomerID__c, a.IsDeleted, a.Invoice_If_Child__c,
                          a.Invoice_Delivery_Method__c, a.Industry, a.Id, a.Fax, a.CExpiry_Date__c, 
                          a.Exclude_from_Ageing__c, a.Due_Date__c, a.Description,  
                          a.Currency__c, a.Credit_Limit__c, a.CreatedDate, a.CreatedById,  a.Credit_Card_Number__c,//a.Card_Number__c,
                          a.Billing_Address_2__c, a.BillingStreet, a.BillingState, a.BillingPostalCode, 
                          a.BillingCountry, a.BillingCity, a.Bank_Name__c, a.Bank_Acc_Number__c, 
                          a.Balance_Type__c, a.Auto_Recharge_Thershold__c, a.AnnualRevenue, a.Allow_Sub_Accounts__c, 
                           a.Account_Type__c, a.AccountNumber,a.ispassword__c ,a.Temporary_Password__c,//,a.password__c
                          a.Due_Date_Unit__c,a.Due_Date_Value__c,a.paymentMethod__c, a.First_Name__c, a.Bank_Account_Number__c
                            From Account a where id=:accId];
   }
    
    
   public JBUserWrapper(JbillingApi.UserWS UWSParam)
   {
       UWS = new JbillingApi.UserWS();
       UWS = UWSParam;
   }
 
   
   public JBUserWrapper( JbillingApi.ContactWS  Contact )
   {
       UWS = new JbillingApi.UserWS();
       UWS.contact = new JbillingApi.ContactWS();
       UWS.contact  = Contact;
   }

    public JbillingApi.UserWS MakeUserWSData(List<Account> xlist)
   {        
        JbillingAPI.userWS user = new jbillingAPI.userWS();
        JBillingAPI.contactWS contact= new jbillingAPI.contactWS();
        user.accountTypeId = 60102;
        
        
        
        
        for(Account a: xlist)
        {
            
            if(a.Phone != null){jbv.FormatPhoneNumber(a.Phone);}         
            //string username = a.Email__c;
            string username = a.Name;
            string password = GenerateRandomPassword();

            if(a.JB_CustomerID__c != null && a.JB_CustomerID__c != '')
            {
                integer uId = integer.valueOf(a.JB_CustomerID__c);
                user.userId = uId;
                
                //putting next first day of month for only update
                
                Date d = system.today();
                d = d.addMonths(1);
                d = d.toStartOfMonth();
                Datetime dt = datetime.newInstance(d.year(), d.month(),d.day());
                
                system.debug('date for invoice::: '+dt);
                user.nextInvoiceDate = dt;
            }

            
            if(a.ParentId != null){user.parentId = getJBIdForAccount(a.ParentId);}
            if(a.Partner_Id__c != null){user.partnerIds[0] = getJBIdForAccount(a.Partner_Id__c);}
            if(a.JB_CustomerID__c == null)
            {user.userName = username;}  
             
             user.accountTypeId = 60102;
             
            if(a.ispassword__c != true)
            {
                user.password = password;
                Temppassword = password;
            
            }
            
            user.mainRoleId = 5;
            user.notes = a.Description;
            if(JBSuspendUserController.issuspend == true){user.status = 'Suspended';}
            user.excludeAgeing = a.Exclude_from_Ageing__c;
            user.creditLimit =String.ValueOf(a.Credit_Limit__c);
            user.creditLimitAsDecimal = a.Credit_Limit__c;
            user.createDatetime = a.CreatedDate;
            //user.autoRecharge = String.ValueOf(a.Auto_Recharge_Thershold__c);
            //user.autoRechargeAsDecimal = a.Auto_Recharge_Thershold__c;
            user.language = a.Language__c;
            user.companyName = a.Organization_Name__c;
            user.invoiceChild = a.Invoice_If_Child__c;
            user.isParent = a.Allow_Sub_Accounts__c;
            user.useParentPricing = a.Use_Parent_Pricing__c;
            user.dueDateValue = Integer.valueOf(a.Due_Date_Value__c);
            if(a.Due_Date_Unit__c != null){user.dueDateUnitId = jbc.GetPeriodUnitCode(a.Due_Date_Unit__c);}
            if(a.Preferred_Payment_Type__c !=  null)
            {user.automaticPaymentType = jbc.GetAutoPayTypeCode(a.Preferred_Payment_Type__c);}
                        
            contact.firstName = a.Name;
            contact.lastName = a.Last_Name__c;
            //contact.address1=a.BillingStreet;
            //contact.address2 = a.Billing_Address_2__c;
            //contact.city=a.BillingCity;
            if(a.JB_CustomerID__c == null){
                //contact.email=a.Email__c;
                }
                contact.email=a.Email__c;
            //contact.postalCode=a.BillingPostalCode;
            contact.phoneAreaCode = string.valueOf(JBValidator.areacode);
            contact.phoneCountryCode = string.valueOf(JBValidator.countrycode);
            //contact.phoneNumber=string.ValueOf(JBValidator.phonenum);
            contact.organizationName=a.Organization_Name__c;
            contact.include = a.include_in_notification__c;
            //if(a.BillingCountry != null){contact.countryCode = CountryMap.get(a.BillingCountry.toLowercase());}
            //contact.stateProvince = a.BillingState;
           
            user.contact = contact;
            if (a.status__c != null){user.statusId = jbc.GetStatusCode(a.status__c);}
            if (a.Subscriber_Status__c != null){user.subscriberStatusId = jbc.GetSubStatusCode(a.Subscriber_Status__c);}
            if(a.Currency__c != null){user.currencyId = jbc.GetCurrencyCode(a.Currency__c);}
            if(a.Language__c != null){user.language = a.Language__c; 
                                        user.languageId = jbc.GetLanguageCode(a.Language__c);}
            
            if(a.Invoice_Delivery_Method__c != null){user.invoiceDeliveryMethodId = jbc.GetInvDelMethodCode(a.Invoice_Delivery_Method__c);}
            system.debug('account dyn bal '+a.Balance_Type__c);
            
        

        //setting meta field
            /*
            ulist = User_Credential__c.getInstance();
            system.debug('----------------------::: '+ulist);
            
            if(ulist != null && ulist.Partner_Field__c != null)
            {
                JbillingAPI.MetaFieldValueWS metaField1 = new JbillingAPI.MetaFieldValueWS();
                metaField1.fieldName  = 'ccf.partner' ;
                metaField1.stringValue = ulist.Partner_Field__c;//'APPCELERATOR' ;
                metaField1.mandatory = false;
                metaField1.disabled = false ;
                user.metaFields = new jbillingAPI.MetaFieldValueWS[]{metaField1};
            }
            */ 
                JbillingAPI.MetaFieldValueWS metaField1 = new JbillingAPI.MetaFieldValueWS();
                metaField1.fieldName  = 'ccf.partner' ;
                metaField1.stringValue = 'Salesforce';
                metaField1.mandatory = false;
                metaField1.disabled = false ;
                
                JbillingAPI.MetaFieldValueWS metaField2 = new JbillingAPI.MetaFieldValueWS();
                metaField2.fieldName  = 'contact.email' ;
                metaField2.stringValue = a.Email__c;//'APPCELERATOR' ;
                metaField2.mandatory = false;
                metaField2.disabled = false ;
                
                JbillingAPI.MetaFieldValueWS metaField3 = new JbillingAPI.MetaFieldValueWS();
                metaField3.fieldName  = 'contact.organization' ;
                metaField3.stringValue = a.Organization_Name__c;//'APPCELERATOR' ;
                metaField3.mandatory = false;
                metaField3.disabled = false ;
                
                JbillingAPI.MetaFieldValueWS metaField4 = new JbillingAPI.MetaFieldValueWS();
                metaField4.fieldName  = 'contact.address1' ;
                metaField4.stringValue = a.BillingStreet;//'APPCELERATOR' ;
                metaField4.mandatory = false;
                metaField4.disabled = false ;

                JbillingAPI.MetaFieldValueWS metaField5 = new JbillingAPI.MetaFieldValueWS();
                metaField5.fieldName  = 'contact.address2' ;
                metaField5.stringValue = a.Billing_Address_2__c;//'APPCELERATOR' ;
                metaField5.mandatory = false;
                metaField5.disabled = false ;
                
                JbillingAPI.MetaFieldValueWS metaField6 = new JbillingAPI.MetaFieldValueWS();
                metaField6.fieldName  = 'contact.city' ;
                metaField6.stringValue = a.BillingCity;//'APPCELERATOR' ;
                metaField6.mandatory = false;
                metaField6.disabled = false ;
                
                JbillingAPI.MetaFieldValueWS metaField7 = new JbillingAPI.MetaFieldValueWS();
                metaField7.fieldName  = 'contact.state.province' ;
                metaField7.stringValue = a.BillingState;
                metaField7.mandatory = false;
                metaField7.disabled = false ;
                
                JbillingAPI.MetaFieldValueWS metaField8 = new JbillingAPI.MetaFieldValueWS();
                metaField8.fieldName  = 'contact.postal.code' ;
                metaField8.stringValue = a.BillingPostalCode;//'APPCELERATOR' ;
                metaField8.mandatory = false;
                metaField8.disabled = false ;

                JbillingAPI.MetaFieldValueWS metaField9 = new JbillingAPI.MetaFieldValueWS();
                metaField9.fieldName  = 'contact.country.code' ;
                metaField9.stringValue = CountryMap.get(a.BillingCountry.toLowercase());//'APPCELERATOR' ;
                metaField9.mandatory = false;
                metaField9.disabled = false ;
                
                
                JbillingAPI.MetaFieldValueWS metaField10 = new JbillingAPI.MetaFieldValueWS();
                metaField10.fieldName  = 'contact.last.name' ;
                metaField10.stringValue = a.Last_Name__c;
                metaField10.mandatory = false;
                metaField10.disabled = false ;

                JbillingAPI.MetaFieldValueWS metaField11 = new JbillingAPI.MetaFieldValueWS();
                metaField11.fieldName  = 'contact.phone.country.code' ;
                metaField11.stringValue = string.valueOf(JBValidator.countrycode);
                metaField11.mandatory = false;
                metaField11.disabled = false ;
                
                JbillingAPI.MetaFieldValueWS metaField12 = new JbillingAPI.MetaFieldValueWS();
                metaField12.fieldName  = 'contact.phone.area.code' ;
                metaField12.stringValue = string.valueOf(JBValidator.areacode);
                metaField12.mandatory = false;
                metaField12.disabled = false ;
                
                JbillingAPI.MetaFieldValueWS metaField13 = new JbillingAPI.MetaFieldValueWS();
                metaField13.fieldName  = 'contact.phone.number' ;
                metaField13.stringValue = string.ValueOf(JBValidator.phonenum);
                metaField13.mandatory = false;
                metaField13.disabled = false ;
                

                JbillingAPI.MetaFieldValueWS metaField14 = new JbillingAPI.MetaFieldValueWS();
                metaField14.fieldName  = 'contact.fax.country.code' ;
                metaField14.stringValue = string.valueOf(JBValidator.countrycode);
                metaField14.mandatory = false;
                metaField14.disabled = false ;
                
                JbillingAPI.MetaFieldValueWS metaField15 = new JbillingAPI.MetaFieldValueWS();
                metaField15.fieldName  = 'contact.fax.area.code' ;
                metaField15.stringValue = string.valueOf(JBValidator.areacode);
                metaField15.mandatory = false;
                metaField15.disabled = false ;
                
                JbillingAPI.MetaFieldValueWS metaField16 = new JbillingAPI.MetaFieldValueWS();
                metaField16.fieldName  = 'contact.fax.number' ;
                metaField16.stringValue = a.Fax;
                metaField16.mandatory = false;
                metaField16.disabled = false ;
                
                JbillingAPI.MetaFieldValueWS metaField17 = new JbillingAPI.MetaFieldValueWS();
                metaField17.fieldName  = 'contact.first.name' ;
                metaField17.stringValue = a.First_Name__c;
                metaField17.mandatory = false;
                metaField17.disabled = false ;
                
                // Creadit Card information 
                JbillingAPI.MetaFieldValueWS metaField18 = new JbillingAPI.MetaFieldValueWS();
                metaField18.fieldName  = 'cc.cardholder.name' ;
                metaField18.stringValue = a.Name_OnC_Card__c;
                metaField18.mandatory = false;
                metaField18.disabled = false ;
                
                
                JbillingAPI.MetaFieldValueWS metaField19 = new JbillingAPI.MetaFieldValueWS();
                metaField19.fieldName  = 'cc.number' ;
                metaField19.stringValue = a.Credit_Card_Number__c;
                metaField19.mandatory = false;
                metaField19.disabled = false ;
                              
                JbillingAPI.MetaFieldValueWS metaField20 = new JbillingAPI.MetaFieldValueWS();
                metaField20.fieldName  = 'cc.expiry.date' ;
                metaField20.stringValue = a.CExpiry_Date__c;
                metaField20.mandatory = false;
                metaField20.disabled = false ;
                
                 //ACH information 
                JbillingAPI.MetaFieldValueWS metaField21 = new JbillingAPI.MetaFieldValueWS();
                metaField21.fieldName  = 'ach.routing.number' ;
                metaField21.stringValue = a.ABA_Routing_Number__c;
                metaField21.mandatory = false;
                metaField21.disabled = false ;
                
                JbillingAPI.MetaFieldValueWS metaField22 = new JbillingAPI.MetaFieldValueWS();
                metaField22.fieldName  = 'ach.customer.name' ;
                metaField22.stringValue = a.Name_on_Cust_Acc__c;
                metaField22.mandatory = false;
                metaField22.disabled = false ;
                
                JbillingAPI.MetaFieldValueWS metaField23 = new JbillingAPI.MetaFieldValueWS();
                metaField23.fieldName  = 'ach.account.number' ;
                metaField23.stringValue = a.Bank_Acc_Number__c != null ?  string.valueOf(a.Bank_Acc_Number__c) : '';
                metaField23.mandatory = false;
                metaField23.disabled = false ;
                
                JbillingAPI.MetaFieldValueWS metaField24 = new JbillingAPI.MetaFieldValueWS();
                metaField24.fieldName  = 'ach.bank.name' ;
                metaField24.stringValue = a.Bank_Name__c;
                metaField24.mandatory = false;
                metaField24.disabled = false ;
                
                JbillingAPI.MetaFieldValueWS metaField25 = new JbillingAPI.MetaFieldValueWS();
                metaField25.fieldName  = 'ach.account.type' ;
                metaField25.stringValue = a.Account_Type__c;
                metaField25.mandatory = false;
                metaField25.disabled = false ;
                
                
                user.metaFields = new jbillingAPI.MetaFieldValueWS[]{metaField1,metaField2,
                metaField3,metaField4,metaField5,metaField6,metaField7,metaField8,metaField9,
                metaField10,metaField11,metaField12,metaField13,metaField14,metaField15,
                metaField16,metaField17};

                
                if(a.Preferred_Payment_Type__c == 'Credit Card'){
                
                    JbillingApi.PaymentInformationWS jbpi = new JbillingApi.PaymentInformationWS();
                    
                    jbpi.metaFields = new jbillingAPI.MetaFieldValueWS[]{
                        metaField18,metaField19,metaField20
                        };
                    
                    user.paymentinstruments = new JbillingAPi.paymentInformationWS[] {jbpi};
                    
                    if(user.paymentInstruments != null && user.paymentInstruments.size()>0){
                        user.paymentInstruments[0].paymentMethodTypeId = 13;
                        user.paymentInstruments[0].processingOrder = 1;
                    }
                }
                if(a.Preferred_Payment_Type__c == 'ACH'){
                
                    JbillingApi.PaymentInformationWS jbpi = new JbillingApi.PaymentInformationWS();
                    
                    jbpi.metaFields = new jbillingAPI.MetaFieldValueWS[]{
                        metaField21,metaField22,metaField23,metaField24,metaField25
                        };
                    
                    user.paymentinstruments = new JbillingAPi.paymentInformationWS[] {jbpi};
                    
                    if(user.paymentInstruments != null && user.paymentInstruments.size()>0){
                        user.paymentInstruments[0].paymentMethodTypeId = 11;
                        user.paymentInstruments[0].processingOrder = 2;
                    }
                } 
                
        }
        
        return user;
        
   }
   


  
   public JbillingApi.UserWS MakeUserWSData(string strid)
   {
        setAccountMap(strId);
        
        JbillingAPI.userWS user = new jbillingAPI.userWS();
        JBillingAPI.contactWS contact= new jbillingAPI.contactWS();
        //JBillingAPI.ach ach = new  jbillingAPI.ach();
        //jbillingAPI.credit_card creditcard = new jbillingAPI.credit_card(); 
        
        Account a = AccountMap.get(strId);// added limit for test use ,will remove it later
       
        if(a != null)
        {      
            
            if(a.Phone != null){jbv.FormatPhoneNumber(a.Phone);}         
            string username = a.Name;
            string password = GenerateRandomPassword();
            

            if(a.JB_CustomerID__c != null && a.JB_CustomerID__c != '')
            {
                integer uId = integer.valueOf(a.JB_CustomerID__c);
                user.userId = uId;
                
                //putting next first day of month for only update
                Date d = system.today();
                d = d.addMonths(1);
                d = d.toStartOfMonth();
                Datetime dt = datetime.newInstance(d.year(), d.month(),d.day());
                system.debug('date for invoice::: '+dt);
                user.nextInvoiceDate = dt;
            }
            
            if(a.ParentId != null){user.parentId = getJBIdForAccount(a.ParentId);}
            if(a.Partner_Id__c != null){user.partnerIds[0] = getJBIdForAccount(a.Partner_Id__c);}
                user.userName = username;
            user.accountTypeId = 60102; 
            
            if(a.ispassword__c != true)
            {
                user.password = password;
                Temppassword = password;
                
            }
           
            user.mainRoleId = 5;
            user.notes = a.Description;
            if(JBSuspendUserController.issuspend == true){user.status = 'Suspended';}
            user.excludeAgeing = a.Exclude_from_Ageing__c;
            user.creditLimit =String.ValueOf(a.Credit_Limit__c);
            user.creditLimitAsDecimal = a.Credit_Limit__c;
            user.createDatetime = a.CreatedDate;
           // user.autoRecharge = String.ValueOf(a.Auto_Recharge_Thershold__c);
           // user.autoRechargeAsDecimal = a.Auto_Recharge_Thershold__c;
            user.language = a.Language__c;
            user.companyName = a.Organization_Name__c;
            user.invoiceChild = a.Invoice_If_Child__c;
            user.isParent = a.Allow_Sub_Accounts__c;
            user.useParentPricing = a.Use_Parent_Pricing__c;
            user.dueDateValue = Integer.valueOf(a.Due_Date_Value__c);//a.Due_Date_Unit__c
            if(a.Due_Date_Unit__c != null){user.dueDateUnitId = jbc.GetPeriodUnitCode(a.Due_Date_Unit__c);}
            if(a.Preferred_Payment_Type__c !=  null)
            {user.automaticPaymentType = jbc.GetAutoPayTypeCode(a.Preferred_Payment_Type__c);}
                        
            contact.firstName = a.Name;
            contact.lastName = a.Last_Name__c;
            contact.address1=a.BillingStreet;
            contact.address2 = a.Billing_Address_2__c;
            contact.city=a.BillingCity;
            contact.email=a.Email__c;
            contact.email='waqar.beyondvision@gmail.com';
            contact.postalCode=a.BillingPostalCode;
            contact.phoneAreaCode = string.valueOf(JBValidator.areacode);
            contact.phoneCountryCode = string.valueOf(JBValidator.countrycode);
            contact.phoneNumber=string.ValueOf(JBValidator.phonenum);
            contact.organizationName=a.Organization_Name__c;
            contact.include = a.include_in_notification__c;
            if(a.BillingCountry != null){contact.countryCode = CountryMap.get(a.BillingCountry.toLowercase());}
            contact.stateProvince = a.BillingState;  
           
            user.contact = contact;
            if (a.status__c != null){user.statusId = jbc.GetStatusCode(a.status__c);}
            if (a.Subscriber_Status__c != null){user.subscriberStatusId = jbc.GetSubStatusCode(a.Subscriber_Status__c);}
            if(a.Currency__c != null){user.currencyId = jbc.GetCurrencyCode(a.Currency__c);}
            if(a.Language__c != null){user.language = a.Language__c; 
                                        user.languageId = jbc.GetLanguageCode(a.Language__c);}
            
            if(a.Invoice_Delivery_Method__c != null){user.invoiceDeliveryMethodId = jbc.GetInvDelMethodCode(a.Invoice_Delivery_Method__c);}
            system.debug('account dyn bal '+a.Balance_Type__c);
            
            
        
        //setting meta field
        /*
            ulist = User_Credential__c.getInstance();//getInstance(userinfo.getUserId());//userinfo.getUserId()
            if(ulist != null && ulist.Partner_Field__c != null)
            {
                JbillingAPI.MetaFieldValueWS metaField1 = new JbillingAPI.MetaFieldValueWS();
                metaField1.fieldName  = 'ccf.partner' ;
                metaField1.stringValue = ulist.Partner_Field__c;//'APPCELERATOR' ;
                metaField1.mandatory = false;
                metaField1.disabled = false ;
                
                user.metaFields = new jbillingAPI.MetaFieldValueWS[]{metaField1};
            }
          */    

                JbillingAPI.MetaFieldValueWS metaField1 = new JbillingAPI.MetaFieldValueWS();
                metaField1.fieldName  = 'ccf.partner' ;
                metaField1.stringValue = 'Salesforce';
                metaField1.mandatory = false;
                metaField1.disabled = false ;
                
                JbillingAPI.MetaFieldValueWS metaField2 = new JbillingAPI.MetaFieldValueWS();
                metaField2.fieldName  = 'contact.email' ;
                metaField2.stringValue = a.Email__c;//'APPCELERATOR' ;
                metaField2.mandatory = false;
                metaField2.disabled = false ;
                
                JbillingAPI.MetaFieldValueWS metaField3 = new JbillingAPI.MetaFieldValueWS();
                metaField3.fieldName  = 'contact.organization' ;
                metaField3.stringValue = a.Organization_Name__c;//'APPCELERATOR' ;
                metaField3.mandatory = false;
                metaField3.disabled = false ;
                
                JbillingAPI.MetaFieldValueWS metaField4 = new JbillingAPI.MetaFieldValueWS();
                metaField4.fieldName  = 'contact.address1' ;
                metaField4.stringValue = a.BillingStreet;//'APPCELERATOR' ;
                metaField4.mandatory = false;
                metaField4.disabled = false ;

                JbillingAPI.MetaFieldValueWS metaField5 = new JbillingAPI.MetaFieldValueWS();
                metaField5.fieldName  = 'contact.address2' ;
                metaField5.stringValue = a.Billing_Address_2__c;//'APPCELERATOR' ;
                metaField5.mandatory = false;
                metaField5.disabled = false ;
                
                JbillingAPI.MetaFieldValueWS metaField6 = new JbillingAPI.MetaFieldValueWS();
                metaField6.fieldName  = 'contact.city' ;
                metaField6.stringValue = a.BillingCity;//'APPCELERATOR' ;
                metaField6.mandatory = false;
                metaField6.disabled = false ;
                
                JbillingAPI.MetaFieldValueWS metaField7 = new JbillingAPI.MetaFieldValueWS();
                metaField7.fieldName  = 'contact.state.province' ;
                metaField7.stringValue = a.BillingState;
                metaField7.mandatory = false;
                metaField7.disabled = false ;
                
                JbillingAPI.MetaFieldValueWS metaField8 = new JbillingAPI.MetaFieldValueWS();
                metaField8.fieldName  = 'contact.postal.code' ;
                metaField8.stringValue = a.BillingPostalCode;//'APPCELERATOR' ;
                metaField8.mandatory = false;
                metaField8.disabled = false ;

                JbillingAPI.MetaFieldValueWS metaField9 = new JbillingAPI.MetaFieldValueWS();
                metaField9.fieldName  = 'contact.country.code' ;
                if(a.BillingCountry != null)
                metaField9.stringValue = CountryMap.get(a.BillingCountry.toLowercase());//'APPCELERATOR' ;
                else
                metaField9.stringValue = '';//'APPCELERATOR' ;
                metaField9.mandatory = false;
                metaField9.disabled = false ;
                
                
                JbillingAPI.MetaFieldValueWS metaField10 = new JbillingAPI.MetaFieldValueWS();
                metaField10.fieldName  = 'contact.last.name' ;
                metaField10.stringValue = a.Last_Name__c;
                metaField10.mandatory = false;
                metaField10.disabled = false ;

                JbillingAPI.MetaFieldValueWS metaField11 = new JbillingAPI.MetaFieldValueWS();
                metaField11.fieldName  = 'contact.phone.country.code' ;
                metaField11.stringValue = string.valueOf(JBValidator.countrycode);
                metaField11.mandatory = false;
                metaField11.disabled = false ;
                
                JbillingAPI.MetaFieldValueWS metaField12 = new JbillingAPI.MetaFieldValueWS();
                metaField12.fieldName  = 'contact.phone.area.code' ;
                metaField12.stringValue = string.valueOf(JBValidator.areacode);
                metaField12.mandatory = false;
                metaField12.disabled = false ;
                
                JbillingAPI.MetaFieldValueWS metaField13 = new JbillingAPI.MetaFieldValueWS();
                metaField13.fieldName  = 'contact.phone.number' ;
                metaField13.stringValue = string.ValueOf(JBValidator.phonenum);
                metaField13.mandatory = false;
                metaField13.disabled = false ;
                

                JbillingAPI.MetaFieldValueWS metaField14 = new JbillingAPI.MetaFieldValueWS();
                metaField14.fieldName  = 'contact.fax.country.code' ;
                metaField14.stringValue = string.valueOf(JBValidator.countrycode);
                metaField14.mandatory = false;
                metaField14.disabled = false ;
                
                JbillingAPI.MetaFieldValueWS metaField15 = new JbillingAPI.MetaFieldValueWS();
                metaField15.fieldName  = 'contact.fax.area.code' ;
                metaField15.stringValue = string.valueOf(JBValidator.areacode);
                metaField15.mandatory = false;
                metaField15.disabled = false ;
                
                JbillingAPI.MetaFieldValueWS metaField16 = new JbillingAPI.MetaFieldValueWS();
                metaField16.fieldName  = 'contact.fax.number' ;
                metaField16.stringValue = a.Fax;
                metaField16.mandatory = false;
                metaField16.disabled = false ;
                
                JbillingAPI.MetaFieldValueWS metaField17 = new JbillingAPI.MetaFieldValueWS();
                metaField17.fieldName  = 'contact.first.name' ;
                metaField17.stringValue = a.First_Name__c;
                metaField17.mandatory = false;
                metaField17.disabled = false ;
                              
                // Creadit Card information 
                JbillingAPI.MetaFieldValueWS metaField18 = new JbillingAPI.MetaFieldValueWS();
                metaField18.fieldName  = 'cc.cardholder.name' ;
                metaField18.stringValue = a.Name_OnC_Card__c;
                metaField18.mandatory = false;
                metaField18.disabled = false ;
                
                
                JbillingAPI.MetaFieldValueWS metaField19 = new JbillingAPI.MetaFieldValueWS();
                metaField19.fieldName  = 'cc.number' ;
                metaField19.stringValue = a.Credit_Card_Number__c;
                metaField19.mandatory = false;
                metaField19.disabled = false ;
                              
                JbillingAPI.MetaFieldValueWS metaField20 = new JbillingAPI.MetaFieldValueWS();
                metaField20.fieldName  = 'cc.expiry.date' ;
                metaField20.stringValue = a.CExpiry_Date__c;
                metaField20.mandatory = false;
                metaField20.disabled = false ;
                
                 //ACH information 
                JbillingAPI.MetaFieldValueWS metaField21 = new JbillingAPI.MetaFieldValueWS();
                metaField21.fieldName  = 'ach.routing.number' ;
                metaField21.stringValue = a.ABA_Routing_Number__c;
                metaField21.mandatory = false;
                metaField21.disabled = false ;
                
                JbillingAPI.MetaFieldValueWS metaField22 = new JbillingAPI.MetaFieldValueWS();
                metaField22.fieldName  = 'ach.customer.name' ;
                metaField22.stringValue = a.Name_on_Cust_Acc__c;
                metaField22.mandatory = false;
                metaField22.disabled = false ;
                
                JbillingAPI.MetaFieldValueWS metaField23 = new JbillingAPI.MetaFieldValueWS();
                metaField23.fieldName  = 'ach.account.number' ;
                metaField23.stringValue = a.Bank_Acc_Number__c != null ?  string.valueOf(a.Bank_Acc_Number__c) : '';
                metaField23.mandatory = false;
                metaField23.disabled = false ;
                
                JbillingAPI.MetaFieldValueWS metaField24 = new JbillingAPI.MetaFieldValueWS();
                metaField24.fieldName  = 'ach.bank.name' ;
                metaField24.stringValue = a.Bank_Name__c;
                metaField24.mandatory = false;
                metaField24.disabled = false ;
                
                JbillingAPI.MetaFieldValueWS metaField25 = new JbillingAPI.MetaFieldValueWS();
                metaField25.fieldName  = 'ach.account.type' ;
                metaField25.stringValue = a.Account_Type__c;
                metaField25.mandatory = false;
                metaField25.disabled = false ;
                
                
                user.metaFields = new jbillingAPI.MetaFieldValueWS[]{metaField1,metaField2,
                metaField3,metaField4,metaField5,metaField6,metaField7,metaField8,metaField9,
                metaField10,metaField11,metaField12,metaField13,metaField14,metaField15,
                metaField16,metaField17};
                
                if(a.Preferred_Payment_Type__c == 'Credit Card'){
                
                    JbillingApi.PaymentInformationWS jbpi = new JbillingApi.PaymentInformationWS();
                    
                    jbpi.metaFields = new jbillingAPI.MetaFieldValueWS[]{
                        metaField18,metaField19,metaField20
                        };
                    
                    user.paymentinstruments = new JbillingAPi.paymentInformationWS[] {jbpi};
                    
                    if(user.paymentInstruments != null && user.paymentInstruments.size()>0){
                        user.paymentInstruments[0].paymentMethodTypeId = 13;
                        user.paymentInstruments[0].processingOrder = 1;
                    }
                }
                if(a.Preferred_Payment_Type__c == 'ACH'){
                
                    JbillingApi.PaymentInformationWS jbpi = new JbillingApi.PaymentInformationWS();
                    
                    jbpi.metaFields = new jbillingAPI.MetaFieldValueWS[]{
                        metaField21,metaField22,metaField23,metaField24,metaField25
                        };
                    
                    user.paymentinstruments = new JbillingAPi.paymentInformationWS[] {jbpi};
                    
                    if(user.paymentInstruments != null && user.paymentInstruments.size()>0){
                        user.paymentInstruments[0].paymentMethodTypeId = 11;
                        user.paymentInstruments[0].processingOrder = 2;
                    }
                } 
            
        }
        
        return user;
        
   }
   
   
   
   public JBillingAPI.contactWS MakeContactWS(string accId)
   {
        setAccountMap(accId);
        
        Account a = AccountMap.get(accId);
        JBillingAPI.contactWS contact= new jbillingAPI.contactWS();
        
        if(a!= null)
        {
            contact.firstName = a.Name;
            contact.lastName = a.Last_Name__c;
           	contact.address1=a.BillingStreet;
            contact.address2 = a.Billing_Address_2__c;
            contact.city=a.BillingCity;
            contact.email=a.Email__c;
            contact.email='waqar.beyondvision@gmail.com';
            contact.postalCode=a.BillingPostalCode;
            contact.phoneAreaCode = string.valueOf(JBValidator.areacode);
            contact.phoneCountryCode = string.valueof(JBValidator.countrycode);
            contact.phoneNumber=string.ValueOf(JBValidator.phonenum);
            contact.organizationName=a.Organization_Name__c;
            contact.include = a.include_in_notification__c;
            if(a.BillingCountry != null){contact.countryCode = CountryMap.get(a.BillingCountry.toLowercase());}
            contact.stateProvince = a.BillingState;
        }
        system.debug('ContactWS :'+contact);
        return contact;
   }
   
      
 
   public Date formatstring2Date(string exp)
   {
        Date dt;
        
            if(exp != null)
            {
                string[] arr = exp.split('/');
                dt = date.newinstance(integer.ValueOf(arr[1]), integer.ValueOf(arr[0]),25);
            }
        
        return dt;
   }
   
   public void updatePassword(string accId,string pass)
   {
        setAccountMap(accId);
        istriggerrunning = true;
        Account accupdate = AccountMap.get(accId);
        accupdate.Temporary_Password__c = pass;
        
        try{update accupdate;}catch(exception ex){}
   }
   //Method to update JB Customer Id returned from webservice to account
   public void updateAccountJBCustomerID(string jbId, string accId,string pass)
   {
        setAccountMap(accId);
        istriggerrunning = true; 
        system.debug('In update account method');
        system.debug('jbId:'+jbId);
        system.debug('accId:'+accId);
        Account accupdate = AccountMap.get(accId);
        accupdate.JB_CustomerID__c = jbId;
        accupdate.ispassword__c = true; 
        accupdate.Temporary_Password__c = pass;
        accupdate.Jbilling_Update_Status__c = 'jBilling account created';
        try{ update accupdate; system.debug('in try');}
        catch(exception ex){system.debug('error while update:'+ex.getMessage());}
        
        //Send Email
        updatePassword(accupdate.Id, pass);
        //SendEmail(accId);
   
   }
   
   
    
   //update jbilling Status field for errors
   
   public void updateJBUpStatusField(string accId,string errstr)
   {
    
        system.debug('error in wrapper: '+errstr);
        setAccountMap(accId);
        istriggerrunning = true; 
        system.debug('accId in update JB status:'+accId);
        system.debug('errstr in update JB status:'+errstr);
        Account accupdate = AccountMap.get(accId);
        if(errstr.contains('User already exists with username')== true)
        {
            accupdate.Jbilling_Update_Status__c = 'Failed to create jBilling account';
        }
        else if (errstr.contains('Validation of \'createUser()\' arguments failed')== true)
        {
            accupdate.Jbilling_Update_Status__c = 'Failed to create jBilling account';
        }
        else if (errstr.contains('time out')== true || errstr.contains('Service Unavailable')== true ||
                 errstr.contains('Web service callout failed: Unexpected element') || errstr.contains('but found \':html\''))
        {
            accupdate.Jbilling_Update_Status__c = 'Failed to connect to jBilling. System unavailable';
        }
        else
        {
            accupdate.Jbilling_Update_Status__c = 'Failed to create jBilling account';
        }
        
        try{update accupdate;}
        catch(exception e){}
   }
   //method to generate Random Password
   public string GenerateRandomPassword()
   {
        Integer max = 9;
        String password = 'a';
        password += EncodingUtil.convertToHex(crypto.generateAesKey(128)).substring(1,max).toUpperCase();
        password += '!';
        Temppassword =password; 
        return password;
   }

   //method to get JB_Customer_ID from parent and partner account
   public integer getJBIdForAccount(string accId)
   {
        setAccountMap(accId);
        Integer Jbint;
        Account acc = AccountMap.get(accId);
        if(acc.JB_CustomerID__c != null && acc.JB_CustomerID__c != '')
        {
            Jbint = Integer.valueOf(acc.JB_CustomerID__c);
        }
        return JbInt;
   }
   public void SendEmail(string accId)
   {
        setAccountMap(accId);
        Account acc = AccountMap.get(accId);
        updatePassword(acc.Id, Temppassword);
        
        string emailBody = 'Your Account has been created on JBilling system'+'<br/>'+
                            '<b>Login :</b> '+acc.Email__c+'<br/>'+
                            '<b>Passwrod :</b> '+acc.Temporary_Password__c;
        
        //create a mail object to send a single email.
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        
        //set the email properties
        mail.setToAddresses(new string[] {acc.Email__c});
        //mail.setToAddresses(new string[] {'maimona.beyondvision@gmail.com'});
        mail.setSenderDisplayName('JBilling Email Agent');
        mail.setSubject('Jbilling Account Created');
        mail.setHtmlBody(emailBody);
        
        //send the email
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail } );
        
   }

    
}