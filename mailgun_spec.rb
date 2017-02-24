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
    it "detect suppression email" do
      suppression_email_list = Mailgun.detect_suppression_email('bkotu6717@gmail.com')
      expect(suppression_email_list).to_not be_nil
      expect(suppression_email_list).to include("bkotu6717@gmail.com")
    end
  end 
  
end