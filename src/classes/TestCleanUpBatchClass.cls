@isTest
private class TestCleanUpBatchClass{
    static testmethod void test(){
        String query='SELECT Id,CreateDate FROM Merchandise__c'+'WHERE Id NOT IN(SELECT Merchandise__c FROM Line_Item__c)';
        Merchandise__c[] ml=new List<Merchandise__c>();
        for(Integer i=0;i<10;i++){
            Merchandise__c m = new Merchandise__c(Name='Merchandise'+i,Description__c='Some Desciption',Price__c=2,Total_Inventory__c=1000);
            ml.add(m);
        }
        insert(ml);
        Test.startTest();
        CleanUpRecords c=new CleanUpRecords(query);
        Database.executeBatch(c);
        Test.stopTest();
        Integer i=[SELECT COUNT() FROM Merchandise__c];
        System.assertEquals(i,0);
    }
}