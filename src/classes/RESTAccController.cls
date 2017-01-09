@RestResource(urlMapping = '/FieldCase/*')
global with sharing class RESTAccController {

    @HttpPost
    global static String createNewAcc(String Name) {
        Account acc = new Account();
        acc.Name = Name;
        acc.mightymani__SLA__c = 'Gold';
        acc.mightymani__SLAExpirationDate__c = date.today();
        acc.mightymani__SLASerialNumber__c = '123';
        insert acc;

        return acc.Id;
    }

    /*@HttpGet
    global static Account getAccount() {
        String companyName = RestContext.request.params.get('Name');
        Account company = [ Select ID, Name, Email__c, BillingState from Account where Name = :companyName];

        return company;

    }*/
}