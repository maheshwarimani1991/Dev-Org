public class MyController{

    public String getAccount() {
        return null;
    }

    public Id selectedAccount { get; set; }
    public List<Contact> contactsInformation { get; set; }
    //public String getMyaccounts() {
       public List<Account> getMyAccounts() {
            return [SELECT Id, Name, AccountNumber FROM Account ORDER BY LastModifiedDate DESC LIMIT 10];
       }
     //  return null;
    //}

}