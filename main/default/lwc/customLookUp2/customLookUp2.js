
import { LightningElement } from 'lwc';

export default class CustomLookUp2 extends LightningElement {
    fields = ["Name","Email","Phone"];
    displayFields = 'Name, Email, Phone'

    handleLookup(event){
        console.log( JSON.stringify ( event.detail) )
    }
}