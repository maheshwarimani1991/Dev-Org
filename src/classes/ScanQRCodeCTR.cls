public class ScanQRCodeCTR {
    public String productUINTemp {get; set;}
    public String productUINTemp1 {get; set;}
    public List<String> scanProdList {get; set;}
    
    public ScanQRCodeCTR(){
        scanProdList = new List<String>();
    }
    
    public PageReference SearchProduct() {
        scanProdList.add(productUINTemp);
        System.debug('-----------------------------'+ scanProdList);
        return null;
    }    
}