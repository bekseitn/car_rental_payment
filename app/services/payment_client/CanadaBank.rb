# Does not send a real request to the payment system, just simply imitates the behavior
class PaymentClient::CanadaBank
  def initialize(payment, payment_type)
    @payment = payment
    @payment_type = payment_type
  end

  def process_payment
    _request = OpenStruct.new(
      header: {},
      data: {
        payment_id: @payment.id,
        amount: @payment.amount,
        token: generate_enc_token,
        payment_type: @payment_type
      }
    )

    response = OpenStruct.new(
      status: "completed",
      header: {},
      body: "Money reseived"
    )

    @payment.update(status: response.status)
  end

  def generate_enc_token
    Digest::SHA1.hexdigest([@payment.id, @payment.amount].join)
  end
end