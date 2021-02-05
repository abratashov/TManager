module Base::Representer
  class JsonApiCollection < Roar::Decorator
    include Representable::JSON::Collection

    self.representation_wrap = :data
  end
end
