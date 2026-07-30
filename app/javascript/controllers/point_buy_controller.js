import { Controller } from "@hotwired/stimulus"

// Shows remaining attribute points during character creation (PRD §4.2).
export default class extends Controller {
  static targets = ["stat", "remaining"]
  static values = { total: Number }

  connect() {
    this.recount()
  }

  recount() {
    const spent = this.statTargets.reduce((sum, el) => sum + (parseInt(el.value) || 0), 0)
    const left = this.totalValue - spent
    this.remainingTarget.textContent = left
    this.remainingTarget.parentElement.style.color = left < 0 ? "var(--red)" : "var(--gold)"
  }
}
