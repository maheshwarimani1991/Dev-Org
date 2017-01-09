public class Myextension{
    private final Account acct;
    public Myextension(ApexPages.StandardController controller){
        this.acct=(Account)controller.getRecord();
    }
    public String getTitle() {
        return 'Account: ' + acct.name + ' (' + acct.id +  ')' ;
    }
}