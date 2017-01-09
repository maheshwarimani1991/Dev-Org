public class QuotePDFContainerExtension
{
    public Id OppId {get;set;}
    public Opportunity opp {get;set;}
    public OpportunityLineItem FNGD{get;set;}
    public OpportunityContactRole oppCnctRole {get; set;}
    
    public QuotePDFContainerExtension(ApexPages.StandardController controller) 
    {
        OppId =  ApexPages.currentPage().getParameters().get('id');  
        opp = [SELECT Id, Name FROM Opportunity WHERE Id = :oppId LIMIT 1];
   }
    
    public void saveAttach()
    {
    }
}