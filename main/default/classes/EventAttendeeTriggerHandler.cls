public with sharing class EventAttendeeTriggerHandler {

    // Method to handle bulk email sending
    public static void sendConfirmationEmails(List<Event_Attendee__c> newlyInsertedAttendees) {
        // Collect emails to send
        List<Messaging.SingleEmailMessage> emailsToSend = new List<Messaging.SingleEmailMessage>();

        // Collect Event and Attendee IDs for querying related data
        Set<Id> eventIds = new Set<Id>();
        Set<Id> attendeeIds = new Set<Id>();

        // Loop through newlyInsertedAttendees to collect Event and Attendee IDs
        for (Event_Attendee__c attendee : newlyInsertedAttendees) {
            if (attendee.Event__c != null) {
                eventIds.add(attendee.Event__c);
            }
            if (attendee.Attendees__c != null) {
                attendeeIds.add(attendee.Attendees__c);
            }
        }

        // Query related Event details
        Map<Id, Event__c> eventMap = new Map<Id, Event__c>([SELECT Name, Start_Date__c, 
                                                             Location_Address_Book__r.Street__c, 
                                                             Location_Address_Book__r.City__c, 
                                                             Location_Address_Book__r.State__c, 
                                                             Location_Address_Book__r.Country__c, 
                                                             Event_Organizer__r.Name 
                                                             FROM Event__c WHERE Id IN :eventIds]);

        // Query related Attendee details
        Map<Id, Attendees__c> attendeeMap = new Map<Id, Attendees__c>([SELECT Name, Email__c, Phone__c 
                                                                     FROM Attendees__c 
                                                                     WHERE Id IN :attendeeIds]);

        // Loop through newlyInsertedAttendees and prepare email content
        for (Event_Attendee__c attendee : newlyInsertedAttendees) {
            try {
                // Check if Event and Attendee records exist in the maps
                if (eventMap.containsKey(attendee.Event__c) && attendeeMap.containsKey(attendee.Attendees__c)) {
                    Event__c eventDetail = eventMap.get(attendee.Event__c);
                    Attendees__c attendeeDetail = attendeeMap.get(attendee.Attendees__c);

                    // Create email message
                    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                    email.setToAddresses(new String[]{attendeeDetail.Email__c});
                    email.setSubject('Pass for the "' + eventDetail.Name + '"');

                    // Build the email body
                    String emailBody = 'Dear ' + attendeeDetail.Name + ',\n\n';
                    emailBody += 'Thank you for registering for "' + eventDetail.Name + '" which will be organized on ' + 
                                 eventDetail.Start_Date__c.format() + ' & will be held in ' + eventDetail.Location_Address_Book__r.Street__c + 
                                 ', ' + eventDetail.Location_Address_Book__r.City__c + ', ' + eventDetail.Location_Address_Book__r.State__c + 
                                 ', ' + eventDetail.Location_Address_Book__r.Country__c + '.\n\n';
                    emailBody += 'We are excited to have you, see you at the event.\n\n';
                    emailBody += 'Find the Google Map Location for the Event Here: ';
                    emailBody += 'https://www.google.com/maps/place/' + eventDetail.Location_Address_Book__r.Street__c + 
                                 ', ' + eventDetail.Location_Address_Book__r.City__c + ', ' + eventDetail.Location_Address_Book__r.State__c + 
                                 ', ' + eventDetail.Location_Address_Book__r.Country__c + '\n\n';
                    emailBody += 'Thanks,\n' + eventDetail.Event_Organizer__r.Name;

                    email.setPlainTextBody(emailBody);
                    emailsToSend.add(email);
                }
            } catch (Exception e) {
                // Handle any exceptions, log them to an Error Log if necessary
                System.debug('Error sending email: ' + e.getMessage());
            }
        }

        // Send emails in bulk
        if (!emailsToSend.isEmpty()) {
            Messaging.sendEmail(emailsToSend);
        }
    }
}


/*public with sharing class EventAttendeeTriggerHandler {

    // Method to handle bulk email sending
    public static void sendConfirmationEmails(List<Event_Attendee__c> attendees) {
        // Collect emails to send
        List<Messaging.SingleEmailMessage> emailsToSend = new List<Messaging.SingleEmailMessage>();

        // Bulk Query to fetch related event details in one query
        Set<Id> eventIds = new Set<Id>();
        for (Event_Attendee__c attendee : attendees) {
            if (attendee.Event__c != null) {
                eventIds.add(attendee.Event__c);
            }
        }

        // Query the event details for the related Event IDs
        Map<Id, Event__c> eventMap = new Map<Id, Event__c>([SELECT Name, Start_Date__c, Location_Address_Book__r.Street__c, 
                                                             Location_Address_Book__r.City__c, Location_Address_Book__r.State__c, 
                                                             Location_Address_Book__r.Country__c, Event_Organizer__r.Name 
                                                             FROM Event__c WHERE Id IN :eventIds]);

        // Loop through attendees and prepare email content
        for (Event_Attendee__c attendee : attendees) {
            try {
                if (eventMap.containsKey(attendee.Event__c)) {
                    Event__c eventDetail = eventMap.get(attendee.Event__c);

                    // Create email message
                    Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                    email.setToAddresses(new String[]{attendee.Attendees__c.Email__c});
                    email.setSubject('Pass for the "' + eventDetail.Name + '"');

                    // Build the email body
                    String emailBody = 'Dear ' + attendee.Name + ',\n\n';
                    emailBody += 'Thank you for registering for "' + eventDetail.Name + '" which will be organized on ' + 
                                 eventDetail.Start_Date__c.format() + ' & will be held in ' + eventDetail.Location_Address_Book__r.Street__c + 
                                 ', ' + eventDetail.Location_Address_Book__r.City__c + ', ' + eventDetail.Location_Address_Book__r.State__c + 
                                 ', ' + eventDetail.Location_Address_Book__r.Country__c + '.\n\n';
                    emailBody += 'We are excited to have you, see you at the event.\n\n';
                    emailBody += 'Find the Google Map Location for the Event Here: ';
                    emailBody += 'https://www.google.com/maps/place/' + eventDetail.Location_Address_Book__r.Street__c + 
                                 ', ' + eventDetail.Location_Address_Book__r.City__c + ', ' + eventDetail.Location_Address_Book__r.State__c + 
                                 ', ' + eventDetail.Location_Address_Book__r.Country__c + '\n\n';
                    emailBody += 'Thanks,\n' + eventDetail.Event_Organizer__r.Name;
                    
                    email.setPlainTextBody(emailBody);
                    emailsToSend.add(email);
                }
            } catch (Exception e) {
                // Handle any exceptions, log them to an Error Log if necessary
                System.debug('Error sending email: ' + e.getMessage());
            }
        }
        
        // Send emails in bulk
        if (!emailsToSend.isEmpty()) {
            Messaging.sendEmail(emailsToSend);
        }
    }
}
    */