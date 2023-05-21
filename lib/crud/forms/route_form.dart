import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:tourist_admin_panel/components/input_label.dart';

import '../../config/config.dart';
import '../../model/route.dart';
import '../../services/service_io.dart';

class RouteForm extends StatefulWidget {
  const RouteForm({super.key, required this.onSubmit, this.initial});

  final Function(RouteTrip) onSubmit;
  final RouteTrip? initial;

  @override
  State<RouteForm> createState() => _RouteFormState();
}

class _RouteFormState extends State<RouteForm> {
  var builder = RouteBuilder();
  var nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initial != null) {
      builder = RouteBuilder.fromExisting(widget.initial!);
      nameController.text = builder.name;
      return;
    }
    builder.id = 0;
    builder.routeType = RouteType.pedestrian;
  }

  String get actionName => widget.initial == null ? "Create" : "Update";

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
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
              "$actionName route",
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
                        child: Image.asset("assets/images/route.png")),
                  )),
              const SizedBox(
                width: Config.defaultPadding,
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
                      hintText: "Route name",
                    ),
                  ),
                  const SizedBox(
                    height: Config.defaultPadding,
                  ),
                ],
              )
            ],
          ),
          Config.defaultText("Select route type"),
          const SizedBox(height: Config.defaultPadding,),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: ToggleSwitch(
              minWidth: 120,
              initialLabelIndex: builder.routeType.index,
              cornerRadius: Config.defaultRadius,
              activeFgColor: Colors.black,
              inactiveBgColor: Config.secondaryColor,
              inactiveFgColor: Colors.white,
              totalSwitches: RouteType.values.length,
              animate: true,
              animationDuration: 200,
              labels: RouteType.values.map((e) => e.string).toList(),
              activeBgColor: const [Colors.blue],
              customTextStyles: List.filled(
                  RouteType.values.length,
                  TextStyle(
                      fontFamily: "Montserrat",
                      fontSize: 14,
                      color: Colors.grey.shade200)),
              onToggle: (index) {
                if (index == null) return;
                setState(() {
                  builder.routeType = RouteType.values[index];
                });
              },
            ),
          ),
          const SizedBox(height: Config.defaultPadding,),
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
}
