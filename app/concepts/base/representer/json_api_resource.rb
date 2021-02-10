module Base::Representer
  class JsonApiResource < Roar::Decorator
    include Rails.application.routes.url_helpers
  end
end
