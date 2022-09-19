public without  sharing class ListOpportunity {

    public List<Opportunity> opportunities {set;get;}
    public List<Opportunity> oneOpportunities {set;get;}
    public String message = System.currentPagereference().getParameters().get('msg');
    
    public List<Opportunity> getOportunidades() {
        String stageName = 'Closed Won';
        opportunities = [SELECT id,Name, Account.name ,Amount, CloseDate,Type, StageName 
                            FROM Opportunity 
                            WHERE StageName =:stageName and CloseDate = THIS_MONTH];

        System.debug('valor: '+message);
        return opportunities;
    }

    @AuraEnabled(cacheable=true)
    public static List<Opportunity> getOportunidades_Perdias_Ganadas( Id account_id) {
        String stageWon = 'Closed Won';
        String stageLost = 'Closed Lost';
        List<Opportunity> oport = [SELECT id, Name, Account.name ,Amount, CloseDate,Type, StageName 
                            FROM Opportunity 
                            WHERE (StageName =:stageWon or StageName =:stageLost) 
                            and CloseDate = THIS_MONTH and Account.Id =: account_id];
        return oport;
    }
 
    public List<Opportunity> getOneOportunidad(){
        String stageName = 'Closed Won';
        oneOpportunities = [SELECT id,Name, Account.name ,Amount, CloseDate,Type, StageName 
                                FROM Opportunity 
                                WHERE StageName =:stageName 
                                AND CloseDate = THIS_MONTH and id = :message];
        
        return oneOpportunities;
    }
   
}
