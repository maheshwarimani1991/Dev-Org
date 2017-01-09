public class updateOppCtr {
    public List<Opportunity> oppList {get; set;}
    public String accId {get; set;}

    public updateOppCtr(ApexPages.StandardController controller) {
        accId = ApexPages.currentPage().getParameters().get('id');
        
        oppList = [SELECT Id, Name, CloseDate, ExpectedRevenue, Amount FROM Opportunity WHERE AccountId =: accId];
    }

}