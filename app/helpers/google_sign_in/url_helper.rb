module GoogleSignIn::UrlHelper
  def callback_url
    GoogleSignIn::Engine.routes.url_helpers.callback_url(
      host: request.host_with_port, protocol: request.protocol
    )
  end
end
