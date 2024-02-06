import Debug "mo:base/Debug";
import Text "mo:base/Text";
import Int "mo:base/Int";
import Nat "mo:base/Nat";
import Time "mo:base/Time";
import Float "mo:base/Float";


actor DBank {
    stable var currentValue: Float = 300;
    currentValue := 300;
    //ÖNEMLİ!! stable anahtar kelimesi ile bu program tekrar deploy edildiğinde
    //yani dfx deploy kullanıldığında en sonki değerinden devam edeceği anlamına geliyor
    //Yani bir databaseye ihtiyacımız kalmıyor. Program tekrar dağıtılsa bile değer korunuyor.
    //Ancak veri tipini  değiştirmek, örneğin Nat -> Float geçmek sıfırlayacaktır bu veriyi. 
    
    Debug.print("Hi, your current value is: " # debug_show(currentValue));
    
    stable var startTime = Time.now();
   
    public func topUp(amount: Float) {
        currentValue += amount;
        Debug.print("New value:" # debug_show(currentValue));
    };
    public func withDraw(amount: Float) {
        let tempValue: Float = currentValue - amount; //geçiciDeğer
        if (tempValue >= 0){
        currentValue -= amount;
        Debug.print("New value:" # debug_show(currentValue));
        } else {
            Debug.print("Current value can not be less than zero");
        }
    };
    //query func blockchain kullanmıyor. Sadece okumak için. Bir güncelleme yapmıyor
    //veya onu bir chain'e eklemiyor. O yüzden çok hızlı çağırılıyor. 
    //hatta Candic UI'da Oneway yazısını görebilirsin fonksiyonların yanında. Geri dönüşsüz olarak oraya eklendiğini gösteriyor.
    public query func checkBalance(): async Float {
        currentValue;
    };
    public func conpoundInterest() {
        let currentTime = Time.now();
        let timeElapsedNS = currentTime - startTime;
        let timeElapsedS = timeElapsedNS / ((3 + (16/100)) * 100000000000000000);
        currentValue := currentValue * (1.01 ** Float.fromInt(timeElapsedS));
        //İşlemlerin hepsi aynı veri tipinde olmalı. Yani bir Float ile Nat toplanıp çarpılamaz.
        startTime := currentTime;

    }

};