public with sharing class JBillingWSErrorLoggingController {
    
    public JBillingWSErrorLoggingController(){}

    public void LogWSResponse(string methodname,List<string> parameters,string apiresponse,datetime timestamp)
    {
        //date to be taken on today date
        jBilingWSLog__c jws = new jBilingWSLog__c();
        jws.Timestamp__c = timestamp;
        jws.API_method_call__c = methodname;
        jws.API_method_parameters__c = ListToString(parameters);
        jws.API_Response__c = apiresponse;
        //jws.Exception__c = exceptionstr;
        
        try
        {
            insert jws;
        }
        catch(exception ex){}
    }
     
    public void LogWSResponse(string methodname, List<string> Parameters,exception e,datetime timestamp)
    {
        system.debug('exceptions:');
        system.debug('exception (getCause):'+e.getCause());
        system.debug('exception (getLineNumber) :'+e.getLineNumber());
        system.debug('exception (getMessage) :'+e.getMessage());
        system.debug('exception (getStackTraceString) :'+e.getStackTraceString());
        system.debug('exception (getTypeName) :'+e.getTypeName());
        //system.debug('json:'+JSON.serialize(e));
        
        jBilingWSLog__c jws = new jBilingWSLog__c();
        jws.Timestamp__c = timestamp;
        jws.API_method_call__c = methodname;
        jws.API_method_parameters__c = ListToString(parameters);
        //jws.API_Response__c ='';
        jws.Exception__c = e.getMessage();
        
        try
        {
            insert jws;
        }
        catch(exception ex){}
        
    }
    //convert list of parameters passed to string
    public string ListToString(List<string> liststr)
    {
        string param='';
        for(integer i=0;i<liststr.size();i++)
        {
            param += liststr[i];
            if(i!=liststr.size()-1)
            {param += ',';}
        }
        return param;
    }
    
    
}