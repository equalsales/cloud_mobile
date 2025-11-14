// ignore_for_file: must_be_immutable

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_mobile/list/hsn_list.dart';
import 'package:cloud_mobile/list/item_list.dart';
import 'package:cloud_mobile/list/design_list.dart';
import 'package:cloud_mobile/common/bottombar.dart';
import 'package:cloud_mobile/common/global.dart' as globals;

class SaleOrderDetAdd extends StatefulWidget {
  SaleOrderDetAdd(
      {Key? mykey, companyid, companyname, fbeg, fend, ptyState, itemDet, id})
      : super(key: mykey) {
    xcompanyid = companyid;
    xcompanyname = companyname;
    xfbeg = fbeg;
    xfend = fend;
    xPtyState = ptyState;
    xid = id;
    xItemDetails = itemDet;
  }

  var xcompanyid;
  var xcompanyname;
  var xfbeg;
  var xfend;
  var xPtyState;
  var xid;
  List xitemDet = [];
  List xItemDetails = [];

  @override
  _SaleOrderDetAddState createState() => _SaleOrderDetAddState();
}

class _SaleOrderDetAddState extends State<SaleOrderDetAdd> {
  // DateTime fromDate = DateTime.now();
  // DateTime toDate = DateTime.now();
  final _formKey = GlobalKey<FormState>();

  final _itemnameCtrl = new TextEditingController();
  final _hsncodeCtrl = new TextEditingController();
  final _designCtrl = new TextEditingController();
  final _pcsCtrl = new TextEditingController(text: '0');
  final _metersCtrl = new TextEditingController(text: '0.00');
  final _rateCtrl = new TextEditingController(text: '0.00');
  final _amountCtrl = new TextEditingController(text: '0');
  final _discPer1Ctrl = new TextEditingController(text: '0.00');
  final _discAmt1Ctrl = new TextEditingController(text: '0.00');
  final _addAmt1Ctrl = new TextEditingController(text: '0.00');
  final _taxableValueCtrl = new TextEditingController(text: '0.00');
  final _sgstRateCtrl = new TextEditingController(text: '0.00');
  final _sgstAmtCtrl = new TextEditingController(text: '0.00');
  final _cgstRateCtrl = new TextEditingController(text: '0.00');
  final _cgstAmtCtrl = new TextEditingController(text: '0.00');
  final _igstRateCtrl = new TextEditingController(text: '0.00');
  final _igstAmtCtrl = new TextEditingController(text: '0.00');
  final _finalAmtCtrl = new TextEditingController(text: '0.00');
  final _gstCtrl = new TextEditingController(text: 'Y');

  String? dropdownUnitType;

  var UnitType = [
    '',
    'P',
    'C',
    'W',
    'M',
  ];

