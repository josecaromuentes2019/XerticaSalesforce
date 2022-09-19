public with sharing class WebServiceOpportunity {

    @InvocableMethod(
        label='endPoint'
        description='Este metodo permite invocar un endPonit')
    public static void CallData(List<String> oppIds) {
        if(oppIds.size() > 0){
            List<Opportunity> listOpp=[SELECT Id, Name,Account.Name, StageName, Amount, CloseDate 
                                        FROM Opportunity where id
                                        IN :oppIds];

            jsonClass jsonnew = new jsonClass();
            Opportunity oppJson = listOpp.get(0);

            jsonnew.opportunityName = oppJson.Name;
            jsonnew.opportunityId = oppJson.id;
            jsonnew.closeDate = oppJson.CloseDate;
            jsonnew.amount = oppJson.Amount;
            jsonnew.accountName = oppJson.Account.Name;
            string json = System.JSON.serialize(jsonnew);
            WSOpp(json, oppJson.id);
        }
    }

    @future(callout=true)
    public static void WSOpp(string jsonGenerado, string id) {

        System.debug('Json'+ jsonGenerado);
        String endPointURL ='http://www.apexdevnet.com/test/prueba/';

        Httprequest request = new HttpRequest();
        Http http = new Http();

        request.setMethod('POST');
        request.setEndpoint(endPointURL);
        request.setHeader('Content-Type','application/x-www-form-urlencoded');
        request.setHeader('Accept-Encoding', 'gzip, deflate, br');
        request.setHeader('Accept', '/');
        request.setHeader('Connection', 'keep-alive');
        request.setBody(jsonGenerado);

        Opportunity opp = [select id, StageName from Opportunity where id = :id];

        HttpResponse response = http.send(request);
        System.debug('status: '+ response.getStatusCode());
        
        if(response.getStatusCode() == 201){
            opp.StageName = 'Enviado';
        } else {
            opp.StageName = 'Reenviar';
        }
        System.debug('id: ' + id);
        update opp;
    }

    public class jsonClass {

        public String opportunityName {set;get;}
        public String opportunityId {set;get;}
        public Date closeDate {set;get;}
        public decimal amount {set;get;}
        public String accountName {set;get;}

        public List<jsonClass> parse(String json) {
            return (List<jsonClass>) System.JSON.deserialize(json,List<jsonClass>.class);  
        }
    }
    


}