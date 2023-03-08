<%@ page import="com.twilio.Twilio" %>
<%@ page import="com.twilio.rest.api.v2010.account.Message" %>
<%@ page import="com.twilio.type.PhoneNumber" %>

<%
  // Your Account SID from twilio.com/console
  String accountSid = "AC62c73cca3bafc6fc4b04fe8553274fbe";
  // Your Auth Token from twilio.com/console
  String authToken = "12f70bb75606e860e9b59498ff053e7e";

  Twilio.init(accountSid, authToken);

  // The phone number to send the SMS to
  String toPhoneNumber = "+918086924467";

  // The phone number to send the SMS from (must be a Twilio phone number)
  String fromPhoneNumber = "+12706790885";

  // The message to send
  String messageText = "Hello, this is a test message from Twilio!";

//  Message message = Message.creator(new PhoneNumber(toPhoneNumber), new PhoneNumber(fromPhoneNumber), messageText).create();

  Message message = Message.creator(
    new PhoneNumber(toPhoneNumber),
    new PhoneNumber(fromPhoneNumber),
    "Sample Twilio SMS using Java")
.create();
  out.println("SMS sent!");
%>
