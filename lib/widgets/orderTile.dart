import 'package:flutter/material.dart';

class OrderTile extends StatefulWidget {
  final Map<String, dynamic> order;
  final Function(Map<String, dynamic>) onUpdateOrderStatus;
  const OrderTile(
      {super.key, required this.order, required this.onUpdateOrderStatus});

  @override
  State<OrderTile> createState() => _OrderTileState();
}

class _OrderTileState extends State<OrderTile> {
  bool orderInProgress = true;
  @override
  Widget build(BuildContext context) {
    print("recived this --> ");
    print(widget.order);
    Map<String, dynamic> orderData = widget.order["detail"];
    String name = widget.order["contact"];
    String contactNumber = widget.order["contact"];
    String orderName = orderData["displayName"];
    String instuctions = orderData["instruction"];
    List<dynamic> addOnsList = orderData["addOns"];
    String addOns = "";

    for (int i = 0; i < addOnsList.length; i++) {
      addOns += addOnsList[i]["name"];
      if (i != (addOnsList.length - 1)) {
        addOns += ",";
      }
    }

    void onOrderStatusChange(bool readyToServe) {
      setState(() {
        orderInProgress = readyToServe;
      });
    }

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ListTile(
        title: Text('Name: $orderName'),
        subtitle: Text(
            'Contact Number: $contactNumber\nOrder: $name\nInstructions: $instuctions\nAdd Ons : $addOns'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                // Handle button press to indicate order in progress
              },
              style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                      orderInProgress ? Colors.red : Colors.grey)),
              child: const Text('In Progress'),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                //onOrderStatusChange(!orderInProgress);
                Future.delayed(const Duration(seconds: 3), () {});
                widget.onUpdateOrderStatus(widget.order);
                print("Button pressed, firing calls now !");
              },
              style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(
                    orderInProgress ? Colors.grey : Colors.green),
              ),
              child: const Text('Placed'),
            ),
          ],
        ),
      ),
    );
  }
}
