public with sharing class AttachPDFTerryTest {
 
    public Account accountItem{get;set;}
    public string idVal{get;set;}
    public string doSave{get;set;}
       
    public AttachPDFTerryTest(ApexPages.StandardController stdController){
         
        idVal = ApexPages.currentPage().getParameters().get('id');
        doSave = ApexPages.currentPage().getParameters().get('doSave');
        accountItem = [Select ID, Name From Account where ID = :idVal];       
    }
     
    public pageReference savePDF(){
         
      if(doSave == 'No'){
        return null;
      }
         
      PageReference pagePdf = new PageReference('/apex/AttachPDFTerryTest');
          pagePdf.getParameters().put('id', idVal);
          pagePdf.getParameters().put('doSave', 'No');
          Blob pdfPageBlob;
          pdfPageBlob = pagePdf.getContentAsPDF();
                 
          Attachment a = new Attachment();
          a.Body = pdfPageBlob;
          a.ParentID = idVal;
          a.Name = 'TerryTestAttach1.pdf';
          a.Description = 'TestDescription1';
          insert a;
      return null;
      //return new PageReference('/' + idVal);
    }
}