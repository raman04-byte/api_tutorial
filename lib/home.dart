import 'package:apitutorial/model/response/list_of_response.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ListOfData> _list = [];

  Future<List<ListOfData>> getAllData() async {
    try {
      final response =
          await http.get(Uri.parse('https://fakestoreapi.com/products'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _list = data.map<ListOfData>((e) => ListOfData.fromJson(e)).toList();
        debugPrint('${_list.length}');
        return _list;
      } else {
        debugPrint(
            'Error in API call Please check your backend and URL carefully');
      }
      return _list;
    } catch (e) {
      debugPrint('$e');
    }
    return _list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: getAllData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: _list.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text('${_list[index].title}'),
                      subtitle: Text('${_list[index].description}'),
                      leading: SizedBox(
                        height: 50,
                        width: 50,
                        child: CachedNetworkImage(
                          imageUrl: '${_list[index].image}',
                          progressIndicatorBuilder: (context, url, progress) =>
                              CircularProgressIndicator(
                                  value: progress.progress),
                        ),
                      ),
                      trailing: Text('${_list[index].price}'),
                    );
                  });
            } else if (snapshot.hasError) {
              return const Text("Error");
            }
            return const Text("No Data");
          }),
    );
  }
}
