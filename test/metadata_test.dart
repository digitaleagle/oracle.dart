import 'dart:io';
import 'package:oracle/oracle.dart' as oracle;
import 'package:test/test.dart';
import 'package:collection/equality.dart';

main() {
  var username;
  var password;
  var connString;
  var con;
  var metadata;

  setUp(() {
    username = Platform.environment['DB_USERNAME'];
    password = Platform.environment['DB_PASSWORD'];
    connString = Platform.environment['DB_CONN_STR'];

    con = new oracle.Connection(username, password, connString);
    con.execute("BEGIN EXECUTE IMMEDIATE 'DROP TABLE metadata_test'; EXCEPTION WHEN OTHERS THEN NULL; END;");
    con.execute("CREATE TABLE metadata_test ( test_int int, test_string varchar(255) , test_number NUMBER(20, 5))");
    
    con.execute("INSERT into metadata_test (test_int) VALUES (NULL)");
    var rs = con.executeQuery('SELECT test_int, test_string, test_number from metadata_test');
    metadata = rs.getColumnListMetadata();

    assert(metadata.length == 3);
  }); 

  tearDown((){
    var stmt = con.createStatement("DROP TABLE metadata_test");
    stmt.execute();
    con.commit();
  });

  group('ColumnMetadata', () {
    test('getParamType', () {
      expect(metadata[0].getParamType(), oracle.ParamType.COLUMN);
    });

    test('getName', () {
      expect(metadata[0].getName(), equals('TEST_INT'));
      expect(metadata[1].getName(), equals('TEST_STRING'));
    });
    
    test('getPrecision', () {
      expect(metadata[0].getPrecision(), equals(38));
      expect(metadata[1].getPrecision(), equals(0));
      expect(metadata[2].getPrecision(), equals(20));
    });
    
    test('getScale', () {
      expect(metadata[0].getScale(), equals(0));
      expect(metadata[1].getScale(), equals(0));
      expect(metadata[2].getScale(), equals(5));
    });

    test('getDataSize', () {
      expect(metadata[1].getDataSize(), equals(255)); 
    });

    test('isCharUsed', () {
      expect(metadata[0].isCharUsed(), isFalse); 
      expect(metadata[1].isCharUsed(), isFalse); 
    });

    test('getDataType', () {
      expect(metadata[0].getDataType(), 2);
      expect(metadata[1].getDataType(), 1); 
    });

    test('canNull', () {
      expect(metadata[0].canNull(), isTrue);
      expect(metadata[1].canNull(), isTrue); 
    });
    
    test('getTypeName', () {
      expect(metadata[0].getTypeName(), '');
      expect(metadata[1].getTypeName(), ''); 
    });

    test('getSchemaName', () {
      expect(metadata[0].getSchemaName(), '');
      expect(metadata[1].getSchemaName(), ''); 
    });
    
    //test('getCharsetId', () {
      //expect(metadata[0].getCharsetId(), 0);
      //expect(metadata[1].getCharsetId(), 0); 
    //});
    
    //test('getCharsetForm', () {
      //expect(metadata[0].getCharsetId(), 0);
      //expect(metadata[1].getCharsetId(), 0); 
    //});
  });
}