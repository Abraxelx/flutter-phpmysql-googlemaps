import 'package:flutter/material.dart';
import 'Employee.dart';
import 'Services.dart';

class DataTableDemo extends StatefulWidget {
  DataTableDemo() : super();
  final String title = 'Flutter Data Table';
  @override
  DataTableDemoState createState() => DataTableDemoState();
}

class DataTableDemoState extends State<DataTableDemo> {
  List<Employee> employees;
  GlobalKey<ScaffoldState> _scaffoldKey;
  //First Name için Textfield denetleyici oluşturacağım.
  TextEditingController _firstNameController;
  //Last Name için Textfield denetleyici oluşturacağım.
  TextEditingController _lastNameController;
  Employee _selectedEmployee;
  bool _isUpdating;
  String _titleProgress;
  List<Employee> _employees;

  @override
  void initState() {
    super.initState();
    _employees = [];
    _isUpdating = false;
    _titleProgress = widget.title;
    _scaffoldKey =
        GlobalKey(); //SnackBar göstermek için bağlamı elde etmenin anahtarı
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _getEmployees();
  }

  //AppBar Başlığındaki başlığı güncelleme yöntemi
  _showProgress(String message) {
    setState(() {
      _titleProgress = message;
    });
  }

  _showSnackBar(context, message) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  _createTable() {
    _showProgress('Creating Table...');
    Services.createTable().then((result) {
      try {
        if ('success' == result) {
          _showSnackBar(context, result);
          _showProgress(widget.title);
        } else {
          _showSnackBar(context, result);
        }
      } catch (e) {
        _showSnackBar(context, e);
      }
    });
  }

  _addEmployee() {
    if (_firstNameController.text.isEmpty || _lastNameController.text.isEmpty) {
      print('Empty Fields');
      return;
    }
    _showProgress('Adding Employee...');
    Services.addEmployee(_firstNameController.text, _lastNameController.text)
        .then((result) {
      if ('success' == result) {
        _getEmployees(); //   her çalışanı ekledikten sonra listeyi yenile
        _clearValues();
      }
    });
  }

  _getEmployees() {
    _showProgress('Loading Employees...');
    Services.getEmployees().then((employees) {
      setState(() {
        _employees = employees;
      });
      _showProgress(widget.title); // başlığı sıfırla
      print("Lenght ${employees.length}");
    });
  }

  _updateEmployee(Employee employee) {
    setState(() {
      _isUpdating = true;
    });
    _showProgress('Updating Employee...');
    Services.updateEmployee(
            employee.id, _firstNameController.text, _lastNameController.text)
        .then((result) {
      if ('success' == result) {
        _getEmployees(); //güncellemeden sonra listeyi yenile
        setState(() {
          _isUpdating = false;
        });
        _clearValues();
      }
    });
  }

  _deleteEmployee(Employee employee) {
    _showProgress('Deleting Employee...');
    Services.deleteEmployee(employee.id).then((result) {
      if ('success' == result) {
        _getEmployees(); //sildikten sonra yenile
      }
    });
  }

  //textfield değerlerini temizleme yöntemi
  _clearValues() {
    _firstNameController.text = '';
    _lastNameController.text = '';
  }

  _showValues(Employee employee) {
    _firstNameController.text = employee.firstName;
    _lastNameController.text = employee.lastName;
  }

  //bir datatable oluşturalım ve içindeki çalışan listesini gösterelim
  SingleChildScrollView _dataBody() {
    //datatable için hem dikey hem de yatay kaydırma görünümü
    //hem dikey hem de yatay kaydırmak için
    return SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: [
              DataColumn(
                label: Text('ID'),
              ),
              DataColumn(
                label: Text('First Name'),
              ),
              DataColumn(
                label: Text('Last Name'),
              ),
              DataColumn(
                label: Text('Delete'),
              ),
            ],
            rows: _employees
                .map(
                  (employee) => DataRow(cells: [
                    DataCell(Text(employee.id),
                        //satırı metin alanlarını güncellemek için karşılık gelen değerlerle dolduralım
                        onTap: () {
                      _showValues(employee);
                      _selectedEmployee = employee;
                      setState(() {
                        _isUpdating = true;
                      });
                    }),
                    DataCell(
                        Text(
                          employee.firstName.toUpperCase(),
                        ), onTap: () {
                      _showValues(employee);
                      _selectedEmployee = employee;
                      //Güncelleme Modunda belirtmek için bayrak güncellemesini true olarak ayarlıyorum
                      setState(() {
                        _isUpdating = true;
                      });
                    }),
                    DataCell(
                        Text(
                          employee.lastName.toUpperCase(),
                        ), onTap: () {
                      _showValues(employee);
                      _selectedEmployee =
                          employee; //seçilen çalışanı güncellemeye ayarla
                      setState(() {
                        _isUpdating = true;
                      });
                    }),
                    DataCell(IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _deleteEmployee(employee);
                      },
                    ))
                  ]),
                )
                .toList(),
          ),
        ));
  }

  //UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(_titleProgress), //başlıkta ilerlemeyi gösteriyorum
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _createTable();
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _getEmployees();
            },
          )
        ],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20.0),
              child: TextField(
                controller: _firstNameController,
                decoration: InputDecoration.collapsed(
                  hintText: 'First Name',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: TextField(
                controller: _lastNameController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Last Name',
                ),
              ),
            ),
            //bir güncelleme düğmesi ve iptal düğmesi ekleliyorum
            //Bu düğmeleri yalnızca bir çalışanı güncellerken göster
            _isUpdating
                ? Row(
                    children: <Widget>[
                      OutlineButton(
                        child: Text('UPDATE'),
                        onPressed: () {
                          _updateEmployee(_selectedEmployee);
                        },
                      ),
                      OutlineButton(
                        child: Text('CANCEL'),
                        onPressed: () {
                          setState(() {
                            _isUpdating = false;
                          });
                          _clearValues();
                        },
                      ),
                    ],
                  )
                : Container(),
            Expanded(
              child: _dataBody(),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addEmployee();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
