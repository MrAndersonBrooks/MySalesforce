public with sharing class WarehouseCalloutService {
    
    private static final String WAREHOUSE_URL = 'https://th-superbadge-apex.herokuapp.com/equipment';
    
    @future(callout=true)
    public static void runWarehouseEquipmentSync() {
        try{
            HTTP http = new HTTP();
            HttpRequest req = new HttpRequest();
            
            req.setEndpoint(WAREHOUSE_URL);
            req.setMethod('GET');
            
            HttpResponse res = http.send(req);
            
            if ( res.getStatusCode() == 200 ) {
                List<Object> results = (List<Object>) JSON.deserializeUntyped(res.getBody());
                List<Product2> upsertList = new List<Product2>();
                for ( Object obj : results ) {
                    Map<String,Object> rec = (Map<String,Object>)obj;
                    
                    Product2 pd = new Product2(
                        Name = (String)rec.get('name'),
                        Replacement_Part__c = true,
                        Cost__c = (Decimal)rec.get('cost'),
                        Current_Inventory__c = (Decimal)rec.get('quantity'),
                        Lifespan_Months__c = (Decimal)rec.get('lifespan'),
                        Maintenance_Cycle__c = (Decimal) rec.get('maintenanceperiod'),
                        Warehouse_SKU__c = (String)rec.get('sku')
                    );
                    upsertList.add(pd);
                }
                upsert upsertList Warehouse_SKU__c;
            }
        } catch (Exception e) {
            system.debug(e.getMessage());
        } 
    }
}