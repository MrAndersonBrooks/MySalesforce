// This class can be safely deleted from your org. 
// It was only used to ensure 100% test coverage 
// for the managed package installation 

@IsTest
public class InstallationTests {
        
    @IsTest
    public static void testMaintenanceRequest(){
                List<Case> upsertList = new List<Case>();
        
        Case testCase1 = new Case(
            Type = 'Repair',
            Status = 'New',
            Origin = 'Phone',
            subject = 'TestCase1'
        );
        Case testCase2 = new Case(
            Type = 'Routine Maintenance',
            Status = 'New',
            Origin = 'Phone',
            subject = 'TestCase2'
        );
        Case testCase3 = new Case(
            Type = 'Mechanical',
            Status = 'New',
            Origin = 'Phone',
            subject = 'TestCase2'
        );
        upsertList.add(testCase1);
        upsertList.add(testCase2);
        upsertList.add(testCase3);
        
        insert upsertList;
        
        upsertList = new List<Case>();
        
        testCase1.Status = 'Closed';
        testCase2.Status = 'Closed';
        testCase3.Status = 'Closed';

        upsertList.add(testCase1);
        upsertList.add(testCase2);
        upsertList.add(testCase3);
        
        update upsertList;
    }
    
    @IsTest
    static void testWarehouseSync(){
        test.startTest();
        
        String jobId = System.schedule('ApexSpecialist','20 30 8 10 2 ?',new WarehouseSyncSchedule());
        
        test.stopTest();
    }
}