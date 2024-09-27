/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an org are executed whenever Apex code is deployed
 * to a production org to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production org. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the org size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
public class EventAttendeeTriggerTest {

    // Use @TestSetup to create common test data
    @TestSetup
    static void setupTestData() {
        // Insert an Event record as test data for attendees
        Event__c eventRecord = new Event__c(
            Name = 'Test Event',
            Start_Date__c = Date.today(),
            End_Date__c = Date.today().addDays(10)  // End date must be after start date to avoid validation errors
        );
        insert eventRecord;

        // Insert an Attendee record as test data
        Attendees__c attendeeRecord = new Attendees__c(
            Name = 'Test Attendee',
            Email__c = 'test.attendee@example.com',
            Phone__c = '123-456-7890'
        );
        insert attendeeRecord;
    }

    @isTest
    static void testSendConfirmationEmail() {
        // Retrieve the test event and attendee created in @TestSetup
        Event__c testEvent = [SELECT Id FROM Event__c LIMIT 1];
        Attendees__c testAttendee = [SELECT Id FROM Attendees__c LIMIT 1];

        // Create a test Event Attendee (junction object)
        Event_Attendee__c eventAttendee = new Event_Attendee__c(
            Event__c = testEvent.Id,
            Attendees__c = testAttendee.Id
        );

        Test.startTest();
        
        // Insert the Event Attendee and invoke the trigger
        insert eventAttendee;
        
        Test.stopTest();

        // Add assertion to confirm attendee was created
        Event_Attendee__c insertedEventAttendee = [SELECT Id, Event__c, Attendees__c FROM Event_Attendee__c WHERE Id = :eventAttendee.Id LIMIT 1];
        System.assertEquals(testEvent.Id, insertedEventAttendee.Event__c, 'Event should be linked correctly');
        System.assertEquals(testAttendee.Id, insertedEventAttendee.Attendees__c, 'Attendee should be linked correctly');
        
        // You can add additional checks for email sending logic if applicable
    }

    @isTest
    static void testBulkSendConfirmationEmail() {
        // Retrieve the test event and attendee created in @TestSetup
        Event__c testEvent = [SELECT Id FROM Event__c LIMIT 1];
        Attendees__c testAttendee = [SELECT Id FROM Attendees__c LIMIT 1];

        List<Event_Attendee__c> eventAttendees = new List<Event_Attendee__c>();

        // Create multiple Event Attendee records for bulk insert
        for (Integer i = 0; i < 10; i++) {
            Event_Attendee__c eventAttendee = new Event_Attendee__c(
                Event__c = testEvent.Id,
                Attendees__c = testAttendee.Id
            );
            eventAttendees.add(eventAttendee);
        }

        Test.startTest();
        
        // Insert the list of event attendees (bulk insert)
        insert eventAttendees;
        
        Test.stopTest();

        // Add assertions to confirm bulk insert worked
        List<Event_Attendee__c> insertedEventAttendees = [SELECT Id, Event__c, Attendees__c FROM Event_Attendee__c WHERE Event__c = :testEvent.Id];
        System.assertEquals(10, insertedEventAttendees.size(), '10 event attendees should have been inserted');
    }
}
