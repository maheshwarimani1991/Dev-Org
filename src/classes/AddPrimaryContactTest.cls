@isTest
public class AddPrimaryContactTest {

    @testSetup 
    static void setup() {
        List<Account> accounts = new List<Account>();
        // add a parent account
        Account acc = new Account();
        acc.Name = 'Yipee';
        insert acc;

        Contact con = new Contact();
        con.LastName = 'test';
        con.AccountId = acc.Id;
        insert con;

        for (Integer i = 0; i < 50; i++) {
            Account acct = new Account();
            acct.Name = 'Test Account' + i;
            acct.BillingState = 'NY';
            acct.BillingStreet = 'qwerty' + i;
            accounts.add(acct);
        }

        for (Integer i = 0; i < 50; i++) {
            Account acct1 = new Account();
            acct1.Name = 'Test Account2' + i;
            acct1.BillingState = 'CA';
            acct1.BillingStreet = 'qawerty' + i;
            accounts.add(acct1);
        }

        insert accounts;
    }
    

    static testmethod void testQueueable() {
        
        Contact con = [SELECT Id, AccountId, LastName FROM Contact LIMIT 1];

        // Create our Queueable instance
        AddPrimaryContact updater = new AddPrimaryContact(con, 'CA');
        // startTest/stopTest block to force async processes to run
        Test.startTest();        
        System.enqueueJob(updater);
        Test.stopTest();        
    }    
}