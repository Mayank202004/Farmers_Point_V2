import 'package:flutter/material.dart';

import '../utils/type_def.dart';

class SearchInput extends StatelessWidget {
  final TextEditingController controller;
  final InputCallback callback;
  const SearchInput({super.key, required this.controller, required this.callback});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: callback,
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search,color: Colors.black54,),
          filled: true,
          fillColor: Colors.black12.withOpacity(0.03),
          hintText: "Search User",
          hintStyle: const TextStyle(color: Colors.grey),
          contentPadding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15)),
          ),
          enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15))
          ),
          focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(15))
          )
      ),
    );
  }
}
