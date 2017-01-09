public class getUrlCtr {

    public PageReference geturl() {
        
        hostVal  = ApexPages.currentPage().getHeaders().get('Host');
        urlVal = Apexpages.currentPage().getUrl();
        URLL = 'https://' + hostVal+ urlVal;
        System.debug('HostVal : '+hostVal);
        System.debug('urlVal : '+urlVal);
        System.debug('URLL : '+URLL);
        return null;
    }

    public String hostVal{get; set;}
    public String urlVal{get; set;}
    public String URLL{get; set;}
    public void getUrlCtr(){
        System.debug('HostVal : ');
        hostVal  = ApexPages.currentPage().getHeaders().get('Host');
        urlVal = Apexpages.currentPage().getUrl();
        URLL = 'https://' + hostVal+ urlVal;
        System.debug('HostVal : '+hostVal);
        System.debug('urlVal : '+urlVal);
        System.debug('URLL : '+URLL);
        URLL = 'isajjdas';
    }
}