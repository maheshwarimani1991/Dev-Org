public class VisualRelationshipController {
    public String json { get ; set; }
    public Account a{get; set;}
    public VisualRelationshipController(ApexPages.StandardController controller) {
        a=  (Account)controller.getRecord();
        json= getjson(); 
        getRelation('Account')  ;    
    }
    public List<Schema.ChildRelationship> getRelation(){return null;}
    public List<Schema.ChildRelationship> getRelation( String obj){
        
        Schema.SObjectType sobj = Schema.getGlobalDescribe().get(obj);
        Schema.DescribeSObjectResult R = sobj.getDescribe();
        List<Schema.ChildRelationship> c = R.getChildRelationships();
        for(Schema.ChildRelationship child : R.getChildRelationships()){
            getchildJSone(String.valueOf(child.getChildSObject()),String.valueOf(child.getField()));
        }
        return c;
    }
    public void getchildJSone(String s,String fields) {
        System.debug('--------------'+s+'----'+fields);
        String query = 'select name from '+s+' where '+fields+' =\''+a.id+'\'';
        System.debug('query----------'+query);  
          
    }
    public String getjson(){
        a= [select name,(select name from Contacts),(select id from Cases) from Account where id=:a.id] ;
        
        String s = '"nodes":[';
        s+='{"nodeName":"'+a.Name+'", "group":1},';
         Integer counter =1;
        for(Contact c:a.contacts){
            s+='{"nodeName":"'+c.Name+'", "group":2}'; 
            if(counter < a.contacts.size() || a.cases.size() >0)
                s+=',';
            counter++;
        } 
        counter =1;
        for(case c:a.cases){
            s+='{"nodeName":"'+c.id+'", "group":3}'; 
            if(counter < a.cases.size())
                s+=',';
            counter++;
        }     
        s+='],"links":[';
        
        counter =1;
        for(Contact c:a.contacts) {
            s+='{"source":'+counter+', "target":0, "value":5}';
            if(counter < a.contacts.size() || a.cases.size() >0)
                s+=',';
            counter++;
        }
        counter =1;
        for(case c:a.cases){
            s+='{"source":'+(a.contacts.size()+counter)+', "target":0, "value":5}';
            if(counter < a.cases.size())
                s+=',';
            counter++;
        }
        s+=']';
        return s;   
    }

}