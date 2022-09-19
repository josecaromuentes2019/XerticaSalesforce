import { LightningElement, wire, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import getOportunidades from '@salesforce/apex/ListOpportunity.getOportunidades_Perdias_Ganadas';


export default class Lwc_Cerradas_Ganadas extends NavigationMixin(LightningElement) {
    @api recordId;
    @wire(getOportunidades, { account_id: '$recordId' })
    oportunidades;

    
    navigateToRecordViewPage(event) {
      
        console.log(event.currentTarget.dataset.id)
        console.log(JSON.stringify(this.oportunidades))
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: event.currentTarget.dataset.id,
                objectApiName: 'Opportunity', 
                actionName: 'view'
            }
        });
    }
}