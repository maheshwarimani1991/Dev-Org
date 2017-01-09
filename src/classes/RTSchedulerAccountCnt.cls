public with sharing class RTSchedulerAccountCnt {
    public ApexPages.StandardSetController scon {get;private set;}
    private ApexPages.StandardSetController mycon;
    private static final String base_soql = 'Select Id, Name, Type, Email__c From Account';

    public RTSchedulerAccountCnt(ApexPages.StandardSetController controller) {
        scon = controller;
        isDesc = false;
        changeOrder();
    }

    public List<Account> getRecords() {
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
        for (Account i : (List<Account>)tmp.getRecords()) {
            soql += ',\'' + i.Id + '\'';
        }
        soql += ')';
        if (null != orderBy) soql += ' Order by ' + orderBy + (isDesc ? ' DESC' : '');
        System.debug('=======================================SOQL:' + soql);

        mycon = new ApexPages.StandardSetController(Database.query(soql));

        return null;
    }
}