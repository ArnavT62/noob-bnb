    module Api
    class WishlistsController < ApplicationController
        protect_from_forgery with: :null_session
        def create
            wishlist = Wishlist.find_or_create_by(wishlist_params)
            respond_to do |format|
                format.json do
                    render json: wishlist.to_json, status: :ok
                end
            end
        rescue ActiveRecord::RecordInvalid => e
            respond_to do |format|
                format.json do
                    render json: { error: e.message }, status: :unprocessable_entity
                end
            end
        end
        def destroy
            wishlist = Wishlist.find(params[:id])
            wishlist.destroy
            respond_to do |format|
                format.json do
                    head :no_content
                end
            end
        rescue ActiveRecord::RecordNotFound => e
            respond_to do |format|
                format.json do
                    render json: { error: "Wishlist not found" }, status: :not_found
                end
            end
        end

        def wishlist_params
            params.permit(:user_id, :property_id)
        end
    end
end