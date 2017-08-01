require 'httparty'
require 'json'
require 'roadmap'

class Kele
  include HTTParty
  include Roadmap
  base_uri 'https://www.bloc.io/api/v1'

  def initialize(email, password)
    response = self.class.post('/sessions', body: { email: "#{email}", password: "#{password}" } )
    @auth_token = response["auth_token"]
    raise "ERROR: Wrong email or password." if @auth_token.nil?
  end

  def get_me
  	response = self.class.get('/users/me', headers: { "authorization" => @auth_token } )
  	JSON.parse(response.body)
  end

  def get_mentor_availability(mentor_id)
  	response = self.class.get("https://www.bloc.io/api/v1/mentors/#{mentor_id}/student_availability", headers: { "authorization" => @auth_token } )
  	@mentor_availability = JSON.parse(response.body)
  end

end