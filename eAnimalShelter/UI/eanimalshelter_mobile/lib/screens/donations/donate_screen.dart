import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
import 'package:provider/provider.dart';

import '../../models/create_payment_intent_request.dart';
import '../../providers/donation_provider.dart';
import 'my_donations_screen.dart';
import 'dart:io';

class DonateScreen extends StatefulWidget {
  const DonateScreen({super.key});

  @override
  State<DonateScreen> createState() =>
      _DonateScreenState();
}

class _DonateScreenState
    extends State<DonateScreen> {
  final _amountController =
      TextEditingController();

  final _noteController =
      TextEditingController();

  final _formKey =
      GlobalKey<FormState>();

  bool _loading = false;

  Future<void> _pay() async {
    if (Platform.isWindows) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Stripe payments are available only on Android and iOS.",
        ),
      ),
    );
    return;
  }
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final confirm =
        await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title:
            const Text("Confirm payment"),
        content: Text(
          "Are you sure you want to donate €${double.parse(_amountController.text).toStringAsFixed(2)} ?",
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () =>
                Navigator.pop(context, true),
            child: const Text("Pay"),
          )
        ],
      ),
    );

    if (confirm != true) {
      return;
    }

    try {
      setState(() {
        _loading = true;
      });

      final provider =
          context.read<DonationProvider>();

      final paymentIntent =
          await provider.createPaymentIntent(
        CreatePaymentIntentRequest(
          amount: double.parse(
            _amountController.text,
          ),
          note: _noteController.text.trim(),
        ),
      );

      await stripe.Stripe.instance.initPaymentSheet(
        paymentSheetParameters:
            stripe.SetupPaymentSheetParameters(
          merchantDisplayName:
              "eAnimalShelter",
          paymentIntentClientSecret:
              paymentIntent.clientSecret,
        ),
      );

      await stripe.Stripe.instance.presentPaymentSheet();

      await provider.confirmPayment(
        paymentIntent.donationId,
      );

      if (!mounted) return;

      await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          icon: const Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 60,
          ),
          title:
              const Text("Payment sent"),
          content: const Text(
            "Your payment has been sent successfully.\n\nThe donation will appear after Stripe confirms the payment.",
            textAlign: TextAlign.center,
          ),
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.pop(context);

                _amountController.clear();
                _noteController.clear();
              },
              child: const Text("OK"),
            )
          ],
        ),
      );
    } on stripe.StripeException catch (e) {
      if (!mounted) return;

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text(
              "Payment cancelled"),
          content: Text(
            e.error.localizedMessage ??
                "Payment cancelled.",
          ),
          actions: [
            FilledButton(
              onPressed: () =>
                  Navigator.pop(context),
              child: const Text("OK"),
            )
          ],
        ),
      );
    } catch (e) {
      if (!mounted) return;

      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Error"),
          content: Text(e.toString()),
          actions: [
            FilledButton(
              onPressed: () =>
                  Navigator.pop(context),
              child: const Text("OK"),
            )
          ],
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text("Donate"),
        actions: [
          IconButton(
            tooltip: "My Donations",
            icon: const Icon(
              Icons.receipt_long,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      const MyDonationsScreen(),
                ),
              );
            },
          )
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.all(20),
            child: Card(
              elevation: 4,
              shape:
                  RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(
                        20),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .stretch,
                  children: [
                    const Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 70,
                    ),
                    const SizedBox(
                        height: 15),
                    Text(
                      "Support our animals",
                      textAlign:
                          TextAlign.center,
                      style: Theme.of(
                              context)
                          .textTheme
                          .headlineSmall,
                    ),
                    const SizedBox(
                        height: 8),
                    const Text(
                      "Every donation helps us provide food, shelter and medical care.",
                      textAlign:
                          TextAlign.center,
                    ),
                    const SizedBox(
                        height: 30),
                    TextFormField(
                      controller:
                          _amountController,
                      keyboardType:
                          const TextInputType.numberWithOptions(
                              decimal: true),
                      decoration:
                          const InputDecoration(
                        labelText:
                            "Amount (€)",
                        prefixIcon: Icon(
                            Icons.euro),
                        border:
                            OutlineInputBorder(),
                      ),
                      validator:
                          (value) {
                        if (value == null ||
                            value
                                .trim()
                                .isEmpty) {
                          return "Amount is required";
                        }

                        final amount =
                            double.tryParse(
                                value);

                        if (amount ==
                            null) {
                          return "Invalid amount";
                        }

                        if (amount <= 0) {
                          return "Amount must be greater than 0";
                        }

                        if (amount >
                            5000) {
                          return "Maximum donation is €5000";
                        }

                        return null;
                      },
                    ),
                    const SizedBox(
                        height: 20),
                    TextFormField(
                      controller:
                          _noteController,
                      maxLines: 4,
                      maxLength: 500,
                      decoration:
                          const InputDecoration(
                        labelText:
                            "Note (optional)",
                        alignLabelWithHint:
                            true,
                        prefixIcon:
                            Icon(Icons.note),
                        border:
                            OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                        height: 30),
                                        SizedBox(
                      height: 55,
                      child: FilledButton.icon(
                        onPressed:
                            _loading ? null : _pay,
                        icon: _loading
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child:
                                    CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(
                                Icons.payment,
                              ),
                        label: Text(
                          _loading
                              ? "Processing..."
                              : "PAY NOW",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}