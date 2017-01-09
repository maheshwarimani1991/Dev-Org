public class AddPrimaryContact implements Queueable {
    
    public Contact con;
    public String state;
    
    public AddPrimaryContact(Contact cn, String st) {
        con = cn;
        state = st;
    }

    public void execute(QueueableContext context) {
        List <Contact> conList = new List <Contact>();
        for (Account account : [SELECT Id FROM Account WHERE BillingState =: state LIMIT 200]) {
            Contact cntct = con.clone();
            cntct.AccountId = account.Id;
            conList.add(cntct);
        }
        
        if(conList.size() > 0)
            insert conList;
    }    
}