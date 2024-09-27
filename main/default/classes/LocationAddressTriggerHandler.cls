/*public with sharing class LocationAddressTriggerHandler {
   
   // @future(callout=true)
    public static void validateAddress(List<ID> newIds) {

        
       List<Location_Address_Book__c> locationsToVerify = new List<Location_Address_Book__c>();
       
        // Query the Address records
        List<Location_Address_Book__c> newAddresses = [SELECT Id, Name, Street__c, City__c, State__c, Postal_Code__c, Country__c FROM Location_Address_Book__c WHERE Id IN :newIds];

            for (Location_Address_Book__c loc : newAddresses) {
                if (loc.Street__c != null && loc.City__c != null && loc.State__c != null && loc.Postal_Code__c != null) {
                    locationsToVerify.add(loc);
                }
            }

            // Call address verification for each location
            for (Location_Address_Book__c loc : locationsToVerify) {
                SmartAPIAddressValidation.verifyAddress(loc.Street__c, loc.City__c, loc.State__c, loc.Postal_Code__c, loc.Id);
            }

    }
}*/

public with sharing class LocationAddressTriggerHandler {
    // Static variable to prevent recursive trigger call
    public static Boolean isTriggerRecursive = false;

    public static void validateAddress(List<ID> newIds) {
        // Prevent recursive call to the future method
        if (!isTriggerRecursive) {
            isTriggerRecursive = true;

            List<Location_Address_Book__c> locationsToVerify = new List<Location_Address_Book__c>();
            // Query the Address records
            List<Location_Address_Book__c> newAddresses = [SELECT Id, Name, Street__c, City__c, State__c, Postal_Code__c, Country__c 
                                                           FROM Location_Address_Book__c WHERE Id IN :newIds];

            for (Location_Address_Book__c loc : newAddresses) {
                if (loc.Street__c != null && loc.City__c != null && loc.State__c != null && loc.Postal_Code__c != null) {
                    locationsToVerify.add(loc);
                }
            }

            // Call the future method to handle callout for each location
            for (Location_Address_Book__c loc : locationsToVerify) {
                // Invoke future method to make the callout
                SmartAPIAddressValidation.verifyAddress(loc.Street__c, loc.City__c, loc.State__c, loc.Postal_Code__c, loc.Id);
            }
        }
    }
}

