module Api
  module V1
    class TaskResource < JSONAPI::Resource
      include Rails.application.routes.url_helpers

      attributes :name, :deadline, :position, :done, :comments_count

      def custom_links(_)
        { self: api_v1_task_url(@model) } if @model.persisted?
      end
    end
  end
end
