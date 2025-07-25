# Rails.application.routes.draw do
#   # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
#
#   # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
#   # Can be used by load balancers and uptime monitors to verify that the app is live.
#   get "up" => "rails/health#show", as: :rails_health_check
#
#   # Defines the root path route ("/")
#   # root "posts#index"
# end

Rails.application.routes.draw do
  resources :products
  resource :basket, only: [:show] do
    post 'add_item/:product_id', to: 'baskets#add_item', as: :add_item
    delete 'remove_item/:id', to: 'baskets#remove_item', as: :remove_item
    get 'checkout', to: 'baskets#checkout'
    post 'complete_purchase', to: 'baskets#complete_purchase'
  end

  get 'order_confirmation/:order_id', to: 'baskets#order_confirmation', as: :order_confirmation
  get 'my_orders', to: 'baskets#orders', as: :my_orders

  root 'products#index'
  get '/.well-known/appspecific/com.chrome.devtools.json', to: ->(env) { [404, {}, ['']] }
end