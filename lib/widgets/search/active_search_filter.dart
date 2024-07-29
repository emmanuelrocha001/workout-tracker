import 'package:flutter/material.dart';
import '../../class_extensions.dart';

class ActiveFilter extends StatelessWidget {
  final String label;
  final String? value;
  final bool wrapValueInQuotationMarks;
  const ActiveFilter(
      {super.key,
      this.label = "",
      this.value,
      this.wrapValueInQuotationMarks = false});

  @override
  Widget build(BuildContext context) {
    // pad label
    var cLabel = label;
    var cValue = value;
    var labelSize = 20;
    var valueSize = 30;
    if (label.length > labelSize) {
      cLabel = "${label.substring(0, labelSize - 3)}...";
    }
    // if ((value?.length ?? 0) > valueSize) {
    //   cValue = "${value?.substring(0, valueSize - 3)}...";
    // }
    print('label $label ${label.length}');
    print('cLabel $cLabel ${cLabel.length}');
    return !value.isNullOrEmpty
        ? ListTile(
            dense: true,
            leading: Text(
              '$cLabel ',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 10.0,
                color: Colors.grey,
              ),
            ),
            title: Text(
              wrapValueInQuotationMarks ? '"$cValue"' : cValue.toString(),
              style: const TextStyle(
                fontSize: 12.0,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        : const SizedBox();
  }
}

//  return !value.isNullOrEmpty
//         ? Row(
//             children: [
//               SizedBox(
//                 width: 100.0,
//                 child: Text(
//                   '$cLabel ',
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 10.0,
//                     color: Colors.grey,
//                   ),
//                 ),
//               ),
//               Text(
//                 wrapValueInQuotationMarks ? '"$cValue"' : cValue.toString(),
//                 style: const TextStyle(
//                   fontSize: 12.0,
//                   color: Colors.black,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           )
//         : const SizedBox();
