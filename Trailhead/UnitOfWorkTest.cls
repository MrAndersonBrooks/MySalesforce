@isTest
public class UnitOfWorkTest {
    @IsTest
    static void challengeComplete() {
        fflib_SObjectUnitOfWork uow = new fflib_SObjectUnitOfWork(
            new Schema.SObjectType[]{
                Account.SObjectType,
                    Contact.SObjectType, 
                    Note.SObjectType});
        for (Integer i = 0; i < 100; i++) {
            Account acc = new Account(Name = 'TestAcc' + i);
            uow.registerNew(acc);
            for (Integer j = 0; j < 5; j++) {
                Contact c = new Contact(LastName = 'TestContact' + i + '_' + j);
                uow.registerNew(c, Contact.AccountId, acc);
                Note n = new Note(Title = 'TestNote' + i + '_' + j, Body = 'Test note body.');
                uow.registerNew(n, Note.ParentId, acc);
            }
        }
        uow.commitWork();
        System.assertEquals(100, [SELECT Id from Account].size());
        System.assertEquals(500, [SELECT Id from Contact].size());
        System.assertEquals(500, [SELECT Id From Note].size());
    }
}