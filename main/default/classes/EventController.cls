public with sharing class EventController {
    @AuraEnabled(cacheable=true)
    public static List<Speaker__c> getSpeakers(Id eventId) {
        return [SELECT Name, Email__c, Phone__c, Company__c 
                FROM Speaker__c 
                WHERE Id IN (SELECT Speaker__c FROM Event_Speaker__c WHERE Event__c = :eventId)];
    }

    @AuraEnabled(cacheable=true)
    public static List<Attendees__c> getAttendees(Id eventId) {
        return [SELECT Name, Email__c, Phone__c, Company_Name__c 
                FROM Attendees__c 
                WHERE Id IN (SELECT Attendees__c FROM Event_Attendee__c WHERE Event__c = :eventId)];
    }

    @AuraEnabled(cacheable=true)
        public static List<Event__c> getLiveEvents() {
            return [
                SELECT Id, Name, Start_Date__c, End_Date__c, Location_Address_Book__r.Name, Remaining_Seats__c
                FROM Event__c
                WHERE Live__c = TRUE
                AND Start_Date__c >= TODAY
                ORDER BY Start_Date__c ASC
            ];
        }

}
