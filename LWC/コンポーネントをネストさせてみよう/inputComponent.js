import { LightningElement } from 'lwc';

export default class InputComponent extends LightningElement {
    searchWord = '';
 
     changeWord(event){
         this.searchWord = event.target.value;
     }

     search(){         
         const event = new CustomEvent('search', {
            detail: this.searchWord
         });

        this.dispatchEvent(event);
    }
}