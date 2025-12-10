import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log("Wishlist controller connected")
  }

  toggleStatus() {
    if(this.element.dataset.status === "false") {
    this.element.classList.add("fill-red-500")
    this.element.classList.remove("fill-none")
    this.element.dataset.status = "true"
  } else {
    this.element.classList.add("fill-none")
    this.element.classList.remove("fill-red-500")
    this.element.dataset.status = "false"
  }
  }
}

