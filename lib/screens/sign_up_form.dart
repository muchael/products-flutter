
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:intl/intl.dart' as intl;

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign up'),
      ),
      body: Form(
        key: _formKey,
        child: Scrollbar(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: AutofillGroup(
              child: Column(
                children: [
                  ...[
                    TextFormField(
                      autofocus: true,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        hintText: 'Jane',
                        labelText: 'Name',
                      ),
                      autofillHints: const [AutofillHints.givenName],
                    ),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        hintText: 'Doe',
                        labelText: 'Last Name',
                      ),
                      autofillHints: const [AutofillHints.familyName],
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        labelText: 'CPF',
                      ),
                      inputFormatters: [
                        // obrigatório
                        FilteringTextInputFormatter.digitsOnly,
                        CpfInputFormatter(),
                      ],
                    ),
                    const TextField(
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        hintText: 'foo@example.com',
                        labelText: 'Email',
                      ),
                      autofillHints: [AutofillHints.email],
                    ),
                    const TextField(
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                      ),
                    ),
                    _FormDatePicker(
                      date: date,
                      onChanged: (value) {
                        setState(() {
                          date = value;
                        });
                      },
                    ),
                    const TextField(
                      keyboardType: TextInputType.streetAddress,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        hintText: '123 4th Ave',
                        labelText: 'Street Address',
                      ),
                      autofillHints: [AutofillHints.streetAddressLine1],
                    ),
                    const TextField(
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        hintText: '12345',
                        labelText: 'Postal Code',
                      ),
                      autofillHints: [AutofillHints.postalCode],
                    ),
                    const TextField(
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        hintText: 'United States',
                        labelText: 'Country',
                      ),
                      autofillHints: [AutofillHints.countryName],
                    ),
                    const TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: '1',
                        labelText: 'Country Code',
                      ),
                      autofillHints: [AutofillHints.countryCode],
                    ),
                    Container(
                      height: 50,
                      width: 250,
                      decoration: BoxDecoration(
                          color: Colors.blue, borderRadius: BorderRadius.circular(20)),
                      child: TextButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // print(nameController.text);
                            // print(difficultyController.text);
                            // print(imageController.text);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Login...'),
                              ),
                            );
                          }
                          // Navigator.push(
                          //     context, MaterialPageRoute(builder: (_) => HomePage()));
                        },
                        child: const Text(
                          'Sing Up',
                          style: TextStyle(color: Colors.white, fontSize: 25),
                        ),
                      ),
                    ),
                  ].expand(
                        (widget) => [
                      widget,
                      const SizedBox(
                        height: 24,
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FormDatePicker extends StatefulWidget {
  final DateTime date;
  final ValueChanged<DateTime> onChanged;

  const _FormDatePicker({
    required this.date,
    required this.onChanged,
  });

  @override
  State<_FormDatePicker> createState() => _FormDatePickerState();
}

class _FormDatePickerState extends State<_FormDatePicker> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'Birth date',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              intl.DateFormat.yMd().format(widget.date),
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        TextButton(
          child: const Text('Edit'),
          onPressed: () async {
            var newDate = await showDatePicker(
              context: context,
              initialDate: widget.date,
              firstDate: DateTime(1900),
              lastDate: DateTime(2100),
            );

            // Don't change the date if the date picker returns null.
            if (newDate == null) {
              return;
            }

            widget.onChanged(newDate);
          },
        )
      ],
    );
  }
}