public class AndroidRegistrationsPageController {
    public String regId {get; set;}
    
    public void doAction (){
      regId = System.currentPagereference().getParameters().get('regId');
      if(regId != null){
        List<AndroidRegistrations__c> lstAR = [Select Id From AndroidRegistrations__c where registrationId__c = :regId];
      
        if(lstAR == null || lstAR.size() == 0){      
          AndroidRegistrations__c objAR = new AndroidRegistrations__c();
          objAR.registrationId__c = regId;
        
          insert objAR;
        }
      }
    }
}