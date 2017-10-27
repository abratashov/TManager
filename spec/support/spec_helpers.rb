# http://apionrails.icalialabs.com/book/chapter_four
module Spec
  module Helpers
    def json
      @json_response ||= JSON.parse(response.body, symbolize_names: true)
    end
  end
end

def fixture_file_uploader(filename)
  Rack::Test::UploadedFile.new(File.open(Rails.root.join('spec', 'fixtures', filename)))
end

# https://github.com/lynndylanhurley/devise_token_auth/issues/577
def token_sign_in(user)
  auth_headers = user.create_new_auth_token
  request.headers.merge!(auth_headers)
end

def factory_v1_json(filename)
  full_path = Rails.root.join('spec', 'support', 'json', 'api', 'v1', "#{filename}.json")
  JSON.parse(File.read(full_path))
end
