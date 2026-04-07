import 'package:e_commerce_app/core/styling/app_styles.dart';
import 'package:e_commerce_app/core/widgets/spacing_widgets.dart';
import 'package:e_commerce_app/features/address/widgets/address_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddressScreen extends StatelessWidget {
  const AddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Address'),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(),
            const HeightSpace(20),
            Text("Saved Address", style: AppStyles.black15BoldStyle),
            const HeightSpace(24),
            Expanded(
              child: ListView(
                children: [
                  AddressItemWidget(
                    isDefault: true,
                    address: "Home.",
                    addressDetails: "925 S Chugach St #APT 10, Alas...",
                  ),
                  AddressItemWidget(
                    address: "Home.",
                    addressDetails: "925 S Chugach St #APT 10, Alas...",
                  ),
                  AddressItemWidget(
                    address: "Home.",
                    addressDetails: "925 S Chugach St #APT 10, Alas...",
                  ),
                  AddressItemWidget(
                    address: "Home.",
                    addressDetails: "925 S Chugach St #APT 10, Alas...",
                  ),
                  AddressItemWidget(
                    address: "Home.",
                    addressDetails: "925 S Chugach St #APT 10, Alas...",
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
