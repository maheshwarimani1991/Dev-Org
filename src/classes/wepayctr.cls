/**
* For the brave souls who get this far: You are the chosen ones,
* the valiant knights of programming who toil away, without rest,
* fixing our most awful code. To you, true saviors, kings of men,
* I say this: never gonna give you up, never gonna let you down,
* never gonna run around and desert you. Never gonna make you cry,
* never gonna say goodbye. Never gonna tell a lie and hurt you.
*/
public class wepayctr {
    public static String response{get;set;}
    public static Integer statuscode{get;set;}
    public static String statusmessage{get;set;}
    public static String response1{get;set;}
    public static Integer statuscode1{get;set;}
    public static String statusmessage1{get;set;} 
    
    public boolean show{get;set;}
    public boolean show2{get;set;}
    public String selected{get;set;}
    public String urll{get;set;}
    public String iframeurl{get;set;}
    public String iframeurl1{get;set;}
    
    // variable for subscription plans.
    public String planName {get; set;}
    public String planDesc {get; set;}
    public String Period {get; set;}
    public String Amount {get; set;}
    public boolean show1{get;set;}
    public List<SelectOption> options { get; set; }
    
    public wepayctr(){
        show = false;
        show1 = false;
        show2 = false;
        options = new List<SelectOption>();
        options.add(new SelectOption('948884847','Developer'));
        options.add(new SelectOption('747314787','Enterprize'));
        options.add(new SelectOption('1438708806','Unlimited'));
    }
    
    public void showcc(){
        show1 = true;
        show = false;
        show2 = false;
    }
    
    public void creditcard(){
        show = false;
        show2 = false;
        String url = 'https://stage.wepayapi.com/v2/subscription_plan/create?account_id=1029028608&name='+planName+'&short_description='+planDesc+'&period='+period+'&amount='+amount;                     //account?account_id=1029028608';
        
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('POST');
        req.setHeader('Authorization','BEARER STAGE_f746e3cee9753414a64d1af879c01b19853ef2914adbca4cc0d3de8c00608951');
        req.setTimeout(60*1000);
        
        HttpResponse res;
        res = h.send(req);
        response = res.getBody();
        statuscode = res.getStatusCode();
        statusmessage = res.getStatus();
        if(statuscode == 200){
            if (response != null && response != '') {
                JSONParser parser = JSON.createParser(response);
                while (parser.nextToken() != null) {
                    if((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'subscription_plan_id')) {
                        parser.nextValue();
                        options.add(new SelectOption(parser.getText(),planName));    
                    }
                }
            }
            planName = '';
            planName = '';
            amount = '';
            period = '';
            show1 = false;
        }
    }
    
    public void subscribe(){
        show = true;
        show1 = false;
        show2 = false;
        urll = 'https://stage.wepayapi.com/v2/subscription/create?subscription_plan_id='+selected+'&mode=iframe';                     
        
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(urll);
        req.setMethod('POST');
        req.setHeader('Authorization','BEARER STAGE_f746e3cee9753414a64d1af879c01b19853ef2914adbca4cc0d3de8c00608951');
        req.setTimeout(60*1000);
        
        HttpResponse res;
        res = h.send(req);
        response1 = res.getBody();
        statuscode1 = res.getStatusCode();
        statusmessage1 = res.getStatus();
        
        if (response1 != null && response1 != '') {
            JSONParser parser = JSON.createParser(response1);
            while (parser.nextToken() != null) {
                if((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'subscription_uri')) {
                    parser.nextValue();
                    iframeurl = parser.getText();
                }
            }
        }
    }
    
    public void singlepay(){
        show2 = true;
        String url1 = 'https://stage.wepayapi.com/v2/checkout/create?account_id=1029028608&short_description=testing&type=DONATION&amount=3.61&mode=iframe';                     
        
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url1);
        req.setMethod('POST');
        req.setHeader('Authorization','BEARER STAGE_f746e3cee9753414a64d1af879c01b19853ef2914adbca4cc0d3de8c00608951');
        req.setTimeout(60*1000);
        
        HttpResponse res;
        res = h.send(req);
        response1 = res.getBody();
        statuscode1 = res.getStatusCode();
        statusmessage1 = res.getStatus();
        
        if (response1 != null && response1 != '') {
            JSONParser parser = JSON.createParser(response1);
            while (parser.nextToken() != null) {
                if((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'checkout_uri')) {
                    parser.nextValue();
                    iframeurl1 = parser.getText();
                }
            }
        }
    }
}