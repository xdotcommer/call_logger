# Call Logger Service

A Ruby on Rails service that persistently stores emergency service call information. This service provides a reliable storage and retrieval system for emergency call data with a focus on data integrity and accessibility.

## Overview

The Call Logger Service is a Rails-based system that:
- Logs detailed emergency call information
- Provides call history retrieval
- Maintains data persistence
- Offers RESTful API endpoints for call data management

## Requirements

- Ruby 3.3.0
- Rails 8.x
- PostgreSQL
- Bundler

## Installation

1. Clone the repository:
```bash
git clone https://github.com/xdotcommer/call_logger
cd call_logger
```

2. Install dependencies:
```bash
bundle install
```

3. Database setup:
```bash
rails db:create
rails db:migrate
```

## Database Schema

The service uses a PostgreSQL database with the following structure:

```ruby
create_table "calls", force: :cascade do |t|
  t.string   "incident_number"
  t.string   "call_type"
  t.string   "call_type_group"
  t.datetime "call_time"
  t.string   "street"
  t.string   "call_origin"
  t.boolean  "mental_health"
  t.boolean  "drug_related"
  t.boolean  "dv_related"
  t.boolean  "alcohol_related"
  t.string   "area"
  t.string   "area_name"
  t.decimal  "latitude"
  t.decimal  "longitude"
  t.string   "hour"
  t.string   "day_of_week"
  t.integer  "ward"
  t.string   "district"
  t.string   "priority"
  t.string   "month"
  t.integer  "year"
  t.string   "apco_code"        # APCO standardized code
  t.string   "apco_description" # APCO incident description
  t.text     "apco_notes"      # Additional APCO-related notes
  t.timestamps
end
```

The APCO fields provide standardized emergency response information:
- `apco_code`: The standardized APCO incident type code
- `apco_description`: Official APCO description of the incident type
- `apco_notes`: Additional context or instructions for the incident type

This allows the service to maintain both the original call information and its standardized APCO classification.

## API Endpoints

### Health Check
```http
GET /health
```
Returns service health status.

Response:
```json
{
  "status": "ok"
}
```

### Log a Call
```http
POST /calls
```

Records a new emergency service call.

Example Request:
```json
{
  "call": {
    "incident_number": "22BU000002",
    "call_type": "Welfare Check",
    "call_type_group": "Public Service",
    "call_time": "2021-12-31T20:08:55-05:00",
    "street": "Main St",
    "call_origin": "911",
    "mental_health": false,
    "drug_related": false,
    "dv_related": false,
    "alcohol_related": false,
    "area": "Downtown",
    "area_name": "Central District",
    "latitude": 44.475410,
    "longitude": -73.197113,
    "hour": "1 am",
    "day_of_week": "Saturday",
    "ward": 8,
    "district": "East",
    "priority": "Priority 2",
    "month": "January",
    "year": 2022,
    "apco_code": "101",
    "apco_description": "Medical Emergency",
    "apco_notes": "Requires immediate response"
  }
}
```

Success Response (201 Created):
```json
{
  "id": 1,
  "incident_number": "22BU000002",
  "call_type": "Welfare Check",
  // ... other fields as above ...
}
```

Error Response (422 Unprocessable Entity):
```json
{
  "errors": {
    "incident_number": ["can't be blank"],
    "call_type": ["can't be blank"]
  }
}
```

### Retrieve All Calls
```http
GET /calls
```
Returns a list of all logged calls.

Response:
```json
[
  {
    "id": 1,
    "incident_number": "22BU000002",
    "call_type": "Welfare Check",
    // ... all call fields ...
  },
  {
    "id": 2,
    "incident_number": "22BU000003",
    // ... all call fields ...
  }
]
```

### Retrieve Latest Call Time
```http
GET /calls/last_call_time
```
Returns the timestamp of the most recent call.

Response:
```json
"2021-12-31T20:08:55-05:00"
```

### Retrieve Call by Incident Number
```http
GET /calls/:incident_number
```

Example Request:
```http
GET /calls/22BU000002
```

Success Response:
```json
{
  "id": 1,
  "incident_number": "22BU000002",
  "call_type": "Welfare Check",
  // ... all call fields ...
}
```

Error Response (404 Not Found):
```json
{
  "error": "Call not found"
}
```

### API Error Responses

The API may return the following status codes:

- `200 OK`: Successful GET request
- `201 Created`: Successful POST request
- `400 Bad Request`: Invalid request format
- `404 Not Found`: Resource not found
- `422 Unprocessable Entity`: Validation errors
- `500 Internal Server Error`: Server error

All error responses follow this format:
```json
{
  "error": "Error message" // or
  "errors": {
    "field_name": ["error messages"]
  }
}
```

### Health Check
```http
GET /health
```
Returns service health status.

Response:
```json
{
  "status": "ok"
}
```

### Log a Call
```http
POST /calls
```

Records a new emergency service call.

Example Request:
```json
{
  "call": {
    "incident_number": "22BU000002",
    "call_type": "Welfare Check",
    "call_type_group": "Public Service",
    "call_time": "2021-12-31T20:08:55-05:00",
    "street": "Main St",
    "call_origin": "911",
    "mental_health": false,
    "drug_related": false,
    "dv_related": false,
    "alcohol_related": false,
    "area": "Downtown",
    "area_name": "Central District",
    "latitude": 44.475410,
    "longitude": -73.197113,
    "hour": "1 am",
    "day_of_week": "Saturday",
    "ward": 8,
    "district": "East",
    "priority": "Priority 2",
    "month": "January",
    "year": 2022
  }
}
```

### Retrieve Calls
```http
GET /calls
```
Returns a list of logged calls.

## Development

1. Set up your development environment:
```bash
bundle install
rails db:setup
```

2. Run the test suite:
```bash
bundle exec rspec
```

3. Start the server:
```bash
rails server -p 3333
```

The service will be available at `http://localhost:3333`

## Configuration

Create a `config/database.yml`:
```yaml
default: &default
  adapter: postgresql
  encoding: unicode
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>

development:
  <<: *default
  database: call_logger_development

test:
  <<: *default
  database: call_logger_test

production:
  <<: *default
  database: call_logger_production
  username: call_logger
  password: <%= ENV['CALL_LOGGER_DATABASE_PASSWORD'] %>
```

## Testing

The project uses RSpec for testing. Run the test suite:

```bash
bundle exec rspec
```

Tests cover:
- Model validations
- API endpoints
- Data integrity
- Error handling

## Docker Support

1. Build the image:
```bash
docker-compose build
```

2. Run the services:
```bash
docker-compose up
```

## Error Handling

The service handles:
- Invalid call data
- Database constraints
- Duplicate incidents
- API request validation

## Data Management

Backup database:
```bash
rails db:dump
```

Import call data:
```bash
rails calls:import
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Related Services

- [CAD Call Simulator](https://github.com/xdotcommer/cad-call-simulator) - A Python tool for simulating incident data
- [Call Service](https://github.com/xdotcommer/call_service) - Main call processing service
- [APCO Service](https://github.com/xdotcommer/apco_incident_types_service) - APCO code lookup service
- [Call Logger](https://github.com/xdotcommer/call_logger) - Persistent storage service for emergency call data

This microservices ecosystem provides a complete solution for:
- Simulating emergency calls (CAD Call Simulator)
- Processing and routing calls (Call Service)
- Standardizing call types (APCO Service)
- Storing call history (Call Logger)

## Acknowledgments

- APCO International for standardized incident type codes
- Redis community for the robust in-memory data store
- Ruby on Rails community
