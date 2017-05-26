public with sharing class JBillingAdminPAnelController {
    
    
    
    public JBillingAdminPAnelController(){}
    
    public pagereference GotoAPIPanel()
    {
        return new PageReference(URL.getSalesforceBaseUrl().toExternalForm() + '/apex/JBilling_Config_Panel');
    }
    public pagereference GotoQuoteManagement()
    {
      return new PageReference(URL.getSalesforceBaseUrl().toExternalForm() + '/apex/JBilling_Config_Panel?isquote=true');
    }
    public pagereference GotoQuoteTemplate()
    {
      return new PageReference(URL.getSalesforceBaseUrl().toExternalForm() + '/apex/QuoteTemplate');
    }
    
    

}