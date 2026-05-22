//create my order screen 
import 'package:e_commerce_app/features/order/cubit/order_cubit.dart';
import 'package:e_commerce_app/features/order/cubit/order_state.dart';
import 'package:e_commerce_app/features/order/models/order_summary_model.dart';
import 'package:e_commerce_app/features/order/widget/order_summary_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../home/widgets/title_price_widget.dart' show TitlePriceWidget, TotalPriceWidget;
class MyOrderScreen extends StatefulWidget {
  const MyOrderScreen({super.key});

  @override
  State<MyOrderScreen> createState() => _MyOrderScreenState();
}

class _MyOrderScreenState extends State<MyOrderScreen> {
  bool _hasFetchedOrders = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasFetchedOrders) {
      _hasFetchedOrders = true;
      context.read<OrderCubit>().fetchOrders();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Orders'),
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: BlocBuilder<OrderCubit, OrderState>(
        builder: (context, state) {
          if (state is LoadingOrders) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SuccessOrders) {
            final List orders = state.orders;
            if (orders.isEmpty) {
              return const Center(child: Text('No orders found.'));
            }
            return ListView.builder(
              padding: EdgeInsets.symmetric(vertical: 10.h),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return OrderSummaryCard(order: order);
              },
            );
          } else if (state is ErrorOrders) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}