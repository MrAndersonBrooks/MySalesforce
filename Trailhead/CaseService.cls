public class CaseService {
    public static void closeCases(Set<Id> Ids, String closeReason){
        List<Case> casesToUpdate = [SELECT Status, Reason FROM Case WHERE Id in :Ids];
        
        for (Case c : casesToUpdate) {
            c.Status = 'Closed';
            c.Reason = closeReason;
        }
        
        update casesToUpdate ;
    }
}