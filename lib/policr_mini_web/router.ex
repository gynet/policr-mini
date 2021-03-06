defmodule PolicrMiniWeb.Router do
  use PolicrMiniWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :admin do
    plug PolicrMiniWeb.TokenAuthentication, from: :page
    plug :put_layout, {PolicrMiniWeb.LayoutView, :admin}
  end

  pipeline :admin_api do
    plug :accepts, ["json"]
    plug PolicrMiniWeb.TokenAuthentication, from: :api
  end

  scope "/api", PolicrMiniWeb.API do
    pipe_through :api

    get "/index", IndexController, :index
  end

  scope "/admin/api", PolicrMiniWeb.Admin.API do
    pipe_through [:admin_api]

    get "/chats", ChatController, :index
    get "/chats/:id/photo", ChatController, :photo
    get "/chats/:id/customs", ChatController, :customs
    get "/chats/:id/scheme", ChatController, :scheme
    put "/chats/:chat_id/scheme", ChatController, :update_scheme
    put "/chats/:chat_id/takeover", ChatController, :change_takeover

    post "/customs", CustomKitController, :add
    put "/customs/:id", CustomKitController, :update
    delete "/customs/:id", CustomKitController, :delete

    get "/logs", LogController, :index
  end

  scope "/admin", PolicrMiniWeb.Admin do
    pipe_through [:browser, :admin]

    get "/*path", PageController, :index
  end

  scope "/", PolicrMiniWeb do
    pipe_through :browser

    get "/*path", PageController, :index
  end
end
