Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth'

  namespace :api do
    namespace :v1 do
      mount_devise_token_auth_for 'User', at: 'auth'

      jsonapi_resources :projects do
        jsonapi_resources :tasks do
          jsonapi_resources :comments, except: %i[show update]
        end
      end
      jsonapi_resources :tasks
      jsonapi_resources :comments, except: %i[show update]
    end
  end

  get '/apidocs' => redirect('/swagger/dist/index.html?url=/apidocs/api-docs.yml')
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
