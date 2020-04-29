@isTest
private class BillingCalloutServiceTest {
    
    @testSetup
    static void testSetup(){
        
        ServiceCredentials__c credentials = new ServiceCredentials__c(
            Name = 'BillingServiceCredential',
            Password__c = 'Tsetpass',
            Username__c = 'TestUser'
        );
        insert credentials;
        
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
        
        Project__c prj = new Project__c(
            ProjectRef__c = 'Project',
            Name  = 'TestName',
            Opportunity__c = opp.Id,
            Start_Date__c = Date.today(),
            End_Date__c = Date.today().addDays(1),
            Billable_Amount__c = 12000,
            Status__c = 'Running'
        );
        insert prj;
    }
    @isTest
    static void failedTest(){
        List<Project__c> prjList = [SELECT Id,Status__c FROM Project__c WHERE Name = 'TestName'];
        for ( Project__c p : prjList ) {
            p.Status__c = 'Running';
        }
        
        Test.startTest();
        Test.setMock(WebServiceMock.class,new BillingCalloutServiceMockFailure());
        update prjList;
        Test.stopTest();
        
        prjList = [SELECT Status__c FROM Project__c WHERE Name = 'TestName'];
        system.assertEquals('Running', prjList[0].Status__c);
    }
    @isTest
    static void successTest(){
        List<Project__c> prjList = [SELECT Id,Status__c FROM Project__c WHERE Name = 'TestName'];
        for ( Project__c p : prjList ) {
            p.Status__c = 'Billable';
        }
        
        Test.startTest();
        Test.setMock(WebServiceMock.class,new BillingCalloutServiceMock());
        update prjList;
        Test.stopTest();
        
        prjList = [SELECT Status__c FROM Project__c WHERE Name = 'TestName'];
        system.assertEquals('Billable', prjList[0].Status__c);
    }
}