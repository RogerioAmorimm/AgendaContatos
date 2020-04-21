import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

final String tabelaContatos = "tabelaContatos";
final String colunaID = "colunaID";
final String colunaNome = "colunaNome";
final String colunaEmail = "colunaEmail";
final String colunaTelefone = "colunaTelefone";
final String colunaImg = "colunaImg";

class ContactHelper {
  static final ContactHelper _instance = ContactHelper.internal();
  factory ContactHelper() => _instance;
  ContactHelper.internal();

  Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDB();
    }
  }

  Future<Database> initDB() async {
    final caminhoBaseDados = await getDatabasesPath();
    final caminho = join(caminhoBaseDados, "contacts.db");

    return await openDatabase(caminho, version: 1,
        onCreate: (Database db, int novaVersao) async {
      await db.execute("CREATE TABLE $tabelaContatos "
          "($colunaID INTEGER PRIMARY KEY, $colunaNome TEXT,"
          "$colunaEmail TEXT, $colunaTelefone TEXT, $colunaImg TEXT)");
    });
  }

  Future<Contact> salvaContato(Contact contato) async {
    Database dbContato = await db;
    await dbContato.insert(tabelaContatos, contato.toMap());
    return contato;
  }

  Future<Contact> obterContato(int id) async {
    Database dbContato =  await db;
    List<Map> contatos = await dbContato.query(tabelaContatos,
    columns: [colunaID, colunaNome, colunaEmail, colunaTelefone, colunaImg],
    where: "$colunaID =  ?",
    whereArgs: [id]);
    if (contatos.length > 0 ) {
      return Contact.fromMap(contatos.first)
    }else{
      return null;
    }
  }

  Future<int> deletarContato(int id) async{
    Database dbContato = await db;
    return await dbContato.delete(tabelaContatos, where:  "$colunaID = ?", whereArgs: [id]);
  }

  Future<int> updateContato(Contact contato) async{
    Database dbContato = await db;
    return  await dbContato.update(tabelaContatos,
         contato.toMap(),
         where: "$colunaID = ?",
         whereArgs: [contato.id]);
  }
  
  Future<List> obtenhaTodosContatos() async{
    Database dbContato = await db;
    List listaTodosContatos = await dbContato.rawQuery("SELECT * FROM $tabelaContatos");
    List<Contact> listaContatoConvertidos =  List();

    listaTodosContatos.forEach((contato) => listaContatoConvertidos.add(contato));
    return listaContatoConvertidos;
  }
   Future<int> obtenhaQuantidadoElementos() async{
    Database dbContato =  await db;
    return Sqflite.firstIntValue(await dbContato.rawQuery("SELECT COUNT(*) FROM $tabelaContatos"));
  }

  Future close() async{
    Database dbContato = await db;
    dbContato.close();
  }

}

class Contact {
  int id;
  String nome;
  String email;
  String numeroTelefone;
  String img;

  Contact.fromMap(Map map) {
    id = map[colunaID];
    nome = map[colunaNome];
    email = map[colunaEmail];
    numeroTelefone = map[colunaTelefone];
    img = map[colunaImg];
  }
  Map toMap() {
    Map<String, dynamic> mapContato = {
      colunaNome: nome,
      colunaEmail: email,
      colunaTelefone: numeroTelefone,
      colunaImg: img
    };
    if (id != null) {
      mapContato[colunaID] = id;
    }

    @override
    String toString() {
      return "Contato(id: $id, nome: $nome, email: $email, "
          "telefone: $numeroTelefone, img: $img)";
    }
  }
}
