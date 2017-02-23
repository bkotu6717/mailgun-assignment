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
end