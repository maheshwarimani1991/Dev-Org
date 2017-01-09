@isTest
public class LeadProcessorTest{
     public static testMethod void testLeadProcessor() {
        List<Lead> ldList = new List<Lead>();
        
        for(integer i=0 ; i<200 ; i++){
            Lead ld = new Lead();
            ld.LastName = 'test' + i;
            ld.Company = 'test';
            ldList.add(ld);
        }
        
        insert ldlist;

       Test.startTest();
            LeadProcessor lpr = new LeadProcessor();
            Database.executeBatch(lpr);
        Test.stopTest();
        
    }    
}