@isTest
    
    public class AllTestClassMethods{
    
    private static testmethod void AdminPanelControllerTest ()
    { 
        JBillingAdminPAnelController jap = new JBillingAdminPAnelController();
        
        PageReference newpg = jap.GotoAPIPanel();
        
        jap.GotoQuoteManagement();
        jap.GotoQuoteTemplate();
        system.assertequals(newpg.getUrl(),URL.getSalesforceBaseUrl().toExternalForm()+'/apex/JBilling_Config_Panel');
    }
    
  private static testmethod void CodeReferenceControllerTest()
  {
    JBillingCodeEnumContoller crc = new JBillingCodeEnumContoller();
    
    //language code
    integer lgcode = crc.GetLanguageCode('English');
    system.assertequals(lgcode,1);
    integer lgcode2 = crc.GetLanguageCode('portuguese');
    system.assertequals(lgcode2,2);
    integer lgcode_err = crc.GetLanguageCode('Dutch');
    system.assertequals(lgcode_err,null);
    
    //currency code
    integer crcode = crc.GetCurrencyCode('United States Dollars');
    system.assertequals(crcode,1);
    integer crcode2 = crc.GetCurrencyCode('Canadian Dollar');
    system.assertequals(crcode2,2);
    integer crcode3 = crc.GetCurrencyCode('Euro');
    system.assertequals(crcode3,3);
    
    crc.GetAutoPayTypeCode('Credit Card');
    crc.GetAutoPayTypeCode('ACH');
    crc.GetAutoPayTypeCode('Cheque');
    
    crc.GetDynBalCode('none');
    crc.GetDynBalCode('pre paid');
    crc.GetDynBalCode('credit limit');
    
    crc.GetInvDelMethodCode('Email');
    crc.GetInvDelMethodCode('paper');
    crc.GetInvDelMethodCode('Email & paper');
    
    crc.GetPaymentMethodCode('Cheque');
    crc.GetPaymentMethodCode('visa');
    crc.GetPaymentMethodCode('mastercard');
    crc.GetPaymentMethodCode('ach');
    
    crc.GetProStatusCode('active');
    crc.GetProStatusCode('inactive');
    crc.GetProStatusCode('failed');
    crc.GetProStatusCode('unavailable');
    
    crc.GetRoleCodes('Customer');
    crc.GetRoleCodes('Internal');
    crc.GetRoleCodes('Clerk');
    crc.GetRoleCodes('partner');
    
    crc.GetStatusCode('active');
    crc.GetStatusCode('overdue');
    crc.GetStatusCode('suspended');
    crc.GetStatusCode('deleted');
    
    crc.GetSubStatusCode('active');
    crc.GetSubStatusCode('expired');
    crc.GetSubStatusCode('Nonsubscriber');
    
    
    Integer day = crc.GetPeriodUnitCode('Year');
    system.assertequals(day,4);
    
    String period = crc.GetPeriodUnitstring(4);
    system.assertequals(period,'Year');
    
    //static methods
    JBillingCodeEnumContoller.GetPaymentResultMap(1);
    JBillingCodeEnumContoller.GetInvoiceStatusMap(0);
    JBillingCodeEnumContoller.GetOrderStatusMap(2);
    
    
  }
  
    private static testmethod void JBillingconfigControllerTest()
    {
        Delete[select id from User_Credential__c];
        
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        
        Quote_Term__c qt = new Quote_Term__c ();
        qt.Name = 'Test Terms';
        qt.Quote_Types__c = 'test';
        qt.Quote_Terms__c = 'test terms';
        
        insert qt;
        
        
        JBillingConfigController jcc = new JBillingConfigController();
        
        jcc.getOrderst();
        //when custom setting data is null
        
        jcc.SavePartner();
        
        jcc.pageload();
        jcc.username ='';
        jcc.pwd = '';
        jcc.Cancel();   
        
        boolean bx = jcc.CredentialsValidation(jcc.username,jcc.pwd);
        system.assertequals(bx,false);
        
        //when partner is null
        jcc.SavePartner();
        
        jcc.username ='abc';
        jcc.pwd = 'pwd';
        jcc.partner = 'Test Appcelerator';
        jcc.jbUrl ='http://demo.com';
        jcc.companyId = '30';
        

        //without user credentials in dbase
        //else condition in savecredentials method
        
        jcc.SaveCredentials();
        
        JBTestDataClass jbt = new JBTestDataClass();
        
        //savecredentials method for if condition
        jcc.SaveCredentials();
        jcc.SavePartner();
        
        //save status
        jcc.orderstatus = 'active';
        jcc.partner = 'ccf.partner';
        jcc.SaveStatus();
        
        //quote terms 
        
        jcc.quoteTerm.Name = 'test QTerms';
        jcc.quoteTerm.Quote_Terms__c = 'test terms ';
        jcc.quoteTerm.Quote_Types__c = 'test type ';
        
        jcc.SaveTerms();
        
        apexPages.currentPage().getPArameters().put('SelectedTerm',qt.Id);
        jcc.EditQuoteTerm(); 
        
        jcc.DeleteQuoteTerm();
        
        boolean b1 = jcc.saveToSettings(jcc.username, jcc.pwd,jcc.jbUrl);
        system.assertequals(b1,true);
            
    }
    
    private static testmethod void JBillingWSErrorLoggingControllerTest()
    {
        //exception ex ='';
        JBillingWSErrorLoggingController jel = new JBillingWSErrorLoggingController();
        
        List<string> xliststr = new List<string>();
        xliststr.add('Test1');
        xliststr.add('Test2');
        xliststr.add('Test3');
        
        string xstr = jel.ListToString(xliststr);
        system.assertEquals(xstr,'Test1,Test2,Test3');
        
        jel.LogWSResponse('create User',xliststr,'success',system.today());
        
        try{ list<string> strs ; strs.add('add') ;}catch(exception ex){
        jel.LogWSResponse('create User',xliststr, ex, system.today());
        }
        

    }
    
    public static testmethod void JBInvoiceEmailControllerUnitTest() 
   {
    
       Test.setMock(WebServiceMock.class, new WebServiceMockImpl());

       
       Account Acc= new Account(name = 'TEst ACcount',JB_CustomerID__c = '10');
       
       ApexPages.CurrentPage().getParameters().put('Jid','1');
       ApexPages.CurrentPage().getParameters().put('Uid','10');
       
       
       JBInvoiceEmailController init = new JBInvoiceEmailController();
      
       
       init.InitForEmail();
       string filename = init.GetFileName();
       system.assertequals(filename,'Invoice # 1.pdf');
       init.GetBlobFile();
       init.GetPDFbase64String();
       
       insert acc;
       
       
       init.SendEmail();
       init.InsertAtt(); 
       init.InitForEmail();

   }
   
   public static testmethod void JBInvoicesOnAccountControllerUnitTest() {
   
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
       JBInvoicesOnAccountController JbConTeat = new JBInvoicesOnAccountController();
       Account Acc = new Account(Name = 'Jbilling Test ACcount',JB_CustomerID__c = '10',Credit_Card_Number__c = '4111111111111111',CExpiry_Date__c = '12/2014',Name_OnC_Card__c ='test',Email__c ='testing124@demo.com',paymentMethod__c='Visa');
       
       ApexPages.StandardController controller = new ApexPages.StandardController(Acc);
       JBInvoicesOnAccountController JBTest = new JBInvoicesOnAccountController(controller );
       
       insert Acc;
       controller = new ApexPages.StandardController(Acc);
       JBTest = new JBInvoicesOnAccountController(controller );
       system.assert(JBTest.error,false);
       JBTest.error = true;
       JBTest = new JBInvoicesOnAccountController(controller );
       //InvoiceDetail invd = new InvoiceDetail();
   }
   
   public static testmethod void JBInvoiceViewControllerUnitTest() {
       
       Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
       JBInvoiceViewController init = new JBInvoiceViewController();
       
       ApexPages.CurrentPage().getParameters().put('Jid','200');
       init = new JBInvoiceViewController();
       init.UPWS.UWS = new jbillingAPI.userWS();
       init.UPWS.UWS.contact = new jbillingAPI.contactWS();
           init.JIWS.IWS = new jbillingAPI.invoiceWS(); 
               JBInvoiceService TestSrv = new JBInvoiceService();
         system.assert(init.JIWS.getuserId() == null  ,true);
        TestSrv.Error = true;
        TestSrv.ErrorMsg = 'test';
        init.CatchError(TestSrv );
        //init.EmailInovice();
        //init.PayInvoice();

   }
   
   public static testmethod void JBInvoiceWrapperUnitTest() {
   
       JBInvoiceWrapper  JBTest = new JBInvoiceWrapper();
       JBTest = new JBInvoiceWrapper(new JbillingApi.InvoiceWS());
       system.assert(JBTest.IWS   != null ,true);
         
       JBInvoiceWrapper.invoicelineWrapper  Inv = new  JBInvoiceWrapper.invoicelineWrapper(new  jbillingAPI.invoice_line());
        JBTest.getcarriedBalance();
        JBTest.getcreateDateTime();
        JBTest.getcreateTimeStamp();
        JBTest.getcurrencyId();
        JBTest.getcustomerNotes();
        JBTest.getdelegatedInvoiceId();
        JBTest.getdeleted();
        JBTest.getdueDate();
        JBTest.getid();
        JBTest.getinProcessPayment();
        JBTest.getinvoiceLines();
        JBTest.getisReview();
        JBTest.getlastReminder();
        JBTest.getmetaFields();
        JBTest.getnumber_x();
        JBTest.getorders();
        JBTest.getoverdueStep();
        JBTest.getpaymentAttempts();
        JBTest.getpayments();
        JBTest.getstatusDescr();
        JBTest.getstatusId();
        JBTest.gettoProcess();
        JBTest.gettotal();
        JBTest.getuserId();
        JBTest.getstatusString();
 
       
       
       
         
        JBTest.gettotalInt();
        JBTest.getbalanceInt();
       
   }
   
   private static testmethod void TestSuspendedController()
    {
        Test.setMock(WebServiceMock.class, new WebServiceMockImpl());
        
        Account a = new Account();
        a.Name ='account';
        a.Last_Name__c = 'last';
        a.Credit_Card_Number__c ='4111111111111111';
        a.paymentMethod__c='Visa';
        a.Name_OnC_Card__c ='acc';
        a.CExpiry_Date__c = '1/2016';
        a.Email__c ='abc@g.com';
        a.Status__c = 'Active';
        insert a;
        
        Jbilling_Quote__c JQuote = new Jbilling_Quote__c(Account__c = a.id,Active_Since__c = system.today(),Active_Until__c = system.today(),Jbilling_fromOrderId__c='123');
        insert Jquote;
        
        JBSuspendUserController jsc = new JBSuspendUserController();
        
        //JBSuspendUserController.SuspendUser(a.Id);
        Account acctest = [select Id,Status__c from account where id=:a.Id];
        
        //system.assertequals(acctest.status__c,'Suspended');
        //JBSuspendUserController.CheckStatusOfAccount(a.Id);
        //JBSuspendUserController.ActivateUser(a.Id);
        //JBSuspendUserController.Convert2Order(Jquote.Id);
        //boolean bool = JBSuspendUserController.RenewQuoteValid(Jquote.Id);
        
        
    }
    
    private static testmethod void JBUserWrapperTest()
   {
        Account a = new Account();
        a.Name ='account';
        a.Last_Name__c = 'last';
        a.Credit_Card_Number__c ='4111111111111111';
        a.paymentMethod__c='Visa';
        a.Name_OnC_Card__c ='acc';
        a.CExpiry_Date__c = '12/2015';
        a.Email__c ='abc@g.com';
        insert a;
        
        Account a1 = new Account();
        a1.Name ='account1';
        a1.Credit_Card_Number__c ='4111111111111111';
        a1.paymentMethod__c='Visa';
        a1.Name_OnC_Card__c ='acc';
        a1.CExpiry_Date__c = '12/2015';
        a1.Email__c ='abc2@g.com';
        a1.JB_CustomerID__c ='31';
        insert a1;
        
        JBUserWrapper jbuw = new JBUserWrapper();
        jbuw.MakeUserWSData(a.id);
        jbuw.MakeContactWS(a.Id);
        string xstr = jbuw.GenerateRandomPassword();
        jbuw.updateAccountJBCustomerID('12',a.Id,xstr);
        system.debug('passwrod: '+xstr);
        
        jbuw.updateAccountJBCustomerID('12', a.Id,xstr);
        
        Account ac = [select id,JB_CustomerID__c from Account where id =: a.id ];
        system.assertequals(ac.JB_CustomerID__c , '12');
        
        integer jbid = jbuw.getJBIdForAccount(a1.Id);
        system.assertequals(jbid,31);
   }
   
   private static testmethod void TestJBValidator()
    {
        JBValidator jbv = new JBValidator();
        string xstr = jbv.PhoneCountryCode('(999) 123-456789');
        system.assertequals(xstr,'999');
        /*string xstr2 = jbv.PhoneAreaCode('128 123-456789');
        system.assertequals(xstr2,'128');
        string xstr3 = jbv.PhoneAreaCode('138-123-456789');
        system.assertequals(xstr3,'138');*/
        
        //test phone formatting
        
        jbv.FormatPhoneNumber('123 456 7890');
        //system.assertequals(countrycode,123);
        //system.assertequals(areacode,456);
        //system.assertequals(phonenum,'7890');
        
        jbv.FormatPhoneNumber('123-456-7890');
        //system.assertequals(countrycode,123);
        //system.assertequals(areacode,456);
        //system.assertequals(phonenum,'7890');
        
        jbv.FormatPhoneNumber('(123) 456-7890');
        //system.assertequals(countrycode,123);
        //system.assertequals(areacode,456);
        //system.assertequals(phonenum,'456-7890');
        
        jbv.FormatPhoneNumber('(123) 456 7890');
        //system.assertequals(countrycode,123);
        //system.assertequals(areacode,456);
        //system.assertequals(phonenum,'7890');
        
        jbv.FormatPhoneNumber('456 7890');
        //system.assertequals(countrycode,null);
        //system.assertequals(areacode,456);
        //system.assertequals(phonenum,'7890');
        
        jbv.FormatPhoneNumber('4567890');
        //system.assertequals(countrycode,null);
        //system.assertequals(areacode,null);
        //system.assertequals(phonenum,'4567890');
        
        string xcardstr = jbv.validateCreditCard('Visa', '4012-8888-8888-1881');
        system.assertequals(xcardstr,null);
        
        string xerrors ='Credit card number has an inappropriate number of digits' +'\r Format for Visa is 4111111111111111 or 4111-1111-1111-1111';
        string xerrors2 ='Invalid Prefix for Visa'+'\r'+'Allowed prefix are '+'{ 4 }';
        
        string xcardinvalid = jbv.validateCreditCard('Visa', '401288888888188');
        system.assertequals(xcardinvalid,xerrors);
        
        string xinvalidprefix = jbv.validateCreditCard('Visa', '5012888888881881');
        system.assertequals(xinvalidprefix,xerrors2);
    }
    
    private static testmethod void TestQuoteTemplateController()
    {
        
        Quote_Template__c Qtemp = new Quote_Template__c();
        
        Qtemp.Name = 'Test class';
        Qtemp.Font_Face__c = 'Arial';
        Qtemp.Font_Size__c = '12';
        Qtemp.Footer__c = 'footer..';
        Qtemp.Header__c = 'header...';
        Qtemp.Singnature_Line__c = 'signatur...';
        Qtemp.Sub_Heading__c = 'Sub..';
        Qtemp.Main_Heading__c = 'Mainm..';
        Qtemp.Margins_left_right__c = 0.5;
        Qtemp.Margins_top_bottom__c = 0.5;
        Qtemp.Company_Name__c = 'company..';
        Qtemp.Subscription_Type__c = 'Change Subscription';
        
        insert Qtemp;
        
        QuoteTemplateController obj = new QuoteTemplateController();
    
        obj.Validate();
        
        obj.PageLoad();
        
        
        //no subscription type 
        obj.Saveobj.Name = 'Test class';
        
        obj.Save();
        
        // no margins top bottom
        obj.Saveobj.Name = 'Test class';
        obj.Saveobj.Subscription_Type__c = 'New Subscription';
        
        obj.Save();
         
        //no margis
        
        //no subscription type 
        obj.Saveobj.Name = 'Test class';
        obj.Saveobj.Margins_top_bottom__c = 0.5;
        obj.Saveobj.Subscription_Type__c = 'New Subscription';
        
        obj.Save();
        
        //no font face
        obj.Saveobj.Name = 'Test class';
        obj.Saveobj.Margins_left_right__c = 0.5;
        obj.Saveobj.Margins_top_bottom__c = 0.5;
        obj.Saveobj.Subscription_Type__c = 'New Subscription';
        
        obj.Save();
        
        //no font size
        obj.Saveobj.Name = 'Test class';
        obj.Saveobj.Font_Face__c = 'Arial';
        obj.Saveobj.Margins_left_right__c = 0.5;
        obj.Saveobj.Margins_top_bottom__c = 0.5;
        obj.Saveobj.Subscription_Type__c = 'New Subscription';
        
        obj.Save();
        
        //main heading
        obj.Saveobj.Name = 'Test class';
        obj.Saveobj.Font_Face__c = 'Arial';
        obj.Saveobj.Font_Size__c = '12';
        obj.Saveobj.Margins_left_right__c = 0.5;
        obj.Saveobj.Margins_top_bottom__c = 0.5;
        obj.Saveobj.Subscription_Type__c = 'New Subscription';
        
        obj.Save();
        
        //signature line
        obj.Saveobj.Name = 'Test class';
        obj.Saveobj.Font_Face__c = 'Arial';
        obj.Saveobj.Font_Size__c = '12';
        obj.Saveobj.Main_Heading__c = 'Mainm..';
        obj.Saveobj.Margins_left_right__c = 0.5;
        obj.Saveobj.Margins_top_bottom__c = 0.5;
        obj.Saveobj.Subscription_Type__c = 'New Subscription';
        
        obj.Save();
        //header
        obj.Saveobj.Name = 'Test class';
        obj.Saveobj.Font_Face__c = 'Arial';
        obj.Saveobj.Font_Size__c = '12';
        obj.Saveobj.Singnature_Line__c = 'signatur...';
        obj.Saveobj.Main_Heading__c = 'Mainm..';
        obj.Saveobj.Margins_left_right__c = 0.5;
        obj.Saveobj.Margins_top_bottom__c = 0.5;
        obj.Saveobj.Subscription_Type__c = 'New Subscription';
        
        obj.Save();
        
        //footer
        obj.Saveobj.Name = 'Test class';
        obj.Saveobj.Font_Face__c = 'Arial';
        obj.Saveobj.Font_Size__c = '12';
        obj.Saveobj.Header__c = 'header...';
        obj.Saveobj.Singnature_Line__c = 'signatur...';
        obj.Saveobj.Main_Heading__c = 'Mainm..';
        obj.Saveobj.Margins_left_right__c = 0.5;
        obj.Saveobj.Margins_top_bottom__c = 0.5;
        obj.Saveobj.Subscription_Type__c = 'New Subscription';
        
        obj.Save();
        
        
        obj.PageLoad();
        obj.Cancel();
        obj.Validate();
        
        
        obj.Saveobj.Name = 'Test class new ';
        obj.Saveobj.Font_Face__c = 'Arial';
        obj.Saveobj.Font_Size__c = '12';
        obj.Saveobj.Footer__c = 'footer..';
        obj.Saveobj.Header__c = 'header...';
        obj.Saveobj.Singnature_Line__c = 'signatur...';
        obj.Saveobj.Sub_Heading__c = 'Sub..';
        obj.Saveobj.Main_Heading__c = 'Mainm..';
        obj.Saveobj.Margins_left_right__c = 0.5;
        obj.Saveobj.Margins_top_bottom__c = 0.5;
        obj.Saveobj.Company_Name__c = 'company..';
        obj.Saveobj.Subscription_Type__c = 'New Subscription';
        
        
        obj.Save();
        
        apexPages.currentPage().getParameters().put('SelectedTerm',Qtemp.Id);
        obj.EditTemp();
        system.assertequals(obj.isupdate,true);

    }
    
  }