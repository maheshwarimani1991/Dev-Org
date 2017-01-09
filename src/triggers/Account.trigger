/**
 * Account
 * @description A description of the Trigger 
 */

trigger Account on Account (after delete, after insert, after undelete, after update, before delete, before insert, before update) {
    AccountTriggerHandler handler = new AccountTriggerHandler(Trigger.isExecuting, Trigger.size);
    
    if(Trigger.isUpdate && Trigger.isBefore){
        AccountTriggerHandler1.OnBeforeUpdate(Trigger.old, Trigger.new, Trigger.oldMap);
    }
}