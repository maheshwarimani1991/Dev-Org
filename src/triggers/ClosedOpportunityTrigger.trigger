trigger ClosedOpportunityTrigger on Opportunity (after insert, before update) {
    List<Task> tskList = new List<Task>();
    for(Opportunity opp : Trigger.New){
        if(opp.StageName == 'Closed Won'){
            Task tsk = new Task();
            tsk.Subject = 'Follow Up Test Task';
            tsk.WhatId = opp.Id;
            tskList.add(tsk);
        }
    }
    
    if(tskList.size() > 0)
        insert tskList;
}