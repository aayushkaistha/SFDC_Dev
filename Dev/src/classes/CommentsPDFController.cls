public class CommentsPDFController {
    public Comments__c comment {get; set;}
    
    public CommentsPDFController(ApexPages.StandardController controller) {
        comment = (Comments__c) controller.getRecord();
        
        comment = [Select Id, Name, comment__c From Comments__c where Id = :comment.Id];
    }

}