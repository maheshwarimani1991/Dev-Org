/* ********************************************
Git - This code changes everything you open it.
Happy Debugging...!!!!!
******************************************** */
public class AccountHandler{
    public static Account insertNewAccount(String Name){
        Account acc = new Account();
        acc.Name = Name;
        try{
            insert acc;
            return acc;
        }catch(Exception ex){
            return null;
        }
    }
}