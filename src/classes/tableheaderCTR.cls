public class tableheaderCTR {
    public List<Opportunity> olist {get; set;}
    public tableheaderCTR(){
        oList = new List<Opportunity>();
        oList = [select id,name,amount from Opportunity];
        
    
    
    }
}