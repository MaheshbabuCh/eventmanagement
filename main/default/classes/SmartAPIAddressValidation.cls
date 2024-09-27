/*public with sharing class SmartAPIAddressValidation {
   
        // Get credentials from metadata
      public static Smart_API_Setting__mdt apiSettings = Smart_API_Setting__mdt.getInstance('Zipcode_API');
    
    // Method to verify the address using the SmartyStreets API
   
    public static void verifyAddress(String street, String city, String state, String zipCode, Id locationId) {
        try {
            // Construct the API URL
            // https://us-zipcode.api.smartystreets.com/lookup?auth-id=6a9990b1-ff54-dc86-8bbf-4d973b7f1883&auth-token=uStt7tVGW8w3U5OoeIBC
            //https://us-zipcode.api.smartystreets.com/lookup?auth-id=6a9990b1-ff54-dc86-8bbf-4d973b7f1883
            // &auth-token=uStt7tVGW8w3U5OoeIBC&zipcode=12401&city=Kingston&state=New York
            String endpoint = 'https://us-zipcode.api.smartystreets.com/lookup';
            endpoint += '?auth-id=' + apiSettings.Auth_ID__c;
            endpoint += '&auth-token=' + apiSettings.Auth_token__c;
            endpoint += '&street=' + EncodingUtil.urlEncode(street, 'UTF-8');
            endpoint += '&city=' + EncodingUtil.urlEncode(city, 'UTF-8');
            endpoint += '&state=' + EncodingUtil.urlEncode(state, 'UTF-8');
            endpoint += '&zipcode=' + EncodingUtil.urlEncode(zipCode, 'UTF-8');

            // Create the HTTP request
            HttpRequest req = new HttpRequest();
            req.setEndpoint(endpoint);
            req.setMethod('GET');

            // Send the HTTP request and get the response
            Http http = new Http();
            HttpResponse res = http.send(req);

            // Parse the response
            if (res.getStatusCode() == 200) {
                // Success: Parse the response and update the location record
                List<Object> jsonResponse = (List<Object>) JSON.deserializeUntyped(res.getBody());

                if (!jsonResponse.isEmpty()) {
                    // Address verified
                    updateLocationVerified(locationId, true);
                    System.debug('Location verification Done: ' + true);
                } else {
                    // No valid address found
                    updateLocationVerified(locationId, true);
                    System.debug('Location verification not done: ' + false + jsonResponse);
                    ErrorLogHandler.insertErrorLog(datetime.now(), 'Location verification Done: ' + false, 'SmartAPIAddressValidation');
                }
            } else {
                // Log errors in the response
                System.debug('Error: ' + res.getBody());
                ErrorLogHandler.insertErrorLog(datetime.now(), res.getBody(), 'SmartAPIAddressValidation');
                updateLocationVerified(locationId, false);
            }
        } catch (Exception e) {
            // Handle callout exceptions
            System.debug('Callout failed: ' + e.getMessage());
            ErrorLogHandler.insertErrorLog(datetime.now(), e.getMessage(), 'SmartAPIAddressValidation');
            updateLocationVerified(locationId, false);
        }
    }

    // Helper method to update the Location Verified field
    private static void updateLocationVerified(Id locationId, Boolean isVerified) {
        Location_Address_Book__c loc = new Location_Address_Book__c(Id = locationId, Verified__c = isVerified);
        loc.Landmark__c = 'test landmark';
        
        update loc;
        System.debug('Location verification Done: ' + isVerified);
    }

    }

*/

/*

public with sharing class SmartAPIAddressValidation {
    // @future(callout=true)
    // public static void doFuture(String street, String city, String state, String zipCode, Id locationId) {
    //     // Compare with snippet from ./force-app/main/default/classes/SmartAPIAddressValidation.cls
    //     verifyAddress(street, city, state, zipCode, locationId);
    // }
   
    // Get credentials from metadata
    public static Smart_API_Setting__mdt apiSettings = Smart_API_Setting__mdt.getInstance('Zipcode_API');
    
    // Method to verify the address using the SmartyStreets API
   @Future(callout=true)
    public static void verifyAddress(String street, String city, String state, String zipCode, Id locationId) {
        try {
            // Construct the API URL
            String endpoint = 'https://us-zipcode.api.smartystreets.com/lookup';
            endpoint += '?auth-id=' + apiSettings.Auth_ID__c;
            endpoint += '&auth-token=' + apiSettings.Auth_token__c;
            endpoint += '&street=' + EncodingUtil.urlEncode(street, 'UTF-8');
            endpoint += '&city=' + EncodingUtil.urlEncode(city, 'UTF-8');
            endpoint += '&state=' + EncodingUtil.urlEncode(state, 'UTF-8');
            endpoint += '&zipcode=' + EncodingUtil.urlEncode(zipCode, 'UTF-8');

            // Create the HTTP request
            HttpRequest req = new HttpRequest();
            req.setEndpoint(endpoint);
            req.setMethod('GET');

            // Send the HTTP request and get the response
            Http http = new Http();
            HttpResponse res = http.send(req);

            // Parse the response
            if (res.getStatusCode() == 200) {
                // Success: Parse the response and update the location record
                List<Object> jsonResponse = (List<Object>) JSON.deserializeUntyped(res.getBody());

                if (!jsonResponse.isEmpty()) {
                    // Address verified
                    updateLocationVerified(locationId, true);
                    System.debug('Location verification Done: ' + true);
                } else {
                    // No valid address found
                    updateLocationVerified(locationId, true);
                    System.debug('Location verification not done: ' + false + jsonResponse);
                    ErrorLogHandler.insertErrorLog(datetime.now(), 'Location verification Done: ' + false, 'SmartAPIAddressValidation');
                }
            } else {
                // Log errors in the response
                System.debug('Error: ' + res.getBody());
                ErrorLogHandler.insertErrorLog(datetime.now(), res.getBody() + ' ' + res.getStatusCode(), 'SmartAPIAddressValidation');
                updateLocationVerified(locationId, false);
            }
        } catch (Exception e) {
            // Handle callout exceptions
            System.debug('Callout failed: ' + e.getMessage());
            ErrorLogHandler.insertErrorLog(datetime.now(), e.getMessage(), 'SmartAPIAddressValidation');
            updateLocationVerified(locationId, false);
        }
    }

    // Helper method to update the Location Verified field
    private static void updateLocationVerified(Id locationId, Boolean isVerified) {
        Location_Address_Book__c loc = new Location_Address_Book__c(Id = locationId, Verified__c = isVerified);
        loc.Landmark__c = 'test landmark' + isVerified;
        update loc;
    }
}

*/