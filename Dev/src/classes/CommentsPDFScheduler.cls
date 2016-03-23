global class CommentsPDFScheduler implements Schedulable{
   global void execute(SchedulableContext SC) {
      
      List<Comments__c> lstComments = [Select Id, Name, comment__c From Comments__c Limit 10];
      
      List<Attachment> lstAttachments = new List<Attachment>();
      for(Comments__c objComment : lstComments){
          HttpRequest req = new HttpRequest();
          req.setEndpoint('http://paras-developer-edition.ap1.force.com/CommentsPDF?id=' + objComment.Id);
          req.setMethod('GET');
          
          Http http = new Http();
          HTTPResponse res = http.send(req);
      
        Attachment attach = new Attachment();
        attach.Name = 'PDF_from_WS' + Date.today() + '.pdf';
        attach.body = res.getBodyAsBlob();
        attach.parentId = objComment.Id;
        
        lstAttachments.add(attach);
      }
      
      insert  lstAttachments;
   }
   
   public static void start(){
       CommentsPDFScheduler m = new CommentsPDFScheduler();
        String seconds = '0'; //Execute at Zero Seconds
        String minutes = '*'; //Execute at every 10th minute of hour
        String hours = '*'; // Execute Every Hour
        String dayOfMonth = '*'; // Execute Every Day of the Month
        String month = '*'; //Execute only in November(11)
        String dayOfWeek = '?'; //Execute on all 7 days of the Week
        String year = '*'; //Execute only for year 2009
        //Seconds Minutes Hours Day_of_month Month Day_of_week optional_year
        String sch = seconds + ' ' + minutes + ' ' + hours + ' ' + dayOfMonth + ' ' + month + ' ' + dayOfWeek + ' ' + year;
        //String sch = ’0 10,20,30,40,50 * * 11 ? 2009′;
        system.schedule('CommentsPDFScheduler', sch, m);
   }
}