public with sharing class attendeeEventsController {

    @AuraEnabled(cacheable=true)
    public static List<Event__c> getAttendeeUpcomingEvents(Id attendeeId) {
        // Query to get the events the attendee has registered for
        return [
            SELECT Id, Name, Start_Date__c, End_Date__c, Location_Address_Book__r.Name
            FROM Event__c
            WHERE Id IN (
                SELECT Event__c 
                FROM Event_Attendee__c 
                WHERE Attendees__c = :attendeeId
            )
            AND Start_Date__c > TODAY
            ORDER BY Start_Date__c ASC
        ];
    }

    @AuraEnabled(cacheable=true)
    public static List<Event__c> getAttendeePastEvents(Id attendeeId) {
        return [
            SELECT Id, Name, Start_Date__c, End_Date__c, Location_Address_Book__r.Name
            FROM Event__c
            WHERE Id IN (
                SELECT Event__c 
                FROM Event_Attendee__c 
                WHERE Attendees__c = :attendeeId
            )
            AND End_Date__c < TODAY
            ORDER BY End_Date__c DESC
        ];
    }
}
