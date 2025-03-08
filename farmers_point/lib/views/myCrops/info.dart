import 'package:cropunity/controller/infoController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Info extends StatefulWidget {
  const Info({super.key});

  @override
  State<Info> createState() => _InfoState();
}

class _InfoState extends State<Info> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  InfoController controller = Get.put(InfoController());

  String selectedUnit = 'Acres';
  String selectedQualification = 'None';
  String selectedDegree = 'None';



  final List<String> units = ['Acres', 'Guntha', 'Hectares', 'Square Feet'];
  final List<String> qualifications = [
    'None',
    'High School',
    'Bachelor\'s Degree',
    'Master\'s Degree',
    'PhD'
  ];
  final List<String> agricultureDegrees = [
    'None',
    'B.Sc in Agriculture',
    'M.Sc in Agriculture',
    'PhD in Agriculture'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manage Farm Information"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Obx(
              () => controller.loading.value
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Address Field
                  TextFormField(
                    initialValue: controller.info.value.farmAddress,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: "Farm Address",
                      hintText: "Enter farm address",
                    ),
                    onSaved: (value) {
                      controller.address = value ?? ""; // Save address directly
                    },
                  ),
                  const SizedBox(height: 20),

                  // Total Farm Area
                  Row(
                    children: [
                      // Farm Area Text Field
                      Expanded(
                        flex: 5,
                        child: TextFormField(
                          initialValue: controller.info.value.farmArea?.toString(),
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: "Total Farm Area",
                            hintText: "Enter farm area",
                          ),
                          validator: (value) {
                            if (value != null && value.isNotEmpty) {
                              final areaValue = double.tryParse(value);
                              if (areaValue == null || areaValue <= 0) {
                                return "Enter a valid positive number.";
                              }
                            }
                            return null;
                          },
                          onSaved: (value) {
                            controller.area = double.tryParse(value ?? "0") ?? 0;
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Unit Dropdown
                      Expanded(
                        flex: 4,
                        child: DropdownButtonFormField<String>(
                          value: controller.info.value.unit ?? selectedUnit,
                          items: units.map((String unit) {
                            return DropdownMenuItem<String>(
                              value: unit,
                              child: Text(unit),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              selectedUnit = value!;
                            });
                          },
                          decoration: const InputDecoration(
                            border: UnderlineInputBorder(),
                            labelText: "Unit",
                          ),
                          onSaved: (value) {
                            controller.unit = value ?? "Acres";
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Contact Field
                  TextFormField(
                    initialValue: controller.info.value.contact,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: "Contact",
                      hintText: "Enter contact number",
                    ),
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        final regex = RegExp(r'^[0-9]{10}$');
                        if (!regex.hasMatch(value)) {
                          return "Enter a valid 10-digit phone number.";
                        }
                      }
                      return null;
                    },
                    onSaved: (value) {
                      controller.contact = value ?? "";
                    },
                  ),
                  const SizedBox(height: 20),

                  // Age Field
                  TextFormField(
                    initialValue: controller.info.value.age?.toString(),
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: "Age",
                      hintText: "Enter your age",
                    ),
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        final ageValue = int.tryParse(value);
                        if (ageValue == null || ageValue <= 0) {
                          return "Age must be a positive integer.";
                        }
                      }
                      return null;
                    },
                    onSaved: (value) {
                      controller.age = int.tryParse(value ?? "0") ?? 0;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Qualification Dropdown
                  DropdownButtonFormField<String>(
                    value: controller.info.value.qualification ?? selectedQualification,
                    items: qualifications.map((String qualification) {
                      return DropdownMenuItem<String>(
                        value: qualification,
                        child: Text(qualification),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        selectedQualification = value!;
                      });
                    },
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: "Qualification",
                    ),
                    onSaved: (value) {
                      controller.qualification = selectedQualification;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Agriculture Degree Dropdown
                  DropdownButtonFormField<String>(
                    value: controller.info.value.agriculturalDegree ?? selectedDegree,
                    items: agricultureDegrees.map((String degree) {
                      return DropdownMenuItem<String>(
                        value: degree,
                        child: Text(degree),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        selectedDegree = value!;
                      });
                    },
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: "Agriculture Degree",
                    ),
                    onSaved: (value) {
                      controller.degree = selectedDegree;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Additional Details Field
                  TextFormField(
                    initialValue: controller.info.value.description,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Additional Details",
                      hintText: "Add details about the farm (e.g., crops grown)",
                    ),
                    onSaved: (value) {
                      controller.description = value ?? "";
                    },
                  ),
                  const SizedBox(height: 20),

                  // Submit Button
                  Center(
                    child: Obx(
                          () => ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            controller.updateInfo();
                          }
                        },
                        child: controller.loading.value
                            ? const SizedBox(
                          height: 15,
                          width: 15,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                            : const Text("Submit / Update"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
