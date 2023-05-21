import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tourist_admin_panel/components/simple_button.dart';
import 'package:tourist_admin_panel/crud/forms/tourist_select_list.dart';
import 'package:tourist_admin_panel/model/competition.dart';
import 'package:tourist_admin_panel/model/tourist.dart';

import '../../api/tourist_api.dart';
import '../../components/input_label.dart';
import '../../config/config.dart';
import '../../services/service_io.dart';
import '../../utils.dart';
import '../base_crud_future_builder.dart';
import '../filters/tourist_filters.dart';

class CompetitionForm extends StatefulWidget {
  const CompetitionForm({super.key, required this.onSubmit, this.initial});

  final Function(Competition) onSubmit;
  final Competition? initial;

  @override
  State<CompetitionForm> createState() => _CompetitionFormState();
}

class _CompetitionFormState extends State<CompetitionForm> {
  var builder = CompetitionBuilder();
  Set<Tourist> selected = HashSet();
  var nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initial != null) {
      builder = CompetitionBuilder.fromExisting(widget.initial!);
      selected.addAll(builder.tourists);
      nameController.text = builder.name;
      return;
    }
    builder.id = 0;
    builder.date = DateTime.now();
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  String get actionName => widget.initial == null ? "Create" : "Update";

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: Config.borderRadius,
        color: Config.bgColor,
      ),
      padding: Config.paddingAll,
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "$actionName competition",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const SizedBox(
            height: Config.defaultPadding,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  height: 200,
                  width: 200,
                  alignment: Alignment.center,
                  child: SizedBox(
                    height: 150,
                    width: 150,
                    child: ClipRRect(
                        borderRadius: Config.borderRadius,
                        child: Image.asset("assets/images/competition.png")),
                  )),
              const SizedBox(
                width: Config.defaultPadding * 3,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: Config.defaultPadding,
                  ),
                  SizedBox(
                    width: 300,
                    child: InputLabel(
                      controller: nameController,
                      hintText: "Competition name",
                    ),
                  ),
                  const SizedBox(
                    height: Config.defaultPadding,
                  ),
                  SizedBox(
                      width: 300,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 50,
                            width: 50,
                            child: Image.asset("assets/images/group.png"),
                          ),
                          const SizedBox(
                            width: Config.defaultPadding,
                          ),
                          SimpleButton(
                              onPressed: selectTourists,
                              color: Config.secondaryColor,
                              text: selected.isEmpty ? "Select participants" :
                              "Selected ${selected.length} participants")
                        ],
                      )),
                  const SizedBox(
                    height: Config.defaultPadding,
                  ),
                  SizedBox(
                      width: 300,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 50,
                            width: 50,
                            child: Image.asset("assets/images/time.png"),
                          ),
                          const SizedBox(
                            width: Config.defaultPadding,
                          ),
                          SimpleButton(
                              onPressed: selectDate,
                              color: Config.secondaryColor,
                              text: "Start date ${dateTimeToStr(builder.date)}")
                        ],
                      )),
                  const SizedBox(
                    height: Config.defaultPadding,)
                ],
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.red),
                  ),
                  child: Container(
                    padding: Config.paddingAll,
                    child: Text("Cancel",
                        style: Theme.of(context).textTheme.titleMedium),
                  )),
              ElevatedButton(
                  onPressed: () {
                    builder.tourists = selected.toList();
                    if (builder.tourists.isEmpty) {
                      ServiceIO()
                          .showMessage("Select tourists for the trip", context);
                      return;
                    }
                    builder.name = nameController.text;
                    if (builder.name.isEmpty) {
                      ServiceIO()
                          .showMessage("Name must not be empty", context);
                      return;
                    }
                    Navigator.of(context).pop();
                    widget.onSubmit(builder.build());
                  },
                  style: ButtonStyle(
                    backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.green),
                  ),
                  child: Container(
                    padding: Config.paddingAll,
                    child: Text(actionName,
                        style: Theme.of(context).textTheme.titleMedium),
                  )),
            ],
          )
        ],
      ),
    );
  }

  void selectDate() async {
    DateTime? newTime = await showDatePicker(
        context: context,
        initialDate: builder.date,
        firstDate: DateTime(2023),
        lastDate: DateTime(2024));
    if (newTime != null) {
      setState(() {
        builder.date = newTime;
      });
    }
  }

  void selectTourists() {
    ServiceIO().showWidget(context,
        barrierColor: Colors.transparent,
        child: Container(
          width: max(1200, Config.pageWidth(context) * .5),
          height: max(400, Config.pageHeight(context) * .5),
          color: Config.bgColor.withOpacity(.99),
          padding: Config.paddingAll,
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: ItemsFutureBuilder<Tourist>(
              itemsGetter: TouristApi().findByGenderAndSkill(),
              contentBuilder: (tourists) => TouristSelectList(
                tourists: tourists,
                onDispose: () {
                  Future.delayed(const Duration(milliseconds: 10), () {
                    setState(() {
                    });
                  });
                },
                filtersFlex: 2,
                itemHoverColor: Colors.grey,
                selected: selected,
              ),
            ),
          ),
        ));
  }
}
