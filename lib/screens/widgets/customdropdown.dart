import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final List<String> items;
  final String hint;
  final String? value;
  final double? fontSize;
  final Color? filledColor;
  final List<String>? selectedItems;

  final Function function;
  const CustomDropdown(
      {Key? key,
      required this.items,
      this.fontSize,
      this.filledColor,
      required this.value,
      required this.function,
      required this.hint,
      this.selectedItems})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        selectedItemBuilder: (context) => items
            .map((item) => DropdownMenuItem<String>(
                  value: item,
                  child: Container(
                    child: Text(
                      item,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: const TextStyle(
                          fontSize: 14, color: Colors.black),
                    ),
                  ),
                ))
            .toList(),

        dropdownStyleData: DropdownStyleData(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            offset: Offset(0, -15),
            padding: EdgeInsets.zero), //To avoid long text overflowing.
        isExpanded: true,
        hint: Text(
          hint,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: TextStyle(
            fontSize: fontSize ?? 14,
            color: Theme.of(context).hintColor,
          ),
        ),
        value: value,
        items: items
            .map((item) => DropdownMenuItem<String>(
                  value: item,
                  child: Container(
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            item,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                        if (selectedItems != null &&
                            selectedItems!.contains(item))
                          Icon(
                            Icons.done,
                            size: 20,
                            color: Colors.black,
                          )
                      ],
                    ),
                  ),
                ))
            .toList(),
        onChanged: (val) {
          function(val);
        },

        customButton: Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
              color: filledColor,
              border: Border.all(color: Colors.grey[300]!, width: 0.5),
              borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
          child: Row(children: [
            SizedBox(height: 3),
            Expanded(
                child: Text(
              value != null ? value! : hint,
              maxLines: 1,
              style: TextStyle(
                  fontSize: fontSize != null ? fontSize : 14,
                  color: value != null ||
                          (selectedItems != null && selectedItems!.isNotEmpty)
                      ? Colors.black
                      : Colors.grey),
            )),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Colors.grey,
            )
          ]),
        ),
      ),
    );
  }
}
