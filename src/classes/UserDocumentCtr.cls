/* ***********************************************************************************
Name        : UserDocumentCtr
Function    : To display Chatter File data for users
Author      : Himanshu Maheshwari (Astrea IT Services)
Created On  : 24-02-2014
************************************************************************************ */
public with sharing class UserDocumentCtr {

    public Map<String,List<ContentDocument>> cMap{get;set;}
    public Map<String,String>nMap{get;set;}
    public Map<String,Integer>ccountMap{get;set;}
    public Map<String,Integer>csizeMap{get;set;}
    public Map<String,String>cidMap{get;set;}
    public List<String> uID{get;set;}
    
    private String sortDirection = 'ASC';
    private String sortExp = 'owner.name';
    
    public String sortExpression{
        get{
            return sortExp;
        }
        set{
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
    
    public PageReference Users(){
        cMap = new Map<String,List<ContentDocument>>();
        nMap = new Map<String,String>();
        ccountMap = new Map<String,Integer>();
        csizeMap = new Map<String,Integer>();
        cidMap = new Map<String,String>(); 
        uId = new List<String>();
        
        string sortFullExp = sortExpression  + ' ' + sortDirection;
        
        for(ContentDocument u : Database.query('select id,Title,PublishStatus,LatestPublishedVersionId,ownerid,owner.name from ContentDocument order by ' + sortFullExp)){
            List < ContentDocument > dummyList = cMap.get(u.ownerid)!=null?cMap.get(u.ownerid):new List < ContentDocument > ();
            dummyList.add(u);
            cidMap.put(u.id,u.ownerid);  
            
            cMap.put(u.ownerid,dummyList);
            integer count = dummyList.size();
            ccountMap.put(u.ownerid,count);
            if(!(nMap.containsKey(u.ownerid)))
                uId.add(u.ownerid);  
            nMap.put(u.ownerid,u.owner.name);
        }
        
        for(ContentVersion cv : [select id,ContentDocumentId,Checksum,Title,VersionNumber,PathOnClient,ContentSize,ContentUrl,FileType from ContentVersion  where ContentDocumentId IN: cidMap.keyset()]){
            
            if(csizeMap.get(cidMap.get(cv.ContentDocumentId)) != null){
                Integer total = csizeMap.get(cidMap.get(cv.ContentDocumentId)) + cv.ContentSize/1024;
                csizeMap.put(cidMap.get(cv.ContentDocumentId),total);
            }
            else{
                csizeMap.put(cidMap.get(cv.ContentDocumentId),cv.ContentSize/1024);
            }
        }
        return null;
    }
    
    public PageReference mapsort(){  
        Map<Integer,List<String>>revMap = new Map<Integer,List<String>>();
        List<String> cdocList = new List<String>();
        List<Integer> sList = new List<Integer>();
        
        for(String cid : csizeMap.keySet()){
            if(revMap.containsKey(csizeMap.get(cid)))
                cdocList = revMap.get(csizeMap.get(cid));
            else
                cdocList = new List<String>();
            cdocList.add(cid);
            if(!revMap.containsKey(csizeMap.get(cid)))
                sList.add(csizeMap.get(cid));
            revMap.put(csizeMap.get(cid),cdocList);
        }
        sList.sort();
        if(sortDirection == 'DESC'){
            for(integer i = 0; i < sList.size()/2 ; i++){
                integer si = sList[i];
                sList[i] = sList[sList.size()-i-1];
                sList[sList.size()-i-1] = si;
            }
        }
        uId = new List<String>();
        for(Integer size : sList){
            uId.addAll(revMap.get(size));
        }
        return null;
    }
}