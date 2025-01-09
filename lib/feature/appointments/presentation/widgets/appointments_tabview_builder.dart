import 'package:atele_seller/core/functions/custom_appbar.dart';
import 'package:atele_seller/core/utils/app_colors.dart';
import 'package:atele_seller/core/utils/app_strings.dart';
import 'package:atele_seller/feature/appointments/presentation/views/my_appointments_view.dart';
import 'package:flutter/material.dart';

class AppointmentsTabviewBuilder extends StatelessWidget {
  const AppointmentsTabviewBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return  DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: customAppBar(
          title: 'My Appointments',
          tabBar: const TabBar(
            indicatorColor: AppColors.primaryColor,
            labelColor: AppColors.primaryColor,
            unselectedLabelColor: AppColors.greyColor,
            tabs: [
              Tab(text: FirebaseStrings.statusPending ),
              Tab(text: FirebaseStrings.statusApproved),
              Tab(text: FirebaseStrings.statusrejected),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            MyAppointmentsView(status :FirebaseStrings.statusPending ,isPending: true,),
            MyAppointmentsView(status :FirebaseStrings.statusApproved,  isPending: false,),
            MyAppointmentsView(status :FirebaseStrings.statusrejected,  isPending: false,),
          ],
        ),
      ),
    );
  }
}