import 'dart:convert';
import 'package:cafe_dejavu_kot/Providers/kitchen_type_count_provider.dart';
import 'package:cafe_dejavu_kot/Providers/order_item_list_provider.dart';
import 'package:cafe_dejavu_kot/widgets/orderTile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final channel = WebSocketChannel.connect(Uri.parse('ws://localhost:8080'));
  @override
  void initState() {
    super.initState();
    streamListener();
  }

  streamListener() {
    channel.stream.listen((event) {
      final getData = jsonDecode(event);
      String kitchenType = getData["detail"]["kitchen"];
      ref.read(orderItemListProvider.notifier).addItem(getData);
      ref.read(kitchenTypeCountProvider.notifier).addItem(kitchenType);
      print(getData);
    });
  }

  void onOrderDeliveredSuccessfully(Map<String, dynamic> order) async {
    print("Function has been called successfully , now http post will happen");
    String removeId = order["_id"];
    String kitchenType = order["detail"]["kitchen"];
    const url = 'http://localhost:5000/orderCRUD/update/subOrder';
    final uri = Uri.parse(url);
    Map<String, dynamic> sendItem = {"subOrderId": removeId, "status": 1};
    var body = jsonEncode(sendItem);
    var response = await http.post(
      uri,
      headers: <String, String>{
        "Content-Type": "application/json",
      },
      body: body,
    );
    if (response.statusCode == 200) {
      print("Server Post request successful! ${response.body}");
    } else {
      print("Connection with the server has failed ${response.statusCode}");
    }
    ref.read(orderItemListProvider.notifier).removeItem(removeId);
    ref.read(kitchenTypeCountProvider.notifier).removeItem(kitchenType);
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> ordersList = ref.watch(orderItemListProvider);
    Map<String, int> kitchenTypeCounter = ref.watch(kitchenTypeCountProvider);

    print("Currently inside build");
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Cafe Deja Vu KOT",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 40, 145, 231),
        centerTitle: true,
      ),
      body: Row(
        children: [
          Container(
            height: double.infinity,
            width: MediaQuery.of(context).size.width / 3,
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 158, 157, 157),
            ),
            child: ListView(
              children: [
                const Center(
                  child: Text(
                    "ACTIVITY LOGS",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                ...kitchenTypeCounter.entries
                    .map(
                      (e) => ListTile(
                        title: Text('${e.key} : ${e.value.toString()}'),
                      ),
                    )
                    .toList(),
              ],
            ),
          ),
          Container(
            height: double.infinity,
            width: MediaQuery.of(context).size.width * 2 / 3,
            decoration:
                const BoxDecoration(color: Color.fromARGB(255, 236, 211, 211)),
            child: ListView(
              children: [
                const Center(
                  child: Text(
                    "CURRENT ORDERS",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                ...ordersList
                    .map((e) => OrderTile(
                          order: e,
                          onUpdateOrderStatus: onOrderDeliveredSuccessfully,
                        ))
                    .toList(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
