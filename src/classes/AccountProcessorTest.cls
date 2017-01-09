@isTest
public class AccountProcessorTest{
     public static testMethod void testAccountProcessor() {
        List<Id> accIdList = new List<Id>();
        Account acc = new Account();
        acc.Name = '1234';
        insert acc;
        
        Account acc3 = new Account();
        acc3.Name = '1234';
        insert acc3;
        
        Account acc2 = new Account();
        acc2.Name = '1234';
        insert acc2;
        
        Account acc1 = new Account();
        acc1.Name = '1234';
        insert acc1;
        accIdList.add(acc.Id);
        accIdList.add(acc1.Id);
        accIdList.add(acc2.Id);
        accIdList.add(acc3.Id);
        
        Contact c = new Contact();
        c.LastName = '1234';
        c.AccountId = acc.Id;
        insert c;
        
        Contact c1 = new Contact();
        c1.LastName = '1234';
        c1.AccountId = acc1.Id;
        insert c1;
        
        Contact c2 = new Contact();
        c2.LastName = '1234';
        c2.AccountId = acc2.Id;
        insert c2;
        
        Contact c3 = new Contact();
        c3.LastName = '1234';
        c3.AccountId = acc2.Id;
        insert c3;
        
        Test.startTest();
            AccountProcessor.countContacts(accIdList);
        Test.stopTest();
        
        AccountProcessor.countContacts(accIdList);
    }    
}