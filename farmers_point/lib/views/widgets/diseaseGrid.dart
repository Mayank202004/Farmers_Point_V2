import 'package:cropunity/controller/plantController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/routeNames.dart';

class DiseaseGrid extends StatefulWidget {
  final PlantController controller;
  const DiseaseGrid({super.key, required this.controller});

  @override
  State<DiseaseGrid> createState() => _DiseaseGridState();
}

class _DiseaseGridState extends State<DiseaseGrid> {
  bool _showAll = false; // It is used to toggle between show all and show less grid boxes
  @override
  Widget build(BuildContext context) {
    final diseases = widget.controller.plant.diseases ?? [];
    final displayCount = _showAll ? diseases.length : (diseases.length > 4 ? 4 : diseases.length);
    return Column(
      children: [
        GridView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          children: List.generate(displayCount, (index){
            return GestureDetector(
              onTap: (){Get.toNamed(RouteNames.ShowDisease,arguments: widget.controller.plant.diseases?[index]);},
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                child: Container(
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(20),border: Border.all(color: Colors.black,width: 0.3)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                            borderRadius: const BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20)),
                            child: SizedBox(
                              height: 108,
                                width: 200,

                                child: Image.network("https://mjxkyduomhstppmdbidb.supabase.co/storage/v1/object/public/fpBucket/application/Diseases/${widget.controller.plant.diseases?[index].diseaseName}/1.jpg",fit: BoxFit.cover,))
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0,right: 8),
                          child: Text("${widget.controller.plant.diseases?[index].diseaseName}",maxLines: 2,style: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                        )
                      ],
                    )
                ),
              ),
            );
          }),),
        TextButton(
          onPressed: (){
            setState(() {
              _showAll = !_showAll;
              });
            },
          child: Text(_showAll ? "Show Less" : "View More"),
        )],
    );
  }
}
