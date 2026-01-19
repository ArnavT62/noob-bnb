class Admin::PropertiesController < ApplicationController
  layout "admin"
  before_action :authenticate_admin!
    def index
        @properties = Property.all
    end

    def show
        @property = Property.find(params[:id])
    end

    def new
        @property = Property.new
    end

    def create
        @property = Property.new(property_params)
        if property_params[:price].present? && property_params[:price].to_f > 0
          @property.price = Money.from_amount(property_params[:price].to_f, "USD")
        end
        if @property.save
            redirect_to admin_properties_path, notice: "Property created successfully"
    else
      render :new, status: :unprocessable_entity
        end
    end

  def edit
    @property = Property.find(params[:id])
  end

    def update
        @property = Property.find(params[:id])
    update_params = property_params.dup
    if update_params[:price].present? && update_params[:price].to_f > 0
      @property.price = Money.from_amount(update_params[:price].to_f, "USD")
      update_params.delete(:price)
    end
    if @property.update(update_params)
            redirect_to admin_properties_path, notice: "Property updated successfully"
    else
      render :edit, status: :unprocessable_entity
    end
  end

    def destroy
        @property = Property.find(params[:id])
        @property.destroy
        redirect_to admin_properties_path, notice: "Property deleted successfully"
    end
    
  private

  def property_params
    params.require(:property).permit(
      :name,
      :headline,
      :description,
      :host_name,
      :address_1,
      :address_2,
      :city,
      :state,
      :country,
      :price,
      :guest_count,
      :bedroom_count,
      :bed_count,
      images: []
    )
  end
end