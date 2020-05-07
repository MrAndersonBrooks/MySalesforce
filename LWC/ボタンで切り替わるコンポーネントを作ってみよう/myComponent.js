import { LightningElement } from 'lwc';

export default class MyComponent extends LightningElement {
    isChangePanel = true;
    count = 0;
    // nextCount = count + 1;

    clickedButton(){

        this.count++;
        if (this.count === 10) {
            this.isChangePanel = false;
        }
        
    }
}