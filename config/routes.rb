Rails.application.routes.draw do
  root 'static#index'
  post 'distributor_permission' => 'static#distributor_permission'
end
