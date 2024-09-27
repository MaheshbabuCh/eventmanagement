public class ErrorLogHandler {

    /**
     * Inserts an Error Log record with the provided details.
     * @param logDateTime The DateTime when the error occurred.
     * @param logDetails The complete stack trace or error message.
     * @param processName The name of the Apex class or trigger where the error occurred.
     */
    public static void insertErrorLog(DateTime logDateTime, String logDetails, String processName) {
        try {
            // Create a new Error Log record
            Error_Log__c errorLog = new Error_Log__c();
            
            // Set the fields with the provided parameters
            errorLog.Log_Date_Time__c = logDateTime;
            errorLog.Log_Details__c = logDetails;
            errorLog.Process_Name__c = processName;
            
            // Insert the Error Log record
            insert errorLog;
        } catch (Exception e) {
            // Optionally, handle exceptions that occur during the insertion
            System.debug('Error while inserting Error Log: ' + e.getMessage());
        }
    }
}


