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
import 'package:url_launcher/url_launcher.dart';
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

  var buttons = [
    IconButton(
      icon: const Icon(Icons.home),
      onPressed: () => launchUrl(Uri.parse('https://legacy.superbart.xyz')),
    ),
    IconButton(
      icon: const Icon(Icons.code),
      onPressed: () => launchUrl(
          Uri.parse('https://github.com/BenderBlog/xidian_directory')),
    ),
    IconButton(
      icon: const Icon(Icons.info),
      onPressed: () => launchUrl(Uri.parse('https://ncov.hawa130.com/about')),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    if (isDesktop(context)) {
      return Row(
        children: [
          ListDrawer(mainPageCallback: changePage),
          const VerticalDivider(width: 1),
          Expanded(
            child: Scaffold(
              appBar: AppBar(
                title: Text(current),
                actions: buttons,
              ),
              body: SafeArea(child: toShow),
            ),
          ),
        ],
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(current),
          actions: buttons,
        ),
        body: SafeArea(child: toShow),
        drawer: ListDrawer(mainPageCallback: changePage),
      );
    }
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
