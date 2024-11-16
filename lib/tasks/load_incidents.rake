namespace :data do
  desc "Load incidents from CSV"
  task load: :environment do
    file_path = Rails.root.join('data', 'incidents.csv')
    
    unless File.exist?(file_path)
      puts "CSV file not found at #{file_path}"
      exit
    end

    puts "Starting to load incidents from CSV..."
    csv_data = File.read(file_path)
    csv = CSV.parse(csv_data, headers: true)

    csv.each_with_index do |row, index|
      begin
        call_time = Time.parse(row['call_time'])
        Call.create!(
          incident_number: row['incident_number'],
          call_type: row['call_type'],
          call_type_group: row['call_type_group'],
          call_time: call_time,
          street: row['Street'],
          call_origin: row['call_origin'],
          mental_health: row['mental_health'].present?,
          drug_related: row['drug_related'].present?,
          dv_related: row['dv_related'].present?,
          alcohol_related: row['alcohol_related'].present?,
          area: row['Area'],
          area_name: row['AreaName'],
          latitude: row['Latitude'].to_d,
          longitude: row['Longitude'].to_d,
          hour: row['Hour'].to_i,
          day_of_week: row['DayOfWeek'],
          ward: row['WARD'].present? ? row['WARD'].to_i : nil,
          district: row['DISTRICT'],
          priority: row['priority'],
          month: row['Month'].to_i,
          year: row['year'].to_i
        )
        puts "Successfully processed row #{index + 1}: #{row['incident_number']}"
      rescue StandardError => e
        puts "Failed to process row #{index + 1}: #{e.message}"
      end
    end

    puts "Incident data import completed."
  end
end

