public with sharing class RTSchedulerCnt {
    public String selectedType = null;
    public boolean isAccount{get;set;}
    public boolean isContact{get;set;}
    public boolean isOpps{get;set;}
    public Account searchAct{get;set;} public String testSearchActName{get;set;}
    public Contact searchCtc{get;set;} public String testSearchCtcName{get;set;}
    public Opportunity searchOpps{get;set;}

    public String SearchActQuery;
    public String SearchCtcQuery;
    public String SearchOppsQuery;
    
    public boolean isContactOwner{get;set;}
    public boolean isOppsOwner{get;set;}

    public RTSchedulerCnt(){
        isAccount = true;
        isContact = false;
        isOpps = false;
        
        selectedType = 'Account';
        initAccount();
        
        isContactOwner = true;
        isOppsOwner = true;
        
        searchAct = new Account();
    }

    // AccountList
    public void initAccount(){
        SearchActQuery = 'select Id, Name, Email__c, Type, Rating from Account order by type asc limit 25';
    }

    public List<Account> getAccountData(){
        List<Account> acdata = Database.query(SearchActQuery);
        return acdata;
    }

    // ContactList
    public void initContact(){
        SearchCtcQuery = 'select Id, Name, AccountId, LastActivityDate from Contact where OwnerId = \'' + UserInfo.getUserId() + '\' order by LastActivityDate asc limit 25';
    }

    public List<Contact> getContactData(){
        List<Contact> ctcdata = new List<Contact>();
        if(isContact){
            ctcdata = Database.query(SearchCtcQuery);
        }
        return ctcdata;
    }

    // OppsList
    public void initOpps(){
        SearchOppsQuery = 'select Id, Name, AccountId, LastActivityDate, StageName from Opportunity where OwnerId = \'' + UserInfo.getUserId() + '\' order by DateofLastVisit__c asc limit 25';
    }

    public List<Opportunity> getOppsData(){
        List<Opportunity> oppsdata = new List<Opportunity>();
        if(isOpps){
            oppsdata = Database.query(SearchOppsQuery);
        }
        return oppsdata;
    }

    // change type
    public List<SelectOption> getItems() {
        // get object label
        Schema.DescribeSObjectResult A = Account.SObjectType.getDescribe();
        String AccountLabel = A.getLabel();
        
        Schema.DescribeSObjectResult C = Contact.SObjectType.getDescribe();
        String ContactLabel = C.getLabel();
        
        Schema.DescribeSObjectResult O = Opportunity.SObjectType.getDescribe();
        String OppsLabel = O.getLabel();
        
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('Account', AccountLabel));
        options.add(new SelectOption('Contact', ContactLabel));
        options.add(new SelectOption('Opportunity', OppsLabel));

        return options;
    }

    public String getSelectedType() {
        return selectedType;
    }

    public void setSelectedType(String selectedType) {
        this.selectedType = selectedType;
    }

    public PageReference changeType() {
        if(selectedType == 'Account'){
            isAccount = true;
            isContact = false;
            isOpps = false;
        }
        if(selectedType == 'Contact'){
            isAccount = false;
            isContact = true;
            isOpps = false;
        }
        if(selectedType == 'Opportunity'){
            isAccount = false;
            isContact = false;
            isOpps = true;
        }
        
        initAccount();
        initContact();
        initOpps();
        
        searchAct = new Account();
        searchCtc = new Contact();
        searchOpps = new Opportunity();
        
        return null;
    }

    // 取引先の検索
    public Pagereference doAccountSearch(){
        Boolean isFirst = true;
        SearchActQuery = 'select Id, Name, Email__c, Type, Rating from Account';
        if(searchAct.Name != '' || searchAct.Email__c != NULL){
            SearchActQuery += ' Where';
            if(searchAct.Name != ''){
                SearchActQuery += ' Name like \'%' + searchAct.Name + '%\'';
                isFirst = false;
            }

            if(searchAct.Email__c != NULL){
                if(!isFirst){
                    SearchActQuery += ' AND';
                }
                SearchActQuery += ' Email__c = \'' + searchAct.Email__c + '\'';
                isFirst = false;
            }
        }
        SearchActQuery += ' order by Type asc limit 25';
        
        getAccountData();
        return null;
    }

    // 取引責任者の検索
    public Pagereference doContactSearch(){
        Boolean isFirst = true;
        SearchCtcQuery = 'select Id, Name, AccountId, LastActivityDate from Contact';
            if(isContactOwner != true){
                if(searchCtc.Name != '' || testSearchActName != ''){
                    String Name = searchCtc.Name != '' ? searchCtc.Name : testSearchActName;
                    SearchCtcQuery += ' Where Name like \'%' + Name + '%\'';
                    isFirst = false;
                }
            } else {
                SearchCtcQuery += ' Where';
                if(searchCtc.Name != ''){
                    SearchCtcQuery += ' Name like \'%' + searchCtc.Name + '%\'';
                    isFirst = false;
                }
    
                if(isContactOwner == true){
                    if(!isFirst){
                        SearchCtcQuery += ' AND';
                    }
                    SearchCtcQuery += ' OwnerId = \'' + UserInfo.getUserId() + '\'';
                    isFirst = false;
                }
            }
            SearchCtcQuery += ' order by LastActivityDate asc limit 25';
            
        getContactData();
        return null;
    }

    // 商談の検索
    public Pagereference doOppsSearch(){
       Boolean isFirst = true;
       SearchOppsQuery = 'select Id, Name, AccountId, LastActivityDate, StageName from Opportunity';
            if(isOppsOwner != true){       
                if(searchOpps.Name != '' || testSearchCtcName != ''){
                    String Name = searchOpps.Name != '' ? searchOpps.Name : testSearchCtcName;
                    SearchOppsQuery += ' Where Name like \'%' + Name + '%\'';
                    isFirst = false;
                }
            } else {
                SearchOppsQuery += ' Where';
                if(searchOpps.Name != ''){
                    SearchOppsQuery += ' Name like \'%' + searchOpps.Name + '%\'';
                    isFirst = false;
                }
                if(isOppsOwner == true){
                    if(!isFirst){
                        SearchOppsQuery += ' AND';
                    }
                    SearchOppsQuery += ' OwnerId = \'' + UserInfo.getUserId() + '\'';
                    isFirst = false;
                }
            }
            SearchOppsQuery += ' order by Type asc limit 25';
            
        getOppsData();
        return null;
    }

    // test
    private static TestMethod void testSchedulerCnt(){
        RTSchedulerCnt sc = new RTSchedulerCnt();
        Boolean TestisAccount = sc.isAccount;
        Boolean TestisContact = sc.isContact;
        Boolean TestisOpps = sc.isOpps;
        
        sc.initAccount();
        sc.getAccountData();
        sc.initContact();
        sc.getContactData();
        sc.initOpps();
        sc.getOppsData();
        sc.getItems();
        String testST = sc.getSelectedType();
        sc.setSelectedType(testST);

        sc.selectedType = 'Contact';
        sc.changeType();
        sc.selectedType = 'Opportunity';
        sc.changeType();

        sc.searchAct.email__c = 'maheshwarimani1991@gmail.com';
        sc.doAccountSearch();

        sc.doContactSearch();
        sc.isContactOwner = false;
        sc.testSearchActName = 'test';
        sc.doContactSearch();

        sc.doOppsSearch();
        sc.isOppsOwner = false;
        sc.testSearchCtcName = 'test';
        sc.doOppsSearch();
        // sc.getMyEventsData();
        // sc.deleteEvent();
        // sc.updateEvent();
        // sc.addEvent();
        // sc.getEvent();
        //sc.escapeJsonValue();
        
        RTSchedulerCnt sc2 = new RTSchedulerCnt();
        sc2.isAccount = false;
        sc2.isContact = true;
        sc2.isOpps = true;
        
        sc2.initAccount();
        sc2.getAccountData();
        sc2.initContact();
        sc2.getContactData();
        sc2.initOpps();
        sc2.getOppsData();
        sc2.getItems();
        String testST2 = sc2.getSelectedType();
        sc2.setSelectedType(testST2);
        sc2.changeType();
        sc2.doAccountSearch();
        sc2.doContactSearch();
        sc2.doOppsSearch();
        // sc2.getMyEventsData();
        // sc2.deleteEvent();
        // sc2.updateEvent();
        // sc2.addEvent();
        // sc2.getEvent();
        //sc2.escapeJsonValue();
    }
}