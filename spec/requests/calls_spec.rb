require 'rails_helper'

RSpec.describe 'Calls', type: :request do
  describe 'GET /calls' do
    before do
      allow(Call).to receive(:all).and_return([
        Call.new(incident_number: '123456', call_type: 'Assault'),
        Call.new(incident_number: '789012', call_type: 'Theft')
      ])
    end

    it 'returns all call logs' do
      get '/calls', headers: { 'Accept' => 'application/json' }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(2)
    end
  end

  describe 'POST /calls' do
    let(:valid_attributes) do
      {
        incident_number: 'TEST123',
        call_type: 'Assault',
        call_type_group: 'Violent Crime',
        call_time: Time.current,
        call_origin: 'Phone',
        Area: 'Downtown',
        AreaName: 'Central District',
        Latitude: 45.123456,
        Longitude: -122.654321,
        Hour: '10',
        DayOfWeek: 'Monday',
        WARD: 1,
        DISTRICT: 'Central',
        Month: 'May',
        year: 2023,
        priority: 'High',
        alcohol_related: true
      }
    end

    it 'attempts to create a new call log' do
      call_instance = instance_double(Call)

      expect(Call).to receive(:new).with(hash_including(
        'incident_number' => 'TEST123'
      )).and_return(call_instance)

      expect(call_instance).to receive(:save).and_return(true)
      allow(call_instance).to receive_messages(
        to_json: { incident_number: 'TEST123' }.to_json,
        as_json: { 'incident_number' => 'TEST123' }
      )

      post '/calls',
           params: { call: valid_attributes }.to_json,
           headers: {
             'Accept' => 'application/json',
             'Content-Type' => 'application/json'
           }

      expect(response).to have_http_status(:created)
    end

    context 'with invalid attributes' do
      let(:invalid_attributes) do
        valid_attributes.merge(incident_number: nil)
      end

      it 'returns unprocessable entity status when save fails' do
        call_instance = instance_double(Call)
        allow(Call).to receive(:new).and_return(call_instance)
        allow(call_instance).to receive(:save).and_return(false)
        allow(call_instance).to receive(:errors).and_return(
          { 'incident_number' => [ "can't be blank" ] }
        )

        post '/calls',
             params: { call: invalid_attributes }.to_json,
             headers: {
               'Accept' => 'application/json',
               'Content-Type' => 'application/json'
             }

        expect(response).to have_http_status(:unprocessable_entity)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response).to have_key('incident_number')
      end
    end
  end
end
