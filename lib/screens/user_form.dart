
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:intl/intl.dart' as intl;
import 'package:search_cep/search_cep.dart';

class UserForm extends StatefulWidget {
  const UserForm({super.key});

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _formKey = GlobalKey<FormState>();
  DateTime date = DateTime.now();
  final nameController = TextEditingController();
  final lastNameController = TextEditingController();
  final cpfController = TextEditingController();
  final birthDateController = TextEditingController();
  final cepController = TextEditingController();
  final stateController = TextEditingController();
  final cityController = TextEditingController();
  final neighborhoodController = TextEditingController();
  final streetController = TextEditingController();
  final complementController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Start listening to changes.
    cepController.addListener(_consultCep);
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    nameController.dispose();
    lastNameController.dispose();
    cpfController.dispose();
    birthDateController.dispose();
    cepController.dispose();
    stateController.dispose();
    cityController.dispose();
    neighborhoodController.dispose();
    streetController.dispose();
    complementController.dispose();
    super.dispose();
  }

  void _consultCep() async {
    final value = cepController.text;

    if (value!.length == 10) {
      final viaCepSearchCep = ViaCepSearchCep();
      final infoCepJSON = await viaCepSearchCep.searchInfoByCep(cep: value.replaceAll(new RegExp(r'[^0-9]'),''));

      if (infoCepJSON != null) {
        var cep = infoCepJSON.getOrElse(() => ViaCepInfo());
        if (cep.uf != null) stateController.text = cep.uf!;
        if (cep.localidade != null) cityController.text = cep.localidade!;
        if (cep.bairro != null) neighborhoodController.text = cep.bairro!;
        if (cep.logradouro != null) streetController.text = cep.logradouro!;
      }
    }
  }

  String? valueRequired(String? value){
    if(value == null || value.isEmpty){
      return "Required field";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User info'),
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
                      controller: nameController,
                      validator: valueRequired,
                      autofocus: true,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        hintText: 'Jane',
                        labelText: 'Name',
                      ),
                      autofillHints: const [AutofillHints.givenName],
                    ),
                    TextFormField(
                      controller: lastNameController,
                      validator: valueRequired,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        hintText: 'Doe',
                        labelText: 'Last Name',
                      ),
                      autofillHints: const [AutofillHints.familyName],
                    ),
                    TextFormField(
                      controller: cpfController,
                      validator: (value) {
                        if (!UtilBrasilFields.isCPFValido(value)) {
                          return 'Enter a valid CPF';
                        }
                        return null;
                      },
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
                    _FormDatePicker(
                      date: date,
                      onChanged: (value) {
                        setState(() {
                          date = value;
                        });
                      },
                    ),
                    TextFormField(
                      controller: cepController,
                      validator: (String? value) {
                        if (value!.isEmpty || value.length < 10) {
                          return 'CEP inválido';
                        }
                        return null;
                      },
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        hintText: '85850-000',
                        labelText: 'CEP',
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        CepInputFormatter()
                      ],
                      autofillHints: const [AutofillHints.postalCode],
                    ),
                    TextFormField(
                      controller: stateController,
                      validator: valueRequired,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        hintText: 'Paraná',
                        labelText: 'State',
                      ),
                    ),
                    TextFormField(
                      controller: cityController,
                      validator: valueRequired,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        hintText: 'Foz do Iguaçu',
                        labelText: 'City',
                      ),
                    ),
                    TextFormField(
                      controller: neighborhoodController,
                      validator: valueRequired,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        hintText: 'Downtown',
                        labelText: 'Neighborhood',
                      ),
                    ),
                    TextFormField(
                      controller: streetController,
                      validator: valueRequired,
                      keyboardType: TextInputType.streetAddress,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        hintText: '123 4th Ave',
                        labelText: 'Street Address',
                      ),
                      autofillHints: [AutofillHints.streetAddressLine1],
                    ),
                    TextFormField(
                      controller: complementController,
                      validator: valueRequired,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                        hintText: 'Apartment 2',
                        labelText: 'Complement',
                      ),
                    ),
                    Container(
                      height: 50,
                      width: 250,
                      decoration: BoxDecoration(
                          color: Colors.blue, borderRadius: BorderRadius.circular(20)),
                      child: TextButton(
                        onPressed: () async {
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
                          'Save',
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
              intl.DateFormat('d/MM/y').format(widget.date),
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
              lastDate: DateTime.now(),
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