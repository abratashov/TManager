module Project::Representer
  class Show < Base::Representer::JsonApiResource
    include Roar::JSON::JSONAPI.resource :projects

    link(:self) { api_v1_project_url(represented.id) if represented.persisted? }

    attributes do
      property :name
    end
  end
end
