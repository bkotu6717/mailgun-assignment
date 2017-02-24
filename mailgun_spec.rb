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
      response = Mailgun.detect_suppression_email('bkotu6717@gmail.com')
      binding.pry
      expect(suppression_email_list).not_to nil

      # response = JSON.parse(response.body)
      # expect(response).to have_key('id')
      # expect(response).to have_key('message')
      # expect(response['message']).to eq('Queued. Thank you.')
    end
  end 

end