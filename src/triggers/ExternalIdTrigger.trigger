trigger ExternalIdTrigger on Job_Application__c (before insert, before update) {
    for(Job_Application__c jApp : Trigger.New){
        jApp.mightymani__candidate__c = 'a0590000005HSKk';
        jApp.mightymani__position__r = new mightymani__position__c(mightymani__External_Id__c = '1234');
    }
}