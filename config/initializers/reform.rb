require 'dry/validation/messages/i18n'
require 'reform'
require 'reform/form/dry'
require 'reform/form/coercion'

Rails.application.config.reform.validations = :dry

Reform::Form.class_eval do
  feature Reform::Form::Dry
end
