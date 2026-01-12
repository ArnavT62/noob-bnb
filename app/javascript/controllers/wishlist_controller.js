import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [ "icon" ]
  connect() {
    console.log("Wishlist controller connected")
  }

  toggleStatus(event) {
    // Prevent navigation when clicking wishlist on homepage
    event.preventDefault()
    event.stopPropagation()

    const userLoggedIn = this.element.dataset.userLoggedIn
    if(userLoggedIn === "false") {
     window.location.href = "/users/sign_in"
      return
    }
    const status = this.element.dataset.status
    if(status === "false" || !status || status === "") {
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
        this.iconTarget.classList.remove("fill-none")
        this.iconTarget.classList.add("fill-red-500")
        this.element.dataset.status = "true"
        if (data && data.id) {
          this.element.dataset.wishlistId = data.id
        }
      })
      .catch(error=>{
        console.error(error);
      })
  }
  removePropertyFromWishlist(wishlistId) {
    if (!wishlistId) {
      console.warn("No wishlist id present, skipping delete");
      return;
    }
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
    this.iconTarget.classList.add("fill-none")
    this.iconTarget.classList.remove("fill-red-500")
    this.element.dataset.status = "false"
  })
  .catch(error=>{
    console.error(error);
  })
}
}
