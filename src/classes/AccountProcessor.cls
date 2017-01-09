/*
Test Comment Again
*/
public class AccountProcessor{
    @future
    public static void countContacts(List<Id> accIdList){
        List<Account> accList = new List<Account>();
        for(Account acc : [SELECT Id, Number_of_Contacts__c, (SELECT Id FROM Contacts) FROM Account WHERE Id IN: accIdList]){
            if(acc.Contacts != NULL)
                acc.Number_of_Contacts__c = acc.Contacts.size();
            accList.add(acc);
        }
        
        if(accList.size() > 0)
            update accList;
    }
}