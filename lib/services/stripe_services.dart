import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:newone/config.dart';

class StripeService {
  // Singleton instance
  StripeService._();
  static final StripeService instance = StripeService._();
  factory StripeService() => instance;

  // Stripe secret key (replace with your actual secret key)
  static const String _secretKey = stripeSecretKey;

  Future<String> _createPaymentIntent(int amount, String currency) async {
    try {
      final url = Uri.parse('https://api.stripe.com/v1/payment_intents');
      final headers = {
        'Authorization': 'Bearer $_secretKey',
        'Content-Type': 'application/x-www-form-urlencoded',
      };
      final body = {
        'amount': _calculateAmount(amount), // Amount in cents
        'currency': currency,
        'payment_method_types[]': 'card',
      };

      final response = await http.post(
        url,
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['client_secret']; // Return the client secret
      } else {
        throw Exception('Failed to create payment intent: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error creating payment intent: $e');
    }
  }

  // Convert amount to cents
  String _calculateAmount(int amount) {
    return (amount * 100).toString();
  }

  // Initialize and present the payment sheet
  Future<void> makePayment({required int amount, required String currency}) async {
    try {
      // 1. Create a payment intent and get the client secret
      final clientSecret = await _createPaymentIntent(amount, currency);

      // 2. Initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'TRAVO',
          // Optional: Add customer details if needed
          // customerId: 'customer_id',
          // customerEphemeralKeySecret: 'ephemeral_key',
        ),
      );

      // 3. Present the payment sheet to the user
      await Stripe.instance.presentPaymentSheet();

      // 4. If the payment is successful, this line will be reached
      print('Payment successful!');
    } catch (e) {
      if (e is StripeException) {
        print('Stripe error: ${e.error.localizedMessage}');
      } else {
        print('Error making payment: $e');
      }
      rethrow; // Rethrow the error to handle it in the UI
    }
  }
}
