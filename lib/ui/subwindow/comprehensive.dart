/*
Comprehensive Hall UI of the Xidian Directory.
Copyright (C) 2022 SuperBart

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

Please refer to ADDITIONAL TERMS APPLIED TO XIDIAN_DIRECTORY SOURCE CODE
if you want to use.
*/

import 'package:flutter/material.dart';
import 'package:xidian_directory/weight.dart';
import 'package:xidian_directory/SliverGridDelegateWithFixedHeight.dart';
import 'package:xidian_directory/data/shop_information_entity.dart';
import 'package:xidian_directory/communicate/XidianDirectorySession.dart';

class ComprehensiveWindow extends StatefulWidget {
  const ComprehensiveWindow({Key? key}) : super(key: key);

  @override
  State<ComprehensiveWindow> createState() => _ComprehensiveWindowState();
}

class _ComprehensiveWindowState extends State<ComprehensiveWindow> {
  String categoryToSent = "所有";
  String toSearch = "";

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size.width);
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 10,
                spreadRadius: 0.1,
                color: Colors.black.withOpacity(0.2),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: "在此搜索",
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (String text) {
                      setState(() {
                        toSearch = text;
                        _get(false);
                      });
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: DropdownButton(
                  value: categoryToSent,
                  icon: const Icon(
                    Icons.keyboard_arrow_down,
                  ),
                  underline: Container(
                    height: 2,
                  ),
                  items: [
                    for (var i in categories)
                      DropdownMenuItem(value: i, child: Text(i))
                  ],
                  onChanged: (String? value) {
                    setState(
                      () {
                        categoryToSent = value!;
                        _get(false);
                      },
                    );
                  },
                ),
              )
            ],
          ),
        ),
        Expanded(
          child: Container(
            // White edge on the left & right.
            // constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.9),
            child: RefreshIndicator(
              onRefresh: () async => _get(true),
              child: FutureBuilder<ShopInformationEntity>(
                future: _get(false),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return Center(child: Text("坏事: ${snapshot.error}"));
                    } else {
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedHeight(
                            maxCrossAxisExtent: 324, height: 200),
                        itemCount: snapshot.data.results.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) =>
                            ShopCard(toUse: snapshot.data.results[index]),
                      );
                    }
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<ShopInformationEntity> _get(bool isForceUpdate) async => getShopData(
      category: categoryToSent, toFind: toSearch, isForceUpdate: isForceUpdate);
}

class ShopCard extends StatelessWidget {
  final ShopInformationResults toUse;

  const ShopCard({Key? key, required this.toUse}) : super(key: key);

  Icon _iconForTarget() {
    switch (toUse.category) {
      case '饮食':
        return const Icon(Icons.restaurant);
      case '生活':
        return const Icon(Icons.nightlife);
      case '打印':
        return const Icon(Icons.print);
      case '学习':
        return const Icon(Icons.book);
      case '快递':
        return const Icon(Icons.local_shipping);
      case '超市':
        return const Icon(Icons.store);
      case '饮用水':
        return const Icon(Icons.water_drop);
      default:
        return const Icon(Icons.lightbulb);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ShadowBox(
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  toUse.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.left,
                  textScaleFactor: 1.25,
                ),
                TagsBoxes(
                  text: toUse.status ? "开放" : "关闭",
                  backgroundColor: toUse.status ? Colors.green : Colors.red,
                )
              ],
            ),
            Row(
              children: [
                _iconForTarget(),
                const SizedBox(width: 5),
                for (var i in toUse.tags)
                  Row(
                    children: [
                      TagsBoxes(
                        text: i,
                      ),
                      const SizedBox(width: 4)
                    ],
                  )
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(2.5, 0, 0, 0),
              child: Text(
                toUse.description ?? "没有描述",
                maxLines: 1,
                overflow: TextOverflow.fade,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("${toUse.name}的描述"),
                      content: Text(
                        toUse.description ?? "没有描述",
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text("确定"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  ),
                  child: const Text("详情"),
                ),
                /*
                    TextButton(
                      // To be implemented.
                      onPressed: () {},
                      child: const Text("纠正"),
                    ),
                    */
                Text(
                    "上次更新在 ${toUse.updatedAt.toLocal().toString().substring(0, 19)}"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
