public with sharing class MaintenanceRequestHelper {
    
    public static void updateWorkOrders(List<Case> newList) {
        
        List<Case> insertCases = new List<Case>();
        
        for ( Case c : newList ) {
            if ( c.IsClosed == true && ( c.Type == 'Repair' || c.Type == 'Routine Maintenance' ) ) {
                system.debug(c);
                Case insertCase = c.clone(false,true,false,false);
                insertCase.Status = 'New';

                insertCases.add(insertCase);
            }
        }
        insert insertCases;
    }        
    
}