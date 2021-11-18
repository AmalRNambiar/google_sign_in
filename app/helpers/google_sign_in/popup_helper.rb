module GoogleSignIn::PopupHelper
  def google_sign_in_popup(proceed_to:, **options)
    flash[:proceed_to] = proceed_to
    content_tag(
      :div, '',
      'id' => 'g_id_onload',
      'data-client_id' => GoogleSignIn.client_id,
      'data-context' => 'use',
      'data-login_uri' => callback_url,
      **options
    )
  end
end
