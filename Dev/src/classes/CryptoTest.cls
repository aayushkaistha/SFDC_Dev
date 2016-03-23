public class CryptoTest {
    public String inputData {get; set;}
    public String encryptedData {get; set;}
    public String decryptedData {get; set;}
    public String keyToUse {get; set;}

    public void encryptData(){
        Blob cryptoKey = Crypto.generateAesKey(128);
        keyToUse = EncodingUtil.base64Encode(cryptoKey);
        
        Blob data = Blob.valueOf(inputData);        
        
        Blob encryptedDataBlob = Crypto.encryptWithManagedIV('AES128', cryptoKey, data);
        encryptedData = EncodingUtil.base64Encode(encryptedDataBlob);
        
        Blob decryptedDataBlob = Crypto.decryptWithManagedIV('AES128', cryptoKey, encryptedDataBlob);
        decryptedData = decryptedDataBlob.toString();
    }
}