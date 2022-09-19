trigger OpportunityUpdate on Account (before Update) {

    set<id> accountIds = new set<id>();
    for(Account account  : trigger.new){
        if(account.Activa__c == 'No'){
            accountIds.add(account.id);
        }
    }
    
    if(!accountIds.isEmpty()){

        String stageWon = 'Closed Won';
        String stageLost = 'Closed Lost';
        String influyente = 'Influyente';

        list<Opportunity> opportunityList =[SELECT id, StageName, Description 
                                                FROM Opportunity 
                                                WHERE StageName != :stageLost
                                                AND StageName != :stageWon 
                                                AND AccountId 
                                                IN :(accountIds) ];
        system.debug('oportunidades'+opportunityList);

        if(!opportunityList.isEmpty()){
            for(Opportunity opport : opportunityList){
                opport.StageName = stageLost;
                opport.Description = 'Cerrada por Cuenta Inactiva';
            }
            
            Update opportunityList;
        }
        
        list<Contact> contactList = [SELECT id, AccountId,  Rol__c FROM Contact 
                                        WHERE Rol__c = :influyente
                                        AND AccountId 
                                        IN : accountIds ];

        list<Ex_clientes__c> ex_clientes = new list<Ex_clientes__c>();
        
        if(!contactList.isEmpty()){
            for(Contact c : contactList){
                Ex_clientes__c cliente = new Ex_clientes__c();
                cliente.Contacto__c = c.id;                    
                cliente.Generado_automaticamente__c  = true;
                ex_clientes.add(cliente);
            }
            
            upsert ex_clientes;
        } 
    }
}