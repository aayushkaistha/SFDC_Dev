trigger AttachPDFToComments on Comments__c (after insert, after update) {
    String pdfTemplate = '<html><body>Test HTML to PDF <br/><br/>Comment ID: ARG_NAME <br/><br/>Comment: ARG_COMMENT <div style="page-break-after:always;"> PAGE 2 </body></html>';
    
    List<Attachment> lstAttachToInsert = new List<Attachment>();
    for(Comments__c comm : Trigger.New){
        String pdfContent = pdfTemplate.replaceAll('ARG_NAME', comm.Name);
        pdfContent = pdfContent.replaceAll('ARG_COMMENT', comm.Comment__c);
        
        Blob binary = Blob.toPdf(pdfContent);
        Attachment attach = new Attachment();
        attach.Name = 'Comments PDF - ' + DateTime.now();
        attach.Body = binary;
        attach.ContentType = 'application/pdf';
        attach.ParentId = comm.Id;
        
        lstAttachToInsert.add(attach);
    }
    
    if(lstAttachToInsert != null && lstAttachToInsert.size() > 0){
        Database.insert(lstAttachToInsert, false);
    }
}