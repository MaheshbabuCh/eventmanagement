import { LightningElement, api } from 'lwc';

export default class SpeakerTile extends LightningElement {
    @api name;
    @api email;
    @api phone;
    @api profileUrl;
    @api aboutMe;
  
   renderedCallback() {
        if (this.aboutMe) {
            const aboutMeDiv = this.template.querySelector('.about-me');
            if (aboutMeDiv) {
                aboutMeDiv.innerHTML = this.aboutMe;
            }
        }
    }
}
