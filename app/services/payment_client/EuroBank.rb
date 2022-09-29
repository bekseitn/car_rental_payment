class PaymentClient::EuroBank
  def initialize(payment)
    @payment = payment
  end

  def process_payment
    request = OpenStruct.new(
      payment_id: @payment.id,
      amount: @payment.amount,
      token: generate_enc_token
    )

    response = OpenStruct.new(
      status: "success",
      answer: "Money reseived"
    )

    @payment.update(status: response.status)
  end

  def generate_enc_token
    Digest::SHA1.hexdigest([@payment.id, @payment.amount].join)
  end
end
