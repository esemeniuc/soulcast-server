require 'rails_helper'

RSpec.describe WavesController, type: :controller do

  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  # describe "GET #create" do
  #   it "returns http success" do
  #     get :create
  #     expect(response).to have_http_status(:success)
  #   end
  # end

  before(:each) do
    DatabaseCleaner.clean_with(:truncation, reset_ids: true)
    @dev1 = Device.create(token: "5e593e1133fa842384e92789c612ae1e1f217793ca3b48e4b0f4f39912f61104",
                          latitude: 50,
                          longitude: -100,
                          radius: 20.0,
                          os: "ios")

    @dev2 = Device.create(token: "30d89b9620d59f88350af570e7349472d8e02e54367f41825918e054fde792ad",
                          latitude: 50,
                          longitude: -100,
                          radius: 20.0,
                          os: "ios")

    @dev3 = Device.create(token: "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
                          latitude: 25,
                          longitude: -100,
                          radius: 20.0,
                          os: "ios")

    @dev4 = Device.create(token: "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB",
                          latitude: 75,
                          longitude: -100,
                          radius: 20.0,
                          os: "ios")

    @dev5 = Device.create(token: "CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC",
                          latitude: 60,
                          longitude: -100,
                          radius: 20.0,
                          os: "ios")

    @dev6 = Device.create(token:"dQb1nb_yE4A:APA91bEt5a-j61ufp09ImSVGrd9sXebq-uOHcdJ4TF6vTBgZO6scBVtPnewKP_TZb3LCxE_QF1M13HmC1rtqgg4Wo7Nm61JxDwmY-uBUlxLRBHnIC6NPoM9gS3bhUOU-UZKAnH2JxT4s",
                          latitude: 50,
                          longitude: -100,
                          radius: 20.0,
                          os: "android")
  end

  context 'Able to send wave from one device to another' do
    it 'should send a wave from device 1 to device 2' do
      ## At the moment see if creation works
      wave1 = Wave.new(castVoice: {epoch: 12345, s3Key: "12345677"},
                          callerVoice:{epoch: 12345, s3Key: "12345677"},
                          replyVoice: {epoch: 12345, s3Key: "12345677"},
                          casterToken: "5e593e1133fa842384e92789c612ae1e1f217793ca3b48e4b0f4f39912f61104",
                          callerToken: "30d89b9620d59f88350af570e7349472d8e02e54367f41825918e054fde792ad",
                          type: "call",
                          epoch: 1234567)
      expect(wave1).to be_valid
      wave1.echoBackWave()


    end

    it 'should reply a wave from device 2 to device 1' do
      wave2 = Wave.new(castVoice: {epoch: 12345, s3Key: "12345677"},
                          callerVoice:{epoch: 12345, s3Key: "12345677"},
                          replyVoice: {epoch: 12345, s3Key: "12345677"},
                          casterToken: "5e593e1133fa842384e92789c612ae1e1f217793ca3b48e4b0f4f39912f61104",
                          callerToken: "30d89b9620d59f88350af570e7349472d8e02e54367f41825918e054fde792ad",
                          type: "reply",
                          epoch: 1234567)

      expect(wave2).to be_valid
      wave2.echoBackWave()
    end

    it 'should call a wave from device 2 to device 1 with a callerVoice' do
      wave3 = Wave.new(castVoice: {epoch: 12345, s3Key: "12345677"},
                       callerVoice:{epoch: 12345, s3Key: "12345677"},
                       replyVoice: nil,
                       casterToken: "5e593e1133fa842384e92789c612ae1e1f217793ca3b48e4b0f4f39912f61104",
                       callerToken: "30d89b9620d59f88350af570e7349472d8e02e54367f41825918e054fde792ad",
                       type: "reply",
                       epoch: 1234567)

      expect(wave3).to be_valid
      wave3.echoBackWave()
    end

  end

end
