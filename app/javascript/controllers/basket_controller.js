// app/javascript/controllers/basket_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  removeItem(event) {
    event.preventDefault()
    event.stopPropagation()
    event.stopImmediatePropagation()

    const form = event.target.closest('form')
    if (form) {
      form.removeEventListener('submit', this.removeItem)
      form.submit()
    }
  }

  connect() {
    this.element.addEventListener('submit', this.removeItem.bind(this), { once: true })
  }
}