import 'package:flutter/material.dart';

class MymessageUser extends StatelessWidget {
  MymessageUser({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.only(left: 9, top: 9, bottom: 9, right: 9),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(32)),
            color: Colors.blue),
        child: Text(
          "Hi",
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
      ),
    );
  }
}

// class messageUser extends StatelessWidget {
//   messageUser({super.key, required this.message});
//   Message message;
//   @override
//   Widget build(BuildContext context) {
//     return Align(
//       alignment: Alignment.centerRight,
//       child: Container(
//         padding:
//             const EdgeInsets.only(left: 16, top: 25, bottom: 25, right: 25),
//         margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         decoration: const BoxDecoration(
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(32),
//               topRight: Radius.circular(32),
//               bottomLeft: Radius.circular(32),
//             ),
//             color: fForginColor),
//         child: Text(
//           message.message,
//           style: TextStyle(color: Colors.white, fontSize: 18),
//         ),
//       ),
//     );
//   }
// }
