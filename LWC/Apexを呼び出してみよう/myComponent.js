import { LightningElement, wire } from 'lwc';
import serachRecord from '@salesforce/apex/myComponentController.serachTestRecord';

export default class MyComponent extends LightningElement {
   searchWord = '';
   tests;

    changeWord(event){
        this.searchWord = event.target.value;
    }

    search(){
        this.searchWord = this.searchWord;
        serachRecord({serachWord: this.searchWord})
        .then (result => {
            console.log(result);
            
            this.tests = result;
            console.log(this.tests.length > 0);
        })        
    }
    hasChanged(){
        return (this.tests.length > 0);
    }
}