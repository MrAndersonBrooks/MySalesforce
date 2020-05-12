import { LightningElement, wire } from 'lwc';
import serachRecord from '@salesforce/apex/myComponentController.serachTestRecord';

export default class MyComponent extends LightningElement {
    tests;
    searchWord;
    hasChanged;

    handleSearch(evt){
        this.searchWord = evt.detail;
        serachRecord({serachWord: this.searchWord})
        .then (result => {
            console.log(result);
            
            this.tests = result;
            console.log(this.tests.length > 0);
            this.hasChanged = this.tests.length > 0;
        })         
    }
   
}