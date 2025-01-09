
import 'package:atele_seller/core/functions/custom_appbar.dart';
import 'package:atele_seller/feature/appointments/presentation/widgets/my_appointments_builder.dart';
import 'package:flutter/material.dart';


class MyAppointmentsView extends StatelessWidget {
  const MyAppointmentsView({super.key, required this.status});
final String status;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerEnableOpenDragGesture: true,
      body:  Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: CustomScrollView(slivers: [
          SliverToBoxAdapter(
            child: MyAppointmentsBuilder(status: status,),
          )
        ]),
      ),
    );
  }
}

