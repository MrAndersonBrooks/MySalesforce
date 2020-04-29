@RestResource(urlMapping='/project/*')
global class ProjectRESTService {
    @HttpPost
    global static String postProjectData(String ProjectRef,String ProjectName,String OpportunityId,Date StartDate,Date EndDate,Double Amount,String Status){
        
        SavePoint sp = Database.setSavepoint();
        try {
            Project__c project = new Project__c(
                ProjectRef__c = ProjectRef,
                Name  = ProjectName,
                Opportunity__c = OpportunityId,
                Start_Date__c = StartDate,
                End_Date__c = EndDate,
                Billable_Amount__c = Amount,
                Status__c = Status
            );
            upsert project;
            
            Opportunity opp = new Opportunity(
                Id =  OpportunityId,
                DeliveryInstallationStatus__c = 'In progress'
            );
            update opp;
            
            return 'OK';
            
        } catch (exception e)  {
            Database.rollback(sp);
            return e.getMessage();
        }
        
    }
}