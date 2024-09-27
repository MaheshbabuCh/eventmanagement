import { LightningElement, api, wire } from 'lwc';
import getSpeakers from '@salesforce/apex/EventController.getSpeakers';

const columns = [
    { label: 'Name', fieldName: 'Name' },
    { label: 'Email', fieldName: 'Email__c' },
    { label: 'Phone', fieldName: 'Phone__c' },
    { label: 'Company', fieldName: 'Company__c' }
];

export default class SpeakerDetails extends LightningElement {
    @api eventId;
    speakers;
    columns = columns;

    @wire(getSpeakers, { eventId: '$eventId' })
    wiredSpeakers({ error, data }) {
        if (data) {
            this.speakers = data;
        } else if (error) {
            console.error('Error retrieving speakers', error);
        }
    }
}
