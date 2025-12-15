import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log("Wishlist controller connected")
  }

  toggleStatus() {

    const userLoggedIn = this.element.dataset.userLoggedIn
    if(userLoggedIn === "false") {
     document.querySelector(".js-login").click()
      return
    }
    if(this.element.dataset.status === "false") {
    const propertyId = this.element.dataset.propertyId
    const userId = this.element.dataset.userId
    console.log(propertyId, userId);
    this.addPropertyToWishlist(propertyId, userId);
  } else {
    const wishlistId = this.element.dataset.wishlistId
    this.removePropertyFromWishlist(wishlistId);
  }
  }

  addPropertyToWishlist() {
    const params={
      property_id: this.element.dataset.propertyId,
      user_id: this.element.dataset.userId,
    }
    const options={
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
      body: JSON.stringify(params),

    }
    fetch("/api/wishlists", options)
      .then(response=>{
        if(!response.ok){
          throw Error(response.status);
        }
        return response.json();
      })
      .then(data=>{
        console.log(data);
        // Update UI to reflect wishlist was added
        this.element.classList.remove("fill-none")
        this.element.classList.add("fill-red-500")
        this.element.dataset.status = "true"
      })
      .catch(error=>{
        console.error(error);
      })
  }
  removePropertyFromWishlist(wishlistId) {
    const params={
      id: wishlistId,
    }
  const options={
    method: "DELETE",
    headers: { "Content-Type": "application/json", "Accept": "application/json", },
    body: JSON.stringify(params),
  }
  fetch("/api/wishlists/" + wishlistId, options)
  .then(response=>{
    if(!response.ok){
      throw Error(response.status);
    }
    // 204 No Content responses don't have a body, so no need to parse JSON
    if (response.status === 204) {
      return null;
    }
    return response.json();
  })
  .then(data=>{
    console.log("Wishlist removed successfully");
    // Update UI to reflect wishlist was removed
    this.element.classList.add("fill-none")
    this.element.classList.remove("fill-red-500")
    this.element.dataset.status = "false"
  })
  .catch(error=>{
    console.error(error);
  })
}
}
