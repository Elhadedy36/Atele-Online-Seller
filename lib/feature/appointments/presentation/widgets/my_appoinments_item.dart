import 'package:atele_seller/app/atele_online.dart';
import 'package:atele_seller/core/utils/app_strings.dart';
import 'package:atele_seller/core/widgets/custom_row.dart';
import 'package:atele_seller/feature/appointments/data/appointments_model.dart';
import 'package:atele_seller/feature/appointments/presentation/cubit/appointments_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyAppoinmentsItem extends StatelessWidget {
  const MyAppoinmentsItem({
    super.key,
    required this.model, required this.isPending,
  });
  final AppointmentsModel model;
final bool isPending;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 36.w, vertical: 16.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 6,
      child: Column(
        children: [
          SizedBox(height: 20.h),
          Container(
            height: 200.h,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: NetworkImage(model.productImg[0]),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: 26.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: CustomRow(
              title: FirebaseStrings.depositPaid,
              trallingText: model.depositeAmount.toString(),
              style1: TextStyle(
                  color: Colors.black,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold),
              style2: TextStyle(
                fontSize: 12.sp,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: CustomRow(
              title: 'Name Atele:',
              trallingText: model.ateleName,
              style1: TextStyle(
                  color: Colors.black,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold),
              style2: TextStyle(
                fontSize: 12.sp,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: CustomRow(
              title: 'Phone :',
              trallingText: model.phoneNumber,
              style1: TextStyle(
                  color: Colors.black,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold),
              style2: TextStyle(
                fontSize: 12.sp,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: CustomRow(
              title: 'Address :',
              trallingText: model.address,
              style1: TextStyle(
                  color: Colors.black,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold),
              style2: TextStyle(
                fontSize: 12.sp,
              ),
            ),
          ),
          SizedBox(height: 4.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: CustomRow(
              title: 'Appointment :',
              trallingText:
                  '${model.appointmentsDate} at ${model.appointmentsTime}',
              style1: TextStyle(
                  color: Colors.pink,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.bold),
              style2: TextStyle(
                fontSize: 12.sp,
              ),
            ),
          ),
          SizedBox(height: 4.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: CustomRow(
              title: 'Status :',
              trallingText: '${model.status}',
              style1: TextStyle(
                  color: Colors.pink,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.bold),
              style2: TextStyle(
                fontSize: 12.sp,
              ),
            ),
          ),
          SizedBox(height: 16.h),
          isPending?
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () 
                  {
                    context.read<AppointmentsCubit>().updateAppointmentStatus(appointmentId: model.appointmentId, newStatus: FirebaseStrings.statusApproved);
                  }, // Empty for now
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.grey, // Approve button color
                    foregroundColor: Colors.white, // Text color
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(16),
                      ),
                    ),
                  ),
                  child: Text(
                    'Approve',
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () 
                  {
                    context.read<AppointmentsCubit>().updateAppointmentStatus(appointmentId: model.appointmentId, newStatus: FirebaseStrings.statusrejected);

                  }, // Empty for now
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 105, 24, 20), // Reject button color
                    foregroundColor: Colors.white, // Text color
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(16),
                      ),
                    ),
                  ),
                  child: Text(
                    'Reject',
                    style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ):Container(),
        ],
      ),
    );
  }
}
