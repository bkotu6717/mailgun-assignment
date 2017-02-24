require 'rest-client'
require 'pry'
require 'json'
require 'yaml'
require 'thread'  # for Mutex


$cnf = YAML::load_file(File.join(__dir__, 'secrets.yml'))

module Mailgun
	def self.send_mail(mail_to)
    begin
      # Send mail
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

# just sample extra method - to add bounce email to suppression list, Even We can add manually in Mailgun site
  def add_bounce
    begin
      RestClient.post $cnf['mailgun']['apikey'] + $cnf['mailgun']['bounnces'],
                    :address => 'bkotu6717@gmail.com'
    rescue Exception => e
        puts "Exception raised add_bounce:" + e.class.to_s
        puts e.message
    end
  end

  def self.detect_suppression_email(email_id)
    begin
      suppression_email_list = []
        urls = [
        {'link' => $cnf['mailgun']['apikey'] + $cnf['mailgun']['bounnces'] + "/#{email_id}"},
        {'link' => $cnf['mailgun']['apikey'] + $cnf['mailgun']['unsubscribes'] + "/#{email_id}"},
        {'link' => $cnf['mailgun']['apikey'] + $cnf['mailgun']['complaints'] + "/#{email_id}"}
      ]
      # create thread to send a multiple request and get the suppression list for the types [bounnces, unsubscribes, complaints]
      urls.each do |u|
        Thread.new do
          RestClient.get(u['link']){|response, request, result| suppression_email_list << email_id  if response.code == 200}
            puts "Successfully requested #{u['link']}"
          end
        sleep 3
      end
      rescue Exception => e
        puts "Exception raised send_mail:" + e.class.to_s
        puts e.message
      end
      suppression_email_list
  end

  def self.previously_sent_emails(recipient)
  	previously_sent_emails_list = []
    begin
      # Get the mails which is delivered to recipient
      response =  RestClient.get $cnf['mailgun']['apikey'] + $cnf['mailgun']['get_events'],
        :params => {
          :limit       =>  25,
          :recipient => recipient
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