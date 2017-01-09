public class UploadAttchCtr {

    public Attachment attachment {
        get;
        set;
    }
    public UploadAttchCtr() {
        attachment = new Attachment();
    }

    public void upload() {
        attachment.OwnerId = UserInfo.getUserId();
        attachment.ParentId = '0069000000BNuBc'; //specify the record ID;
        attachment.IsPrivate = true;
        
        try {
            insert attachment;
        } catch (DMLException e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR, 'Error uploading attachment'));
            //return null;
        }
        
        Document document = new Document();
        document.AuthorId = UserInfo.getUserId();
        document.FolderId = UserInfo.getUserId(); // put it in running user's folder
        document.Body = attachment.body;
        document.Name = attachment.Name;        
        try {
          insert document;
        } catch (DMLException e) {
          ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading file'));
        }
    }
}