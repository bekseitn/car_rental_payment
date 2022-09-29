class PaymentClient::SberBank
  def new(payment)
    @payment = payment
  end

  def process_payment
    request = {
      request: {
        payment_id: @payment.id,
        amount: @payment.amount,
        token: generate_enc_token
      }
    }

    response = {
      status: "complete",
      answer: "Money reseived"
    }

    @payment.update(status: response.status)
  end

  def generate_enc_token
    Digest::SHA1.hexdigest([@payment.id, @payment.amount].join)
  end
end
