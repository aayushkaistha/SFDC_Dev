public class TestEscapeController {
    public String theCulprit {get; set;}
    
    public TestEscapeController(){
        theCulprit = '<input type="Button" value="Ahaa!" onclick="alert(\'Catch me if you can!\')">';
    }
}