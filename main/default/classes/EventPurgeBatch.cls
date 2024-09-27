public with sharing class EventPurgeBatch implements Database.Batchable<SObject>, Database.Stateful {
    
    // Query to retrieve events that are more than 2 months old and have been organized
    public Database.QueryLocator start(Database.BatchableContext bc) {
        String query = 'SELECT Id, Name FROM Event__c WHERE End_Date__c <= LAST_N_DAYS:60 AND Live__c = true';
        return Database.getQueryLocator(query);
    }

    // Execute method to delete events in batches
    public void execute(Database.BatchableContext bc, List<Event__c> eventsToPurge) {
        try {
            if (!eventsToPurge.isEmpty()) {
                // Delete the old events
                delete eventsToPurge;
                System.debug('Deleted Succeessfully');
            }
        } catch (Exception e) {
            // Handle exception if needed (e.g., logging)
            System.debug('Error during event deletion: ' + e.getMessage());
        }
    }

    // Finish method to send email notification after the batch execution
    public void finish(Database.BatchableContext bc) {
        // Send email notification after batch completion
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setToAddresses(new String[] { 'maheshbabucherukuri1997@gmail.com' });
        email.setSubject('Event Purge Batch Execution Completed - Deleting Completed older events');
        email.setPlainTextBody('The batch process to delete old events which are older than 2 months has been completed successfully.');
        
         Messaging.SendEmailResult[] results = Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
        
                if (results[0].success) {
                    System.debug('The email was sent successfully.');
                } else {
                    System.debug('The email failed to send: '
                        + results[0].errors[0].message);
                }
    }
}
