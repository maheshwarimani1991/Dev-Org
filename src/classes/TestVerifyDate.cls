@isTest
public class TestVerifyDate{
    @isTest public static void TestVerifyDate() {
     
         Date d = System.today();
         Date d1 = System.today().addDays(10);
         Date d2 = VerifyDate.CheckDates(d, d1);
         
         d1 = System.today().addDays(40);
         d2 = VerifyDate.CheckDates(d, d1);
         
         d1 = System.today().addDays(-10);
         d2 = VerifyDate.CheckDates(d, d1);
         
     }
}