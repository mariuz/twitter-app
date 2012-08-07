class SessionsController < ApplicationController
  def new
    @user = client.user if signed_in?
  end

  def create
    request_token = oauth_consumer.get_request_token(:oauth_callback => callback_url)
    session['request_token'] = request_token.token
    session['request_secret'] = request_token.secret
    redirect_to request_token.authorize_url
  end

  def destroy
    reset_session
    redirect_to new_session_path
  end

  def callback
    request_token = OAuth::RequestToken.new(oauth_consumer, session['request_token'], session['request_secret'])
    access_token = request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])
    reset_session
    session['access_token'] = access_token.token
    session['access_secret'] = access_token.secret
    user = client.verify_credentials
    sign_in(user)
    redirect_back_or root_path
  end
  
  
  def get_followers(username)  
    cursor = "-1"
    followerIds = []
    while cursor != 0 do
      followers = Twitter.follower_ids(username,{:cursor=>cursor})
      cursor = followers.next_cursor
      followerIds+= followers.ids
     # sleep(2)
      puts followers.ids
    end
  end
  def unfollow
    #users.each do |user|
    username = param[:username]       
    Twitter.follower_ids(username).ids.each do |user|
    #get_followers("BarackObama").each do |user|                   
      #Twitter.unfollow(user)
      puts user   
    end
    #end
    #Twitter.unfollow(@users)
    redirect_back_or root_path
  end 
  # https://support.twitter.com/groups/32-something-s-not-working/topics/117-following-problems/articles/66885-follow-limits-i-can-t-follow-people
  # Template::Error (DELETE https://api.twitter.com/1/friendships/destroy.json?user_id=306258358: 400: Rate limit exceeded. Clients may not make more than 350 requests per hour.)
  def follow
    username = 'firebirdsql'#param[:username]
    #Twitter.follow(@users)    
    Twitter.follower_ids(username).ids.each do |user|     
      #Twitter.follower_ids("recursive_bot").ids.each do |user|             
      #Twitter.follow(user)
      
      puts user    
      render :text => "alert('Finished')",
         :content_type => "text/javascript"
    end
  end
  
end
