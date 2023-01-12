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
import 'package:xidian_directory/widget.dart';
import 'package:xidian_directory/page/comprehensive.dart' deferred as com;
import 'package:xidian_directory/page/dininghall.dart' deferred as din;
import 'package:xidian_directory/page/telebook.dart' deferred as tel;

var app = MaterialApp(
  title: '西电目录',
  theme: ThemeData(
    primarySwatch: Colors.deepPurple,
  ),
  home: const XidianDir(),
);

class XidianDir extends StatefulWidget {
  const XidianDir({super.key});

  @override
  State<XidianDir> createState() => _XidianDirState();
}

class _XidianDirState extends State<XidianDir> {
  final Widget _com_win = FutureBuilder<void>(
    future: com.loadLibrary(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        return com.ComprehensiveWindow();
      }
      return loading;
    },
  );

  final Widget _din_win = FutureBuilder<void>(
    future: din.loadLibrary(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        return din.DiningHallWindow();
      }
      return loading;
    },
  );

  final Widget _tel_win = FutureBuilder<void>(
    future: tel.loadLibrary(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        return tel.TeleBookWindow();
      }
      return loading;
    },
  );

  late Widget _toShow;
  String _current = "综合楼";

  void changePage(String current) => setState(() {
        _current = current;
        if (_current == "综合楼") {
          _toShow = _com_win;
        }
        if (_current == "食堂") {
          _toShow = _din_win;
        }
        if (_current == "电话本") {
          _toShow = _tel_win;
        }
        if (!isDesktop(context)) Navigator.of(context).pop();
      });

  @override
  void initState() {
    _toShow = _com_win;
    super.initState();
  }

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
                title: Text(_current),
                actions: buttons,
              ),
              body: SafeArea(child: _toShow),
            ),
          ),
        ],
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(_current),
          actions: buttons,
        ),
        body: SafeArea(child: _toShow),
        drawer: ListDrawer(mainPageCallback: changePage),
      );
    }
  }
}

class ListDrawer extends StatelessWidget {
  final ValueChanged<String> mainPageCallback;
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
                mainPageCallback("综合楼");
              },
            ),
            ListTile(
              leading: const Icon(Icons.restaurant),
              title: const Text('食堂'),
              onTap: () {
                mainPageCallback("食堂");
              },
            ),
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('电话本'),
              onTap: () {
                mainPageCallback("电话本");
              },
            ),
          ],
        ),
      ),
    );
  }
}
