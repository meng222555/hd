module ApplicationHelper
  def prepend_url_path ( options={}) # expects keys :url and :prepend_with
    url = options[:url]
    uri = URI::parse( url)

    scheme = uri.scheme # https
    host = uri.host # minghuei.com.sg
    port = uri.port.to_s # 4300
    path = uri.path # /users/password/edit.5
    querystring = uri.query # reset_password_token=73JvjBZrMQmRMDxsmSEU

    url_with_path_prepended = scheme + '://' + host + ':' + port + '/' + options[:prepend_with] + path + "#{querystring.blank? ? '' : '?' + querystring }"
  end
end
