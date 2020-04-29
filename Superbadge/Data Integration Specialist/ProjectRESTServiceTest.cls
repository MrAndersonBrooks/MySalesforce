@isTest
private class ProjectRESTServiceTest {
    @isTest
    static void postProjectData(){
        Account acc = new Account(Name = 'test');
        insert acc;
        
        Opportunity opp = new Opportunity(
            AccountId = acc.Id,
            Name = 'TestOpp',
            CloseDate = Date.today(),
            Type = 'New Project',
            StageName = 'Prospecting',
            Amount = 120000
        );
        insert opp;
        
        String ProjectRef = 'Project';
        String Name  = 'TestName';
        String Opportunity = opp.Id;
        Date Start_Date = Date.today();
        Date End_Date = Date.today().addDays(1);
        Double Billable_Amount = 12000;
        String Status = 'Running';   
        
        RestRequest req = new RestRequest();
        req.httpMethod = 'POST';
        req.requestURI = '/services/apexrest/project';
        
        RestContext.request = req;
        
        Test.startTest();
        String responseSuccess = ProjectRESTService.postProjectData(ProjectRef,Name,Opportunity,Start_Date,End_Date,Billable_Amount,Status);
        String responseFailed = ProjectRESTService.postProjectData(ProjectRef,Name,acc.Id,Start_Date,End_Date,Billable_Amount,Status);
        Test.stopTest();
        
        
    }    
}