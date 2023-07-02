import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:satria_optik/provider/address_provider.dart';
import 'package:satria_optik/utils/common_widget.dart';

import '../../../model/address.dart';

class NewAddressPage extends StatelessWidget {
  static String routeName = '/newAddreess';
  final Address? address;
  const NewAddressPage({
    Key? key,
    this.address,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    final TextEditingController cityController = TextEditingController();
    final TextEditingController detailController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();
    final TextEditingController postalCodeController = TextEditingController();
    final TextEditingController provinceController = TextEditingController();
    final TextEditingController receiverNameController =
        TextEditingController();
    final TextEditingController streetController = TextEditingController();
    final TextEditingController subdistrictController = TextEditingController();
    final TextEditingController villageController = TextEditingController();
    final TextEditingController countryController = TextEditingController();

    if (address != null) {
      cityController.text = address!.city;
      detailController.text = address!.detail;
      phoneController.text = address!.phone;
      postalCodeController.text = address!.postalCode;
      provinceController.text = address!.province;
      receiverNameController.text = address!.receiverName;
      streetController.text = address!.street;
      subdistrictController.text = address!.subdistrict;
      villageController.text = address!.village;
      countryController.text = address!.country;
    }

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Add New Address')),
        body: Form(
          key: formKey,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text('Receiver Name'),
              const SizedBox(height: 10),
              CustomTextFormField(
                controller: receiverNameController,
                validator: (p0) {
                  if (p0 == null || p0.isEmpty) {
                    return 'This field canot empty';
                  }
                  return null;
                },
                label: 'Name',
              ),
              const SizedBox(height: 10),
              const Text('Receiver Phone'),
              const SizedBox(height: 10),
              CustomTextFormField(
                controller: phoneController,
                inputType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\+?\d*'))
                ],
                validator: (p0) {
                  if (p0 == null || p0.isEmpty) {
                    return 'This field canot empty';
                  }
                  return null;
                },
                label: 'Phone',
              ),
              const SizedBox(height: 10),
              const Text('Street'),
              const SizedBox(height: 10),
              CustomTextFormField(
                controller: streetController,
                validator: (p0) {
                  if (p0 == null || p0.isEmpty) {
                    return 'This field canot empty';
                  }
                  return null;
                },
                label: 'Street (RT/RW)',
              ),
              const SizedBox(height: 10),
              const Text('Detail'),
              const SizedBox(height: 10),
              CustomTextFormField(
                controller: detailController,
                validator: (p0) {
                  if (p0 == null || p0.isEmpty) {
                    return 'This field canot empty';
                  }
                  return null;
                },
                label: 'Address detail',
              ),
              const SizedBox(height: 10),
              const Text('Village'),
              const SizedBox(height: 10),
              CustomTextFormField(
                controller: villageController,
                validator: (p0) {
                  if (p0 == null || p0.isEmpty) {
                    return 'This field canot empty';
                  }
                  return null;
                },
                label: 'Village',
              ),
              const SizedBox(height: 10),
              const Text('Subdistrict'),
              const SizedBox(height: 10),
              CustomTextFormField(
                controller: subdistrictController,
                validator: (p0) {
                  if (p0 == null || p0.isEmpty) {
                    return 'This field canot empty';
                  }
                  return null;
                },
                label: 'Subdistrict',
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('City'),
                        const SizedBox(height: 10),
                        CustomTextFormField(
                          controller: cityController,
                          validator: (p0) {
                            if (p0 == null || p0.isEmpty) {
                              return 'This field canot empty';
                            }
                            return null;
                          },
                          label: 'City',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Postal Code'),
                        const SizedBox(height: 10),
                        CustomTextFormField(
                          controller: postalCodeController,
                          inputType: TextInputType.number,
                          validator: (p0) {
                            if (p0 == null || p0.isEmpty) {
                              return 'This field canot empty';
                            }
                            return null;
                          },
                          label: 'Postal Code',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Province'),
                        const SizedBox(height: 10),
                        CustomTextFormField(
                          controller: provinceController,
                          validator: (p0) {
                            if (p0 == null || p0.isEmpty) {
                              return 'This field canot empty';
                            }
                            return null;
                          },
                          label: 'Province',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Country'),
                        const SizedBox(height: 10),
                        CustomTextFormField(
                          controller: countryController,
                          inputType: TextInputType.number,
                          validator: (p0) {
                            if (p0 == null || p0.isEmpty) {
                              return 'This field canot empty';
                            }
                            return null;
                          },
                          label: 'Country',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Consumer<AddressProvider>(
                builder: (context, value, child) {
                  return ElevatedButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        await value.addAddress(
                          Address(
                            city: cityController.text.trim(),
                            detail: detailController.text.trim(),
                            phone: phoneController.text.trim(),
                            postalCode: postalCodeController.text.trim(),
                            province: provinceController.text.trim(),
                            receiverName: receiverNameController.text.trim(),
                            street: streetController.text.trim(),
                            subdistrict: subdistrictController.text.trim(),
                            village: villageController.text.trim(),
                            country: countryController.text.trim(),
                          ),
                        );
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('New address added'),
                            ),
                          );
                          Navigator.of(context).pop();
                        }
                      }
                    },
                    child: const Text('Add New Address'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
