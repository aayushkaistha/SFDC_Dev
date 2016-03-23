public class PostCommentController {
    public String comment {get; set;}
    
    public void doAction (){
      comment = System.currentPagereference().getParameters().get('comment');
      if(comment != null){
        Comments__c objComment = new Comments__c();
        objComment.comment__c = comment;
        
        insert objComment;
      }
    }
}