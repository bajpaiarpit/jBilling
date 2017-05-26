trigger CreateUpdateJBCustTrigger on Account (after insert, after update) {
    
    
    Map<Id,Account> oldacc = trigger.oldmap;
    public JBValidator vcc = new JBValidator();
    public boolean isach {get;set;}
    public boolean isCc {get;set;}
    public List<string> xlistcreate = new List<string>();
    public List<string> xlistcreate_up = new List<string>();
    public List<string> xlistupdate = new List<string>();
    public List<string> xlistupdate_sus = new List<string>();
    
    if(trigger.isInsert)
    { 
        //if(JBAccountFromOrderController.istriggerInsert != true){ // comment by waqar for temporary basis until order work is not done. 
            for(Account a :Trigger.new)
            {
                //validation of ACH data
                if(a.ABA_Routing_Number__c != null)
                {
                     
                    string xstr = a.ABA_Routing_Number__c.replace(',','');
                    system.debug('string:'+xstr);
                    system.debug('string.length'+xstr.length());
                    
                    try{
                        decimal.valueOf(xstr);
                    }catch(exception ex){
                        if(ex.getMessage().contains('Invalid'))
                        {a.ABA_Routing_Number__c.adderror('Invalid Number:'+a.ABA_Routing_Number__c);}
                    }
                    if(xstr.length()>10 || xstr.length() == 0 || xstr.length()<10)
                    {
                        a.ABA_Routing_Number__c.adderror('Routing Number Should be of 10 digits');
                    }
                }
                if(a.Bank_Acc_Number__c != null)
                {
                    
                    string temstr = a.Bank_Acc_Number__c.replace('-','');
                    system.debug('temstr:'+temstr);
                    
                    try{ 
                        decimal.valueOf(temstr);
                    }catch(exception ex){
                        if(ex.getMessage().contains('Invalid'))
                        {a.Bank_Acc_Number__c.adderror('Invalid Number:'+a.Bank_Acc_Number__c);}
                    }
                    
                    if(temstr.length()>16 || temstr.length() == 0 || temstr.length()<16)
                    {
                        a.Bank_Acc_Number__c.adderror('Bank Account Number Should be of 16 digits');
                    }

                }
                //Data Validation End
                if(a.Create_jBilling_Account__c == true)
                {
                    if(a.Email__c == null || a.Email__c == ''){a.Email__c.adderror('You must enter a value');}
                    if(a.Preferred_Payment_Type__c == 'ACH')
                        { 
                            if(a.ABA_Routing_Number__c== null){a.ABA_Routing_Number__c.adderror('You must enter a value');}
                            if(a.Bank_Acc_Number__c== null){a.Bank_Acc_Number__c.adderror('You must enter a value');}
                            if(a.Bank_Name__c== null){a.Bank_Name__c.adderror('You must enter a value');}
                            if(a.Name_on_Cust_Acc__c== null){a.Name_on_Cust_Acc__c.adderror('You must enter a value');}
                            if(a.Account_Type__c== null){a.Account_Type__c.adderror('You must enter a value');}
                        }
                    if(a.Preferred_Payment_Type__c == 'Credit Card')
                        { 
                            if(a.Name_OnC_Card__c== null){a.Name_OnC_Card__c.adderror('You must enter a value');}
                            if(a.Credit_Card_Number__c== null){a.Credit_Card_Number__c.adderror('You must enter a value');}
                            if(a.CExpiry_Date__c== null){a.CExpiry_Date__c.adderror('You must enter a value');}
                            if(a.CExpiry_Date__c != null){
                                string pat = '(0?[1-9]|1[012])/((19|20)\\d\\d)';
                                
                                if(!Pattern.matches(pat,a.CExpiry_Date__c))
                                {
                                    a.CExpiry_Date__c.adderror('Format should be mm/yyyy');
                                }
                            }
                            //if(a.paymentMethod__c== null) {a.paymentMethod__c.adderror('You must enter a value');}
                            if(a.Credit_Card_Number__c!= null){
                                
                            string xstrtest = vcc.validateCreditCard(a.paymentMethod__c,a.Credit_Card_Number__c);
                           
                            if(xstrtest != null && xstrtest != '')
                            {a.Credit_Card_Number__c.adderror(xstrtest);}
                            }
                            
                        }
                    xlistcreate.add(a.Id);  
                    
                }
            }
            
            if(xlistcreate.size()>0)    
            {
            	system.debug('first method called:: '+xlistcreate);
                JBUserServices.CreateUserOnJbilling(xlistcreate);
            }
       // }
    }
    
    else if (trigger.isUpdate)
    {
        isach = false;
        isCc = false;
        if(JBUserWrapper.istriggerrunning != true)
        {
            for(Account a : Trigger.new)
            {
                //validation of ACH data
                if(a.ABA_Routing_Number__c != null)
                {
                    
                    string xstr = a.ABA_Routing_Number__c.replace(',','');
                    system.debug('string:'+xstr);
                    system.debug('string.length'+xstr.length());
                    
                    try{
                        decimal.valueOf(xstr);
                    }catch(exception ex){
                        if(ex.getMessage().contains('Invalid'))
                        {a.ABA_Routing_Number__c.adderror('Invalid Number:'+a.ABA_Routing_Number__c);}
                    }
                    if(xstr.length()>10 || xstr.length() == 0 || xstr.length()<10)
                    {
                        a.ABA_Routing_Number__c.adderror('Routing Number Should be of 10 digits');
                    }
                }
                if(a.Bank_Acc_Number__c != null)
                {
                    
                    string temstr = a.Bank_Acc_Number__c.replace('-','');
                    system.debug('temstr:'+temstr);
                    try{
                        decimal.valueOf(temstr);
                    }catch(exception ex){
                        if(ex.getMessage().contains('Invalid'))
                        {a.Bank_Acc_Number__c.adderror('Invalid Number:'+a.Bank_Acc_Number__c);}
                    }
                    
                    if(temstr.length()>16 || temstr.length() == 0 || temstr.length()<16)
                    {
                        a.Bank_Acc_Number__c.adderror('Bank Account Number Should be of 16 digits');
                    }

                }
                //Data Validation End
                if((a.JB_CustomerID__c == null || a.JB_CustomerID__c == '') && a.Create_jBilling_Account__c == true )
                {
                                        
                    if(a.Email__c == null || a.Email__c == ''){a.Email__c.adderror('You must enter a value');}
                    if(a.Preferred_Payment_Type__c == 'ACH')
                        { 
                            if(a.ABA_Routing_Number__c== null){a.ABA_Routing_Number__c.adderror('You must enter a value');}
                            if(a.Bank_Acc_Number__c== null){a.Bank_Acc_Number__c.adderror('You must enter a value');}
                            if(a.Bank_Name__c== null){a.Bank_Name__c.adderror('You must enter a value');}
                            if(a.Name_on_Cust_Acc__c== null){a.Name_on_Cust_Acc__c.adderror('You must enter a value');}
                            if(a.Account_Type__c== null){a.Account_Type__c.adderror('You must enter a value');}
                        }
                    if(a.Preferred_Payment_Type__c == 'Credit Card')
                        { 
                            if(a.Name_OnC_Card__c== null){a.Name_OnC_Card__c.adderror('You must enter a value');}
                            if(a.Credit_Card_Number__c== null){a.Credit_Card_Number__c.adderror('You must enter a value');}
                            if(a.CExpiry_Date__c== null){a.CExpiry_Date__c.adderror('You must enter a value');}
                            if(a.CExpiry_Date__c != null){
                                string pat = '(0?[1-9]|1[012])/((19|20)\\d\\d)';
                                
                                if(!Pattern.matches(pat,a.CExpiry_Date__c))
                                {
                                    a.CExpiry_Date__c.adderror('Format should be mm/yyyy');
                                }
                            }

                            if(a.Credit_Card_Number__c!= null){
                                
                            string xstrtest = vcc.validateCreditCard(a.paymentMethod__c,a.Credit_Card_Number__c);
                            if(xstrtest != null && xstrtest != '')
                            {a.Credit_Card_Number__c.adderror(xstrtest);}
                            }
                            
                        }
                    xlistcreate_up.add(a.Id);   

                }

                //if update needs on jbilling
                if(a.Create_jBilling_Account__c == true && a.JB_CustomerID__c != null)// && oldacc.get(a.Id).Create_jBilling_Account__c != false)
                {
                    if(a.Email__c == null){a.Email__c.adderror('You must enter a value');}
                    if(a.Preferred_Payment_Type__c == 'ACH')
                    { 
                        if(a.ABA_Routing_Number__c== null){a.ABA_Routing_Number__c.adderror('You must enter a value');}
                        if(a.Bank_Acc_Number__c== null){a.Bank_Acc_Number__c.adderror('You must enter a value');}
                        if(a.Bank_Name__c== null){a.Bank_Name__c.adderror('You must enter a value');}
                        if(a.Name_on_Cust_Acc__c== null){a.Name_on_Cust_Acc__c.adderror('You must enter a value');}
                        if(a.Account_Type__c== null){a.Account_Type__c.adderror('You must enter a value');}
                            
                    
                    }
                    if(a.Preferred_Payment_Type__c == 'Credit Card')
                    { 
                        if(a.Name_OnC_Card__c== null){a.Name_OnC_Card__c.adderror('You must enter a value');}
                        if(a.Credit_Card_Number__c== null){a.Credit_Card_Number__c.adderror('You must enter a value');}
                        if(a.CExpiry_Date__c== null){a.CExpiry_Date__c.adderror('You must enter a value');}
                        if(a.CExpiry_Date__c != null){
                            string pat = '(0?[1-9]|1[012])/((19|20)\\d\\d)';
                            
                            if(!Pattern.matches(pat,a.CExpiry_Date__c))
                            {
                                a.CExpiry_Date__c.adderror('Format should be mm/yyyy');
                            }
                        }

                        if(a.Credit_Card_Number__c!= null){
                            string xstrtest = vcc.validateCreditCard(a.paymentMethod__c,a.Credit_Card_Number__c);
                            if(xstrtest != null && xstrtest != '')
                            {
                                a.Credit_Card_Number__c.adderror(xstrtest);
                            }
                        }
                    
                    }
                    
                    xlistupdate.add(a.Id);              
                }
            } //end of for loop
            //create user on jbilling if "Create jbilling account" was not checked 
            //when inserting record and is now checked in update account
            if(xlistcreate_up.size()>0) 
            {
                system.debug('second method called:: '+xlistcreate_up);
                JBUserServices.CreateUserOnJbilling(xlistcreate_up);
            }
            
            //update user on jbilling
            if(xlistupdate.size()>0)
            {
            	system.debug('third method called:: '+xlistupdate);
                JBUserServices.UPdateUseronJbilling(xlistupdate);
            }
        }
        else if (JBSuspendUserController.issuspend == true)
        {
            for(Account a : Trigger.new)
            {
                xlistupdate_sus.add(a.Id);
                
            }
            if(xlistupdate_sus.size()>0)
            {
            	system.debug('fourth method called:: '+xlistupdate_sus);
                JBUserServices.UPdateUseronJbilling(xlistupdate_sus);
            }
        }
    }

}