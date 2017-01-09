/* ***********************************************************************************
Name        : FileDocumentCtr
Function    : To display data of All Chatter Files
Author      : Himanshu Maheshwari (Astrea IT Services)
Created On  : 28-02-2014
*********************************************************************************** */
public class FileDocumentCtr {

    public List<ContentDocument> dList{get;set;}
    public Map<Id,Integer> countMap{get;set;} 
    public Map<Id,Integer> sizeMap{get;set;}
    private String sortDirection = 'ASC';
    private String sortExp = 'title';
    
    public List<ContentDocument> getcdoc() {
        return dList;
    }
    
    public String sortExpression{
        get
        {
            return sortExp;
        }
        set
        {
            if (value == sortExp)
                sortDirection = (sortDirection == 'ASC')? 'DESC' : 'ASC';
            else
                sortDirection = 'ASC';
            sortExp = value;
        }
    }
   
    public String getSortDirection(){
        if (sortExpression == null || sortExpression == '')
            return 'ASC';
        else
            return sortDirection;
    }

    public void setSortDirection(String value){  
        sortDirection = value;
    }
       
    public PageReference Files(){
        dList = new List<ContentDocument>();
        countMap = new Map<Id,Integer>();
        sizeMap = new Map<Id,Integer>();
        
        string sortFullExp = sortExpression  + ' ' + sortDirection;
    
        dList = Database.query('Select Id,Title,OwnerId from ContentDocument order by ' + sortFullExp);
        //dList = [Select Id,Title,OwnerId from ContentDocument order by ' + sortFullExp];
        for(ContentVersion cv : [Select id,ContentSize,ContentDocumentId from ContentVersion where ContentDocumentId IN: dList]){
            if(countMap.get(cv.ContentDocumentId) != null){
                Integer count = countMap.get(cv.ContentDocumentId) + 1;
                Integer size = sizeMap.get(cv.ContentDocumentId) + cv.ContentSize/1024; 
                countMap.put(cv.ContentDocumentId,count);
                sizeMap.put(cv.ContentDocumentId,size);
            }    
            else{
                countMap.put(cv.ContentDocumentId,1);    
                sizeMap.put(cv.ContentDocumentId,cv.ContentSize/1024);
            }
        }
        //return dList;
        return null;
    } 
}