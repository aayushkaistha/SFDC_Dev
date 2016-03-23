trigger SuppressFileExtensions on Attachment (before insert, before update) {
    for(Attachment att : trigger.New){
        if(att.Name.endsWith('.exe')){
            att.addError('ERROR: File type not allowed.');
            //att.Name = att.Name + '.suppressed';
        }
    }
}