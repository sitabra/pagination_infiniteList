import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> dogImages = [];
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    fetchFive();
    _scrollController.addListener(() {
      if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent){
        fetchFive();
      }
    });
  }
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pagination'),
      ),
      body: ListView.builder(
        controller: _scrollController,
        itemCount: dogImages.length,
          itemBuilder: (BuildContext context, int index) {
          if(index == dogImages.length-1) {
            return  const Center(
              child: SizedBox(
                width: 60,
                  height: 60,
                  child: CircularProgressIndicator()),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.network(dogImages[index],fit: BoxFit.fitWidth,),
          );
          }),
    );
  }

  fetch() async {
    final response = await get(Uri.parse('https://dog.ceo/api/breeds/image/random'));
  if(response.statusCode == 200) {
    if (kDebugMode) {
      print(response.body);
    }
    setState((){
      dogImages.add(json.decode(response.body)['message']);
    });
  }
  else{
    throw Exception('Failed to Load!');
  }
  }
  fetchFive() {
    for(int i=0; i<5;i++ ) {
      fetch();
    }
  }
}
