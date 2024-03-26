import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["numberspeople", "price", "results"];

  connect() {
    if(this.numberspeopleTarget){
      this.numberspeopleTarget.setAttribute("data-action", "click->booking#change");
    }
    this.calculateResult();
  }

  change() {
    this.calculateResult();
  }

  calculateResult() {
    if (this.numberspeopleTarget && this.priceTarget) {
      const total = this.numberspeopleTarget.value * this.priceTarget.value;
      this.resultsTarget.value = formatToVND(total);
    }
  }
}

function formatToVND(amount) {
  const formatter = new Intl.NumberFormat("vi-VN", {
    style: "currency",
    currency: "VND",
    minimumFractionDigits: 0,
  });
  return formatter.format(amount);
}
