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
public class TestEventSpeakerTriggerHandler {

    @TestSetup
    static void setupTestData() {
        // Create a test Event
        Event__c testEvent = new Event__c(Name = 'Test Event', Start_Date__c = Date.today().addDays(5)); 
        insert testEvent;

        // Create a Speaker
        Speaker__c speaker = new Speaker__c(Name = 'John Doe');
        insert speaker;

        // Create an Event-Speaker record (to test against duplicate)
        Event_Speaker__c existingBooking = new Event_Speaker__c(Event__c = testEvent.Id, Speaker__c = speaker.Id);
        insert existingBooking;
    }

    @isTest
    static void testDuplicateSpeakerError() {
        // Fetch the test event and speaker
        Event__c testEvent = [SELECT Id FROM Event__c LIMIT 1];
        Speaker__c speaker = [SELECT Id FROM Speaker__c LIMIT 1];

        // Create another Event-Speaker record for the same speaker (to trigger the error)
        Event_Speaker__c newBooking = new Event_Speaker__c(Event__c = testEvent.Id, Speaker__c = speaker.Id);

        Test.startTest();
        try {
            insert newBooking;
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('This speaker is already booked for another event'), 'Duplicate speaker error should be thrown.');
        }
        Test.stopTest();
    }
}
