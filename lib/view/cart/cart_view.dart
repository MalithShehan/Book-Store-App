import 'package:flutter/material.dart';
import '../../common/bv_colors.dart';
import '../../common_widget/bv_gradient_button.dart';
import '../../data/mock_data.dart';
import '../../model/book_model.dart';

class CartView extends StatefulWidget {
  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  List<CartItemModel> _cartItems = [
    CartItemModel(book: MockData.books[0]),
    CartItemModel(book: MockData.books[1]),
    CartItemModel(book: MockData.books[3]),
  ];
  final _couponCtrl = TextEditingController();
  String? _appliedCoupon;
  double _discount = 0;

  double get _subtotal => _cartItems.fold(0, (sum, i) => sum + i.book.price * i.quantity);
  double get _total => _subtotal - _discount;

  void _applyCoupon() {
    if (_couponCtrl.text.toUpperCase() == 'BOOKVERSE20') {
      setState(() {
        _appliedCoupon = 'BOOKVERSE20';
        _discount = _subtotal * 0.20;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: BVColors.background,
      body: Column(
        children: [
          // Header
          Container(
            padding: EdgeInsets.fromLTRB(20, media.padding.top + 16, 20, 16),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back_ios_new_rounded, color: BVColors.textPrimary, size: 20),
                ),
                const SizedBox(width: 16),
                const Text('My Cart', style: TextStyle(color: BVColors.textPrimary, fontSize: 22, fontWeight: FontWeight.w800)),
                const Spacer(),
                Text('${_cartItems.length} items', style: const TextStyle(color: BVColors.textMuted, fontSize: 13)),
              ],
            ),
          ),
          // Cart items
          Expanded(
            child: _cartItems.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.shopping_cart_outlined, color: BVColors.textMuted, size: 60),
                        SizedBox(height: 16),
                        Text('Your cart is empty', style: TextStyle(color: BVColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w600)),
                        SizedBox(height: 8),
                        Text('Add some books to get started!', style: TextStyle(color: BVColors.textMuted)),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    physics: const BouncingScrollPhysics(),
                    itemCount: _cartItems.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 14),
                    itemBuilder: (_, i) {
                      return _CartItemCard(
                        item: _cartItems[i],
                        onRemove: () => setState(() => _cartItems.removeAt(i)),
                        onIncrement: () => setState(() => _cartItems[i].quantity++),
                        onDecrement: () {
                          if (_cartItems[i].quantity > 1) {
                            setState(() => _cartItems[i].quantity--);
                          }
                        },
                      );
                    },
                  ),
          ),
          // Order summary
          if (_cartItems.isNotEmpty)
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              decoration: BoxDecoration(
                color: BVColors.surface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
                border: Border(top: BorderSide(color: BVColors.glassBorder)),
              ),
              child: Column(
                children: [
                  // Coupon input
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 46,
                          decoration: BoxDecoration(
                            color: BVColors.background,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: _appliedCoupon != null ? BVColors.success : BVColors.glassBorder),
                          ),
                          child: Row(
                            children: [
                              const SizedBox(width: 12),
                              Icon(
                                _appliedCoupon != null ? Icons.check_circle_rounded : Icons.local_offer_outlined,
                                color: _appliedCoupon != null ? BVColors.success : BVColors.textMuted,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: _appliedCoupon != null
                                    ? Text(_appliedCoupon!, style: const TextStyle(color: BVColors.success, fontWeight: FontWeight.w600, fontSize: 13))
                                    : TextField(
                                        controller: _couponCtrl,
                                        style: const TextStyle(color: BVColors.textPrimary, fontSize: 13),
                                        decoration: const InputDecoration(
                                          hintText: 'Coupon code',
                                          hintStyle: TextStyle(color: BVColors.textMuted),
                                          border: InputBorder.none,
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: _appliedCoupon != null
                            ? () => setState(() { _appliedCoupon = null; _discount = 0; _couponCtrl.clear(); })
                            : _applyCoupon,
                        child: Container(
                          height: 46,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            gradient: BVColors.primaryGradient,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              _appliedCoupon != null ? 'Remove' : 'Apply',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  if (_appliedCoupon != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Row(
                        children: [
                          const Icon(Icons.celebration_rounded, color: BVColors.success, size: 16),
                          const SizedBox(width: 6),
                          Text('20% discount applied! You save \$${_discount.toStringAsFixed(2)}',
                              style: const TextStyle(color: BVColors.success, fontSize: 12)),
                        ],
                      ),
                    ),

                  const SizedBox(height: 16),
                  _summaryRow('Subtotal', '\$${_subtotal.toStringAsFixed(2)}'),
                  if (_discount > 0) _summaryRow('Discount', '-\$${_discount.toStringAsFixed(2)}', color: BVColors.success),
                  _summaryRow('Tax (5%)', '\$${(_total * 0.05).toStringAsFixed(2)}'),
                  Divider(color: BVColors.glassBorder, height: 20),
                  _summaryRow('Total', '\$${(_total * 1.05).toStringAsFixed(2)}', isBold: true, color: BVColors.primaryLight),
                  const SizedBox(height: 16),
                  BVGradientButton(
                    text: 'Proceed to Checkout',
                    icon: Icons.arrow_forward_rounded,
                    onPressed: () {},
                  ),
                  SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool isBold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: BVColors.textMuted, fontSize: 14)),
          Text(
            value,
            style: TextStyle(
              color: color ?? BVColors.textPrimary,
              fontSize: isBold ? 18 : 14,
              fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _CartItemCard extends StatelessWidget {
  final CartItemModel item;
  final VoidCallback onRemove;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _CartItemCard({
    required this.item,
    required this.onRemove,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(item.book.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onRemove(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: BVColors.error.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: BVColors.error.withValues(alpha: 0.3)),
        ),
        child: const Icon(Icons.delete_outline_rounded, color: BVColors.error, size: 28),
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: BVColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: BVColors.glassBorder),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                item.book.cover,
                width: 60,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(width: 60, height: 80, color: BVColors.cardDark),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.book.title, maxLines: 2, overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: BVColors.textPrimary, fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 3),
                  Text(item.book.author, style: const TextStyle(color: BVColors.textMuted, fontSize: 11)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      // Quantity stepper
                      _stepperBtn(Icons.remove_rounded, onDecrement),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text('${item.quantity}',
                            style: const TextStyle(color: BVColors.textPrimary, fontWeight: FontWeight.w700, fontSize: 15)),
                      ),
                      _stepperBtn(Icons.add_rounded, onIncrement),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$${(item.book.price * item.quantity).toStringAsFixed(2)}',
                  style: const TextStyle(color: BVColors.primaryLight, fontSize: 16, fontWeight: FontWeight.w800),
                ),
                if (item.quantity > 1)
                  Text(
                    '\$${item.book.price.toStringAsFixed(2)} each',
                    style: const TextStyle(color: BVColors.textMuted, fontSize: 10),
                  ),
                const SizedBox(height: 14),
                GestureDetector(
                  onTap: onRemove,
                  child: const Icon(Icons.close_rounded, color: BVColors.textMuted, size: 18),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _stepperBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: BVColors.surfaceElevated,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: BVColors.textPrimary, size: 16),
      ),
    );
  }
}
