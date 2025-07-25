import { Application } from "@hotwired/stimulus"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }
// app/javascript/BasketController.js
import { Application } from "@hotwired/stimulus"
import BasketController from "./controllers/basket_controller"

const application = Application.start()
application.register("basket", BasketController)
// app/javascript/FlashController.js
import FlashController from "./controllers/flash_controller"

application.register("flash", FlashController)