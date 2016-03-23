public class EditOrderField {

    public String orderName {get; set;}
    public Order__c objOrder {get; set;}
    public String newStatus {get; set;}
    
    public void findOrder(){
        objOrder = [Select Id, status__c From Order__c where Name = :orderName limit 1];
    }
    
    public void updateOrder(){
        objOrder.status__c = newStatus;
        update objOrder;
    }

}