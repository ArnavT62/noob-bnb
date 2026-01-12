    # class WishlistsController < ApplicationController
    #     before_action :authenticate_user!
    #     protect_from_forgery with: :null_session
    #     def create
    #         @property = Property.find(params[:property_id])
    #         @wishlist = current_user.wishlists.find_or_create_by(property: @property)
    #         respond_to do |format|
    #             format.js
    #         end
    #     end
    #     def destroy
    #        @wishlist=current_user.wishlists.find(params[:id])
    #        @property=@wishlist.property
    #        @wishlist.destroy
    #        respond_to do |format|
    #             format.js
    #        end
    #     end
    # end
    class WishlistsController < ApplicationController
        before_action :authenticate_user!
        def create
            @property = Property.find(params[:property_id])
            @wishlist = current_user.wishlists.find_or_create_by(property: @property)
            respond_to do |format|
                format.turbo_stream
                format.html { redirect_to @property, notice: "Property added to wishlist" }
            end
        end
        def destroy
           @wishlist=current_user.wishlists.find(params[:id])
           @property=@wishlist.property
           @wishlist.destroy
           respond_to do |format|
                format.turbo_stream
                format.html { redirect_to @property, notice: "Property removed from wishlist" }
           end
        end
    end