import 'package:flutter/material.dart';
import 'package:ms_admin/widgets/upload_med_widget.dart';

class PharmacyNameWidget extends StatelessWidget {
  const PharmacyNameWidget({super.key});
  static ValueNotifier<String> enteredValue = ValueNotifier('');

  @override
  Widget build(BuildContext context) {
    return Center(
      child: UploadMedWidget(pn: enteredValue.value),
    );
  }
}
