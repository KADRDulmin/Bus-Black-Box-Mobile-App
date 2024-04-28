import 'package:BBBS/Models/Utils/Utils.dart';
import 'package:BBBS/Views/Widgets/custom_button.dart';
import 'package:BBBS/Views/Widgets/custom_text_form_field.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:BBBS/Models/Utils/Colors.dart';
import 'package:BBBS/Models/Utils/Common.dart';
import 'package:BBBS/Models/Utils/FirebaseStructure.dart';
import 'package:BBBS/Models/Utils/Routes.dart';
import 'package:form_validation/form_validation.dart';
import 'package:intl/intl.dart';

class IncidentManagement extends StatefulWidget {
  const IncidentManagement({Key? key}) : super(key: key);

  @override
  State<IncidentManagement> createState() => _IncidentManagementState();
}

class _IncidentManagementState extends State<IncidentManagement> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

  List<dynamic> list = [];

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      getData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        backgroundColor: color7,
        body: SafeArea(
          child: SizedBox(
              width: displaySize.width,
              height: displaySize.height,
              child: Column(
                children: [
                  Expanded(
                      flex: 0,
                      child: Container(
                        decoration: BoxDecoration(
                            color: colorPrimary,
                            borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(10.0),
                                bottomRight: Radius.circular(10.0))),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, right: 20.0, top: 18.0, bottom: 18.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Routes(context: context).back();
                                },
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  color: colorWhite,
                                ),
                              ),
                              Text(
                                "Incident Management",
                                style: TextStyle(fontSize: 16.0, color: color7),
                              ),
                              GestureDetector(
                                onTap: () => openEnrollment(null),
                                child: Icon(
                                  Icons.add,
                                  color: colorWhite,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                  Expanded(
                      flex: 1,
                      child: Container(
                        color: colorWhite,
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              bottom: 5.0, left: 5.0, right: 5.0),
                          child: (list.isNotEmpty)
                              ? SingleChildScrollView(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        for (var rec in list)
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 1.0),
                                            child: SizedBox(
                                              width: double.infinity,
                                              child: Card(
                                                color: colorWhite,
                                                child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 10.0),
                                                    child: ExpansionTile(
                                                      leading: Icon(
                                                        Icons
                                                            .local_parking_outlined,
                                                        color: colorPrimary,
                                                        size: 35.0,
                                                      ),
                                                      title: Text(
                                                        rec['value']['title'],
                                                        style: TextStyle(
                                                            color: colorBlack,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 16.0),
                                                      ),
                                                      subtitle: Text(
                                                        rec['value']['busno'],
                                                        style: TextStyle(
                                                            color: colorBlack,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 14.0),
                                                      ),
                                                      trailing: Wrap(
                                                        children: [
                                                          IconButton(
                                                              onPressed: () =>
                                                                  openEnrollment(
                                                                      rec),
                                                              icon: Icon(
                                                                  Icons.edit,
                                                                  color:
                                                                      color12)),
                                                          IconButton(
                                                              onPressed: () => _databaseReference
                                                                  .child(FirebaseStructure
                                                                      .INCIDENT)
                                                                  .child(rec[
                                                                      'key'])
                                                                  .remove()
                                                                  .then((value) =>
                                                                      getData()),
                                                              icon: Icon(
                                                                  Icons.delete,
                                                                  color:
                                                                      colorRed))
                                                        ],
                                                      ),
                                                      expandedAlignment:
                                                          Alignment.centerLeft,
                                                      expandedCrossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      childrenPadding:
                                                          const EdgeInsets.only(
                                                              top: 10.0,
                                                              left: 10.0),
                                                      backgroundColor: color8
                                                          .withOpacity(0.2),
                                                      children: [
                                                        Text(
                                                          "Description : ${rec['value']['description']}",
                                                          style: TextStyle(
                                                              color: colorBlack,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              fontSize: 14.0),
                                                        )
                                                      ],
                                                    )),
                                              ),
                                            ),
                                          )
                                      ]),
                                )
                              : Center(
                                  child: Text(
                                    "No Data Found".toString().toUpperCase(),
                                    style: TextStyle(
                                        color: colorBlack,
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15.0),
                                  ),
                                ),
                        ),
                      ))
                ],
              )),
        ));
  }

  void openEnrollment(data) {
    final _formKey = GlobalKey<FormState>();

    final TextEditingController _title = TextEditingController();
    final TextEditingController _busNo = TextEditingController();
    final TextEditingController _description = TextEditingController();

    if (data != null) {
      _title.text = data['value']['title'];
      _busNo.text = data['value']['busno'];
      _description.text = data['value']['description'];
    }

    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 10.0),
                  child: SingleChildScrollView(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              flex: 1,
                              child: Text(
                                "${(data != null) ? 'Edit' : 'Add'} Incidents",
                                style: TextStyle(
                                    color: colorBlack,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 15.0),
                              )),
                          Expanded(
                              flex: 0,
                              child: IconButton(
                                  onPressed: () => Navigator.pop(context),
                                  icon: Icon(
                                    Icons.close,
                                    color: colorRed,
                                  )))
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Divider(
                          color: colorGrey,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                        child: CustomTextFormField(
                            height: 5.0,
                            controller: _title,
                            backgroundColor: color7,
                            iconColor: colorPrimary,
                            isIconAvailable: true,
                            hint: 'Title',
                            icon: Icons.food_bank_outlined,
                            textInputType: TextInputType.text,
                            validation: (value) {
                              final validator = Validator(
                                validators: [const RequiredValidator()],
                              );
                              return validator.validate(
                                label: "TThis field cannot be empty",
                                value: value,
                              );
                            },
                            obscureText: false),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                        child: CustomTextFormField(
                            height: 5.0,
                            controller: _busNo,
                            backgroundColor: color7,
                            iconColor: colorPrimary,
                            isIconAvailable: true,
                            hint: 'Bus License Number',
                            icon: Icons.numbers_outlined,
                            textInputType: TextInputType.phone,
                            validation: (value) {
                              final validator = Validator(
                                validators: [const RequiredValidator()],
                              );
                              return validator.validate(
                                label: "TThis field cannot be empty",
                                value: value,
                              );
                            },
                            obscureText: false),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                        child: CustomTextFormField(
                            height: 5.0,
                            controller: _description,
                            backgroundColor: color7,
                            iconColor: colorPrimary,
                            isIconAvailable: true,
                            hint: 'Description',
                            icon: Icons.menu_book_outlined,
                            textInputType: TextInputType.multiline,
                            validation: (value) {
                              final validator = Validator(
                                validators: [const RequiredValidator()],
                              );
                              return validator.validate(
                                label: "TThis field cannot be empty",
                                value: value,
                              );
                            },
                            obscureText: false),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 20.0),
                        child: CustomButton(
                            buttonText: "Submit",
                            textColor: color6,
                            backgroundColor: colorPrimary,
                            isBorder: false,
                            borderColor: color6,
                            onclickFunction: () async {
                              FocusScope.of(context).unfocus();

                              if (_formKey.currentState!.validate()) {
                                CustomUtils.showLoader(context);

                                DatabaseReference ref = _databaseReference
                                    .child(FirebaseStructure.INCIDENT);

                                Map<String, dynamic> saveData = {
                                  "door": false,
                                  "title": _title.text,
                                  "busno": _busNo.text,
                                  "description": _description.text
                                };

                                if (data != null) {
                                  await ref
                                      .child(data['key'])
                                      .update(saveData)
                                      .then((value) {
                                    CustomUtils.hideLoader(context);
                                    Navigator.pop(context);
                                    getData();
                                  });
                                } else {
                                  await ref.push().set(saveData).then((value) {
                                    CustomUtils.hideLoader(context);
                                    Navigator.pop(context);
                                    getData();
                                  });
                                }
                              }
                            }),
                      )
                    ],
                  )),
                )),
          );
        });
  }

  Future<void> getData() async {
    _databaseReference
        .child(FirebaseStructure.INCIDENT)
        .orderByPriority()
        .once()
        .then((DatabaseEvent data) {
      list.clear();
      setState(() {
        for (DataSnapshot element in data.snapshot.children) {
          dynamic value = element.value;
          list.add({'key': element.key, 'value': value});
        }
      });
    });
  }
}
