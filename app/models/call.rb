class Call < ApplicationRecord
  alias_attribute :Street, :street
  alias_attribute :Area, :area
  alias_attribute :AreaName, :area_name
  alias_attribute :Latitude, :latitude
  alias_attribute :Longitude, :longitude
  alias_attribute :Hour, :hour
  alias_attribute :DayOfWeek, :day_of_week
  alias_attribute :WARD, :ward
  alias_attribute :DISTRICT, :district
  alias_attribute :Month, :month

  validates :incident_number, presence: true, uniqueness: true
  validates :call_type, presence: true
  validates :call_type_group, presence: true
  validates :call_time, presence: true
  validates :call_origin, presence: true
  validates :area, presence: true
  validates :area_name, presence: true
  validates :latitude, presence: true
  validates :longitude, presence: true
  validates :hour, presence: true
  validates :day_of_week, presence: true
  validates :ward, presence: true
  validates :district, presence: true
  validates :priority, presence: true
  validates :month, presence: true
  validates :year, presence: true
  validates :alcohol_related, presence: true

  def self.log!(call_data)
    create!(
      incident_number: call_data[:incident_number],
      call_type: call_data[:call_type],
      call_type_group: call_data[:call_type_group],
      call_time: call_data[:call_time],
      street: call_data[:street],
      call_origin: call_data[:call_origin],
      mental_health: call_data[:mental_health],
      drug_related: call_data[:drug_related],
      dv_related: call_data[:dv_related],
      alcohol_related: call_data[:alcohol_related],
      area: call_data[:area],
      area_name: call_data[:area_name],
      latitude: call_data[:latitude],
      longitude: call_data[:longitude],
      hour: call_data[:hour],
      day_of_week: call_data[:day_of_week],
      ward: call_data[:ward],
      district: call_data[:district],
      priority: call_data[:priority],
      month: call_data[:month],
      year: call_data[:year]
    )
  end

  def self.full_list(format: :json)
    calls = all.map { |call| call.attributes.symbolize_keys }

    case format
    when :json
      calls.to_json
    when :csv
      require 'csv'
      CSV.generate do |csv|
        csv << Call.column_names
        calls.each do |call|
          csv << call.values
        end
      end
    else
      raise ArgumentError, "Invalid format: #{format.inspect}. Must be :json or :csv."
    end
  end
end
