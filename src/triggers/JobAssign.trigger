trigger JobAssign on NewObject__c (after update) {
    for(NewObject__c p : Trigger.new){
        if(p.join__c<>null){
        String aa = p.join__c;
        Capability__c c = [Select Applied__c, Name from Capability__c where Name =: aa];
        c.Applied__c = p.Id;
        update c;
        }    
    }       
}