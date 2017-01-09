@isTest
public class TestRestrictContactByName{
     @isTest public static void TestRestrictContactByName() {
     
         Contact c = new Contact();
         c.LastName = 'INVALIDNAME';
         try{
             insert c;
        }catch(Exception ex){}     
     }
}