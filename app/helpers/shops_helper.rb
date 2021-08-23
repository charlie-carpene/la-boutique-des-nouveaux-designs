module ShopsHelper
    def stripe_oauth_url(session_csrf_token)
        url = "https://connect.stripe.com/oauth/authorize"
        redirect_uri = stripe_connect_url
        client_id = ENV['CLIENT_ID']
        state = session_csrf_token

        "#{url}?response_type=code&redirect_uri=#{redirect_uri}&client_id=#{client_id}&scope=read_write&state=#{state}"
    end    
end
