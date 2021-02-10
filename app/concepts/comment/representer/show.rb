module Comment::Representer
  class Show < Base::Representer::JsonApiResource
    include Roar::JSON::JSONAPI.resource :comments

    link(:self) { api_v1_comment_url(represented.id) if represented.persisted? }

    attributes do
      property :body
      property :attachment
    end
  end
end
