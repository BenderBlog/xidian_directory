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
import 'package:xidian_directory/widget.dart';
import 'package:xidian_directory/SliverGridDelegateWithFixedHeight.dart';
import 'package:xidian_directory/model/shop_information_entity.dart';
import 'package:xidian_directory/repository/session.dart';

class ComprehensiveWindow extends StatefulWidget {
  const ComprehensiveWindow({Key? key}) : super(key: key);

  @override
  State<ComprehensiveWindow> createState() => _ComprehensiveWindowState();
}

String categoryToSent = "所有";
TextEditingController toSearch = TextEditingController();
ShopInformationEntity? toUse;

class _ComprehensiveWindowState extends State<ComprehensiveWindow> {
  void loadData() async {
    toUse ??= await getShopData(
        category: categoryToSent, toFind: "", isForceUpdate: true);
    if (mounted) {
      setState(() {});
    }
  }

  void search(String toSearch) async {
    setState(() {
      toUse = null;
    });
    toUse = await getShopData(category: categoryToSent, toFind: toSearch);
    if (mounted) {
      setState(() {});
    }
  }

  void changeCategory(String? newCategory) async {
    setState(() {
      toUse = null;
      categoryToSent = newCategory ?? "所有";
    });
    toUse = await getShopData(category: categoryToSent, toFind: toSearch.text);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                  child: TextFormField(
                    controller: toSearch,
                    decoration: const InputDecoration(
                      hintText: "在此搜索",
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: search,
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
                  onChanged: changeCategory,
                ),
              ),
            ],
          ),
        ),
        _list(toUse)
      ],
    );
  }

  Widget _list(ShopInformationEntity? toUse) {
    if (toUse != null) {
      if (toUse.results.isNotEmpty) {
        return Expanded(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return GridView.builder(
                padding: EdgeInsets.symmetric(
                  horizontal: constraints.maxWidth < 900
                      ? 12.5
                      : constraints.maxWidth * 0.05,
                  vertical: 0.0,
                ),
                gridDelegate: SliverGridDelegateWithFixedHeight(
                    maxCrossAxisExtent: 324, height: 190),
                itemCount: toUse.results.length,
                shrinkWrap: true,
                itemBuilder: (context, index) =>
                    ShopCard(toUse: toUse.results[index]),
              );
            },
          ),
        );
      } else {
        return Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [Icon(Icons.info), Text("没有结果，请检查参数")],
            ),
          ),
        );
      }
    } else {
      return const Expanded(child: Center(child: CircularProgressIndicator()));
    }
  }
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        toUse.name,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                        textScaleFactor: 1.25,
                      ),
                    ),
                    TagsBoxes(
                      text: toUse.status ? "开放" : "关闭",
                      backgroundColor: toUse.status ? Colors.green : Colors.red,
                    )
                  ],
                ),
                const Divider(),
                Row(
                  children: [
                    _iconForTarget(),
                    const SizedBox(width: 5),
                    for (var i in toUse.tags)
                      Row(
                        children: [
                          TagsBoxes(text: i),
                          const SizedBox(width: 4)
                        ],
                      )
                  ],
                ),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(2.5, 0, 0, 0),
                  child: Text(
                    toUse.description ?? "没有描述",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  child: const Text(
                    "详情",
                  ),
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
                ),
                /*
                TextButton(
                  // To be implemented.
                  onPressed: () {},
                  child: const Text("纠正"),
                ),
                */
                Text(
                  "上次更新 ${toUse.updatedAt.toLocal().toString().substring(0, 19)}",
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
