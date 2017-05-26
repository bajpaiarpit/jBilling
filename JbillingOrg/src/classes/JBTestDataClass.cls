@isTest
global with sharing class JBTestDataClass
{
    global JBTestDataClass()
    {
        // user credentials data
        Delete[select id from User_Credential__c];
        
        User_Credential__c uc = new User_Credential__c();
        uc.Uname__c ='admin';
        uc.Password__c ='test';
        
        insert uc; 
        
        //Account with CreditCard data
        //Account with JBId
        
        Account Acc = new Account();
        Acc.Name = 'Jbilling Test ACcount';
        Acc.Preferred_Payment_Type__c ='Credit Caard';
        Acc.JB_CustomerID__c = '10';
        Acc.Credit_Card_Number__c = '4111111111111111';
        Acc.CExpiry_Date__c = '1/2016';
        Acc.Name_OnC_Card__c ='test';
        Acc.Email__c ='testing124@demo.com';
        Acc.paymentMethod__c='Visa';
        Acc.ABA_Routing_Number__c ='1231231231';
        Acc.Bank_Acc_Number__c = '1231231231231231';
        
        insert acc;
        
        //Account with ACH data
        
        //Quote Data
        
        Jbilling_Quote__c JQuote = new Jbilling_Quote__c(Account__c = acc.id,Active_Since__c = system.today(),Active_Until__c = system.today());
        insert Jquote;
        
        Jbilling_Product__c jProd = new Jbilling_Product__c();
        jProd.Description__c ='Mobile 89x3P';
        jProd.Quantity__c = 1;
        jProd.Price__c = 400;
        jProd.Product_ID__c ='100';
        jProd.Quote__c =  Jquote.id;
        
        insert jProd;
        
    }
    
}