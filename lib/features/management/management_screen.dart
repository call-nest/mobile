import 'package:defaults/features/management/viewmodels/manage_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/files.dart';

class ManagementScreen extends StatefulWidget {
  static const routeUrl = '/managementScreen';
  static const routeName = 'managementScreen';

  const ManagementScreen({super.key});

  @override
  State<ManagementScreen> createState() => _ManagementScreenState();
}

class _ManagementScreenState extends State<ManagementScreen> {

  late ManageViewModel manageViewModel;

  @override
  void initState() {
    super.initState();
    manageViewModel = Provider.of<ManageViewModel>(context, listen: false);
    manageViewModel.getFiles();
  }

  @override
  void dispose() {
    manageViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Management'),
      ),
      body: Consumer<ManageViewModel>(
        builder: (context, viewModel, child){
          return ListView.builder(
            itemCount: viewModel.files.length,
            itemBuilder: (context, index){
              final Files data = viewModel.files[index];
              return SwitchListTile(
                subtitle: Text(data.userId.toString()),
                title: Text(data.title),
                value: data.status == 1,
                onChanged: (value){
                  data.status = value ? 1 : 0;
                  viewModel.updateFile(data.id, data.status);
                },
              );
            }
          );
        }
      )
    );
  }
}
