import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:maw3idi_project/features/cart/presentation/cubit/cart_cubit.dart';
import 'package:maw3idi_project/features/order/presentation/cubit/order_cubit.dart';
import 'package:maw3idi_project/features/order/domain/entities/order_entity.dart';
import 'package:maw3idi_project/core/widgets/custom_button.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cartState = context.watch<CartCubit>().state;
    double total = 0;
    if (cartState is CartLoaded) {
      total = cartState.items.fold(0, (sum, item) => sum + (item.product.price * item.quantity));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Delivery Address', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(hintText: 'Enter your full address'),
            ),
            const SizedBox(height: 32),
            const Text('Order Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Amount'),
                Text('$total SAR', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
            const Spacer(),
            BlocConsumer<OrderCubit, OrderState>(
              listener: (context, state) {
                if (state is OrderCreated) {
                  context.go('/tracking/${state.order.id}');
                }
              },
              builder: (context, state) {
                return CustomButton(
                  text: 'Place Order',
                  isLoading: state is OrderLoading,
                  onPressed: () {
                    if (_addressController.text.isNotEmpty && cartState is CartLoaded) {
                      final order = OrderEntity(
                        id: '',
                        items: cartState.items,
                        total: total,
                        address: _addressController.text,
                        status: 'pending',
                        createdAt: DateTime.now(),
                      );
                      context.read<OrderCubit>().createOrder(order);
                    }
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
