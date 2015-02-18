import 'dart:html';
import 'package:slickdart/slick.dart' as grid;
import 'dart:math' as math;
import 'package:slickdart/slick_editor.dart';
import 'package:slickdart/slick_selectionmodel.dart';
void main() {
  grid.SlickGrid  g=init();
  g.init();
}

grid.SlickGrid init(){
  Element el =querySelector('#grid');
  List column = [
       new grid.Column.fromMap ({ 'field': "dtitle", 'sortable': true,'editor': 'TextEditor' }),
       new grid.Column.fromMap ({'width':120, 'field': "duration", 'sortable': true }),
       new grid.Column.fromMap ({'id': "%", 'name': "percent", 'field': "pc", 'sortable': true }),
       new grid.Column.fromMap ({'field': "City", 'editor': new SelectListEditor({"NY":"New York", "TPE":"Taipei"})})
  ];
  List data=[];
  for (var i = 0; i < 50; i++) {
    data.add( {
      'dtitle':  new math.Random().nextInt(100).toString(),
      'duration': new math.Random().nextInt(100).toString(),
      'pc': new math.Random().nextInt(10) * 100,
      'City': "NY"
    });
  }
  Map opt = {'explicitInitialization': false,
             'multiColumnSort': true,
             'editable': true,
  };
  grid.SlickGrid sg= new grid.SlickGrid(el,data,column,opt);

  sg.setSelectionModel(new CellSelectionModel(sg.options));

  sg.onBeforeEditCell.subscribe((e,args){
    //swap editor here
    print(args['column']);
  });
  sg.onSort.subscribe( (e, args) {
    var cols = args['sortCols'];
//{sortCol: {name: Title1, resizable: true, sortable: true, minWidth: 30, rerenderOnResize: false, headerCssClass: null, defaultSortAsc: true, focusable: true, selectable: true, cannotTriggerInsert: false, width: 80, id: title, field: title}, sortAsc: true}
    data.sort( (dataRow1, dataRow2) {
      for (var i = 0, l = cols.length; i < l; i++) {
        var field = cols[i]['sortCol']['field'];
        var sign = cols[i]['sortAsc'] ? 1 : -1;
        dynamic value1 = dataRow1[field], value2 = dataRow2[field];
        if(field=='dtitle') {
          return value1 == value2 ? 0 : (int.parse(value1) > int.parse(value2) ? 1: -1)* sign;
        }
        var result = (value1 == value2 ? 0 : (value1.compareTo(value2)>0 ? 1 : -1)) * sign;
        if (result != 0) {
          return result;
        }
      }
      return 0;
    });
    sg.invalidate();
    sg.render();
  });
  return sg;
}
