Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'calls#index'
  namespace :api do
    match 'ivr_welcome' => 'twilio#ivr_welcome', via: [:post]
    match 'call_status_change' => 'twilio#call_status_change', via: [:post]
  end
end
