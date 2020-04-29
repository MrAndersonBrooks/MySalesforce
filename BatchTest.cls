global class BatchTest implements Database.Batchable<sObject>{
    
    String query;
    
    global BatchTest(String q){
        query = q;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }
    
    global void execute(Database.BatchableContext BC, List<sObject> sObjList){
        for ( sObject s : sObjList ) {
            system.debug(s);
        }
    }
    
    global void finish(Database.BatchableContext BC){
        system.debug('後処理をかく');
    }
}