require 'rest-client' #gem install rest-client, gem install byebug, #use ruby version > 1.9.3
require 'pry'
require 'json'
require 'yaml'
require 'thread'  # for Mutex


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

    urls.each do |u|
      Thread.new do
        u['content'] = RestClient.get(u['link']){|response, request, result| response }
        puts "Successfully requested #{u['link']}"
        data = JSON.parse(response.body)
        (suppression_email_list << email_id) if response.code == 200
        if urls.all? {|u| u.has_key?("content") }
          puts "Fetched all urls!"
          exit
        end
      end
      sleep 3
    end
     # Check email address is listed in a suppressions list
      # if suppression_email_list.present?
      #   puts "#{email_id} address found in suppression list"
        # return true
      # else
      #   puts "#{email_id} Address not found in suppression list"
        # return false
      # end
    rescue Exception => e
      puts "Exception raised send_mail:" + e.class.to_s
      puts e.message
    end
    suppression_email_list
  end

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