public with sharing class QuoteTemplateController
{
  
  public string sectiontitle {get;set;}
  public boolean isupdate {get;set;}
  
  public List<Quote_Template__c> existingTemp {get;set;}
  public Map<string,Quote_Template__c> existingMap = new Map<string,Quote_Template__c>();
  public Quote_Template__c Saveobj {get;set;}

    public QuoteTemplateController()
    { 
      if(apexPages.currentPage().getParameters().get('issave') != null &&
          apexPages.currentPage().getParameters().get('issave') == 'true')
      {
        //issave =apexPages.currentPage().getParameters().get('issave');
        apexPages.addMessage(new apexPages.message(apexPages.severity.INFO,'Template saved successfully !'));
      }
      if(apexPages.currentPage().getParameters().get('issave') != null &&
          apexPages.currentPage().getParameters().get('issave') == 'update')
      {
        //issave =apexPages.currentPage().getParameters().get('issave');
        apexPages.addMessage(new apexPages.message(apexPages.severity.INFO,'Template updated successfully !'));
      }
      isupdate = false;
      sectiontitle = 'New Quote Template';      
      existingTemp = new List<Quote_Template__c>();
      Saveobj = new Quote_Template__c();

      existingTemp = [Select Name,Id,Font_Face__c,Font_Size__c,Header__c,Main_Heading__c,Footer__c,
              Margins_left_right__c,Margins_top_bottom__c,Subscription_Type__c ,Sub_Heading__c,
              Singnature_Line__c,  Company_Name__c
              from Quote_Template__c 
              limit 10];
      
    }
    
    public pagereference PageLoad()
    {
      for(Quote_Template__c qt:existingTemp)
      {
        existingMap.put(qt.Id,qt);
      }
      return null;
    }
    
    public boolean Validate()
    {
      if(saveObj.Name == null || saveObj.Name == '')
      {
        ApexPages.addMessage(new ApexPages.Message(apexPages.Severity.Error,'Please enter \'Template Name\''));
        return false;
      }
      if(saveObj.Subscription_Type__c == null)
      {
        ApexPages.addMessage(new ApexPages.Message(apexPages.Severity.Error,'Please enter \'Subscription Type\''));
        return false;
      }
      if(saveObj.Margins_top_bottom__c == null)
      {
        ApexPages.addMessage(new ApexPages.Message(apexPages.Severity.Error,'Please enter \'Margins\''));
        return false;
      }
      if(saveObj.Margins_left_right__c == null)
      {
        ApexPages.addMessage(new ApexPages.Message(apexPages.Severity.Error,'Please select \'Margins\''));
        return false;
      }
      if(saveObj.Font_Face__c == null)
      {
        ApexPages.addMessage(new ApexPages.Message(apexPages.Severity.Error,'Please select \'Font Face\''));
        return false;
      }
      if(saveObj.Font_Size__c == null)
      {
        ApexPages.addMessage(new ApexPages.Message(apexPages.Severity.Error,'Please select \'Font Size\''));
        return false;
      }
      if(saveObj.Main_Heading__c == null)
      {
        ApexPages.addMessage(new ApexPages.Message(apexPages.Severity.Error,'Please enter \'Main Heading\''));
        return false;
      }
      if(saveObj.Singnature_Line__c == null)
      {
        ApexPages.addMessage(new ApexPages.Message(apexPages.Severity.Error,'Please enter \'Singnature Line\''));
        return false;
      }
      if(saveObj.Header__c == null)
      {
        ApexPages.addMessage(new ApexPages.Message(apexPages.Severity.Error,'Please enter \'Header Information\''));
        return false;
      }
      if(saveObj.Footer__c == null)
      {
        ApexPages.addMessage(new ApexPages.Message(apexPages.Severity.Error,'Please enter \'Footer Information\''));
        return false;
      }
      
      //validation for dupliacte types
      if(saveObj.Id == null)
      {
        List<Quote_Template__c> querylist = new List<Quote_Template__c>();
        
         querylist = [select Subscription_Type__c  
                from Quote_Template__c 
                where Subscription_Type__c =: saveObj.Subscription_Type__c];
                          
      if(querylist.size()>0)
      {
        ApexPages.addMessage(new ApexPages.Message(apexPages.Severity.Error,'Quote template already saved with susbscritpition type \''+saveObj.Subscription_Type__c+'\''));
        ApexPages.addMessage(new ApexPages.Message(apexPages.Severity.Error,'Please change \'Subscription Type\''));
          return false;
      }
      }
      if(saveObj.Id != null)
      {
        List<Quote_Template__c> querylist = new List<Quote_Template__c>();
        
         querylist = [select Subscription_Type__c  
                from Quote_Template__c 
                where Subscription_Type__c =: saveObj.Subscription_Type__c
                AND id !=:saveObj.Id];
                          
      if(querylist.size()>0)
      {
        ApexPages.addMessage(new ApexPages.Message(apexPages.Severity.Error,'Quote template already saved with susbscritpition type \''+saveObj.Subscription_Type__c+'\''));
        ApexPages.addMessage(new ApexPages.Message(apexPages.Severity.Error,'Please change \'Subscription Type\''));
          return false;
      }
      }
      return true;
    }
    
    public pagereference Save()
    {
      if(!Validate()){return null;}
      try
      {
        upsert saveObj;
        //apexPages.addMessages(new apexPages.message(apexPages.severity.Error,'Template saved successfully !'));
        saveObj = new Quote_Template__c();
        sectiontitle = 'New Quote Template';
        
      }
      catch(exception ex)
      {
        apexpages.addMessage(new Apexpages.Message(apexpages.SEVERITY.error,''+ex.getMessage()));
            return null;
      }
      //apexPages.addMessage(new apexPages.message(apexPages.severity.INFO,'Template saved successfully !'));
      //return null;
      if(isupdate == true)
      {
        return new pagereference (URL.getsalesforceBaseUrl().toExternalForm()+'/apex/QuoteTemplate?issave=update');
      }
      return new pagereference (URL.getsalesforceBaseUrl().toExternalForm()+'/apex/QuoteTemplate?issave=true');
    }
    public PageReference Cancel()
    {
      saveObj = new Quote_Template__c();
      sectiontitle = 'New Quote Template';
      
      return null;
    }
    
    public pagereference EditTemp ()
    {
      string qtid = Apexpages.currentPage().getParameters().get('SelectedTerm');//.get('SelectedTerm');
      if(qtId != null)
      {
        Quote_Template__c tempelate = [Select Name,Id,Font_Face__c,Font_Size__c,Header__c,Main_Heading__c,Footer__c,
                        Margins_left_right__c,Margins_top_bottom__c,Subscription_Type__c ,Sub_Heading__c,
                        Singnature_Line__c,  Company_Name__c
                        from Quote_Template__c 
                        where id=:qtId
                        limit 1];
        saveObj = tempelate;
        
        sectiontitle = 'Edit Quote Template';
      }
      isupdate = true;
      
      return null;
    }
    
   
}