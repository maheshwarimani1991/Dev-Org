public class NewCaseListController {

    public List<Case> getNewCases() {
        List<Case> cList = [SELECT Id, CaseNumber FROM CASE WHERE Status = 'New'];
        return cList;
    }

}