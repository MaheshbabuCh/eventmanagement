public with sharing class BatchHandler {
    
    // Method to start the batch job
    public static void executeEventPurgeBatch() {
        Database.executeBatch(new EventPurgeBatch(), 200);  // Process in batches of 200
    }
}

// call BatchHandler.executeEventPurgeBatch();