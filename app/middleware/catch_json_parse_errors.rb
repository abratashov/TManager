# https://robots.thoughtbot.com/catching-json-parse-errors-with-custom-middleware

class CatchJsonParseErrors
  def initialize(app)
    @app = app
  end

  def call(env)
    @app.call(env)
  rescue ActionDispatch::Http::Parameters::ParseError => error
    return [
      400, { 'Content-Type' => 'application/json' },
      [{ errors: [error] }.to_json]
    ]
  end

  private

    def error_body(error)
      {
        title: "There was a problem in the JSON you submitted: #{error}",
        code: 'Error',
        status: 400
      }
    end
end
