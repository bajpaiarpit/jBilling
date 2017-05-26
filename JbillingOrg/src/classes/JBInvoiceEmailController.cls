public with sharing class JBInvoiceEmailController {


    public string JID {get;set;}
    public string UID {get;set;} 
    public string EmailList {get;set;}
    public boolean iserrorshow {get;set;}
    
    public boolean isShow {get;set;}
    public blob GetBlobFile()
    {
        if(Test.isRunningTest())
        {
            return Encodingutil.base64Decode('Test data');
        }
        
        return Encodingutil.base64Decode(GetPDFbase64String());
        
    }
    
     public string GetFileName()
    {
        String name = 'Invoice # ';
        if(ApexPages.CurrentPage().getParameters().get('Jid') != null )
        {
          name = name +  ApexPages.CurrentPage().getParameters().get('Jid') + '.pdf' ;
        }
        return name;
    }
    
    public void InitForEmail() {
        
        iserrorshow= false;
        isShow = true;
        JID = ApexPages.CurrentPage().getParameters().get('Jid');
        UID = ApexPages.CurrentPage().getParameters().get('Uid');
       
        List<JBUserWrapper> ListUPWS  = new List<JBUserWrapper>();
        List<account> ACCList = [select id,name,Email__c from Account where JB_CustomerID__c = : ApexPages.CurrentPage().getParameters().get('Uid') limit 1];
        if(ACCList != null && ACCList.size() > 0)
        {
            ACC   = ACCList[0];
            JBUserServices JbSrv = new JBUserServices();
            
            ListUPWS  = JbSrv.getContactsWSList(integer.valueof(ApexPages.CurrentPage().getParameters().get('Uid')));
            for( JBUserWrapper UPWS  : ListUPWS   )
            {
                ACC.Email__c  = UPWS.getEmail();
                EmailList   = UPWS.getEmail();
            }
            system.debug('what is this?'); 
            if(ListUPWS != null){
                if(ListUPWS.size()>0){ErrorMsg  = ListUPWS[0].getEmail();}
            }
            if(JbSrv.error == true)
            {
                Error   = JbSrv.error;
                ErrorMsg = JbSrv.errorMsg;
            }    
        }else
        {
             Error   = true ;
             ErrorMsg = 'No account found';
        }
        
       /* List<emailTemplate> Template = [select id from  EmailTemplate  where  DeveloperName = : 'Jbilling_Invoice' and  IsActive = true  limit 1]; 
        if(Template != null && Template.size()> 0  )
        {
           TemplateID = Template[0].id;
        }else
        {
            Error   = true;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Email Template not found' ));

        }*/
         
        
        if(Error   == true ){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ErrorMsg ));
            ErrorMsg = 'No Account found';
        }
    }


    public string TemplateID;
    public string Body {get ; set;}
    public string Subject {get ; set;}
    public PageReference SendEmail() {
            try{
            //setting up attachment
            
                Messaging.EmailFileAttachment[] fileAttachments = new Messaging.EmailFileAttachment[] {};               
                Messaging.EmailFileAttachment efa = new Messaging.EmailFileAttachment();  
                
                if(GetPDFbase64String() == null)
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'No attachment Found!'));       
                    return null;
                }
                if(GetPDFbase64String() != null)
                {
                    efa.setFileName(GetFileName());
                    efa.setBody(Encodingutil.base64Decode(GetPDFbase64String()));
                    efa.setInline(true);
                    fileAttachments.add(efa);
                }
               
                system.debug('fileAttachments :'+fileAttachments);
                system.debug('Acc.Id: '+Acc.Id);
                system.debug('Body: '+Body);
                system.debug('Subject: '+Subject);
                system.debug('acc.email__c: '+Acc.email__c);
                
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                if(fileAttachments != null)
                mail.setFileAttachments(fileAttachments);
                mail.setWhatId(ACC.id);
                mail.setHtmlBody(Body );
                mail.setsubject(Subject );
                // mail.setTemplateId(TemplateID );
                mail.setToAddresses(SeperateEmailAdd(EmailList));//new String[] {Acc.email__c});
                system.debug('Mail :'+mail);
                //  mail.setTargetObjectId('0039000000Ic4db');
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail });
                 
                isShow = false;
            }catch(exception ex)
            {
                if(ex.getMessage().contains('error: INVALID_EMAIL_ADDRESS') && EmailList.countMatches('@')>1)
                {
                    //ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Invalid email address(s) entered.'));
                    iserrorshow= true;
                    return null;
                }
                if(ex.getMessage().contains('error: INVALID_EMAIL_ADDRESS') )
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Invalid email address(s) entered.'));       
                    iserrorshow= false;
                    return null;
                }
                iserrorshow= false;
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,ex + ''));       
                return null;
            }
             
             
        
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'Email Sent successfully!'));
        //return new PageReference('/' + ACc.id);
        return null;
    }

    public string[] SeperateEmailAdd(string xstr)
    {
        List<string> xlist = new List<string>();
        system.debug('In seperate address method');
        system.debug('xstr.contains:'+xstr.contains(';'));
        if(xstr!= null && xstr.contains(';'))
        {
            system.debug('In seperate address method2');
            string[] emailadd = xstr.split(';');
            for(string s: emailadd)
            {
                xlist.add(s);
            }
            system.debug('xlist:'+xlist);
        }
        else if(xstr!= null && xstr.contains(','))
        {
            string[] emailadd = xstr.split(',');
            for(string xs: emailadd)
            {
                xlist.add(xs);
            }
        }
        else
        {
            system.debug('In else');
            xlist.add(xstr);
        }
        string[] emailarr = new string[xlist.size()];
        for(integer i=0;i<xlist.size();i++)
        {
            emailarr[i] = xlist[i];
        }
        return emailarr;
    }
    
    public pagereference BackToAcc()
    {
        return new PageReference('/' + ACc.id);
    }
   public Account ACC  {get ; set ;}
    public PageReference InsertAtt() {
    
        List<Attachment> xlistattach = new List<Attachment>();
         List<account> ACCList = [select id,name,Email__c from Account where JB_CustomerID__c = : ApexPages.CurrentPage().getParameters().get('Uid') limit 1];
        if(ACCList != null && ACCList.size() > 0)
        {
           JBInvoiceService JbSrv = new JBInvoiceService();
            JBInvoiceWrapper JIWS  = new JBInvoiceWrapper();
            Attachment Att = new Attachment();
            if(GetPDFbase64String() == null)
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Error in retrieving invoice from webservice!'));
                return null;
            }
            if(GetPDFbase64String() != null)
            {
                Att.parentID = ACCList[0].id;
                Att.name = GetFileName();
                Att.body   = Encodingutil.base64Decode(GetPDFbase64String());
                //insert att;
                xlistattach.add(Att);
                
                InsertAttachment(xlistattach);
            }
            
            if(JbSrv.error == true)
            {
                Error    = JbSrv.error;
                ErrorMsg = JbSrv.errorMsg;
                return null;
            }   
            
            return new Pagereference('/servlet/servlet.FileDownload?file=' + Att.id);
         }else
         {
             Error    = true ;
             ErrorMsg = 'No account found';
         }  
                
        return null;    
    }
    
    public void InsertAttachment(List<Attachment> attach)
    {
        try
        {
            insert attach;
        }
        catch(exception ex)
        {
            
        }
    }
     public String GetPDFbase64String() {
       JBInvoiceService JbSrv = new JBInvoiceService();
        system.debug('In GetPDFbase64::'+JbSrv.getPaperInvoicePDFGetInovice(integer.valueof(ApexPages.CurrentPage().getParameters().get('Jid'))));
        return JbSrv.getPaperInvoicePDFGetInovice(integer.valueof(ApexPages.CurrentPage().getParameters().get('Jid')));
        
        if(JbSrv.error == true)
        {
            Error   = JbSrv.error;
            ErrorMsg = JbSrv.errorMsg;
        }
        
         
        return '';
    }
    


    Public string BlobString {get ; set ;}
    public boolean Error {set; get ;}
    public String ErrorMsg {set; get ;}
    public JBInvoiceEmailController()
    {
    
    }
    
    
}