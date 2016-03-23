public class BasePDFGeneratorController {
  public String content {get; set;}

  private List<pdfObject> lstObjects;

  public BasePDFGeneratorController(){
    Id templateId = 'a0O90000004ivI9';
    try{
      //DynamicPDFTemplate__c objDPT = [Select Id, Name, header__c From DynamicPDFTemplate__c where Id = :templateId];
      //Attachment attachDPT = [Select body From Attachment where parentId = :objDPT.Id and Name = 'content' order by LastModifiedDate desc limit 1];
    
      //content = attachDPT.body.toString();
      //String templateXML = objDPT.header__c;
    
      //parseXML(templateXML);
      List<String> lstF = new List<String>();
      lstF.add('Name');
      
      pdfObject obj1 = new pdfObject();
      obj1.objectX = 'Account';
      obj1.fields = lstF;
      
      pdfObject obj2 = new pdfObject();
      obj2.objectX = 'Product2';
      obj2.fields = lstF;
      
      lstObjects = new List<pdfObject>();
      lstObjects.add(obj1);
      lstObjects.add(obj2);
      
      Id EmailTemplateId = '00X90000000PWWj';
      EmailTemplate et = [Select htmlValue, BrandTemplateId From EmailTemplate where Id = :EmailTemplateId];
      BrandTemplate bt = [Select Value From BrandTemplate where Id = :et.BrandTemplateId];
      content = et.htmlValue;
      
      content = content.replaceAll('<!\\[CDATA\\[','');
      content = content.replaceAll(']]','');
      content = content.replaceAll('>>','>');
    
      for(pdfObject pobj : lstObjects){
        String fieldsSeq = '';
        for(String f : pobj.fields){
          fieldsSeq = fieldsSeq + f + ',';
        }
        if(fieldsSeq.endsWith(',')){
          fieldsSeq = fieldsSeq.subString(0, fieldsSeq.length() - 1);
        }
        
        String id = ApexPages.currentPage().getParameters().get(pobj.objectX + '_id');
        String query = 'Select ' + fieldsSeq + ' From ' + pobj.objectX + ' where id=\'' + id + '\' limit 1';
        sObject obj = Database.query(query);
    
        for(String f : pobj.fields){
          String toReplace = '\\{!' + pobj.objectX + '.' + f + '\\}';
          content = content.replaceAll(toReplace, (String)obj.get(f)); 
        }
      }
    }catch(Exception e){
      content = e.getMessage() + ': ' + e.getStackTraceString();
    }
  }
  
  private void parseXML(String templateXML){
    Map<String, String> mapObjVsId = new Map<String, String>();
    Dom.Document doc = new Dom.Document();
    doc.load(templateXML);
    
    lstObjects = new List<pdfObject>();
    Dom.XmlNode tagHeader = doc.getRootElement();
    
    Dom.XmlNode tagObjects = tagHeader.getChildElement('objects', null);
    for(Dom.XMLNode tagObject : tagObjects.getChildElements()) {
      pdfObject obj = new pdfObject();
      obj.objectX = tagObject.getChildElement('name', null).getText();
      
      Dom.XMLNode tagFields = tagObject.getChildElement('fields', null);
      obj.fields = new List<String>();
      for(Dom.XMLNode tagField : tagFields.getChildElements()) {
        obj.fields.add(tagField.getText());
      }
      
      lstObjects.add(obj);
    }
  }
  
  class pdfObject{
    public String objectX {get; set;}
    public List<String> fields {get; set;}
  }
}