# spec/models/call_spec.rb
require 'rails_helper'

RSpec.describe Call do
  describe 'validations' do
    let(:valid_attributes) do
      {
        incident_number: '123456',
        call_type: 'Assault',
        call_type_group: 'Violent Crime',
        call_time: Time.current,
        call_origin: 'Phone',
        area: 'Downtown',
        area_name: 'Central District',
        latitude: 45.123456,
        longitude: -122.654321,
        hour: '10',
        day_of_week: 'Monday',
        ward: 1,
        district: 'Central',
        priority: 'High',
        month: 'May',
        year: 2023,
        alcohol_related: true
      }
    end

    it 'validates required attributes' do
      call = Call.new(valid_attributes)
      expect(call).to be_valid

      required_fields = [
        :incident_number, :call_type, :call_type_group, :call_time,
        :call_origin, :area, :area_name, :latitude, :longitude,
        :hour, :day_of_week, :ward, :district, :priority,
        :month, :year, :alcohol_related
      ]

      required_fields.each do |field|
        call = Call.new(valid_attributes.except(field))
        expect(call).not_to be_valid
        expect(call.errors[field]).to include("can't be blank")
      end
    end
  end

  describe '.log!' do
    let(:call_data) do
      {
        incident_number: '654321',
        call_type: 'Burglary',
        call_type_group: 'Property Crime',
        street: '123 Main St',
        call_time: Time.current,
        call_origin: 'Phone',
        area: 'Downtown',
        area_name: 'Central District',
        latitude: 45.123456,
        longitude: -122.654321,
        hour: '10',
        day_of_week: 'Monday',
        ward: 1,
        district: 'Central',
        priority: 'High',
        month: 'May',
        year: 2023,
        drug_related: true,
        alcohol_related: true
      }
    end

    it 'creates a new call with the provided attributes' do
      call = Call.log!(call_data)
      expect(call.incident_number).to eq('654321')
      expect(call.call_type).to eq('Burglary')
      expect(call.call_type_group).to eq('Property Crime')
      expect(call.street).to eq('123 Main St')
      expect(call.drug_related).to be true
    end
  end

  describe '.full_list' do
    let(:test_calls) do
      [
        Call.new(
          incident_number: '123456',
          call_type: 'Assault',
          call_type_group: 'Violent Crime',
          call_time: Time.current,
          call_origin: 'Phone',
          area: 'Downtown',
          area_name: 'Central District',
          latitude: 45.123456,
          longitude: -122.654321,
          hour: '10',
          day_of_week: 'Monday',
          ward: 1,
          district: 'Central',
          priority: 'High',
          month: 'May',
          year: 2023,
          alcohol_related: false
        ),
        Call.new(
          incident_number: '789012',
          call_type: 'Theft',
          call_type_group: 'Property Crime',
          call_time: Time.current,
          call_origin: 'Phone',
          area: 'Uptown',
          area_name: 'North District',
          latitude: 45.678901,
          longitude: -122.109876,
          hour: '15',
          day_of_week: 'Tuesday',
          ward: 2,
          district: 'North',
          priority: 'Low',
          month: 'May',
          year: 2023,
          alcohol_related: false
        )
      ]
    end

    before do
      allow(Call).to receive(:all).and_return(test_calls)
    end

    it 'returns all call logs as json by default' do
      json = Call.full_list
      expect(json).to be_a(String)
      calls = JSON.parse(json)
      expect(calls.count).to eq(2)
      expect(calls.first.keys).to include(
        'incident_number', 'call_type', 'call_type_group'
      )
    end

    it 'returns all call logs as csv' do
      csv = Call.full_list(format: :csv)
      expect(csv).to be_a(String)
      rows = csv.split("\n")
      expect(rows.count).to eq(3) # header + 2 rows
      headers = rows.first.split(',')
      expect(headers).to include(
        'incident_number', 'call_type', 'call_type_group'
      )
    end

    it 'raises an error for invalid format' do
      expect { Call.full_list(format: :invalid) }.to raise_error(ArgumentError)
    end
  end
end
