@IsTest
private class WarehouseCalloutServiceTest {
    @isTest
    static void testGetCallout(){
        WarehouseCalloutServiceMock mock = new WarehouseCalloutServiceMock();
        
        Test.setMock(HttpCalloutMock.class,mock);
        
        WarehouseCalloutService.runWarehouseEquipmentSync();
    }

}