console.log("[order_payment] loaded");
document.addEventListener("turbo:load", setupPayjp);
document.addEventListener("DOMContentLoaded", setupPayjp);

function setupPayjp() {
  const form = document.getElementById("charge-form");
  if (!form) return;

  const pk = document.querySelector('meta[name="payjp-public-key"]')?.content;
  if (!pk) return;

  // ページ再訪時の二重マウント防止
  if (form.dataset.payjpMounted === "true") return;

  const payjp = window.Payjp(pk);
  const elements = payjp.elements();

  const numberEl = elements.create("cardNumber");
  const expiryEl = elements.create("cardExpiry");
  const cvcEl    = elements.create("cardCvc");

  numberEl.mount("#number-form");
  expiryEl.mount("#expiry-form");
  cvcEl.mount("#cvc-form");

  form.dataset.payjpMounted = "true";

  form.addEventListener("submit", async (e) => {
  e.preventDefault();
  console.log("[PAYJP] submit handler START");

  const result = await payjp.createToken(numberEl);   // ← 戻り値は { id, error }
  if (result.error) {
    console.log("[PAYJP] token error:", result.error);
    alert(result.error.message || "カード情報の作成に失敗しました");
    return;
  }
  console.log("[PAYJP] token OK:", result.id);
  const tokenInput = document.getElementById("card-token");
  if (!tokenInput) {
    alert("hiddenの#card-tokenが見つかりません");
    return;
  }
  tokenInput.value = result.id;

  // セキュリティのためUIを空に
  try { numberEl.clear(); expiryEl.clear(); cvcEl.clear(); } catch(_) {}

  console.log("[PAYJP] form.submit()");
  form.submit();
});
}
