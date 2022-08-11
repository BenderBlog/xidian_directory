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
import 'package:xidian_directory/ui/subwindow/comprehensive.dart';
import 'package:xidian_directory/ui/subwindow/dininghall.dart';
import 'package:xidian_directory/ui/subwindow/telebook.dart';

class XidianDirWindow extends StatelessWidget {
  const XidianDirWindow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const TabForXDDir();
  }
}

class TabForXDDir extends StatelessWidget {
  const TabForXDDir({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("西电目录"),
          actions: [
            IconButton(
              icon: const Icon(Icons.info),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
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
                    ));
              },

            ),

          ],
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.store_mall_directory)),
              Tab(icon: Icon(Icons.restaurant)),
              Tab(icon: Icon(Icons.phone)),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ComprehensiveWindow(),
            DiningHallWindow(),
            TeleBookWindow(),
          ],
        ),
      ),
    );
  }
}
