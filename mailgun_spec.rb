require './mailgun'

describe Mailgun do
  describe "#send_mail" do
  	it "should send mail" do
  		response = Mailgun.send_mail('mangala <mangala176@gmail.com>')
  		expect(response.code).to eq(200)
  		response = JSON.parse(response.body)
  		expect(response).to have_key('id')
  		expect(response).to have_key('message')
  		expect(response['message']).to eq('Queued. Thank you.')
	  end
  end

  describe "#detect_suppression_email" do
    it "Detect if an email address is listed in a suppressions list" do
      suppression_email_list = Mailgun.detect_suppression_email('bkotu6717@gmail.com')
      if suppression_email_list == []
        expect(suppression_email_list).to_not include("bkotu6717@gmail.com")
      else
        expect(suppression_email_list).to include("bkotu6717@gmail.com")
      end
    end
  end
  
  describe "#previously_sent_emails" do
    it "Get the list of previously sent emails to an email address" do
      previously_sent_emails_list = Mailgun.previously_sent_emails('mangala <mangala176@gmail.com>')
      # array previously_sent_emails_list has collection of emails that has been delivered to recipient mangala176@gmail.com
      if previously_sent_emails_list == []
        expect(previously_sent_emails_list).to be_empty
        expect(previously_sent_emails_list).to_not include("mangala <mangala176@gmail.com>")
      else
        expect(previously_sent_emails_list).not_to be_empty
        expect(previously_sent_emails_list).to include("mangala <mangala176@gmail.com>")
      end
    end
  end
end