public with sharing class OrderPageController {
    public Order__c objOrder {get; set;}
    
    public OrderPageController(ApexPages.StandardController controller) {
        ObjOrder = (Order__c) controller.getRecord();
        objOrder = [Select Id, Name, First_Name__c, Last_Name__c, testRTA__c From Order__c where Id = :objOrder.Id Limit 1];
    }

}