  @override
  void initState() {
    super.initState();
    calcSaleOrderGrid();
    // fromDate = retconvdate(widget.xfbeg);
    // toDate = retconvdate(widget.xfend);
    // var curDate = getsystemdate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('Sale Order Item Details',
                style: const TextStyle(
                    fontSize: 25.0, fontWeight: FontWeight.normal))),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.done),
            backgroundColor: Colors.green,
            onPressed: () => {
                  if (_formKey.currentState!.validate())
                    {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content:const Text('Form submitted successfully')),
                      ),
                      saveData()
                    }
                }),
        body: SingleChildScrollView(
            child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      enabled: true,
                      controller: _itemnameCtrl,
                      decoration: const InputDecoration(
                          icon: const Icon(Icons.person),
                          hintText: 'Item Name',
                          labelText: 'Item Name'),
                      onTap: gotoItemnameList,
                      validator: (value) {
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _hsncodeCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          icon: const Icon(Icons.person),
                          hintText: 'HSN Code',
                          labelText: 'HSN Code'),
                      onTap: openHSNList,
                      validator: (value) {
                        return null;
                      },
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      enabled: true,
                      controller: _designCtrl,
                      decoration: const InputDecoration(
                          icon: const Icon(Icons.person),
                          hintText: 'Design',
                          labelText: 'Design'),
                      onTap: openDesignList,
                      validator: (value) {
                        return null;
                      },
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _pcsCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          icon: const Icon(Icons.person),
                          hintText: 'Pcs / Taka',
                          labelText: 'Pcs'),
                      onChanged: (value) {},
                      validator: (value) {
                        return null;
                      },
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      enabled: true,
                      controller: _metersCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          icon: const Icon(Icons.person),
                          hintText: 'Meters',
                          labelText: 'Meters'),
                      validator: (value) {
                        return null;
                      },
                    ),
                  )
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _rateCtrl,
                      enabled: true,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          icon: const Icon(Icons.person),
                          hintText: 'Rate',
                          labelText: 'Rate'),
                      validator: (value) {
                        return null;
                      },
                    ),
                  ),
                  Expanded(
                    child: DropdownButtonFormField(
                        value: dropdownUnitType,
                        decoration: const InputDecoration(
                            labelText: 'Unit',
                            hintText: "Unit",
                            icon: const Icon(Icons.person)),
                        items: UnitType.map((String items) {
                          return DropdownMenuItem(
                              value: items, child: Text(items));
                        }).toList(),
                        icon: const Icon(Icons.arrow_drop_down_circle),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownUnitType = newValue!;
                          });
                          _calcAmount();
                        }),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      enabled: true,
                      controller: _amountCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          icon: const Icon(Icons.person),
                          hintText: 'Amount',
                          labelText: 'Amount'),
                      validator: (value) {
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      enabled: true,
                      controller: _discPer1Ctrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          icon: const Icon(Icons.person),
                          hintText: 'Disc1 %',
                          labelText: 'Disc1 %'),
                      validator: (value) {
                        return null;
                      },
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      enabled: true,
                      controller: _discAmt1Ctrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          icon: const Icon(Icons.person),
                          hintText: 'DiscAmt1',
                          labelText: 'DiscAmt1'),
                      validator: (value) {
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      enabled: true,
                      controller: _addAmt1Ctrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          icon: const Icon(Icons.person),
                          hintText: 'AddAmt1',
                          labelText: 'AddAmt1'),
                      validator: (value) {
                        return null;
                      },
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      enabled: false,
                      controller: _taxableValueCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          icon: const Icon(Icons.person),
                          hintText: 'TaxableValue',
                          labelText: 'TaxableValue'),
                      validator: (value) {
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      enabled: true,
                      controller: _sgstRateCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          icon: const Icon(Icons.person),
                          hintText: 'SGST %',
                          labelText: 'SGST %'),
                      validator: (value) {
                        return null;
                      },
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      enabled: true,
                      controller: _sgstAmtCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          icon: const Icon(Icons.person),
                          hintText: 'SGST',
                          labelText: 'SGST'),
                      validator: (value) {
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      enabled: true,
                      controller: _cgstRateCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          icon: const Icon(Icons.person),
                          hintText: 'CGST %',
                          labelText: 'CGST %'),
                      validator: (value) {
                        return null;
                      },
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      enabled: true,
                      controller: _cgstAmtCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          icon: const Icon(Icons.person),
                          hintText: 'CGST',
                          labelText: 'CGST'),
                      validator: (value) {
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      enabled: true,
                      controller: _igstRateCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          icon: const Icon(Icons.person),
                          hintText: 'IGST %',
                          labelText: 'IGST %'),
                      validator: (value) {
                        return null;
                      },
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      enabled: true,
                      controller: _igstAmtCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          icon: const Icon(Icons.person),
                          hintText: 'IGST',
                          labelText: 'IGST'),
                      validator: (value) {
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      enabled: true,
                      controller: _finalAmtCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                          icon: const Icon(Icons.person),
                          hintText: 'FinalAmt',
                          labelText: 'FinalAmt'),
                      validator: (value) {
                        return null;
                      },
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      enabled: false,
                      controller: _gstCtrl,
                      decoration: const InputDecoration(
                          icon: const Icon(Icons.person),
                          hintText: '_GST',
                          labelText: '_GST'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20)
            ],
          ),
        )),
        bottomNavigationBar: BottomBar(
            companyname: widget.xcompanyname,
            fbeg: widget.xfbeg,
            fend: widget.xfend));
  }

  Future<bool> saveData() async {
    var itemname = _itemnameCtrl.text;
    var hsncode = _hsncodeCtrl.text;
    var design = _designCtrl.text;
    var pcs = _pcsCtrl.text;
    var meters = _metersCtrl.text;
    var rate = _rateCtrl.text;
    var unit = dropdownUnitType;
    var amount = _amountCtrl.text;
    var discPer1 = _discPer1Ctrl.text;
    var discAmt1 = _discAmt1Ctrl.text;
    var addAmt1 = _addAmt1Ctrl.text;
    var taxableValue = _taxableValueCtrl.text;
    var sgstRate = _sgstRateCtrl.text;
    var sgstAmt = _sgstAmtCtrl.text;
    var cgstRate = _cgstRateCtrl.text;
    var cgstAmt = _cgstAmtCtrl.text;
    var igstRate = _igstRateCtrl.text;
    var igstAmt = _igstAmtCtrl.text;
    var finalAmt = _finalAmtCtrl.text;

    widget.xitemDet.add({
      'itemname': itemname,
      'hsncode': hsncode,
      'design': design,
      'pcs': pcs,
      'meters': meters,
      'rate': rate,
      'unit': unit,
      'amount': amount,
      'discper': discPer1,
      'discamt': discAmt1,
      'addamt': addAmt1,
      'taxablevalue': taxableValue,
      'sgstrate': sgstRate,
      'sgstamt': sgstAmt,
      'cgstrate': cgstRate,
      'cgstamt': cgstAmt,
      'igstrate': igstRate,
      'igstamt': igstAmt,
      'finalamt': finalAmt,
      '_gst': finalAmt,
    });

    Navigator.pop(context, widget.xitemDet);
    return true;
  }

  void gotoItemnameList() async {
    var result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => item_list(
                companyid: widget.xcompanyid,
                companyname: widget.xcompanyname,
                fbeg: widget.xfbeg,
                fend: widget.xfend)));

    var retResult = result;
    var newResult = result[1];
    var selItemname = '';
    for (var ictr = 0; ictr < retResult[0].length; ictr++) {
      if (ictr > 0) {
        selItemname = selItemname + ',';
      }
      selItemname = selItemname + retResult[0][ictr];
    }
    // setState(() {
    _itemnameCtrl.text = newResult[0]['itemname'].toString();
    _hsncodeCtrl.text = newResult[0]['hsncode'].toString();
    // });
  }

  void openHSNList() async {
    var result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => HSN_list(
                companyid: widget.xcompanyid,
                companyname: widget.xcompanyname,
                fbeg: widget.xfbeg,
                fend: widget.xfend,
                acctype: "")));

    List _hsnlist = result[0];

    var selParty = _hsnlist.firstOrNull;
    // setState(() {
    _hsncodeCtrl.text = selParty;
    // });
  }

  void openDesignList() async {
    var result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => design_list(
                companyid: widget.xcompanyid,
                companyname: widget.xcompanyname,
                fbeg: widget.xfbeg,
                fend: widget.xfend)));
    var retResult = result;
    var selDesign = '';
    for (var ictr = 0; ictr < retResult.length; ictr++) {
      if (ictr > 0) {
        selDesign = selDesign + ',';
      }
      selDesign = selDesign + retResult[ictr].toString();
    }
    // setState(() {
    _designCtrl.text = selDesign;
    // });
  }

  void getHsnDet() async {
    String url = "${globals.cdomain}/api/api_gethsndet?1=1"
            "&dbname=${globals.dbname}" +
        "&hsncode=${_hsncodeCtrl.text}" +
        "&statename=${widget.xPtyState}" +
        "&costatename=${globals.companystate}" +
        "&rate=${_rateCtrl.text}";

    print("hsn url => " + url);

    var response = await http.get(Uri.parse(url));

    var res = jsonDecode(response.body);
    print('hsn res => ${res}');

    if (res.toString().contains('success')) {
      if (res['success']) {
        _sgstRateCtrl.text = res['sgstrate'].toString();
        _cgstRateCtrl.text = res['cgstrate'].toString();
        _igstRateCtrl.text = res['igstrate'].toString();
      }
    }
  }

  //to calculate Amount ..
  void _calcAmount() {
    var nPcs = int.tryParse(_pcsCtrl.text) ?? 0;
    var nMtrs = double.tryParse(_metersCtrl.text) ?? 0;
    var nRate = int.tryParse(_rateCtrl.text) ?? 0;
    var cPer = dropdownUnitType;
    num nAmount;

    if (cPer == 'P') {
      nAmount = nPcs * nRate;
    } else if (cPer == 'M') {
      nAmount = nMtrs * nRate;
    } else {
      nAmount = 0;
    }

    _amountCtrl.text = nAmount.toString();
  }

  // to calculate discounts ..
  void _calcDisc() {
    double amount = double.tryParse(_amountCtrl.text) ?? 0.0;
    double discPer = double.tryParse(_discPer1Ctrl.text) ?? 0.0;

    double nDiscAmt = 0;

    if (discPer > 0) nDiscAmt = (amount * discPer) / 100;

    _discAmt1Ctrl.text = nDiscAmt.toStringAsFixed(2);
  }

  // to calculate final amount ..
  void _calcFinalAmt() {
    double amount = double.tryParse(_amountCtrl.text) ?? 0.0;
    double discAmt = double.tryParse(_discAmt1Ctrl.text) ?? 0.0;
    double addAmt = double.tryParse(_addAmt1Ctrl.text) ?? 0.0;

    double cgstAmt = double.tryParse(_cgstAmtCtrl.text) ?? 0.0;
    double sgstAmt = double.tryParse(_sgstAmtCtrl.text) ?? 0.0;
    double igstAmt = double.tryParse(_igstAmtCtrl.text) ?? 0.0;

    double taxableValue = amount - discAmt + addAmt;

    double finalAmt = calcFinalAmount(
        nTaxableValue: taxableValue,
        nCGSTAmt: cgstAmt,
        nSGSTAmt: sgstAmt,
        NIGSTAmt: igstAmt);

    _finalAmtCtrl.text = finalAmt.toStringAsFixed(2);
  }

  // to calculate taxable value ..
  void _calcTaxableValue() {
    double amount = double.tryParse(_amountCtrl.text) ?? 0.0;
    double discAmt = double.tryParse(_discAmt1Ctrl.text) ?? 0.0;
    double addAmt = double.tryParse(_addAmt1Ctrl.text) ?? 0.0;

    double taxableValue = amount - discAmt + addAmt;
    _taxableValueCtrl.text = taxableValue.toStringAsFixed(2);
  }

  // to calculate CGST Amount ..
  void _calcCGSTAmt() {
    double taxablevalue = double.tryParse(_taxableValueCtrl.text) ?? 0.0;
    double CGSTRate = double.tryParse(_cgstRateCtrl.text) ?? 0.0;

    double CGSTAmt =
        calcCGSTAmount(nCGSTRate: CGSTRate, nTaxableValue: taxablevalue);
    _cgstAmtCtrl.text = CGSTAmt.toStringAsFixed(2);
  }

  // to calculate CGST Amount ..
  void _calcSGSTAmt() {
    double taxablevalue = double.tryParse(_taxableValueCtrl.text) ?? 0.0;
    double SGSTRate = double.tryParse(_sgstRateCtrl.text) ?? 0.0;

    double SGSTAmt =
        calcSGSTAmount(nSGSTRate: SGSTRate, nTaxableValue: taxablevalue);
    _sgstAmtCtrl.text = SGSTAmt.toStringAsFixed(2);
  }

  // to calculate CGST Amount ..
  void _calcIGSTAmt() {
    double taxablevalue = double.tryParse(_taxableValueCtrl.text) ?? 0.0;
    double IGSTRate = double.tryParse(_igstRateCtrl.text) ?? 0.0;

    double IGSTAmt =
        calcIGSTAmount(nIGSTRate: IGSTRate, nTaxableValue: taxablevalue);
    _igstAmtCtrl.text = IGSTAmt.toStringAsFixed(2);
  }

  void calcSaleOrderGrid() {
    // To get gst details from HSN ..
    _hsncodeCtrl.addListener(getHsnDet);
    _rateCtrl.addListener(getHsnDet);

    if (_hsncodeCtrl.text.trim().isNotEmpty &&
        _rateCtrl.text.trim().isNotEmpty) {}

    // To calculate amount ..
    _pcsCtrl.addListener(_calcAmount);
    _metersCtrl.addListener(_calcAmount);
    _rateCtrl.addListener(_calcAmount);

    // To calculate Discounts ..
    _pcsCtrl.addListener(_calcDisc);
    _metersCtrl.addListener(_calcDisc);
    _amountCtrl.addListener(_calcDisc);
    _discPer1Ctrl.addListener(_calcDisc);

    // To calculate taxable value ..
    _amountCtrl.addListener(_calcTaxableValue);
    _discPer1Ctrl.addListener(_calcTaxableValue);
    _addAmt1Ctrl.addListener(_calcTaxableValue);

    //To calculate final amt ..
    _amountCtrl.addListener(_calcFinalAmt);
    _discPer1Ctrl.addListener(_calcFinalAmt);
    _discPer1Ctrl.addListener(_calcFinalAmt);

    _cgstAmtCtrl.addListener(_calcFinalAmt);
    _sgstAmtCtrl.addListener(_calcFinalAmt);
    _igstAmtCtrl.addListener(_calcFinalAmt);

    //To calculate SGST amt ..
    _taxableValueCtrl.addListener(_calcSGSTAmt);
    _sgstRateCtrl.addListener(_calcSGSTAmt);
    _pcsCtrl.addListener(_calcSGSTAmt);

    //To calculate CGST amt ..
    // _amountController.addListener(_calcCGSTAmt);
    _taxableValueCtrl.addListener(_calcCGSTAmt);
    _cgstRateCtrl.addListener(_calcCGSTAmt);

    //To calculate IGST amt ..
    _taxableValueCtrl.addListener(_calcIGSTAmt);
    _igstRateCtrl.addListener(_calcIGSTAmt);
  }
}

// Method to calculate final amount ..
double calcFinalAmount(
    {required double nTaxableValue,
    required double nCGSTAmt,
    required double nSGSTAmt,
    required double NIGSTAmt}) {
  return nTaxableValue + nCGSTAmt + nSGSTAmt + NIGSTAmt;
}

// Method to calculate SGST amount ..
double calcSGSTAmount(
    {required double nTaxableValue, required double nSGSTRate}) {
  if (nSGSTRate > 0) return ((nTaxableValue * nSGSTRate) / 100);
  return 0.0;
}

// Method to calculate CGST amount ..
double calcCGSTAmount(
    {required double nTaxableValue, required double nCGSTRate}) {
  if (nCGSTRate > 0) return ((nTaxableValue * nCGSTRate) / 100);
  return 0.0;
}

// Method to calculate IGST amount ..
double calcIGSTAmount(
    {required double nTaxableValue, required double nIGSTRate}) {
  if (nIGSTRate > 0) return ((nTaxableValue * nIGSTRate) / 100);
  return 0.0;
}
