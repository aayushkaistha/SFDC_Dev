public class AES128Encrypt {
    public String encryptedData {get; set;}

    public AES128Encrypt(){
        String inputData = ApexPages.currentPage().getParameters().get('data');
        if(inputData != null && inputData.length() > 0){
            Blob key = EncodingUtil.base64Decode('8fKpZB21s/VIGLI/rhfwKA==');
            Blob data = Blob.valueOf(inputData);        
        
            Blob encryptedDataBlob = Crypto.encryptWithManagedIV('AES128', key, data);
            encryptedData = EncodingUtil.base64Encode(encryptedDataBlob);
        }
    }

}