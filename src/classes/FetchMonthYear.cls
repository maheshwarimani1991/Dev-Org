global virtual class FetchMonthYear{

    private Settings__c a;
    private static Map<Integer,String> monthsMap;
    public List<Wrapper> wrapperList;
    
    public FetchMonthYear(){
        a =  Settings__c.getinstance('MyHierarchy');
        monthsMap = new Map<Integer ,String>{
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
        
                                        
        wrapperList = new List<Wrapper>();                  
        for(Integer i=0; i<=11; i++){
            wrapperList.add(
                        new Wrapper(a.CurrentFiscalYear__c.addMonths(i).month(), a.CurrentFiscalYear__c.addMonths(i).year())
                        );
        }
        system.debug('wrapperList is: '+wrapperList);
    } // END init()
    

    public class Wrapper {
        public String month {get;set;}
        public Integer year {get;set;}
    
        public Wrapper(Integer month, Integer year){
            this.month = monthsMap.get(month);
            this.year = year;
        } // END init(2 params ...)
    
     
    } // END Wrapper
}