public class opportunityctr {
    public string oppId;
    public Capability__c o;
    public blob b {get;set;}
    public String contentType {get; set;}

    public opportunityctr(ApexPages.StandardController controller) {
        o = (Capability__c)controller.getRecord();
    }
    
    public void saveopp(){
        Attachment a = new Attachment();
        a.body = b;
        a.ParentId = o.id;
        a.OwnerId = UserInfo.getUserId();
        a.contentType = contentType;
        a.name = 'test Attachment';
        insert a;
        System.debug('Attachment:::::::::::::'+contentType);
        System.debug('....................'+o);
        upsert o;
    }
}