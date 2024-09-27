import { LightningElement, api, wire } from 'lwc';
import getAttendees from '@salesforce/apex/EventController.getAttendees';

const columns = [
    { label: 'Name', fieldName: 'Name' },
    { label: 'Email', fieldName: 'Email__c' },
    { label: 'Phone', fieldName: 'Phone__c' },
    { label: 'Company', fieldName: 'Company_Name__c' }
];

export default class AttendeesDetails extends LightningElement {
    @api eventId;
    attendees;
    columns = columns;

    @wire(getAttendees, { eventId: '$eventId' })
    wiredAttendees({ error, data }) {
        if (data) {
            this.attendees = data;
        } else if (error) {
            console.error('Error retrieving attendees', error);
        }
    }
}
