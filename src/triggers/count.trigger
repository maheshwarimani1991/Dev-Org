trigger count on Opportunity (before update) {

    Map<Id, Opportunity> opportunityMap = new Map<Id,Opportunity>([Select Id From Opportunity WHERE id in :Trigger.newMap.keySet()]);
    
    Map<Id, List<OpportunityContactRole>> contactRoleMap = new Map<Id, List<OpportunityContactRole>>();
    
    List<OpportunityContactRole> contactRolesList = new List<OpportunityContactRole> ([SELECT Id, OpportunityId  from OpportunityContactRole  where OpportunityId in :Trigger.newMap.keySet()]);
    
    for(OpportunityContactRole EachOppRole: contactRolesList )                                                         // Iterate and poopulate the Map 
    {
           List<OpportunityContactRole> crList = contactRoleMap.get(EachOppRole.OpportunityId);
     
           if (crList == null) {
                crList = new List<OpportunityContactRole>();
                contactRoleMap.put(EachOppRole.OpportunityId, crList);
            }
    
        crList.add(EachOppRole);                                                                                               //populate the list by fetching value from the map 
    }
}