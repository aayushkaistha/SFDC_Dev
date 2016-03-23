public class DTBugTestController {
    public Contract objContract {get; set;}
    
    public DTBugTestController(){
      objContract = new Contract();
      objContract.test__c = DateTime.now();
    }
    
    public PageReference dummyAction(){
        return Page.PDFTemplateGenerator;
    }
}