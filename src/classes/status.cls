public class status{
private final Account applicant;
public Blob resume {get; set;}
public String contentType {get; set;}
public String fileName {get; set;}
public Attachment attach {get;set;}
public status(ApexPages.StandardController stdController) {
this.applicant=(Account)stdController.getRecord();
}
public void saveApplication() {

  if(resume!=null){
      attach=new Attachment();
      attach.Body=resume;
      attach.Name=filename;
      attach.ContentType=contentType;
      attach.ParentID=applicant.id;
     insert(attach);
      
  }
                 
}
}