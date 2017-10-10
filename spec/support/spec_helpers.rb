# http://apionrails.icalialabs.com/book/chapter_four
module Spec
  module Helpers
    def json
      @json_response ||= JSON.parse(response.body, symbolize_names: true)
    end
  end
end

def fixture_file_uploader(filename)
  Rack::Test::UploadedFile.new(File.open(File.join(Rails.root, "/spec/fixtures/#{filename}")))
end

# https://github.com/lynndylanhurley/devise_token_auth/issues/577
def token_sign_in(user)
  auth_headers = user.create_new_auth_token
  request.headers.merge!(auth_headers)
end
