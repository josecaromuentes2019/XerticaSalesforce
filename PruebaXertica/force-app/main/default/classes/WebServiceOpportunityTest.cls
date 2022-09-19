@isTest
public with sharing class WebServiceOpportunityTest {

@TestSetup
static void crearData(){
   
    Account cuenta1=new Account();
    cuenta1.Name='CuentaPrueba';
    cuenta1.Type='Customer - Direct';
    cuenta1.Phone ='3107237275';
    insert cuenta1;

    Opportunity opp=new Opportunity();
    opp.Name='OportunidadPrueba';
    opp.AccountId=cuenta1.id;
    opp.StageName='Closed Won';
    opp.CloseDate=system.today()+7;
    insert opp;
   
}

@isTest static void TestCallData2(){
    Test.startTest();
    Opportunity opp=[SELECT Id, Name 
                        FROM Opportunity 
                        WHERE Name='OportunidadPrueba'];
    
    WebServiceOpportunity.WSOpp('[{"opportunityName": "Edge Emergency  Generator","opportunityId": "'+opp.id+'","closeDate": "2018-10-20","amount": 50000,"accountName": "Edge Communications"}]',opp.id);
    Test.stopTest();
    }

@isTest 
static void TestCallData(){
    Test.startTest();
    Opportunity opp=[SELECT Id, Name FROM Opportunity WHERE Name='OportunidadPrueba'];
    List<String> ids = new List<String>();
    ids.add(opp.id);
    WebServiceOpportunity.CallData(ids);
    Test.stopTest();
}

    @isTest static void TestJsonClass(){
        Test.startTest();
        WebServiceOpportunity.jsonClass jSonClas=new WebServiceOpportunity.jsonClass();
        jSonClas.parse('String');
        Test.stopTest();
    }
}
