public class ContactSearch{
    public static List<Contact> searchForContacts(String lName, String pCode){
        List<Contact> cList = [SELECT Id, Name FROM CONTACT WHERE LastName =: lName AND MailingPostalCode =: pCode];
        return cList;
    }
}