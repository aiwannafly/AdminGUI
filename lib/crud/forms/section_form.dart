import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tourist_admin_panel/components/simple_button.dart';
import 'package:tourist_admin_panel/model/section_manager.dart';

import '../../api/section_manager_api.dart';
import '../../components/input_label.dart';
import '../../config/config.dart';
import '../../model/section.dart';
import '../../services/service_io.dart';
import '../base_crud_future_builder.dart';
import '../section_manager_crud.dart';

class SectionForm extends StatefulWidget {
  const SectionForm({super.key, required this.onSubmit, this.initial});

  final Function(Section) onSubmit;
  final Section? initial;

  @override
  State<SectionForm> createState() => _SectionFormState();
}

class _SectionFormState extends State<SectionForm> {
  var builder = SectionBuilder();
  var nameController = TextEditingController();
  SectionManager? currentManager;

  @override
  void initState() {
    super.initState();
    if (widget.initial != null) {
      builder = SectionBuilder.fromExisting(widget.initial!);
      nameController.text = builder.name;
      currentManager = builder.sectionManager;
      return;
    }
    builder.id = 0;
  }

  String get actionName => widget.initial == null ? "Create" : "Update";

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
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
              "$actionName section",
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
                        child: Image.asset("assets/images/section.png")),
                  )),
              const SizedBox(
                width: Config.defaultPadding,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: Config.defaultPadding * 3,
                  ),
                  SizedBox(
                      width: 300,
                      child: Row(
                        children: [
                          SizedBox(
                            height: 50,
                            width: 50,
                            child: Image.asset("assets/images/manager.png"),
                          ),
                          const SizedBox(
                            width: Config.defaultPadding,
                          ),
                          SimpleButton(
                              onPressed: selectManager,
                              color: Config.secondaryColor,
                              text: currentManager == null
                                  ? "Select section manager"
                                  : "${currentManager!.firstName} ${currentManager!.secondName}")
                        ],
                      )),
                  const SizedBox(
                    height: Config.defaultPadding * 2,
                  ),
                  SizedBox(
                      width: 300,
                      child: InputLabel(
                          controller: nameController,
                          hintText: "Section name")),
                  const SizedBox(
                    height: Config.defaultPadding,
                  ),
                ],
              )
            ],
          ),
          const SizedBox(
            height: Config.defaultPadding,
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
                    builder.name = nameController.text;
                    if (builder.name.isEmpty) {
                      ServiceIO()
                          .showMessage("Name must not be empty", context);
                      return;
                    }
                    if (currentManager == null) {
                      ServiceIO().showMessage(
                          "Section manager is not selected", context);
                      return;
                    }
                    builder.sectionManager = currentManager!;
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

  void selectManager() {
    ServiceIO().showWidget(context,
        barrierColor: Colors.transparent,
        child: Container(
          width: max(900, Config.pageWidth(context) * .5),
          height: max(400, Config.pageHeight(context) * .5),
          color: Config.bgColor.withOpacity(.99),
          padding: Config.paddingAll,
          alignment: Alignment.center,
          child: SingleChildScrollView(
              child: BaseCRUDFutureBuilder<SectionManager>(
            itemsGetter: SectionManagerApi().getAll(),
            contentBuilder: (sectionManagers) => SectionManagerCRUD(
              sectionManagers: sectionManagers,
              onTap: (s) {
                currentManager = s;
                Navigator.of(context).pop();
                setState(() {});
              },
              filtersFlex: 0,
              itemHoverColor: Colors.grey,
            ),
          )),
        ));
  }
}
