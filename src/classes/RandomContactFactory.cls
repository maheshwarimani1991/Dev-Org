public class RandomContactFactory{
    public static List<Contact> generateRandomContacts(Integer count, String lName){
        List<Contact> cList = new List<Contact>();
        for(Integer i = 1 ; i<=count ; i++){
            Contact c = new Contact();
            c.FirstName = 'Test'+i;
            c.LastName = lName;
            cList.add(c);
        }
        
        return cList;
    }
}