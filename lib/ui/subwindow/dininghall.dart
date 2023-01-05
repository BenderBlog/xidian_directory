/*
Cafeteria UI of the Xidian Directory.
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

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:xidian_directory/SliverGridDelegateWithFixedHeight.dart';
import 'package:xidian_directory/weight.dart';
import 'package:xidian_directory/data/cafeteria_window_item_entity.dart';
import 'package:xidian_directory/communicate/XidianDirectorySession.dart';

class DiningHallWindow extends StatefulWidget {
  const DiningHallWindow({Key? key}) : super(key: key);

  @override
  State<DiningHallWindow> createState() => _DiningHallWindowState();
}

class _DiningHallWindowState extends State<DiningHallWindow> {
  String toSearch = "";
  String goToWhere = "竹园一楼";
  @override
  Widget build(BuildContext context) {
    return Column(children: [
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
                value: goToWhere,
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
                      goToWhere = value!;
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
          constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width > 1280
                  ? MediaQuery.of(context).size.width * 0.8
                  : MediaQuery.of(context).size.width),
          child: RefreshIndicator(
            onRefresh: () async => _get(true),
            child: FutureBuilder<List<WindowInformation>>(
              future: _get(false),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Center(
                        child:
                            Text("坏事: ${snapshot.error} + ${snapshot.data}"));
                  } else {
                    return ListView(
                      children: [
                        for (var i in snapshot.data) CafeteriaCard(toUse: i),
                      ],
                    );
                  }
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ),
      )
    ]);
  }

  Future<List<WindowInformation>> _get(bool isForceUpdate) async =>
      getCafeteriaData(
          toFind: toSearch, where: goToWhere, isForceUpdate: isForceUpdate);
}

class CafeteriaCard extends StatelessWidget {
  final WindowInformation toUse;

  const CafeteriaCard({Key? key, required this.toUse}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShadowBox(
        child: Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                if (toUse.number != null)
                  Row(
                    children: [
                      TagsBoxes(
                        text: toUse.number.toString(),
                        backgroundColor: Colors.grey,
                      ),
                      const SizedBox(width: 10),
                    ],
                  ),
                SizedBox(
                  width: 150,
                  child: Text(
                    toUse.name,
                    textAlign: TextAlign.left,
                    textScaleFactor: 1.5,
                    overflow: TextOverflow.ellipsis,
                    softWrap: true,
                  ),
                )
              ]),
              Row(
                children: [
                  TagsBoxes(
                      text: toUse.places, backgroundColor: Colors.deepPurple),
                  const SizedBox(width: 5),
                  TagsBoxes(
                    text: toUse.state() ? "开放" : "关门",
                    backgroundColor: toUse.state() ? Colors.green : Colors.red,
                  ),
                ],
              ),
            ],
          ),
          if (toUse.commit != null)
            Row(
              children: [
                const SizedBox(height: 5),
                Flexible(
                  child: Text("${toUse.commit}"),
                )
              ],
            ),
          const Divider(height: 28.0),
          GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedHeight(
                maxCrossAxisExtent: 375,
                height: 70,
                mainAxisSpacing: 15.0,
                crossAxisSpacing: 15.0),
            itemCount: toUse.items.length,
            shrinkWrap: true,
            itemBuilder: (context, index) =>
                ItemBox(toUse: toUse.items.elementAt(index)),
          ),
        ],
      ),
    ));
  }
}

class ItemBox extends StatelessWidget {
  final WindowItemsGroup toUse;
  const ItemBox({Key? key, required this.toUse}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 237, 242, 247),
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              toUse.commit == null
                  ? toUse.name
                  : "${toUse.name}\n${toUse.commit!}",
              textScaleFactor: 1.10,
              style: TextStyle(
                decoration: !toUse.status
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
            Row(
              children: [
                Text(
                  "${toUse.price.join(" 或 ")} 元每${toUse.unit}",
                  textScaleFactor: 1.10,
                  style: TextStyle(
                    decoration: !toUse.status
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
