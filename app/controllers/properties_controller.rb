class PropertiesController < ApplicationController
    def show
        @property = Property.find(params[:id])
        @user_has_reviewed = current_user&.reviews&.exists?(property_id: @property.id) if user_signed_in?
        @review = Review.new if user_signed_in? && !@user_has_reviewed
    end
end