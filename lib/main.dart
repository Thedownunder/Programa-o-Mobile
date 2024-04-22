import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class Tarefa {
  String titulo;
  bool concluida;

  Tarefa(this.titulo, {this.concluida = false});
}

class ProvedorTarefas extends ChangeNotifier {
  List<Tarefa> _tarefas = [];

  List<Tarefa> get tarefas => _tarefas;

  void adicionarTarefa(Tarefa tarefa) {
    _tarefas.add(tarefa);
    notifyListeners();
  }

  void removerTarefa(int indice) {
    _tarefas.removeAt(indice);
    notifyListeners();
  }

  void alternarConclusaoTarefa(int indice, bool novoValor) {
    _tarefas[indice].concluida = novoValor;
    notifyListeners();
  }
}

class MeuApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ProvedorTarefas(),
      child: MaterialApp(
        title: 'Lista de Tarefas',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: TelaListaTarefas(),
      ),
    );
  }
}

class TelaListaTarefas extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provedorTarefas = Provider.of<ProvedorTarefas>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Tarefas'),
      ),
      body: Consumer<ProvedorTarefas>(
        builder: (context, provedorTarefas, _) {
          return ListView.builder(
            itemCount: provedorTarefas.tarefas.length,
            itemBuilder: (context, indice) {
              final tarefa = provedorTarefas.tarefas[indice];
              return Dismissible(
                key: Key(tarefa.titulo),
                onDismissed: (direcao) {
                  provedorTarefas.removerTarefa(indice);
                },
                child: CheckboxListTile(
                  title: Text(tarefa.titulo),
                  value: tarefa.concluida,
                  onChanged: (novoValor) {
                    provedorTarefas.alternarConclusaoTarefa(indice, novoValor!);
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final novaTarefa = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TelaAdicionarTarefa()),
          );
          if (novaTarefa != null) {
            provedorTarefas.adicionarTarefa(novaTarefa);
          }
        },
        tooltip: 'Adicionar Tarefa',
        child: Icon(Icons.add),
      ),
    );
  }
}

class TelaAdicionarTarefa extends StatelessWidget {
  final TextEditingController _controladorTarefa = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Tarefa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _controladorTarefa,
              decoration: InputDecoration(labelText: 'Título da Tarefa'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                if (_controladorTarefa.text.isNotEmpty) {
                  Navigator.pop(
                    context,
                    Tarefa(_controladorTarefa.text),
                  );
                }
              },
              child: Text('Adicionar'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controladorTarefa.dispose();
    super.dispose();
  }
}
