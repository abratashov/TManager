module Api
  module V1
    class CommentResource < JSONAPI::Resource
      include Rails.application.routes.url_helpers

      attributes :body, :attachment

      def custom_links(_)
        { self: api_v1_comment_url(@model) } if @model.persisted?
      end
    end
  end
end
