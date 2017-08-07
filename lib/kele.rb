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

  def get_messages(page_number = nil)
  	if page_number == nil
  		response = self.class.get("https://www.bloc.io/api/v1/message_threads", headers: { "authorization" => @auth_token } )
  	else
  		response = self.class.get("https://www.bloc.io/api/v1/message_threads?page_number=#{page_number}", headers: { "authorization" => @auth_token } )
  	end
  	@messages = JSON.parse(response.body)
  end

  def create_message(user_id, recipient_id, token, subject, message)
  	response = self.class.post("https://www.bloc.io/api/v1/messages", 
  		body: {
  			user_id: user_id, 
  			recipient_id: recipient_id,
  			subject: subject,
  			message: message,
  			token: nil
  			}, 
  			headers: { "authorization" => @auth_token } )
  	puts response
  end

  def create_submission (checkpoint_id, assignment_branch, assignment_commit_link, comment, enrollment_id)
  	response = self.class.post("https://www.bloc.io/api/v1/checkpoint_submissions", 
  		body: {
  			checkpoint_id: checkpoint_id, 
  			assignment_branch: assignment_branch,
  			assignment_commit_link: assignment_commit_link,
  			comment: comment,
  			enrollment_id: enrollment_id
  			}, 
  			headers: { "authorization" => @auth_token } )
  	puts response
  end

end