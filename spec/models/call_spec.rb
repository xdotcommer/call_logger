require 'rails_helper'

RSpec.describe Call, type: :model do
  describe 'validations' do
    subject { build(:call)  }

    it { should validate_presence_of(:incident_number) }
    it { should validate_presence_of(:call_type) }
    it { should validate_presence_of(:call_type_group) }
    it { should validate_presence_of(:call_time) }
    it { should validate_presence_of(:call_origin) }
    it { should validate_presence_of(:area) }
    it { should validate_presence_of(:area_name) }
    it { should validate_presence_of(:latitude) }
    it { should validate_presence_of(:longitude) }
    it { should validate_presence_of(:hour) }
    it { should validate_presence_of(:day_of_week) }
    it { should validate_presence_of(:ward) }
    it { should validate_presence_of(:district) }
    it { should validate_presence_of(:priority) }
    it { should validate_presence_of(:month) }
    it { should validate_presence_of(:year) }
    it { should validate_presence_of(:alcohol_related) }
  end

    describe 'creating a call log' do
    let(:valid_attributes) do
      attributes_for(:call).merge(
        incident_number: '123456',
        call_type: 'Assault',
        call_type_group: 'Violent Crime',
        call_time: Time.now,
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
        year: 2023
      )
    end

    it 'creates a new call log' do
      call = Call.new(valid_attributes)
      expect(call).to be_valid
    end
  end

  describe 'reading call logs' do
    let!(:call1) { create(:call, incident_number: '123456') }
    let!(:call2) { create(:call, incident_number: '789012') }

    it 'reads all call logs' do
      expect(Call.all.count).to eq(2)
    end
  end

  describe '.log!' do
    let(:call_json) do
      attributes_for(:call).merge(
        incident_number: '654321',
        call_type: 'Burglary',
        call_type_group: 'Property Crime',
        street: '123 Main St',
        drug_related: true
      )
    end

    it 'creates a new call log from json' do
      expect { Call.log!(call_json) }.to change { Call.count }.by(1)
      call = Call.last
      expect(call.incident_number).to eq('654321')
      expect(call.call_type).to eq('Burglary')
      expect(call.call_type_group).to eq('Property Crime')
      expect(call.street).to eq('123 Main St')
      expect(call.drug_related).to be true
    end
  end

  describe '.full_list' do
    before do
      create_list(:call, 2)
    end

    it 'returns all call logs as json by default' do
      json = Call.full_list
      expect(json).to be_a(String)
      calls = JSON.parse(json)
      expect(calls.count).to eq(2)
      expect(calls.first.keys).to match_array(Call.column_names)
    end

    it 'returns all call logs as csv' do
      csv = Call.full_list(format: :csv)
      expect(csv).to be_a(String)
      rows = csv.split("\n")
      expect(rows.count).to eq(3) # header + 2 rows
      expect(rows.first.split(',')).to match_array(Call.column_names)
    end

    it 'raises an error for invalid format' do
      expect { Call.full_list(format: :invalid) }.to raise_error(ArgumentError)
    end
  end
end