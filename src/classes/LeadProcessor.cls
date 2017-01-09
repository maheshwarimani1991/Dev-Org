global class LeadProcessor implements Database.Batchable<sObject>{
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            'SELECT ID, LeadSource FROM LEAD'
        );
    }

    global void execute(Database.BatchableContext bc, List<lead> scope){
        List<Lead> ldList = new List<Lead>();
        for (Lead ld : scope) {
            ld.LeadSource = 'Dreamforce';
            ldList.add(ld);
        }
        if(ldList.size() > 0)
            update ldList;
    }    

    global void finish(Database.BatchableContext bc){
       
    }    

}