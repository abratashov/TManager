ActiveModelSerializers.config.adapter = :json_api

# https://github.com/rails-api/active_model_serializers/issues/1027
api_mime_types = %W(
  application/vnd.api+json
  text/x-json
  application/json
)
Mime::Type.register 'application/vnd.api+json', :json, api_mime_types
