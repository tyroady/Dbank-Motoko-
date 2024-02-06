import {dbank_backend} from "../../declarations/dbank_backend";


window.addEventListener("DOMContentLoaded", async () => {
  const currentAmount = await dbank_backend.checkBalance(); 
  //Bu noktadda bu veriyi beklememiz gerekiyor (await ile) çünkü gösterecek bir şeyimiz olmuyor öbür türlü.
  //await eklemek için de içinde bulunduğumuz fonksiyonu async func yaptık.
  document.getElementById("value").innerText = Math.round(currentAmount * 100) / 100;
});


document.querySelector("form").addEventListener("submit", async (event) => {
  event.preventDefault();
  const button = event.target.querySelector("#submit-btn");
  console.log("Submitted");

  const yukselecekDeger = parseFloat(document.getElementById("input-amount").value);
  const alcalacakDeger = parseFloat(document.getElementById("withdrawal-amount").value);

  button.setAttribute("disabled", true);

  /* Eğer boş bir değer girilip submit edilirse currentValue değeri motoko backendde NaN olarak kalır.
  Bu gibi hatalar çok korkunç. Çünkü eğer bu gerçekte olursa insanlar varlıklarını kaybeder. O yüzden
  değerlere çok dikkat etmeliyiz. */

  if (document.getElementById("input-amount").value.length != 0) {
    await dbank_backend.topUp(yukselecekDeger); 
  }
  if (document.getElementById("withdrawal-amount").value.length != 0) {
    await dbank_backend.withDraw(alcalacakDeger);
  }
  
  const currentAmount = await dbank_backend.checkBalance();
  document.getElementById("value").innerText = Math.round(currentAmount * 100) / 100;

  document.getElementById("input-amount").value = "";
  document.getElementById("withdrawal-amount").value = "";
  button.removeAttribute("disabled");

})