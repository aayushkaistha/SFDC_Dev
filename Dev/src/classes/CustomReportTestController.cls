public class CustomReportTestController {
  public String debug {get; set;}
  public void doAction(){
    List<Report> reps = [SELECT Id,Name, description FROM Report WHERE Id =:'00O90000001qTDy' ];
    Report r = reps.get(0);
    
    debug = r.get('Name') + '';
  }

}