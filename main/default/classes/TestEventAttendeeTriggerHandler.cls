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
public class TestEventAttendeeTriggerHandler {

    @TestSetup
    static void setupTestData() {
        // Create Event Organizer
        Event_Organizer__c organizer = new Event_Organizer__c(Name='John Doe', Email__c='john.doe@example.com');
        insert organizer;

        // Create Location
        Location_Address_Book__c location = new Location_Address_Book__c(Street__c='123 Main St', City__c='Metropolis', State__c='NY', Country__c='USA');
        insert location;

        // Create Event
        Event__c event = new Event__c(Name='Test Event', Start_Date__c=Date.today().addDays(5), Event_Organizer__c=organizer.Id, Location_Address_Book__c=location.Id);
        insert event;

        // Create Attendee
        Attendees__c attendee = new Attendees__c(Name='Jane Doe', Email__c='jane.doe@example.com', Phone__c='1234567890');
        insert attendee;
    }

    @isTest
    static void testSendConfirmationEmails() {
        // Fetch test data
        Event__c event = [SELECT Id FROM Event__c LIMIT 1];
        Attendees__c attendee = [SELECT Id FROM Attendees__c LIMIT 1];

        // Create Event Attendee Record
        Event_Attendee__c eventAttendee = new Event_Attendee__c(Event__c=event.Id, Attendees__c=attendee.Id);
        
        Test.startTest();
        insert eventAttendee;
        Test.stopTest();

        // Retrieve the sent emails using Messaging.getSentEmailMessages()
        List<Messaging.SingleEmailMessage> sentEmails = Messaging.getSentEmailMessages();
        System.assertEquals(1, sentEmails.size(), 'An email should have been sent.');

        // Further assert email content if necessary
        Messaging.SingleEmailMessage email = sentEmails[0];
        System.assertEquals('Pass for the "Test Event"', email.getSubject(), 'Subject should match.');
        System.assert(email.getPlainTextBody().contains('Dear Jane Doe,'), 'Email body should contain attendee name.');
    }

    @isTest
    static void testNegativeCase_NoEmailSent() {
        // Create Event without attendees to test negative case
        Event__c event = [SELECT Id FROM Event__c LIMIT 1];

        // Create Event Attendee with null attendee reference
        Event_Attendee__c eventAttendee = new Event_Attendee__c(Event__c=event.Id, Attendees__c=null);
        
        Test.startTest();
        insert eventAttendee;
        Test.stopTest();

        // Retrieve the sent emails using Messaging.getSentEmailMessages()
        List<Messaging.SingleEmailMessage> sentEmails = Messaging.getSentEmailMessages();
        System.assertEquals(0, sentEmails.size(), 'No email should be sent if attendee details are missing.');
    }
}
