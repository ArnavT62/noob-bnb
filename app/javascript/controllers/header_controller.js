import { Controller } from "@hotwired/stimulus"
import {enter,leave,toggle} from "el-transition"

export default class extends Controller {
  static targets = [ "openUserMenu", "dropdown" ]

  connect() {
    console.log("Header controller connected");
    console.log("enter", enter);
    this.openUserMenuTarget.addEventListener("click", (e) => {
      console.log("Open user menu clicked");
      openDropdown(this.dropdownTarget);
    });
  }
  
}
function openDropdown(dropdownTarget) {
  toggle(dropdownTarget).then(() => {
        console.log("Enter transition complete")
    })
}
 
// remove element when close
function closeDropdown(dropdownTarget) {
    leave(dropdownTarget).then(() => {
        dropdownTarget.destroy();
    })
}