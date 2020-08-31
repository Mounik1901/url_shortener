Rails.application.routes.draw do
  get 'url_shortener/index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: "url_shorteners#index"

  resources :url_shorteners
  get "/stats", to: "url_shorteners#stats"
  get "/:identifier", to: "url_shorteners#redirect_to_original_url"
end
