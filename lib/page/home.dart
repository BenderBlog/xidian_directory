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
import 'package:xidian_directory/page/comprehensive.dart';
import 'package:xidian_directory/page/dininghall.dart';
import 'package:xidian_directory/page/telebook.dart';

bool isDesktop(context) => MediaQuery.of(context).size.width > 1000;

class XidianDir extends StatefulWidget {
  const XidianDir({super.key});

  @override
  State<XidianDir> createState() => _XidianDirState();
}

class _XidianDirState extends State<XidianDir> {
  Widget toShow = const ComprehensiveWindow();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (isDesktop(context))
          Drawer(
            child: SafeArea(
              child: ListView(
                // Important: Remove any padding from the ListView.
                padding: EdgeInsets.zero,
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
                      setState(() {
                        toShow = const ComprehensiveWindow();
                      });
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.restaurant),
                    title: const Text('食堂'),
                    onTap: () {
                      setState(() {
                        toShow = const DiningHallWindow();
                      });
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.phone),
                    title: const Text('电话本'),
                    onTap: () {
                      setState(() {
                        toShow = const TeleBookWindow();
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        const VerticalDivider(width: 1),
        Expanded(
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: !isDesktop(context),
              title: const Text("西电目录 Flutter 网页版"),
            ),
            body: SafeArea(child: toShow),
            drawer: Drawer(
              child: SafeArea(
                child: ListView(
                  // Important: Remove any padding from the ListView.
                  padding: EdgeInsets.zero,
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
                        setState(() {
                          toShow = const ComprehensiveWindow();
                        });
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.restaurant),
                      title: const Text('食堂'),
                      onTap: () {
                        setState(() {
                          toShow = const DiningHallWindow();
                        });
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.phone),
                      title: const Text('电话本'),
                      onTap: () {
                        setState(() {
                          toShow = const TeleBookWindow();
                        });
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class ListDrawer extends StatefulWidget {
  const ListDrawer({super.key});

  @override
  State<ListDrawer> createState() => _ListDrawerState();
}

class _ListDrawerState extends State<ListDrawer> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
