public with sharing class RTSchedulerOpportunityCnt {
    public ApexPages.StandardSetController scon {get;private set;}
    private ApexPages.StandardSetController mycon;
    private static final String base_soql = 'Select Id, Name, StageName, AccountId From Opportunity';

    public RTSchedulerOpportunityCnt(ApexPages.StandardSetController controller) {
        scon = controller;
        isDesc = false;
        changeOrder();
    }

    public List<Opportunity> getRecords() {
        return mycon.getRecords();
    }

    public String orderBy {
        get;
        set {
            if (null == orderBy || orderBy != value) {
                orderBy = value;
                isDesc = false;
            } else {
                isDesc = !isDesc;
            }
        }
    }
    public Boolean isDesc {get;set;}
    public Pagereference changeOrder() {
        ApexPages.StandardSetController tmp = new ApexPages.StandardSetController(Database.getQueryLocator(base_soql));
        tmp.setFilterId(scon.getFilterId());
        List<ID> ids = new List<ID>();

        String soql = base_soql + ' Where Id in (\'\'';
        for (Opportunity i : (List<Opportunity>)tmp.getRecords()) {
            soql += ',\'' + i.Id + '\'';
        }
        soql += ')';
        if (null != orderBy) soql += ' Order by ' + orderBy + (isDesc ? ' DESC' : '');
        System.debug('=======================================SOQL:' + soql);

        mycon = new ApexPages.StandardSetController(Database.query(soql));

        return null;
    }
}