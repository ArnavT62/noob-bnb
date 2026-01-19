class ReviewsController < ApplicationController
    before_action :authenticate_user!
    
    def create
        @property = Property.find(params[:property_id])
        @review = current_user.reviews.build(review_params)
        @review.property = @property
        
        if @review.save
            redirect_to property_path(@property), notice: "Review created successfully"
        else
            redirect_to property_path(@property), alert: @review.errors.full_messages.join(", ")
        end
    end
    
    private
    
    def review_params
        params.require(:review).permit(:content, :cleanliness_rating, :accuracy_rating, :checkin_rating, :communication_rating, :location_rating, :value_rating)
    end
end