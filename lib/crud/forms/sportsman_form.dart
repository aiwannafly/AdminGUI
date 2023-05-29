import 'package:flutter/material.dart';
import 'package:tourist_admin_panel/components/image_box.dart';
import 'package:tourist_admin_panel/crud/forms/base_form.dart';
import 'package:tourist_admin_panel/crud/selector.dart';
import 'package:tourist_admin_panel/model/sportsman.dart';
import 'package:tourist_admin_panel/model/tourist.dart';

import '../../components/image_button.dart';
import '../../config/config.dart';
import '../../services/service_io.dart';

class SportsmanForm extends StatefulWidget {
  const SportsmanForm({super.key, required this.onSubmit, this.initial});

  final Function(Sportsman) onSubmit;
  final Sportsman? initial;

  @override
  State<SportsmanForm> createState() => _SportsmanFormState();
}

class _SportsmanFormState extends State<SportsmanForm> {
  var builder = SportsmanBuilder();
  Tourist? currentTourist;

  @override
  void initState() {
    super.initState();
    if (widget.initial != null) {
      builder = SportsmanBuilder.fromExisting(widget.initial!);
      currentTourist = builder.tourist;
      return;
    }
    builder.id = 0;
  }

  String get actionName => widget.initial == null ? "Create" : "Update";

  String get postfix => currentTourist == null
      ? "_male"
      : currentTourist!.gender == Gender.male
      ? "_male"
      : "_female";

  @override
  Widget build(BuildContext context) {
    return BaseForm(
        buildEntity: buildEntity,
        entityName: "sportsman",
        formType: widget.initial == null ? FormType.create : FormType.update,
        body: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ImageBox(imageName: "sportsman.png"),
                const SizedBox(
                  width: Config.defaultPadding,
                ),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const SizedBox(
                    height: Config.defaultPadding * 3,
                  ),
                  ImageButton(
                      onPressed: selectTourist,
                      imageName: "tourist$postfix.png",
                      text: currentTourist == null
                          ? "Select person"
                          : "${currentTourist!.firstName} ${currentTourist!.secondName}")
                ])
              ],
            ),
          ],
        ));
  }

  void buildEntity() {
    if (currentTourist == null) {
      ServiceIO().showMessage("Tourist is not selected", context);
      return;
    }
    builder.tourist = currentTourist!;
    widget.onSubmit(builder.build());
  }

  void selectTourist() {
    Selector.selectTrainerAndSportsmanCandidates(context, onSelected: (t) {
      Navigator.of(context).pop();
      setState(() {
        currentTourist = t;
      });
    });
  }
}
