public class ProjectCalloutService {
    //Complete the implementation for business and callout logic
    @InvocableMethod(label='postOpportunityToPMS')
    public static void postOpportunityToPMS(List<Id> oppIds){
        system.debug(oppIds);
        
        List<Opportunity> records = [
            SELECT Id,Name,Account.Name,CloseDate,Amount,StageName
            FROM Opportunity
            WHERE Id IN :oppIds ];
        system.debug(records);
        QueueablePMSCall que = new QueueablePMSCall(records);
        Id jobId = system.enqueueJob(que);
        
    }
    private class QueueablePMSCall implements Queueable,Database.AllowsCallouts {
        
        private List<Opportunity> oppList;
        private String Token;
        
        public QueueablePMSCall(List<Opportunity> records){
            system.debug('koko');
            oppList = records;
            
            Token = [SELECT Id,Name,Token__c FROM ServiceTokens__c Where Name = 'ProjectServiceToken'].Token__c;
        }
        
        public void execute(QueueableContext context){
            
            
            Opportunity updateOpp = oppList[0];
            
            Http http = new Http();
            HttpRequest req = new HttpRequest();
            
            req.setEndpoint('callout:ProjectService');
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('token', Token);
            req.setBody(jsonSerialize(updateOpp));
            
            HttpResponse res = http.send(req);
            if ( res.getStatusCode() == 201 || res.getStatus() == 'OK' ) {
                updateOpp.StageName = 'Submitted Project';
            } else {
                updateOpp.StageName = 'Resubmit Project';
            }
            update updateOpp;
            
            
        }
        private String jsonSerialize(Opportunity opp){
            String json = '{';
            json += 'opportunityId' + opp.Id + ','
                	  + 'opportunityName' + opp.Name + ','
                      + 'accountName' + opp.Account.Name + ','
                      + 'closeDate' + opp.CloseDate + ','
                      + 'amount' + opp.Amount;
                json += '}';
            return json;
        }
    }
}