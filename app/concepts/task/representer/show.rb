module Task::Representer
  class Show < Base::Representer::JsonApiResource
    include Roar::JSON::JSONAPI.resource :tasks

    link(:self) { api_v1_task_url(represented.id) if represented.persisted? }

    attributes do
      property :name
      property :deadline
      property :position
      property :done
      property :comments_count
    end
  end
end
