class PropertyController < ActionController::API

  def show
    @property = Property.find_by_id params[:id]
    render json: @property
  end

  def create
    @property = Property.new(property_params)

    if @property.save
      render json: {
        status: 'success',
        data:  @property.as_json
      }
    else
      render json: {
        status: 'error',
        errors: @property.errors.to_hash.merge(full_messages: @property.errors.full_messages)
      }, status: 422
    end
  end

  def search
    search_params
    @properties = Property.where(town: params[:town], county: params[:county], ptrb: params[:ptrb], rent_allowance: params[:rent_allowance] 
                                  )

    render json: @properties
  end

private
  def property_params
    params.permit(:landlord_id, :street, :town, :county, :rent,
                          :n_baths, :rent_allowance, :ptrb, :n_beds, :avail_beds)
  end

  def search_params
    params.permit(:town, :county, :rent_allowance, :ptrb)
    params[:ptrb] = str_to_bool(params[:ptrb])
    params[:rent_allowance] = str_to_bool(params[:rent_allowance])
  end

  def str_to_bool(str) 
    return str == 'true'
  end

end
