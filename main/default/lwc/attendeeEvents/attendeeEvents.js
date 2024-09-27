// part 1 
// import { LightningElement, track, wire, api } from 'lwc';
// import getAttendeeUpcomingEvents from '@salesforce/apex/attendeeEventsController.getAttendeeUpcomingEvents';

// export default class AttendeeEvents extends LightningElement {
//     @api recordId; // This is the Attendee's ID passed from the record page
//     @track upcomingEvents = [];
//     @track error;

//     // Fetch upcoming events for the attendee
//     @wire(getAttendeeUpcomingEvents, { attendeeId: '$recordId' })
//     wiredUpcomingEvents({ error, data }) {
//         if (data) {
//             this.upcomingEvents = data;
//         } else if (error) {
//             this.error = error;
//         }
//     }

//     get hasUpcomingEvents() {
//         return this.upcomingEvents.length > 0;
//     }
  
// }

import { LightningElement, track, wire, api } from 'lwc';
import getAttendeeUpcomingEvents from '@salesforce/apex/AttendeeEventsController.getAttendeeUpcomingEvents';
import getAttendeePastEvents from '@salesforce/apex/AttendeeEventsController.getAttendeePastEvents';

export default class AttendeeEvents extends LightningElement {
    @api recordId; // This is the Attendee's ID passed from the record page
    @track upcomingEvents = [];
    @track pastEvents = [];
    @track error;

    // Fetch upcoming events for the attendee
    @wire(getAttendeeUpcomingEvents, { attendeeId: '$recordId' })
    wiredUpcomingEvents({ error, data }) {
        if (data) {
            this.upcomingEvents = data;
        } else if (error) {
            this.error = error;
        }
    }

    // Fetch past events for the attendee
    @wire(getAttendeePastEvents, { attendeeId: '$recordId' })
    wiredPastEvents({ error, data }) {
        if (data) {
            this.pastEvents = data;
        } else if (error) {
            this.error = error;
        }
    }

    get hasUpcomingEvents() {
        return this.upcomingEvents.length > 0;
    }

    get hasPastEvents() {
        return this.pastEvents.length > 0;
    }
}
