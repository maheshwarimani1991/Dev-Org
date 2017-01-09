trigger TaskTest on Task (after insert) { 
    Set<ID> whoIdSet = new Set<ID>(); 
    for(Task e: trigger.new){ 
        if(e.whoId != null){
            whoIdSet.add(e.WhoId); 
        } 
    }
    
    //Get contacts
    Map<ID, Contact> contactMap = new Map<ID, Contact>([select email_date__c,task_Date__c from contact where id in :whoIdSet]); 
    //update task date value 
    List<Contact> updContactList = new List<Contact>(); 
    for(Task e: trigger.new){
        if(e.whoId != null && contactMap.containsKey(e.whoId)){
            Contact c1 = contactMap.get(e.whoId); 
            //create date from datetime 
            if(e.ActivityDate != NULL){
                Date d1 = Date.newInstance( e.ActivityDate.year(), e.activitydate.month(), e.activitydate.day()); 
                if(e.Type != 'Email')
                    c1.Task_Date__c = d1;    
                else
                    c1.Email_Date__c = d1;  
            }
            updContactList.add(c1); 
        } 
    }
    if(updContactList.size()>0){
        update updContactList; 
    }
}