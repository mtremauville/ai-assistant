import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["card"]

  // Called when "Ouvrir" is clicked — highlights the active card
  select(event) {
    const trainingId = event.currentTarget.dataset.trainingId

    this.cardTargets.forEach(card => {
      card.classList.toggle("active", card.dataset.id === trainingId)
    })
  }

  // Called when "Fermer" is clicked — resets the right panel
  close() {
    const frame = this.element.querySelector("turbo-frame#training-detail")
    if (frame) {
      frame.innerHTML = `
        <div class="tl-empty-state">
          <span class="tl-empty-icon">
            <i class="fa-solid fa-table-tennis-paddle-ball"></i>
          </span>
          <p>Sélectionnez un exercice</p>
        </div>
      `
    }
    this.cardTargets.forEach(card => card.classList.remove("active"))
  }
}
