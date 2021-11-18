GoogleSignIn::Engine.routes.draw do
  resource :authorization, only: :create
  resource :callback, only: %i[show create]
end
