# Car rental payment system

The current prototype allows you to pay for a car rental order initiated by the user. 
You can pay for the order in several parts in different currencies. 
When creating a payment request, the system selects the payment system and uses it to debit funds.
If the amount specified during the payment exceeds the order amount, the payment does not occur. 
The refund works the same way, but before paying, we check that the refund amount does not exceed the amount paid by the user. 
All payment systems do not make any real requests and simulate their work.

There is no public in the prototype, but you can check the work scenarios by looking at the tests in payment_request and payment_refund. 

Basic entities:

* User - the user in the system who can pay for the order.
* Car - rental product. You can replace it with anything else, as long as the price and currency attribute is specified
* Order - entity of the order linking the objects above. Also, when paying and returning, these objects will refer to this entity.
* Payment - parent class for payment and refund request objects. 
  Store almost all the basic logic, such as choosing a payment system, currency conversion, etc.
* PaymentRequest - request for payment of the order. 
  When creating, specify the amount and currency. It also has a status that changes at different stages of the payment life cycle.
* PaymentRefund - same as payment_request, but only performs a refund to the user.
* PaymentClient - namespace in which there are several service clients. 
