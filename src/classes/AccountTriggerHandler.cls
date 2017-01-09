/**
 * TriggerName
 * @description A description of the Trigger
 */

public with sharing class AccountTriggerHandler {
    private boolean m_isExecuting = false;
    private integer BatchSize = 0;

    public AccountTriggerHandler(boolean isExecuting, integer size) {
        m_isExecuting = isExecuting;
        BatchSize = size;
    }

    public void OnBeforeInsert() {

    }

    public void OnAfterInsert() {

    }

    public void OnBeforeUpdate(Account[] oldsObject, Account[] updatedsObjects, Map<ID, Account> sObjectMap) {
        //Example Map usage
        Map<ID, Account> contacts = new Map<ID, Account>( [select Id, Name from Account where Id IN :sObjectMap.keySet()] );

        for(Account acc : updatedsObjects){
            acc.AnnualRevenue = 100000000;
        }
    }

    public void OnAfterUpdate() {

    }

    public void OnBeforeDelete() {

    }

    public void OnAfterDelete() {

    }

    public void OnUndelete() {

    }

    public boolean IsTriggerContext {
        get{ return m_isExecuting;}
    }

    public boolean IsVisualforcePageContext {
        get{ return !IsTriggerContext;}
    }

    public boolean IsWebServiceContext {
        get{ return !IsTriggerContext;}
    }

    public boolean IsExecuteAnonymousContext {
        get{ return !IsTriggerContext;}
    }
}