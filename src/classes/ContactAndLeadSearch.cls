public class ContactAndLeadSearch{
    public static List<List< SObject>> searchContactsAndLeads(String Name){
        List<List<sObject>> searchList = [FIND :Name IN NAME FIELDS RETURNING Lead(FirstName, LastName),Contact(FirstName,LastName)];
        return searchList;
    }
}