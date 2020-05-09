public with sharing class myComponentController {
    @AuraEnabled(Cacheable=true)
    public static List<Test1__c> serachTestRecord( String serachWord ){
        serachWord = serachWord.trim();
        if ( serachWord == null ) {
            return [
                SELECT
                 Id,
                 Name,
                 Text__c,
                 CheckBox__c,
                 Datetime__c,
                 PickList__c
                FROM Test1__c
            ];
        }
        serachWord = '%' + serachWord + '%';
        return [
            SELECT
             Id,
             Name,
             Text__c,
             CheckBox__c,
             Datetime__c,
             PickList__c
            FROM Test1__c
            Where Text__c Like :serachWord
        ];
    }
}
