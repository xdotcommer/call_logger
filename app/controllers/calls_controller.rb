class CallsController < ApplicationController
  def index
    @calls = Call.all
    render json: @calls
  end

  def create
    # Parse JSON input manually if it's a JSON request
    params_hash = if request.content_type == "application/json"
      JSON.parse(request.body.read)
    else
      params
    end

    @call = Call.new(call_params_from_hash(params_hash))

    if @call.save
      render json: @call, status: :created
    else
      render json: @call.errors, status: :unprocessable_entity
    end
  rescue ActionController::ParameterMissing
    render json: { error: "Missing required parameters" }, status: :bad_request
  rescue JSON::ParserError
    render json: { error: "Invalid JSON format" }, status: :bad_request
  end

  def last_call_time
    @last_call_time = Call.order(call_time: :desc).first&.call_time
    if @last_call_time
      render json: @last_call_time
    else
      render json: { error: "No calls found" }, status: :not_found
    end
  end

  private

  def call_params_from_hash(hash)
    # Handle both string and symbol keys
    data = hash.with_indifferent_access
    data = data[:call] if data[:call] || data["call"]

    ActionController::Parameters.new(data).permit(
      :alcohol_related,
      :incident_number,
      :call_type,
      :call_type_group,
      :call_time,
      :Street,
      :call_origin,
      :mental_health,
      :drug_related,
      :dv_related,
      :Area,
      :AreaName,
      :Latitude,
      :Longitude,
      :Hour,
      :DayOfWeek,
      :WARD,
      :DISTRICT,
      :Month,
      :year,
      :priority,
      :apco_code,
      :apco_description,
      :apco_notes
    )
  end

  def call_params
    params.require(:call).permit(
      :alcohol_related,
      :incident_number,
      :call_type,
      :call_type_group,
      :call_time,
      :Street,
      :call_origin,
      :mental_health,
      :drug_related,
      :dv_related,
      :Area,
      :AreaName,
      :Latitude,
      :Longitude,
      :Hour,
      :DayOfWeek,
      :WARD,
      :DISTRICT,
      :Month,
      :year,
      :priority,
      :apco_code,
      :apco_description,
      :apco_notes
    )
  end
end
