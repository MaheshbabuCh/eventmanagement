public with sharing class LocationVerifyAPI {
    @Future(callout=true)
    public static void dofuture(Id locationId){
        System.debug('locationId: ' + locationId);
        List<Location_Address_Book__c> locationList = [select Id, Name, Street__c, City__c, Postal_Code__c, State__c, Verified__c from Location_Address_Book__c where Id =:locationId];
        System.debug('locationList: ' + locationList);
        locationVerification(locationList);
    }

    public static void locationVerification(List<Location_Address_Book__c> locationList){
        List<Location_Address_Book__c> locationsToUpdate = new List<Location_Address_Book__c>();
        for (Location_Address_Book__c location : locationList) {
            // Call SmartyStreets API to verify the address
            Boolean isVerified = callSmartyStreetsAPI(location.Street__c, location.City__c, location.State__c, location.Postal_Code__c);
           
            // Update the Location Verified field based on the API response
            location.Verified__c = isVerified;
            locationsToUpdate.add(location);
        }
        try {
            update locationsToUpdate;
        } catch (DmlException e) {
            System.debug('Error updating locations: ' + e.getMessage());
            // Handle more specific error logic or rethrow as needed
        }
    }
 
    public static Boolean callSmartyStreetsAPI(String street, String city, String state, String zip){
          Smart_API_Setting__mdt apiSettings = Smart_API_Setting__mdt.getInstance('Zipcode_API');
       
       String endpoint = 'https://us-zipcode.api.smartystreets.com/lookup';
            endpoint += '?auth-id=' + apiSettings.Auth_ID__c;
            endpoint += '&auth-token=' + apiSettings.Auth_token__c;
            endpoint += '&street=' + EncodingUtil.urlEncode(street, 'UTF-8');
            endpoint += '&city=' + EncodingUtil.urlEncode(city, 'UTF-8');
            endpoint += '&state=' + EncodingUtil.urlEncode(state, 'UTF-8');
            endpoint += '&zipcode=' + EncodingUtil.urlEncode(zip, 'UTF-8');

        Http http = new Http();
        Httprequest request = new Httprequest();
        request.setMethod('GET');
        request.setEndpoint(endpoint);
        try {
            Httpresponse response = http.send(request);
            System.debug('Get Status ' + response.getStatus());
            System.debug('Get Status Code ' + response.getStatusCode());
            System.debug('Get Response Body' + response.getBody());
            if (response.getStatusCode() == 200) {
                return true;
            }else {
                return false;
            }
        } catch (Exception ex) {
            System.debug(ex.getMessage());
            return false;
        }
    }
 
 
}