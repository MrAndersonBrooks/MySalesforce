@isTest
private class ProjectCalloutServiceTest {
    @testSetup
    static void SetupRecord(){
        ServiceTokens__c token = new ServiceTokens__c();
        token.Name = 'ProjectServiceToken';
        token.Token__c = 'TestToken';
        insert token;
        
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
    }
    @isTest
    static void testFailure(){
        system.debug( [SELECT Id,StageName FROM Opportunity WHERE Name = 'TestOpp']);
        List<Opportunity> opps  = [SELECT Id,StageName FROM Opportunity WHERE Name = 'TestOpp'];
        for (Opportunity opp : opps){
            opp.StageName = 'Closed Won';
        } 
        system.debug(opps);
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMockFailure());
        update opps;
        Test.stopTest();
        
        opps = [SELECT Id,StageName FROM Opportunity WHERE Name = 'TestOpp'];
        system.assertEquals('Resubmit Project', opps[0].StageName);
    }
    @isTest
    static void testCorrect(){
        List<Opportunity> opps  = [SELECT Id,StageName FROM Opportunity WHERE Name = 'TestOpp'];
        for (Opportunity opp : opps){
            opp.StageName = 'Closed Won';
        } 
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMock());
        update opps;
        Test.stopTest();
        
        opps = [SELECT Id,StageName FROM Opportunity WHERE Name = 'TestOpp'];
        system.assertEquals('Submitted Project', opps[0].StageName);
    }
    
    
    
}