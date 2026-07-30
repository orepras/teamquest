import { Controller } from "@hotwired/stimulus"

// When the XP category changes, prefill the amount with its default.
export default class extends Controller {
  static targets = ["category", "amount"]

  apply() {
    const option = this.categoryTarget.selectedOptions[0]
    if (option?.dataset.defaultXp) this.amountTarget.value = option.dataset.defaultXp
  }
}
