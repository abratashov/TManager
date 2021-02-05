module Project::Contract::Base
  include Reform::Form::Module

  property :name

  validation name: :unique, if: :default, with: {form: true}  do
    configure do
      config.messages_file = 'app/concepts/project/locales/errors.yml'

      def unique?(name)
        Project.where.not(id: form.model.id).where(name: name, user_id: form.model.user_id).empty?
      end
    end

    required(:name).filled(:unique?)
  end
end
