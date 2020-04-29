trigger ProjectTrigger on Project__c (after insert, after update) {
    
    if ( Trigger.isAfter ) {
        if ( Trigger.isInsert ) {
            Map<Id,Project__c> blankMap = new Map<Id,Project__c>();
            BillingCalloutService.callBillingService(Trigger.new,blankMap); 
        } else if ( Trigger.isUpdate ) {
            BillingCalloutService.callBillingService(Trigger.new,Trigger.oldMap); 
        }
    }  
    
}