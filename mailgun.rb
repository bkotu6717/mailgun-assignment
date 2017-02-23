require 'rest-client' #gem install rest-client, gem install byebug, #use ruby version > 1.9.3
require 'pry'
require 'json'
require 'yaml'

$cnf = YAML::load_file(File.join(__dir__, 'secrets.yml'))

module Mailgun
	def self.send_mail(mail_to)
    begin
      RestClient.post $cnf['mailgun']['apikey'] + $cnf['mailgun']['post_domain'],
        :from => $cnf['mailgun']['from'],
        :to => mail_to,
        :subject => "Hello mangala",
        :id => "11",
        :text => "Congratulations mangala, you just sent an email with Mailgun!  You are truly awesome!  You can see a record of this email in your logs: https://mailgun.com/cp/log .  You can send up to 300 emails/day from this sandbox server.  Next, you should add your own domain so you can send 10,000 emails/month for free."
    rescue Exception => e
      puts "Exception raised send_mail:" + e.class.to_s
      puts e.message
    end
  
  end

# def detect_suppression_email

# end

# def get_bounces
#   RestClient.get "https://api:YOUR_API_KEY"\
#   "@api.mailgun.net/v3/YOUR_DOMAIN_NAME/bounces"
# end

# def get_unsubscribes
#   RestClient.get "https://api:YOUR_API_KEY"\
#   "@api.mailgun.net/v3/YOUR_DOMAIN_NAME/unsubscribes"
# end
# def get_complaints
#   RestClient.get "https://api:YOUR_API_KEY"\
#   "@api.mailgun.net/v3/YOUR_DOMAIN_NAME/complaints"
# end


  def self.previously_sent_emails  #looks like this is not correct, should check
  	previously_sent_emails_list = []
    begin
      response =  RestClient.get $cnf['mailgun']['apikey'] + $cnf['mailgun']['get_domain'],
        :params => {
          :limit       =>  25,
          :recipient => 'mangala <mangala176@gmail.com>'
        }

      data = JSON.parse(response.body)
      data["items"].map{|item| previously_sent_emails_list << item['message']['headers']['to']}
      previously_sent_emails_list
    rescue Exception => e
      puts "Exception raised previously_sent_emails:  " + e.class.to_s
      puts e.http_body
    end
  end
end