import 'dart:convert';

import 'package:flutter/material.dart';

// http
import 'package:http/http.dart' as http;


class MessageScreen extends StatefulWidget {

  final String id;
  final String name;

  const MessageScreen({Key? key, required this.id, required this.name}) : super(key: key);

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {



  // post data function
  void postData() async {

    // url
    var url = 'http://118.179.223.20:7002/ords/xact_erp/notifytest/temp';

    // params value
    var params = {
      'P_id' : widget.id ,
      'P_name' : widget.name,
    };

    // send the post request
    final response = await http.post(Uri.parse(url), body: jsonEncode(params));


    if(response.statusCode == 200 ){

      print('Data posted successfully');
    }
    else{
      throw Exception('error');
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(


      // appbar
      appBar: AppBar(
        title: Text('Message Screens'+ widget.id),
      ),

      // body
      body: Column(

        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [



          // Payload data
          Card(

            child: Column(

              children: [



                Row(

                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                  children: [

                    Text(widget.id.toString()),

                    Text(widget.name.toString()),
                  ],
                )
              ],
            ),
          ),

          // Text(widget.id.toString()),


          SizedBox(height: MediaQuery.of(context).size.height * 0.04,),

          // button
          GestureDetector(

            // onTap function
            onTap: postData,

            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(

                height: 50,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Center(child: Text('Post Data',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                )),
              ),
            ),
          ),

        ],
      ),



    );
  }
}
