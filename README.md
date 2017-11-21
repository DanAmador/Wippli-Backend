
# User
     GET        /api/users                                     
     GET        /api/users/:id                                 
     POST       /api/users  Required: nickname Optional: telegram_id, phone
     PUT/PATCH  /api/users/:id                                 
     DELETE     /api/users/:id                                 
   

# Zone 
      GET       /api/zones                                    
      GET       /api/zones/:id                                 
      POST      /api/zones Required: user_id, password
      PATCH/PUT /api/zones/:id Required: old_password, user_id, new_password
      DELETE    /api/zones/:id                                 

# Participants in Zone
     Required: zone_id, user_id 
     POST    /api/zones/:zone_id/participants/:user_id      
     DELETE  /api/zones/:zone_id/participants/:user_id/:id  

# Song Requests  
    Required: user_id, song_url 
    POST    /api/zones/requests 
    
# Votes
    Required: request_id, user_id, rating (integer)
    POST    /api/requests/:request_id
