trigger ExternalIdTrigger1 on Opportunity (before insert, before update) {
    for(Opportunity opp : Trigger.New){
        opp.Account = new Account(mightymani__ID__c = '12321');
    }
}