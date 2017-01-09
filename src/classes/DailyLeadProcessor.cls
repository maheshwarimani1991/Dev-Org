global class DailyLeadProcessor implements Schedulable {

    global void execute(SchedulableContext ctx) {
        List<Lead> ldlist = new List<Lead>();
        for(Lead ld : [SELECT Id, LeadSource FROM Lead WHERE LeadSource = '' LIMIT 200]){
            ld.LeadSource = 'Dreamforce';
            ldlist.add(ld);
        }
        
        if(ldlist.size() > 0)
            update ldlist;
    }    
}