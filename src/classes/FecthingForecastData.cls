public class FecthingForecastData extends FetchMonthYear{
    
    //private List<UserRole> userRoles = new List<UserRole>();
    public List<User> users {get;set;}
    public List<Forecast__c> acts;
    public List<Forecast__c> addForcst{get;set;}
    public Integer index {get;set;}
    public String CurrentYear {get;set;}
    public String NextYear {get;set;}
    public Integer curMonth {get;set;}
    public ForecastType__c ftype {get;set;}
    public Map<String,Forecast__c> fMap;
    public String rId;
    public String FiscalYear{get;set;}
    public List<ForecestQuaterlyWrapper> fwqList{get;set;}
    public Map<Integer,String> mnameMap; 
    public String SubordinateName{get;set;}
    public User us {get;set;}
    
    public List<SelectOption> getitems() {
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('--NONE--','--NONE--'));
        for(User u : users){
            options.add(new SelectOption(u.name,u.name));
        }
        return options;
    }
        
    public FecthingForecastData(){
        rId = '';
        mnameMap = new Map<Integer ,String>{
                                            1 => 'January',
                                            2 => 'February',
                                            3 => 'March',
                                            4 => 'April',
                                            5 => 'May',
                                            6 => 'June',
                                            7 => 'July',
                                            8 => 'August',
                                            9 => 'September',
                                            10 => 'October',
                                            11 => 'November',
                                            12 => 'December'
                                             
                                        };
        fwqList = new List<ForecestQuaterlyWrapper>();
        addForcst = new List<Forecast__c>();
        fMap = new Map<String,Forecast__c>();
        currentYear = String.ValueOf(System.today().year());
        NextYear = String.ValueOf(System.today().addYears(1).year());
        curMonth = System.today().month();
        users = new ManagerUtility().findUserRoleHierarchy(UserInfo.getUserId());
        ftype = [select Forecast_Type__c from ForecastType__c limit 1];
        
        if(ftype.forecast_type__c == 'Monthly')
            rId = '012900000015LhO';                                  //dynamic
        else if(ftype.forecast_type__c == 'Weekly')
            rId = '012900000015LiC';                                  //dynamic
        
        us = [select id,name,FullPhotoUrl from User where id =: UserInfo.getUserId()];
        acts =  [SELECT name,Day__c,Month__c,Original_Forecast__c,Overridden_Value__c,Override_Amount__c,Quota__c,User__c,User__r.name, Year__c FROM Forecast__c where User__c =:UserInfo.getUserId() AND recordTypeId =: rID]; 
        for(Forecast__c f : acts){
            String ss = f.Month__c +'-'+ f.Year__c;
            fMap.put(ss,f);
        }
    }
    
    public void removeForecast(){
        addForcst.remove(index);
    }
    
    public void addForecast(){
        Forecast__c f = new Forecast__c();
        f.User__c = UserInfo.getUserId();
        addForcst.add(f);
    }
    
    public PageReference updateList(){
        for(Forecast__c f : addForcst){
            if(ftype.forecast_type__c == 'Monthly')
                f.recordtypeId = '012900000015LhO';                              //dynamic
            else if(ftype.forecast_type__c == 'Weekly')
                f.recordtypeId = '012900000015LiC';                              //dynamic
            
            if((f.Month__c == null && f.Day__c == null) || f.Year__c == null || f.Original_Forecast__c == null || f.Quota__c== null){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Month,Quota,Original Forecast and Year are required fields for forecast. Please enter their value.');
                ApexPages.addMessage(myMsg);
                return null;
            }
            
            if(f.Original_Forecast__c < 1 || f.Quota__c < 0){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Negative values are not allowed.Please enter a correct value.');
                ApexPages.addMessage(myMsg);
                return null;
            }
            
            Integer month = 0;
            if(f.Month__c == 'January')
                month = 1;
            else if(f.Month__c == 'February')
                month = 2;
            else if(f.Month__c == 'March')
                month = 3;
            else if(f.Month__c == 'April')
                month = 4;
            else if(f.Month__c == 'May')
                month = 5;
            else if(f.Month__c == 'June')
                month = 6;
            else if(f.Month__c == 'July')
                month = 7;
            else if(f.Month__c == 'August')
                month = 8;
            else if(f.Month__c == 'September')
                month = 9;
            else if(f.Month__c == 'October')
                month = 10;
            else if(f.Month__c == 'November')
                month = 11;
            else if(f.Month__c == 'December')
                month = 12;
            
            ApexPages.Message myMsg;
            System.debug('myMsg::::::'+myMsg);
            
            if((ftype.Forecast_Type__c == 'Monthly') && ((f.Year__c == CurrentYear && month < system.today().month()) || (f.Year__c == NextYear && month > system.today().month()) || (f.Year__c <> NextYear && f.Year__c <> CurrentYear))){
                myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Can Only add Forecast for current year cycle');
                ApexPages.addMessage(myMsg);
                return null;
            }
            
            String s = '';
            if(f.recordtypeId == '012900000015LhO')
                s = f.Month__c +'-'+ f.Year__c;
            else if(f.recordtypeId == '012900000015LiC')
                s = f.Day__c +'-'+ f.Year__c;
            
            System.debug('Map is :::::::::::::::::::::::'+fMap);
            if(fMap.get(s) != NULL){
                myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Forecast for the current Month/Day already exists.');
                ApexPages.addMessage(myMsg);
                return null;
            }
        }
        
        for(forecast__c f : acts){
            Pattern isnumbers = Pattern.Compile('^[0-9]+$');
            Matcher postalMatch = isnumbers.matcher(f.Year__c);
            Boolean result = postalMatch.Matches();
            if(result == false){
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'.Please enter a numeric value for year.');
                ApexPages.addMessage(myMsg);
                return null;
            }
        }
        upsert addForcst;
        update acts;
        update ftype;
        PageReference newocp = new PageReference('/apex/enterForecast');
        newocp.setRedirect(true);
        return newocp;
    }
    
    public PageReference cancelList() {
        PageReference newocp = new PageReference('/apex/enterForecast');
        newocp.setRedirect(true);
        return newocp;
    }
    
    
    public void changetype(){
    
        if(ftype.forecast_type__c == 'Monthly')
            rId = '012900000015LhO';                                  //dynamic
        else if(ftype.forecast_type__c == 'Weekly')
            rId = '012900000015LiC';                                  //dynamic
        /*else if(ftype.forecast_type__c == 'Quaterly'){
            FiscalYear = 'May';
            integer mnumber = getMonth(FiscalYear);
                    
            for(integer i = 1;i<=4;i++){
                List<String> cqmList = new List<String>();
                List<String> cqyList = new List<String>();
                cqmList.add(mnameMap.get(mnumber));
                mnumber=mnumber+1;
                if(mnumber>12)
                    mnumber = 1;
                cqmList.add(mnameMap.get(mnumber));
                mnumber=mnumber+1;
                if(mnumber>12)
                    mnumber = 1;
                cqmList.add(mnameMap.get(mnumber));
                mnumber=mnumber+1;
                cqylist.add('2014');
                if(mnumber < getMonth(FiscalYear))
                    cqyList.add('2015');
                System.debug('cqmList========='+cqmList);
                System.debug('cqyList~~~~~~~~~'+cqyList);
                acts =  [SELECT name,Day__c,Month__c,recordtypeId,Original_Forecast__c,Overridden_Value__c,Override_Amount__c,Quota__c,User__c,User__r.name, Year__c FROM Forecast__c where User__c =:UserInfo.getUserId() AND Month__c IN: cqmList AND Year__c  IN: cqyList];        
                ForecestQuaterlyWrapper frc = new ForecestQuaterlyWrapper(acts,100);
                fwqList.add(frc);
            }
        }*/
        
        //System.debug('::::::::::::'+acts);
        //System.debug('FWQLIST::::::::::::'+fwqList);
        acts =  [SELECT name,Day__c,Month__c,recordtypeId,Original_Forecast__c,Overridden_Value__c,Override_Amount__c,Quota__c,User__c,User__r.name, Year__c FROM Forecast__c where User__c =:UserInfo.getUserId() AND recordtypeId =: rId];
        for(Forecast__c f : acts){
            String ss = '';
            if(f.recordtypeId == '012900000015LhO')
                ss = f.Month__c +'-'+ f.Year__c;
            else if(f.recordtypeId == '012900000015LiC')
                ss = f.Day__c +'-'+ f.Year__c;
            fMap.put(ss,f);
        }
    }
    
    public void doNothing(){}
    
    public List<Forecast__c> getacts(){
            return acts;
    }
    
    public class ForecestQuaterlyWrapper{
        public Integer QuaterlySum {get;set;}
        public List<Forecast__c> fqList {get;set;}
        
        ForecestQuaterlyWrapper(List<Forecast__c> fw,integer Sum){
            this.QuaterlySum = Sum;
            this.fqList = fw;
        }
    }
    
    public Integer getMonth(String mname){
        Integer month = 0;
        if(mname == 'January'){
            month = 1;
        }else if(mname == 'February'){
            month = 2;
        }else if(mname == 'March'){
            month = 3;
        }else if(mname == 'April'){
            month = 4;
        }else if(mname == 'May'){
            month = 5;
        }else if(mname == 'June'){
            month = 6;
        }else if(mname == 'July'){
            month = 7;
        }else if(mname == 'August'){
            month = 8;
        }else if(mname == 'September'){
            month = 9;
        }else if(mname == 'October'){
            month = 10;
        }else if(mname == 'November'){
            month = 11;
        }else if(mname == 'December'){
            month = 12;
        }
        return month;
    }
}