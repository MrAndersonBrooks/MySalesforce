import { LightningElement } from 'lwc';

export default class MyComponent extends LightningElement {
    message = 'Hello World';
    inputChage( event ){        
        this.message = event.target.value;
    }
}