module Base::Representer
  class JsonApiResource < Roar::Decorator
    include Roar::JSON::JSONAPI.resource :projects
    include Rails.application.routes.url_helpers
  end
end
