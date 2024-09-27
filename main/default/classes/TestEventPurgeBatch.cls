@isTest
public class TestEventPurgeBatch {

    // Test Setup to create test data
    @testSetup
    static void setup() {
        List<Event__c> eventList = new List<Event__c>();
        
        // Creating 199 event records with a mix of past and future events
        for (Integer i = 0; i < 199; i++) {
            Event__c evt = new Event__c();
            evt.Name = 'Test Event ' + i;
            evt.End_Date__c = (i < 100) ? Date.today().addMonths(-3) : Date.today().addDays(10); // 100 events older than 2 months
            evt.Live__c = (i < 100); // First 100 events marked as 'Live'
            eventList.add(evt);
        }
        
        insert eventList;
    }

    // Main test method to verify batch execution
    @isTest
    static void testBatchExecution() {
        Test.startTest();
        
        // Create the batch instance and execute it with a batch size of 50
        EventPurgeBatch batchInstance = new EventPurgeBatch();
        Database.executeBatch(batchInstance, 50);
        
        Test.stopTest();
        
        // Assert: Only 99 events (live and future) should remain after batch execution
        Integer remainingEvents = [SELECT COUNT() FROM Event__c];
        System.assertEquals(99, remainingEvents, 'Only 99 events should remain after batch execution');
        
        // Assert: Verify that all non-live, old events have been deleted
        Integer deletedOldEvents = [SELECT COUNT() FROM Event__c WHERE End_Date__c <= :Date.today().addMonths(-2) AND Live__c = true];
        System.assertEquals(0, deletedOldEvents, 'All old, live events should have been purged.');
    }

    // Test to verify email sending from the finish method of the batch
    @isTest
    static void testEmailInFinish() {
        Test.startTest();

        // Create the batch instance and execute it
        EventPurgeBatch batchInstance = new EventPurgeBatch();
        Database.executeBatch(batchInstance, 50);

        Test.stopTest();

        // Verify that the email has been sent
        List<EmailMessage> emails = [SELECT Id, Subject, ToAddress FROM EmailMessage];
        System.assertEquals(1, emails.size(), 'One email should be sent after batch execution');
        System.assert(emails[0].ToAddress.contains('maheshbabucherukuri1997@gmail.com'), 'Email should be sent to the correct address');
    }
}