public class EditProductCTR {

    public EditProductCTR(ApexPages.StandardController controller) {
        
    }
    
    public PageReference redirect(){
        PageReference newocp = new PageReference('/'+ApexPages.currentPage().getParameters().get('id')+'/e');
        newocp.setRedirect(true);
        return newocp;
    }

}