import { LightningElement, api } from 'lwc';


export default class ListComponent extends LightningElement {
    @api tests;
    @api hasChanged;
}