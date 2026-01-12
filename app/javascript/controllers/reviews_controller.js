import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["review", "button", "hiddenReviews"]

  connect() {
    console.log("Reviews controller connected")
  }

  toggle() {
    const hiddenReviews = this.hiddenReviewsTargets
    const button = this.buttonTarget
    
    hiddenReviews.forEach(review => {
      review.classList.toggle("hidden")
    })
    
    // Toggle button text
    if (button.textContent.trim() === "Show more") {
      button.textContent = "Show less"
    } else {
      button.textContent = "Show more"
    }
  }
}

