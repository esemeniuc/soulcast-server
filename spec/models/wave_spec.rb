require 'rails_helper'

RSpec.describe Wave, type: :model do
  it "is valid with valid attributes" do
    wave1 = Wave.new(castVoice: {epoch: 12345, s3Key: "12345677"},
                     callerVoice:{epoch: 12345, s3Key: "12345677"},
                     replyVoice: {epoch: 12345, s3Key: "12345677"},
                     casterToken: "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB",
                     callerToken: "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
                     type: "call",
                     epoch: 1234567)
    expect(wave1).to be_valid
  end
  it "is not valid without a castVoice, invalid without casterToken, invalid without callerToken" do
    wave2 = Wave.new(castVoice: nil,
                     callerVoice:{epoch: 12345, s3Key: "12345677"},
                     replyVoice: {epoch: 12345, s3Key: "12345677"},
                     casterToken: "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB",
                     callerToken: "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
                     type: "call",
                     epoch: 1234567)
    wave3 = Wave.new(castVoice: {epoch: 12345, s3Key: "12345677"},
                     callerVoice:{epoch: 12345, s3Key: "12345677"},
                     replyVoice: {epoch: 12345, s3Key: "12345677"},
                     casterToken: nil,
                     callerToken: "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
                     type: "reply",
                     epoch: 1234567)
    wave4 = Wave.new(castVoice: {epoch: 12345, s3Key: "12345677"},
                     callerVoice:{epoch: 12345, s3Key: "12345677"},
                     replyVoice: {epoch: 12345, s3Key: "12345677"},
                     casterToken: "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB",
                     callerToken: nil,
                     type: "call",
                     epoch: 1234567)

    expect(wave2).to_not be_valid
    expect(wave3).to_not be_valid
    expect(wave4).to_not be_valid
  end

  it "is valid without a callVoice" do
    wave1 = Wave.new(castVoice: {epoch: 12345, s3Key: "12345677"},
                     callerVoice: nil,
                     replyVoice: {epoch: 12345, s3Key: "12345677"},
                     casterToken: "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB",
                     callerToken: "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
                     type: "call",
                     epoch: 1234567)
    wave2 = Wave.new(castVoice: {epoch: 12345, s3Key: "12345677"},
                     callerVoice: {epoch: 12345, s3Key: "12345677"},
                     replyVoice: nil,
                     casterToken: "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB",
                     callerToken: "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
                     type: "call",
                     epoch: 1234567)

    expect(wave1).to be_valid
    expect(wave2).to be_valid
  end
  it "is not valid without a type" do
    wave1 = Wave.new(castVoice: {epoch: 12345, s3Key: "12345677"},
                     callerVoice:{epoch: 12345, s3Key: "12345677"},
                     replyVoice: {epoch: 12345, s3Key: "12345677"},
                     casterToken: "BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB",
                     callerToken: "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
                     type: nil,
                     epoch: 1234567)

    expect(wave1).to_not be_valid
  end
end
