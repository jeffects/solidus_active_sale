Spree::Core::Engine.routes.draw do
  # Add your extension routes here
  namespace :admin do
    resources :active_sales do
      collection do
        get  :products
        post :update_positions
      end
      member do
        get :get_children
      end
      resources :active_sale_events do
        member do
          put :update_events
        end
        resources :sale_images do
          collection do
            post :update_positions
          end
        end
      end
    end
  end
end
