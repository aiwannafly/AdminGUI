import 'package:flutter/material.dart';

import '../../components/simple_button.dart';
import '../../config/config.dart';

enum FormType { create, update }

class BaseForm extends StatelessWidget {
  const BaseForm({
    super.key,
    required this.buildEntity,
    required this.entityName,
    this.formType = FormType.create,
    required this.body,
  });

  final Widget body;
  final VoidCallback buildEntity;
  final String entityName;
  final FormType formType;

  static const double defaultLabelWidth = 300;

  String get actionName => formType == FormType.create ? "Create" : "Update";

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
              "$actionName $entityName",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const SizedBox(
            height: Config.defaultPadding,
          ),
          body,
          const SizedBox(
            height: Config.defaultPadding,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SimpleButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  color: Colors.red,
                  text: "Cancel"),
              SimpleButton(
                  onPressed: buildEntity, color: Colors.green, text: actionName),
            ],
          )
        ],
      ),
    );
  }
}
