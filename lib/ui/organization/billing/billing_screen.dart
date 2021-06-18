import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guardspot/app/theme/styles.dart';
import 'package:guardspot/util/country_codes.dart';
import 'package:guardspot/util/validators.dart';

class BillingScreen extends StatefulWidget {
  @override
  _BillingScreenState createState() => _BillingScreenState();
}

class _BillingScreenState extends State<BillingScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Wählen Sie einen Abrechnungsplan und nutzen Sie GuardSpot unbeschränkt.",
            style: Theme.of(context).textTheme.headline5,
          ),
          SizedBox(height: 10),
          Text(
            "12 Euro /pro Person/pro Monat",
            style: Theme.of(context).textTheme.headline6,
          ),
          SizedBox(height: 15),
          _buildCreditCardForm(),
        ],
      ),
    );
  }

  Widget _buildCreditCardForm() {
    ThemeData themeData = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          onChanged: (_) => null,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) => notEmptyValidator(value!, context),
          decoration: InputDecoration(
            labelText: "Kartennummer",
            border: const OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                onChanged: (_) => null,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => notEmptyValidator(value!, context),
                decoration: InputDecoration(
                  labelText: "Ablaufdatum",
                  helperText: "MM/JJ",
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                onChanged: (_) => null,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => notEmptyValidator(value!, context),
                decoration: InputDecoration(
                  labelText: "CVV",
                  helperText: "Drei Ziffern",
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        Text(
          "Rechnungsadresse".toUpperCase(),
          style: TextStyles.sectionHeader(themeData),
        ),
        SizedBox(height: 10),
        TextFormField(
          onChanged: (_) => null,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) => notEmptyValidator(value!, context),
          decoration: InputDecoration(
            labelText: "Straße",
            border: const OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                onChanged: (_) => null,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => notEmptyValidator(value!, context),
                decoration: InputDecoration(
                  labelText: "Stadt",
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                onChanged: (_) => null,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => notEmptyValidator(value!, context),
                decoration: InputDecoration(
                  labelText: "Postleitzahl",
                  border: const OutlineInputBorder(),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        DropdownButtonFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          onChanged: (_) => null,
          items: COUNTRY_CODES
              .map((country) => DropdownMenuItem(
                    value: country,
                    child: Text(country),
                  ))
              .toList(),
          decoration: InputDecoration(
            labelText: "Land",
            prefixIcon: Icon(Icons.short_text),
            border: const OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}
