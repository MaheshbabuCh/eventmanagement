public with sharing class EventSpeakerTriggerHandler {
    
    public static void validateDuplicateSpeaker(List<Event_Speaker__c> newSpeakers) {
        
            // Create a set to store speaker IDs being inserted or updated
        Set<Id> speakerIds = new Set<Id>();

        // Loop through the new Event-Speaker records and collect the Speaker IDs
        for (Event_Speaker__c es : newSpeakers) {
            // Ensure that Speaker__c is not null before adding to the set
            if (es.Speaker__c != null) {
                speakerIds.add(es.Speaker__c);
            }
        }

        // Proceed only if there are any speaker IDs to validate
        if (!speakerIds.isEmpty()) {
            // Query existing Event-Speaker records for the same speaker IDs
            List<Event_Speaker__c> existingBookings = [SELECT Id, Name, Speaker__c, Event__c
                                                    FROM Event_Speaker__c
                                                    WHERE Speaker__c IN :speakerIds
                                                    ];

            // Create a map to track which speakers already have events booked
            Map<Id, Id> speakerEventMap = new Map<Id, Id>();

            // Only populate the map if there are any existing bookings
            if (existingBookings != null && !existingBookings.isEmpty()) {
                for (Event_Speaker__c existingBooking : existingBookings) {
                    // Ensure that Speaker__c is not null to avoid null dereferencing
                    if (existingBooking.Speaker__c != null) {
                        speakerEventMap.put(existingBooking.Speaker__c, existingBooking.Event__c);
                    }
                }
            }

            // Loop through the new Event-Speaker records and check for duplicates
            for (Event_Speaker__c es : newSpeakers) {
                // Ensure that Speaker__c is not null before performing the duplicate check
                if (es.Speaker__c != null && speakerEventMap.containsKey(es.Speaker__c)) {
                    Event_Speaker__c eventSp = [SELECT Name, Event__c from Event_Speaker__c WHERE Event__c = :speakerEventMap.get(es.Speaker__c) LIMIT 1];
                    es.addError('This speaker is already booked for another event  : ' + eventSp.Name);
                }
            }
        }
    }
}