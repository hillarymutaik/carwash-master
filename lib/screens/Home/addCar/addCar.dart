import 'dart:io';

import 'package:animation_wrappers/animation_wrappers.dart';
import 'package:carwash/backend/auth_firebase.dart';
import 'package:carwash/components/widgets.dart';
import 'package:carwash/widget/formbuildtextfield.dart';
import 'package:flutter/material.dart';
import 'package:carwash/language/locale.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:image_picker/image_picker.dart';

class AddCar extends StatefulWidget {
  @override
  _AddCarState createState() => _AddCarState();
}

class _AddCarState extends State<AddCar> {
  String? _car;
  String? _model;
  String? _type;
  final ImagePicker _picker = ImagePicker();

  bool isLoading = false;
  File? image;
  final formKey = GlobalKey<FormBuilderState>();
  Column selectionField(BuildContext context, String label, String title,
      List items, String? value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Column(
          children: [
            FormBuilder(
              child: Column(children: [
                formbuildtextfield(
                    height: 40,
                    color: 0xffFFFFFF,
                    hintText: "Enter car brand",
                    attribute: "carBrand",
                    dividerColor: 0xff1F1C34,
                    errorText: "Enter full name first",
                    font: "Poppins",
                    keybordType: TextInputType.text,
                    fontWeight: FontWeight.w400,
                    fontSize: 15.0,
                    formType: "text",
                    dropDownList: [],
                    submitAction: () {}),
                Divider(),
                formbuildtextfield(
                    height: 40,
                    color: 0xffFFFFFF,
                    hintText: "Enter car model",
                    attribute: "carModel",
                    dividerColor: 0xff1F1C34,
                    errorText: "Enter email first",
                    font: "Poppins",
                    keybordType: TextInputType.emailAddress,
                    fontWeight: FontWeight.w400,
                    fontSize: 15.0,
                    formType: "text",
                    dropDownList: [],
                    submitAction: () {}),
                Divider(),
                formbuildtextfield(
                    height: 40,
                    color: 0xffFFFFFF,
                    hintText: "Enter car no.plate",
                    attribute: "carNoPlate",
                    dividerColor: 0xff1F1C34,
                    errorText: "Enter password first",
                    font: "Poppins",
                    keybordType: TextInputType.text,
                    fontWeight: FontWeight.w400,
                    fontSize: 15.0,
                    formType: "text",
                    dropDownList: [],
                    submitAction: () {}),
                Divider(),
              ]),
              key: formKey,
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context)!;

    List cars = [locale.car1, locale.car2];
    List models = [locale.car1Model, locale.car2Model];
    List type = ['Convertible', 'Sedan'];
    return Scaffold(
      appBar: appBar(context, locale.addCar!),
      body: FadedSlideAnimation(
        SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            child: Column(
              children: [
                image == null
                    ? Container(
                        height: 160,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                              colors: [
                                Theme.of(context).dividerColor,
                                Theme.of(context).primaryColor
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter),
                        ),
                        child: InkWell(
                          onTap: (() => imagePicker()),
                          child: Center(
                              child:
                                  HomePageIcons(Icons.camera_alt, 40.0, 15.0)),
                        ),
                      )
                    : InkWell(
                        onTap: (() => imagePicker()),
                        child: Container(
                          height: 160,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: LinearGradient(
                                colors: [
                                  Theme.of(context).dividerColor,
                                  Theme.of(context).primaryColor
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter),
                          ),
                          child: Center(
                              child: Image.file(
                            File(image!.path),
                            fit: BoxFit.cover,
                          )),
                        ),
                      ),
                SizedBox(
                  height: 25,
                ),
                Column(
                  children: [
                    FormBuilder(
                      child: Column(children: [
                        formbuildtextfield(
                            height: 40,
                            color: 0xffFFFFFF,
                            hintText: "Enter car brand",
                            attribute: "carBrand",
                            dividerColor: 0xff1F1C34,
                            errorText: "Enter full name first",
                            font: "Poppins",
                            keybordType: TextInputType.text,
                            fontWeight: FontWeight.w400,
                            fontSize: 15.0,
                            formType: "text",
                            dropDownList: [],
                            submitAction: () {}),
                        Divider(),
                        formbuildtextfield(
                            height: 40,
                            color: 0xffFFFFFF,
                            hintText: "Enter car model",
                            attribute: "carModel",
                            dividerColor: 0xff1F1C34,
                            errorText: "Enter email first",
                            font: "Poppins",
                            keybordType: TextInputType.emailAddress,
                            fontWeight: FontWeight.w400,
                            fontSize: 15.0,
                            formType: "text",
                            dropDownList: [],
                            submitAction: () {}),
                        Divider(),
                        formbuildtextfield(
                            height: 40,
                            color: 0xffFFFFFF,
                            hintText: "Enter car no.plate",
                            attribute: "carNoPlate",
                            dividerColor: 0xff1F1C34,
                            errorText: "Enter password first",
                            font: "Poppins",
                            keybordType: TextInputType.text,
                            fontWeight: FontWeight.w400,
                            fontSize: 15.0,
                            formType: "text",
                            dropDownList: [],
                            submitAction: () {}),
                        Divider(),
                        FormBuilderDropdown(
                          name: 'carType',
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                          // initialValue: 'Male',
                          allowClear: false,
                          style: TextStyle(color: Colors.grey),

                          hint: const Text(
                            'Select car type',
                            style: TextStyle(color: Colors.white),
                          ),
                          validator: FormBuilderValidators.compose(
                              [FormBuilderValidators.required(context)]),
                          items:
                              ['saloon', "suvs", "van", "bus", "truck"]
                                  .map((gender) => DropdownMenuItem(
                                        value: gender,
                                        child: Text('$gender'.toLowerCase()),
                                      ))
                                  .toList(),
                        ),
                      ]),
                      key: formKey,
                    ),
                  ],
                ),
                SizedBox(
                  height: 25,
                ),
                isLoading == false
                    ? GestureDetector(
                    onTap: () {
                      if (formKey.currentState!.saveAndValidate()) {
                        setState(() {
                          isLoading = true;
                        });
                        FirebaseAuthClass().addCar(
                            image!,
                            formKey.currentState!.value['carBrand'],
                            formKey.currentState!.value['carModel'],
                            formKey.currentState!.value['carNoPlate'],
                            formKey.currentState!.value['carType'], () {
                          //successFunction
                          Get.back();
                          setState(() {
                            isLoading = false;
                          });
                        }, () {
                          //failedFunction
                          setState(() {
                            isLoading = false;
                          });
                          Fluttertoast.showToast(
                              msg: "Failed to add car",
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER,
                              timeInSecForIosWeb: 1,
                              backgroundColor:
                                  Theme.of(context).backgroundColor,
                              textColor: Colors.white,
                              fontSize: 14.0);
                        });
                      }
                    },
                    child: GradientButton(locale.saveCarInfo)): Center(child: SizedBox(child: CircularProgressIndicator(),width: 40,height: 40,))
              ],
            ),
          ),
        ),
        beginOffset: Offset(0, 0.3),
        endOffset: Offset(0, 0),
        slideCurve: Curves.linearToEaseOut,
      ),
    );
  }

  void imagePicker() async {
    XFile? Image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      image = File(Image!.path);
    });
  }
}
