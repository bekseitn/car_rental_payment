# Does not send a real request to the payment system, just simply imitates the behavior
class PaymentClient::USBank
  def initialize(payment)
    @payment = payment
  end

  def process_payment
    _request = OpenStruct.new(
      header: {},
      data: {
        payment_id: @payment.id,
        amount: @payment.amount,
        token: generate_enc_token
      }
    )

    response = OpenStruct.new(
      status: "success",
      header: {},
      body: "Money reseived"
    )

    @payment.update(status: response.status)
  end

  def generate_enc_token
    Digest::SHA1.hexdigest([@payment.id, @payment.amount].join)
  end
end
