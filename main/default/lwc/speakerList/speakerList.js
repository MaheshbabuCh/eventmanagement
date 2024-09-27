import { LightningElement, track, wire } from 'lwc';
import getSpeakers from '@salesforce/apex/SpeakerController.getSpeakers';

export default class SpeakerList extends LightningElement {
    @track speakers;
    @track error;

    @wire(getSpeakers)
    wiredSpeakers({ error, data }) {
        if (data) {
            this.speakers = data;
            this.error = undefined;
        } else if (error) {
            this.error = error;
            this.speakers = undefined;
        }
    }
}
