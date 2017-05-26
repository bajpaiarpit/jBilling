/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an organization are executed whenever Apex code is deployed
 * to a production organization to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production organization. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the organization size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class UserTestClass {

    static testMethod void myUnitTest() {
        // TO DO: implement unit test
    
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
}