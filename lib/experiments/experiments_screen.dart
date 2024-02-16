import 'package:flutter/material.dart';
import 'package:yandex_maps/mapkit.dart';
import 'package:yandex_maps/mapkit_factory.dart';

class ExperimentsScreen extends StatefulWidget {
  const ExperimentsScreen({super.key});

  @override
  State<ExperimentsScreen> createState() => ExperimentsScreenState();
}

class ExperimentsScreenState extends State<ExperimentsScreen> {
  ExperimentsScreenState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Experiments'),
      ),
      body: Column(
        children: [
          TextFormField(
            controller: serviceId,
            decoration: const InputDecoration(
                border: UnderlineInputBorder(), labelText: 'ServiceId'),
          ),
          TextFormField(
            controller: parameterName,
            decoration: const InputDecoration(
                border: UnderlineInputBorder(), labelText: 'Parameter name'),
          ),
          TextFormField(
            controller: value,
            decoration: const InputDecoration(
                border: UnderlineInputBorder(), labelText: 'Value'),
          ),
          Row(
            children: [
              TextButton(
                onPressed: () {
                  setState(
                    () => enabledExperiments[(
                      serviceId.text,
                      parameterName.text
                    )] = value.text,
                  );
                  refreshExperiments();
                },
                child: const Text(
                  "Add",
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                flex: 8,
                child: TextFormField(
                  controller: stickyIds,
                  decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Sticky test ids'),
                ),
              ),
              Expanded(
                flex: 2,
                child: TextButton(
                  onPressed: () => setStickyTestIds(stickyIds.text),
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
          const Text(
            'Enabled experiments:',
            textAlign: TextAlign.left,
          ),
          Column(
            children: enabledExperiments.entries.map<Widget>((entry) {
              var (serviceId, parameter) = entry.key;
              var value = entry.value;

              return Container(
                margin: const EdgeInsets.all(15.0),
                padding: const EdgeInsets.all(3.0),
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.blueAccent)),
                child: Text('$serviceId: $parameter = $value'),
              );
            }).toList(),
          )
        ],
      ),
    );
  }

  void setStickyTestIds(String ids) {
    final listIds = <int>[
      for (final id in ids.split(',')) int.parse(id.trim(), radix: 10)
    ];

    mapkit.customExperimentsManager.setStickyExperimentsByTestIds(
        SetExperimentsErrorListener(
            onError: (error) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: const Color.fromARGB(173, 200, 0, 0),
                duration: const Duration(seconds: 3),
                content: Text(
                    'Error on request sticky experiments: ${error.runtimeType}')))),
        ids: listIds);
  }

  void refreshExperiments() {
    final experimentsManager = mapkit.customExperimentsManager;

    for (var entry in enabledExperiments.entries) {
      experimentsManager.setValue(
          serviceId: entry.key.$1,
          parameterName: entry.key.$2,
          value: entry.value);
    }
  }

  final serviceId = TextEditingController();
  final parameterName = TextEditingController();
  final value = TextEditingController();
  final stickyIds = TextEditingController();

  static var enabledExperiments = <(String, String), String>{};
}
