/*
Intro UI of the Xidian Directory. With the bar.
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
import 'package:xidian_directory/page/comprehensive.dart';
import 'package:xidian_directory/page/dininghall.dart';
import 'package:xidian_directory/page/telebook.dart';

class XidianDir extends StatefulWidget {
  const XidianDir({super.key});

  @override
  State<XidianDir> createState() => _XidianDirState();
}

class _XidianDirState extends State<XidianDir> {
  Widget toShow = const ComprehensiveWindow();
  String current = "综合楼";

  void changePage(Widget newPage) => setState(() {
        toShow = newPage;
        if (toShow.runtimeType == ComprehensiveWindow) {
          current = "综合楼";
        }
        if (toShow.runtimeType == DiningHallWindow) {
          current = "食堂";
        }
        if (toShow.runtimeType == TeleBookWindow) {
          current = "电话本";
        }
        if (!isDesktop(context)) Navigator.of(context).pop();
      });

  Widget about(context) => AlertDialog(
        title: const Text('关于西电目录'),
        content: const Text(
          "This Flutter frontend, \nCopyright 2022 SuperBart.\n"
          "\nOriginal React/Chakra-UI frontend, \nCopyright 2022 hawa130.\n"
          "\nData used with permission from \nXidian Directory Development Group.\n"
          "\nBender have shiny metal ass which should not be bitten.\n",
        ),
        actions: <Widget>[
          TextButton(
            child: const Text("确定"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (isDesktop(context)) ListDrawer(mainPageCallback: changePage),
        if (isDesktop(context)) const VerticalDivider(width: 1),
        Expanded(
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: !isDesktop(context),
              title: Text(current),
              actions: [
                IconButton(
                  icon: const Icon(Icons.info),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: about,
                    );
                  },
                ),
              ],
            ),
            body: SafeArea(child: toShow),
            drawer: ListDrawer(mainPageCallback: changePage),
          ),
        ),
      ],
    );
  }
}

class ListDrawer extends StatelessWidget {
  final ValueChanged<Widget> mainPageCallback;
  const ListDrawer({super.key, required this.mainPageCallback});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          children: [
            const ListTile(
              title: SelectableText(
                "西电目录 Flutter 网页版",
                style: TextStyle(fontSize: 20),
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.store_mall_directory),
              title: const Text('综合楼'),
              onTap: () {
                mainPageCallback(const ComprehensiveWindow());
              },
            ),
            ListTile(
              leading: const Icon(Icons.restaurant),
              title: const Text('食堂'),
              onTap: () {
                mainPageCallback(const DiningHallWindow());
              },
            ),
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('电话本'),
              onTap: () {
                mainPageCallback(TeleBookWindow());
              },
            ),
          ],
        ),
      ),
    );
  }
}
