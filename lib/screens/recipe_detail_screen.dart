// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// class MealDetailScreen extends StatelessWidget {
//   static const routeName = '/meal-detail';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(recipe.title),
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: <Widget>[
//             Container(
//               height: 300,
//               width: double.infinity,
//               child: Image.network(
//                 recipe.image,
//                 fit: BoxFit.cover,
//               ),
//             ),
//             Container(
//               margin: EdgeInsets.symmetric(vertical: 10),
//               child: Text(
//                 recipe.ingredients,
//                 style: Theme.of(context).textTheme.headline6,
//               ),
//             ),
//             Container(
//               child: Text(
//                 recipe.recipe,
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
