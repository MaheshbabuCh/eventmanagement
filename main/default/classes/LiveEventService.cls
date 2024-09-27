@RestResource(urlMapping='/liveEvents')
global with sharing class LiveEventService {

    @HttpGet
    global static List<EventResponse> doGet() {
        // Query to get live events where the start date is greater than today
        List<Event__c> liveEvents = [
            SELECT Id, Name, Start_Date__c, End_Date__c, Location_Address_Book__r.Name
            FROM Event__c
            WHERE Start_Date__c > :System.today()
            ORDER BY Start_Date__c ASC
        ];

        // Prepare the response list
        List<EventResponse> response = new List<EventResponse>();
        
        for (Event__c eventRecord : liveEvents) {
            response.add(new EventResponse(
                eventRecord.Id,
                eventRecord.Name,
                eventRecord.Start_Date__c,
                eventRecord.End_Date__c,
                eventRecord.Location_Address_Book__r.Name
            ));
        }

        return response;
    }

    // Inner class to define the structure of the JSON response
    global class EventResponse {
        public String Id;
        public String Name;
        public Date StartDate;
        public Date EndDate;
        public String Location;
        // Constructor
        public EventResponse(String id, String name, Date startDate, Date endDate, String location) {
            this.Id = id;
            this.Name = name;
            this.StartDate = startDate;
            this.EndDate = endDate;
            this.Location = location;
        }
    }
}
/* Response received in work bench - https://maheshbabucapstoneproject-dev-ed.develop.my.salesforce.com/services/apexrest/liveEvents

fd
StartDate: 2024-09-24
Name: fd
Location: null
Id: a02NS000001SpNBYA0
EndDate: 2024-09-27

fgg
StartDate: 2024-09-25
Name: fgg
Location: null
Id: a02NS000001SpLZYA0
EndDate: 2024-09-27

check
StartDate: 2024-10-11
Name: check
Location: null
Id: a02NS000001SpQPYA0
EndDate: 2024-10-23

Republic Day Event
StartDate: 2025-01-23
Name: Republic Day Event
Location: Hyderabad
Id: a02NS000001MybFYAS
EndDate: 2025-01-25
*/
